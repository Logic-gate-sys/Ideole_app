import 'package:flutter/material.dart';
import '../../../core/widgets/index.dart';
import '../widgets/idea_card.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late List<_IdeaModel> _ideas;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _ideas = _generateMockIdeas();
  }

  Future<void> _handleRefresh() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _ideas = _generateMockIdeas();
      _isLoading = false;
    });
  }

  void _handleNewIdea() {
    showAppBottomSheet(
      context,
      title: 'New Idea',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppInput(
            label: 'Title',
            hint: 'Give your idea a title',
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          AppInput(
            label: 'Description',
            hint: 'Describe your idea (problem & solution)',
            maxLines: 4,
            onChanged: (value) {},
          ),
          const SizedBox(height: 16),
          Text(
            'You\'ll be able to set evaluation metrics after creation',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actionLabel: 'Create Idea',
      onAction: () {
        // Handle idea creation
        setState(() {
          _ideas.insert(0, _IdeaModel(
            id: 'new_${DateTime.now().millisecondsSinceEpoch}',
            title: 'New Idea',
            description: 'A new collaborative idea',
            authorName: 'You',
            originality: 70,
            feasibility: 80,
            impact: 85,
          ));
        });
      },
    );
  }

  void _handleIdeaTap(_IdeaModel idea) {
    // Navigate to idea detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tapped: ${idea.title}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _handleLike(String ideaId) {
    setState(() {
      final index = _ideas.indexWhere((i) => i.id == ideaId);
      if (index != -1) {
        final idea = _ideas[index];
        _ideas[index] = _IdeaModel(
          id: idea.id,
          title: idea.title,
          description: idea.description,
          authorName: idea.authorName,
          authorImage: idea.authorImage,
          commentCount: idea.commentCount,
          likeCount: idea.isLiked ? idea.likeCount - 1 : idea.likeCount + 1,
          isLiked: !idea.isLiked,
          originality: idea.originality,
          feasibility: idea.feasibility,
          impact: idea.impact,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      appBar: _buildAppBar(),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _buildFeedList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleNewIdea,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('New Idea'),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.surface,
      elevation: 0,
      title: Text(
        'Ideole',
        style: AppTextStyles.headlineSmall.copyWith(
          fontSize: 24,
          color: AppColors.primary,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {
            // Handle notifications
          },
        ),
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            // Handle search
          },
        ),
      ],
    );
  }

  Widget _buildFeedList() {
    if (_ideas.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: AppColors.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'No ideas yet',
              style: AppTextStyles.headlineSmall.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Be the first to share an idea!',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      itemCount: _ideas.length,
      itemBuilder: (context, index) {
        final idea = _ideas[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: IdeaCard(
            id: idea.id,
            title: idea.title,
            description: idea.description,
            authorName: idea.authorName,
            authorImage: idea.authorImage,
            commentCount: idea.commentCount,
            likeCount: idea.likeCount,
            isLiked: idea.isLiked,
            originality: idea.originality,
            feasibility: idea.feasibility,
            impact: idea.impact,
            onTap: () => _handleIdeaTap(idea),
            onLike: () => _handleLike(idea.id),
            onComment: () {
              // Navigate to comments
            },
            onShare: () {
              // Handle share
            },
          ),
        );
      },
    );
  }

  List<_IdeaModel> _generateMockIdeas() {
    return [
      _IdeaModel(
        id: '1',
        title: 'Smart water management system for urban farms',
        description:
            'A sensor-based IoT system that optimizes water usage in urban agriculture. Uses AI to predict water needs based on weather, soil conditions, and crop type.',
        authorName: 'Alice Chen',
        authorImage: null,
        commentCount: 12,
        likeCount: 284,
        isLiked: false,
        originality: 87,
        feasibility: 72,
        impact: 85,
      ),
      _IdeaModel(
        id: '2',
        title: 'Mental health chatbot for underserved communities',
        description:
            'A multilingual AI chatbot providing accessible mental health support. Designed for communities where professional help is limited and expensive.',
        authorName: 'Marcus Johnson',
        authorImage: null,
        commentCount: 28,
        likeCount: 456,
        isLiked: false,
        originality: 75,
        feasibility: 80,
        impact: 95,
      ),
      _IdeaModel(
        id: '3',
        title: 'Biodegradable packaging from agricultural waste',
        description:
            'Novel compostable packaging material made from agricultural byproducts. Reduces plastic waste while creating value from farm waste.',
        authorName: 'Sofia Martinez',
        authorImage: null,
        commentCount: 19,
        likeCount: 312,
        isLiked: false,
        originality: 82,
        feasibility: 68,
        impact: 88,
      ),
      _IdeaModel(
        id: '4',
        title: 'Community skill-sharing platform',
        description:
            'Peer-to-peer platform connecting neighbors to share skills and knowledge. Builds community while reducing need for expensive services.',
        authorName: 'David Lee',
        authorImage: null,
        commentCount: 7,
        likeCount: 123,
        isLiked: false,
        originality: 65,
        feasibility: 85,
        impact: 70,
      ),
      _IdeaModel(
        id: '5',
        title: 'AI-assisted renewable energy optimization',
        description:
            'Machine learning system that predicts and optimizes renewable energy distribution in microgrids. Maximizes efficiency and reduces waste.',
        authorName: 'Elena Rossi',
        authorImage: null,
        commentCount: 34,
        likeCount: 567,
        isLiked: false,
        originality: 90,
        feasibility: 75,
        impact: 92,
      ),
    ];
  }
}

class _IdeaModel {
  final String id;
  final String title;
  final String description;
  final String authorName;
  final String? authorImage;
  final int commentCount;
  final int likeCount;
  final bool isLiked;
  final double originality;
  final double feasibility;
  final double impact;

  _IdeaModel({
    required this.id,
    required this.title,
    required this.description,
    required this.authorName,
    this.authorImage,
    this.commentCount = 0,
    this.likeCount = 0,
    this.isLiked = false,
    this.originality = 75,
    this.feasibility = 80,
    this.impact = 85,
  });
}

// Backward compatibility - HomeScreen is now FeedScreen
typedef HomeScreen = FeedScreen;
