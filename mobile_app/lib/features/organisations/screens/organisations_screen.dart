import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/design/colors.dart';
import '../../../core/design/typography.dart';
import '../controllers/organisation_controller.dart';
import 'organisation_detail_screen.dart';

/// Organisations List Screen - Browse all organisations
class OrganisationsScreen extends StatefulWidget {
  const OrganisationsScreen({super.key});

  @override
  State<OrganisationsScreen> createState() => _OrganisationsScreenState();
}

class _OrganisationsScreenState extends State<OrganisationsScreen> {
  late ScrollController _scrollController;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _scrollController.addListener(_onScroll);

    // Load organisations on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<OrganisationController>().loadOrganisations();
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<OrganisationController>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<OrganisationController>(
      builder: (context, controller, child) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: SaharaColors.surface,
            title: Row(
              children: [
                Icon(Icons.business, color: SaharaColors.primary),
                const SizedBox(width: 12),
                Text(
                  'Organisations',
                  style: SaharaTypography.headlineSmall.copyWith(
                    color: SaharaColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
          body: _buildBody(context, controller),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _showCreateOrganisationDialog(context);
            },
            backgroundColor: SaharaColors.primary,
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, OrganisationController controller) {
    if (controller.isLoading && controller.organisations.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null && controller.organisations.isEmpty) {
      return _buildErrorState(context, controller);
    }

    if (controller.organisations.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: controller.organisations.length + (controller.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == controller.organisations.length) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          );
        }

        final org = controller.organisations[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => OrganisationDetailScreen(organisation: org),
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: SaharaColors.outlineVariant,
                width: 0.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              org.name,
                              style: SaharaTypography.headlineSmall.copyWith(
                                color: SaharaColors.onSurface,
                              ),
                            ),
                            if (org.description != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                org.description!,
                                style: SaharaTypography.bodySmall.copyWith(
                                  color: SaharaColors.onSurfaceVariant,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: SaharaColors.primaryContainer.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          org.visibility ?? 'PUBLIC',
                          style: SaharaTypography.labelSmall.copyWith(
                            color: SaharaColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => OrganisationDetailScreen(
                              organisation: org,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: SaharaColors.primary,
                        foregroundColor: SaharaColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text(
                        'View Details',
                        style: SaharaTypography.labelSmall.copyWith(
                          color: SaharaColors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.business_outlined,
            size: 64,
            color: SaharaColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'No Organisations',
            style: SaharaTypography.headlineSmall.copyWith(
              color: SaharaColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create or join an organisation to get started',
            style: SaharaTypography.bodySmall.copyWith(
              color: SaharaColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, OrganisationController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red,
          ),
          const SizedBox(height: 16),
          Text(
            'Error',
            style: SaharaTypography.headlineSmall.copyWith(
              color: SaharaColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            controller.errorMessage ?? 'An error occurred',
            style: SaharaTypography.bodySmall.copyWith(
              color: SaharaColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              controller.loadOrganisations(refresh: true);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: SaharaColors.primary,
            ),
            child: Text(
              'Retry',
              style: SaharaTypography.labelSmall.copyWith(
                color: SaharaColors.onPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show create organisation dialog
  void _showCreateOrganisationDialog(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    String visibility = 'PRIVATE';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Organisation'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Organisation Name',
                  hintText: 'e.g., My Company',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'What is this organisation about?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: visibility,
                decoration: InputDecoration(
                  labelText: 'Visibility',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: 'PRIVATE', child: Text('Private')),
                  DropdownMenuItem(value: 'PUBLIC', child: Text('Public')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    visibility = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () async {
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter an organisation name')),
                );
                return;
              }

              Navigator.pop(context);

              final controller = context.read<OrganisationController>();
              final success = await controller.createOrganisation(
                name: nameController.text.trim(),
                description: descriptionController.text.trim(),
                visibility: visibility,
              );

              if (mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Organisation created successfully!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(controller.errorMessage ?? 'Failed to create organisation'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
