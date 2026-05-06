import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/influencer_model.dart';
import '../models/campaign_model.dart';
import '../models/notification_model.dart';
import 'gradient_button.dart';

// ──────────────────────────────────────────────────────────────────────────────
// InfluencerCard
// ──────────────────────────────────────────────────────────────────────────────
class InfluencerCard extends StatelessWidget {
  final Influencer influencer;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const InfluencerCard({super.key, required this.influencer, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2746) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          Stack(children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(influencer.profileImageUrl),
              onBackgroundImageError: (_, __) {},
              backgroundColor: const Color(0xFF5C6BC0).withOpacity(0.2),
            ),
            if (influencer.isVerified)
              Positioned(bottom: 0, right: 0, child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.verified, color: Color(0xFF5C6BC0), size: 14),
              )),
          ]),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(influencer.name, style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700, fontSize: 15,
                color: isDark ? Colors.white : const Color(0xFF1A1A2E)))),
              Text('${influencer.platform.icon}', style: const TextStyle(fontSize: 16)),
            ]),
            Text('${influencer.niche} • ${influencer.location}',
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
            const SizedBox(height: 6),
            Row(children: [
              _chip(influencer.followersFormatted, const Color(0xFF5C6BC0), isDark),
              const SizedBox(width: 6),
              _chip('${influencer.engagementRate}%', const Color(0xFF26C6DA), isDark),
              const SizedBox(width: 6),
              _chip('₹${_fmt(influencer.pricePerPromotion)}', const Color(0xFFFF6B6B), isDark),
            ]),
          ])),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              onPressed: onDelete,
            ),
        ]),
      ),
    );
  }

  Widget _chip(String text, Color color, bool isDark) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
  );

  String _fmt(double v) {
    if (v >= 1000) return '${(v / 1000).toStringAsFixed(0)}K';
    return v.toStringAsFixed(0);
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// CampaignCard
// ──────────────────────────────────────────────────────────────────────────────
class CampaignCard extends StatelessWidget {
  final Campaign campaign;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CampaignCard({super.key, required this.campaign, this.onTap, this.onDelete});

  Color get _statusColor {
    switch (campaign.status) {
      case CampaignStatus.open: return const Color(0xFF4CAF50);
      case CampaignStatus.inProgress: return const Color(0xFFFFB347);
      case CampaignStatus.completed: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2746) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        child: Row(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(campaign.logoUrl, width: 52, height: 52, fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 52, height: 52,
                color: const Color(0xFF5C6BC0).withOpacity(0.2),
                child: const Icon(Icons.business, color: Color(0xFF5C6BC0)))),
          ),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(campaign.title, style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            Text(campaign.businessName,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45)),
            const SizedBox(height: 6),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(color: _statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(campaign.status.displayName,
                  style: TextStyle(fontSize: 10, color: _statusColor, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Text(campaign.budgetFormatted,
                style: const TextStyle(fontSize: 11, color: Color(0xFF5C6BC0), fontWeight: FontWeight.w600)),
              const Spacer(),
              Text('${campaign.applicants} applied',
                style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : Colors.black38)),
            ]),
          ])),
          if (onDelete != null)
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
              onPressed: onDelete,
            ),
        ]),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// MatchCard
// ──────────────────────────────────────────────────────────────────────────────
class MatchCard extends StatelessWidget {
  final String name;
  final String imageUrl;
  final int matchPercent;
  final String reason;
  final String actionLabel;
  final VoidCallback onAction;
  final Color accentColor;

  const MatchCard({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.matchPercent,
    required this.reason,
    required this.actionLabel,
    required this.onAction,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2746) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Row(children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60, height: 60,
              child: CircularProgressIndicator(
                value: matchPercent / 100,
                backgroundColor: accentColor.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                strokeWidth: 4,
              ),
            ),
            CircleAvatar(radius: 24, backgroundImage: NetworkImage(imageUrl), onBackgroundImageError: (_, __) {}),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(name, style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700, fontSize: 14,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E)))),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: accentColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
              child: Text('$matchPercent%', style: TextStyle(color: accentColor, fontWeight: FontWeight.w800, fontSize: 12)),
            ),
          ]),
          const SizedBox(height: 3),
          Text(reason, maxLines: 2, overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 11, color: isDark ? Colors.white54 : Colors.black45, height: 1.4)),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: onAction,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: accentColor.withOpacity(0.3)),
              ),
              child: Text(actionLabel, style: TextStyle(color: accentColor, fontWeight: FontWeight.w700, fontSize: 12)),
            ),
          ),
        ])),
      ]),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// NotificationTile
// ──────────────────────────────────────────────────────────────────────────────
class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  final VoidCallback? onTap;

  const NotificationTile({super.key, required this.notification, this.onTap});

  IconData get _icon {
    switch (notification.type) {
      case NotificationType.newCampaign: return Icons.campaign_rounded;
      case NotificationType.match: return Icons.favorite_rounded;
      case NotificationType.message: return Icons.message_rounded;
      case NotificationType.general: return Icons.notifications_rounded;
    }
  }

  Color get _color {
    switch (notification.type) {
      case NotificationType.newCampaign: return const Color(0xFF5C6BC0);
      case NotificationType.match: return const Color(0xFFFF6B6B);
      case NotificationType.message: return const Color(0xFF26C6DA);
      case NotificationType.general: return const Color(0xFFFFB347);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: notification.isRead
              ? (isDark ? const Color(0xFF1E2746) : Colors.white)
              : (isDark ? _color.withOpacity(0.08) : _color.withOpacity(0.04)),
          borderRadius: BorderRadius.circular(14),
          border: notification.isRead ? null : Border.all(color: _color.withOpacity(0.2)),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6)],
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: _color.withOpacity(0.12), borderRadius: BorderRadius.circular(10)),
            child: Icon(_icon, color: _color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(notification.title, style: TextStyle(
              fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
              fontSize: 13,
              color: isDark ? Colors.white : const Color(0xFF1A1A2E))),
            Text(notification.body,
              style: TextStyle(fontSize: 12, color: isDark ? Colors.white54 : Colors.black45, height: 1.4)),
          ])),
          if (!notification.isRead)
            Container(
              width: 8, height: 8,
              margin: const EdgeInsets.only(left: 6),
              decoration: BoxDecoration(color: _color, shape: BoxShape.circle),
            ),
        ]),
      ),
    );
  }
}
