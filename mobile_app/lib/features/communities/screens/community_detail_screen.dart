import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/index.dart';
import '../../../core/widgets/index.dart';
import '../../../shared/models/community_model.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../ideas/screens/create_idea_screen.dart';
import '../controllers/membership_controller.dart';
import '../models/membership_model.dart';

class CommunityDetailScreen extends StatefulWidget {
  final Community community;
  final String organisationId;

  const CommunityDetailScreen({
    super.key,
    required this.community,
    required this.organisationId,
  });

  @override
  State<CommunityDetailScreen> createState() => _CommunityDetailScreenState();
}

class _CommunityDetailScreenState extends State<CommunityDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadMembershipData();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<MembershipController, AuthController>(
      builder: (context, membershipController, authController, _) {
        final currentUser = authController.currentUser;
        final myMembership = membershipController.getMyMembershipForCommunity(
          widget.community.id,
        );
        final isAdmin = (currentUser?.id == widget.community.adminId) ||
            (myMembership?.isAdminRole ?? false);

        final members =
            membershipController.getMembersForCommunity(widget.community.id);
        final pendingRequests = isAdmin
            ? membershipController.getPendingRequestsForCommunity(
                widget.community.id,
              )
            : <Membership>[];

        return Scaffold(
          backgroundColor: AppColors.surface,
          appBar: AppBar(
            backgroundColor: AppColors.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: GestureDetector(
                  onTap: () {
                    // Reserved for community options.
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: _loadMembershipData,
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.surface,
                    toolbarHeight: 0,
                    collapsedHeight: 0,
                    expandedHeight: 220,
                    floating: false,
                    pinned: true,
                    flexibleSpace: FlexibleSpaceBar(
                      background: _buildHeaderSection(),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.all(AppSpacing.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.community.description?.isNotEmpty ?? false) ...[
                            Text(
                              'About',
                              style: AppTextStyles.headlineSmall,
                            ),
                            SizedBox(height: AppSpacing.md),
                            Text(
                              widget.community.description ?? '',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                            SizedBox(height: AppSpacing.xxxl),
                          ],
                          _buildStatsSection(
                            membersCount: members.length,
                            pendingCount: pendingRequests.length,
                            isAdmin: isAdmin,
                            myMembership: myMembership,
                          ),
                          SizedBox(height: AppSpacing.xxxl),
                          _buildActionButtons(
                            membershipController: membershipController,
                            myMembership: myMembership,
                            isAdmin: isAdmin,
                            isLoading: membershipController.isLoading,
                          ),
                          if (membershipController.error != null) ...[
                            SizedBox(height: AppSpacing.md),
                            Text(
                              membershipController.error!,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ],
                          SizedBox(height: AppSpacing.lg),
                        ],
                      ),
                    ),
                  ),
                  _buildMembersSection(
                    members: members,
                    isAdmin: isAdmin,
                    membershipController: membershipController,
                  ),
                  if (isAdmin)
                    _buildPendingRequestsSection(
                      pendingRequests: pendingRequests,
                      membershipController: membershipController,
                    ),
                  SliverToBoxAdapter(
                    child: SizedBox(height: AppSpacing.lg),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _loadMembershipData() async {
    if (!mounted) {
      return;
    }

    final membershipController = context.read<MembershipController>();
    final authController = context.read<AuthController>();

    await membershipController.loadMyMemberships();
    await membershipController.loadCommunityMembers(widget.community.id);

    final currentUser = authController.currentUser;
    final isAdmin = currentUser?.id == widget.community.adminId;
    if (isAdmin) {
      await membershipController.loadPendingRequests(widget.community.id);
    }
  }

  Widget _buildHeaderSection() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _getVisibilityColor(widget.community.visibility)
                .withValues(alpha: 0.1),
            _getVisibilityColor(widget.community.visibility)
                .withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    color: _getVisibilityColor(widget.community.visibility)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: Icon(
                    _getVisibilityIcon(widget.community.visibility),
                    color:
                        _getVisibilityColor(widget.community.visibility),
                    size: 32,
                  ),
                ),
                SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVisibilityBadge(),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        widget.community.status,
                        style: AppTextStyles.labelSmall.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            Text(
              widget.community.name,
              style: AppTextStyles.displaySmall.copyWith(
                color: AppColors.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisibilityBadge() {
    final visibility = widget.community.visibility.toUpperCase();
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: _getVisibilityColor(widget.community.visibility)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(
          color: _getVisibilityColor(widget.community.visibility),
          width: 1,
        ),
      ),
      child: Text(
        visibility,
        style: AppTextStyles.labelSmall.copyWith(
          color: _getVisibilityColor(widget.community.visibility),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildStatsSection({
    required int membersCount,
    required int pendingCount,
    required bool isAdmin,
    required Membership? myMembership,
  }) {
    final membershipStatus = myMembership?.status ?? 'NOT A MEMBER';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatCard('$membersCount', 'Members'),
        _buildStatCard(
          isAdmin ? '$pendingCount' : membershipStatus,
          isAdmin ? 'Pending' : 'Your Status',
        ),
        _buildStatCard(widget.community.visibility, 'Visibility'),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Card(
        color: AppColors.surfaceVariant,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.md),
          side: BorderSide(color: AppColors.outline, width: 1),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.lg,
          ),
          child: Column(
            children: [
              Text(
                value,
                style: AppTextStyles.headlineLarge.copyWith(
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons({
    required MembershipController membershipController,
    required Membership? myMembership,
    required bool isAdmin,
    required bool isLoading,
  }) {
    final isMember = myMembership?.isActive ?? false;
    final isPending = myMembership?.isPending ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isMember && !isPending)
          AppButton(
            label: 'Join Community',
            variant: AppButtonVariant.filled,
            size: AppButtonSize.large,
            isLoading: isLoading,
            onPressed: () => _handleJoinCommunity(membershipController),
          )
        else if (isPending)
          AppButton(
            label: 'Request Pending Approval',
            variant: AppButtonVariant.tonal,
            size: AppButtonSize.large,
            onPressed: null,
          )
        else
          AppButton(
            label: isAdmin ? 'You are the Community Admin' : 'You are a Member',
            variant: AppButtonVariant.tonal,
            size: AppButtonSize.large,
            onPressed: null,
          ),
        SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Start an Idea',
          variant: isMember || isAdmin
              ? AppButtonVariant.outlined
              : AppButtonVariant.tonal,
          size: AppButtonSize.large,
          onPressed: isMember || isAdmin ? _handleStartIdea : null,
        ),
      ],
    );
  }

  Widget _buildMembersSection({
    required List<Membership> members,
    required bool isAdmin,
    required MembershipController membershipController,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Members',
              style: AppTextStyles.headlineSmall,
            ),
            SizedBox(height: AppSpacing.md),
            if (members.isEmpty)
              Text(
                'No active members yet.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else
              ...members.map(
                (member) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Row(
                      children: [
                        AppAvatar(
                          initials: (member.user?.displayName.isNotEmpty ?? false)
                              ? member.user!.displayName[0].toUpperCase()
                              : member.userId.isNotEmpty
                                  ? member.userId[0].toUpperCase()
                                  : '?',
                          size: 36,
                        ),
                        SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                member.user?.displayName ?? 'Member',
                                style: AppTextStyles.labelLarge,
                              ),
                              if (member.user?.email.isNotEmpty ?? false)
                                Text(
                                  member.user!.email,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        AppBadge(
                          label: member.role.toUpperCase(),
                          variant: AppBadgeVariant.tonal,
                        ),
                        if (isAdmin && !member.isAdminRole) ...[
                          SizedBox(width: AppSpacing.sm),
                          IconButton(
                            tooltip: 'Remove member',
                            onPressed: () => _handleRemoveMember(
                              membershipController,
                              member.id,
                            ),
                            icon: Icon(
                              Icons.person_remove_outlined,
                              color: AppColors.error,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingRequestsSection({
    required List<Membership> pendingRequests,
    required MembershipController membershipController,
  }) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pending Requests',
              style: AppTextStyles.headlineSmall,
            ),
            SizedBox(height: AppSpacing.md),
            if (pendingRequests.isEmpty)
              Text(
                'No pending requests.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              )
            else
              ...pendingRequests.map(
                (request) => Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.md),
                  child: AppCard(
                    padding: EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          request.user?.displayName ?? 'Unknown user',
                          style: AppTextStyles.labelLarge,
                        ),
                        if (request.user?.email.isNotEmpty ?? false)
                          Padding(
                            padding: EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              request.user!.email,
                              style: AppTextStyles.labelSmall.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        SizedBox(height: AppSpacing.md),
                        Row(
                          children: [
                            Expanded(
                              child: AppButton(
                                label: 'Approve',
                                variant: AppButtonVariant.filled,
                                size: AppButtonSize.small,
                                onPressed: () => _handleApproveRequest(
                                  membershipController,
                                  request.id,
                                ),
                              ),
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Expanded(
                              child: AppButton(
                                label: 'Reject',
                                variant: AppButtonVariant.outlined,
                                size: AppButtonSize.small,
                                onPressed: () => _handleRejectRequest(
                                  membershipController,
                                  request.id,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            SizedBox(height: AppSpacing.xxxl),
          ],
        ),
      ),
    );
  }

  Future<void> _handleJoinCommunity(
    MembershipController membershipController,
  ) async {
    final success = await membershipController.requestToJoinCommunity(
      widget.community.id,
    );

    if (!mounted) {
      return;
    }

    final message = success
        ? membershipController.successMessage ?? 'Join request submitted.'
        : membershipController.error ?? 'Unable to submit join request.';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  Future<void> _handleApproveRequest(
    MembershipController membershipController,
    String membershipId,
  ) async {
    final success = await membershipController.approveRequest(
      communityId: widget.community.id,
      membershipId: membershipId,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? membershipController.successMessage ?? 'Membership approved.'
              : membershipController.error ?? 'Unable to approve membership.',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  Future<void> _handleRejectRequest(
    MembershipController membershipController,
    String membershipId,
  ) async {
    final success = await membershipController.rejectRequest(
      communityId: widget.community.id,
      membershipId: membershipId,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? membershipController.successMessage ?? 'Membership rejected.'
              : membershipController.error ?? 'Unable to reject membership.',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  Future<void> _handleRemoveMember(
    MembershipController membershipController,
    String membershipId,
  ) async {
    final confirmed = await showAppAlertDialog(
      context,
      title: 'Remove Member',
      message: 'Are you sure you want to remove this member?',
      positiveLabel: 'Remove',
      negativeLabel: 'Cancel',
      type: AlertType.warning,
    );

    if (confirmed != true || !mounted) {
      return;
    }

    final success = await membershipController.removeMembership(
      communityId: widget.community.id,
      membershipId: membershipId,
    );

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? membershipController.successMessage ?? 'Member removed.'
              : membershipController.error ?? 'Unable to remove member.',
        ),
        backgroundColor: success ? AppColors.primary : AppColors.error,
      ),
    );
  }

  void _handleStartIdea() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CreateIdeaScreen(
          communityId: widget.community.id,
          organisationId: widget.organisationId,
        ),
      ),
    );
  }

  IconData _getVisibilityIcon(String visibility) {
    switch (visibility.toUpperCase()) {
      case 'PUBLIC':
        return Icons.public;
      case 'PROTECTED':
        return Icons.lock_open;
      case 'PRIVATE':
        return Icons.lock;
      default:
        return Icons.visibility;
    }
  }

  Color _getVisibilityColor(String visibility) {
    switch (visibility.toUpperCase()) {
      case 'PUBLIC':
        return AppColors.primary;
      case 'PROTECTED':
        return AppColors.secondary;
      case 'PRIVATE':
        return AppColors.tertiary;
      default:
        return AppColors.outline;
    }
  }
}
