import 'package:flutter/material.dart';
import '../../core/design/colors.dart';
import '../../core/design/typography.dart';

/// Invite Collaborators Modal - Allows inviting team members to ideas/projects
class InviteCollaboratorsModal extends StatefulWidget {
  final Function(List<String>) onInvite;

  const InviteCollaboratorsModal({
    required this.onInvite,
    super.key,
  });

  @override
  State<InviteCollaboratorsModal> createState() =>
      _InviteCollaboratorsModalState();
}

class _InviteCollaboratorsModalState extends State<InviteCollaboratorsModal> {
  late TextEditingController _searchController;
  List<_CollaboratorItem> selectedCollaborators = [];
  List<_CollaboratorItem> suggestions = [
    _CollaboratorItem(name: 'Julian Thorne', email: 'julian@studio.ideole'),
    _CollaboratorItem(name: 'Elena Hadrick', email: 'elena.h@design.com'),
    _CollaboratorItem(name: 'Sasha Vane', email: 'svane@ideole.app'),
    _CollaboratorItem(name: 'Marcus Wei', email: 'marcus.w@tech.com'),
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: SaharaColors.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          child: Column(
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 48,
                  height: 4,
                  decoration: BoxDecoration(
                    color: SaharaColors.outlineVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Invite Collaborators',
                      style: SaharaTypography.headlineLarge.copyWith(
                        color: SaharaColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Add thinkers and makers to your project.',
                      style: SaharaTypography.bodySmall.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              // Search
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search by name or email...',
                    prefixIcon: Icon(
                      Icons.search,
                      color: SaharaColors.onSurfaceVariant,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: SaharaColors.outlineVariant,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: SaharaColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              // Content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    // Active collaborators
                    if (selectedCollaborators.isNotEmpty) ...[
                      Text(
                        'Active Collaborators',
                        style: SaharaTypography.labelSmall.copyWith(
                          color: SaharaColors.onSurfaceVariant,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ...selectedCollaborators.map((collab) {
                        return _buildCollaboratorItem(collab, true);
                      }).toList(),
                      const SizedBox(height: 32),
                    ],
                    // Suggested
                    Text(
                      'Suggested',
                      style: SaharaTypography.labelSmall.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...suggestions.map((collab) {
                      final isSelected =
                          selectedCollaborators.any((c) => c.email == collab.email);
                      return _buildCollaboratorItem(collab, false, isSelected);
                    }).toList(),
                  ],
                ),
              ),
              // Action buttons
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      widget.onInvite(
                        selectedCollaborators.map((c) => c.email).toList(),
                      );
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: SaharaColors.primary,
                      foregroundColor: SaharaColors.onPrimary,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      'Send Invites',
                      style: SaharaTypography.labelMedium.copyWith(
                        color: SaharaColors.onPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCollaboratorItem(
    _CollaboratorItem collab,
    bool isActive, [
    bool isSelected = false,
  ]) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          setState(() {
            if (selectedCollaborators.contains(collab)) {
              selectedCollaborators.remove(collab);
            } else {
              selectedCollaborators.add(collab);
            }
          });
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive
                ? SaharaColors.surfaceContainerLow
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: SaharaColors.primary, width: 2)
                : null,
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: SaharaColors.secondaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    collab.name.substring(0, 2).toUpperCase(),
                    style: SaharaTypography.labelSmall.copyWith(
                      color: SaharaColors.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      collab.name,
                      style: SaharaTypography.labelMedium.copyWith(
                        color: SaharaColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      collab.email,
                      style: SaharaTypography.labelSmall.copyWith(
                        color: SaharaColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isActive)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: SaharaColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Joined',
                    style: SaharaTypography.labelSmall.copyWith(
                      color: SaharaColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              else if (isSelected)
                Icon(Icons.check_circle, color: SaharaColors.primary)
              else
                Icon(Icons.add_circle_outline,
                    color: SaharaColors.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }
}

class _CollaboratorItem {
  final String name;
  final String email;

  _CollaboratorItem({required this.name, required this.email});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is _CollaboratorItem && email == other.email;
  }

  @override
  int get hashCode => email.hashCode;
}
