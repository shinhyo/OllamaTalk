// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
//
// import '../../../domain/models/chat_room_entity.dart';
// import '../../core/themes/theme_ext.dart';
// import '../../tab/history/chat_history_viewmodel.dart';
//
// class DrawerChatHistory extends StatelessWidget {
//   final List<GroupChatRooms> chatRooms;
//   final Function(ChatRoomEntity) onTap;
//   final VoidCallback onClose;
//
//   const DrawerChatHistory({
//     super.key,
//     required this.chatRooms,
//     required this.onTap,
//     required this.onClose,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: onClose,
//                 ),
//                 const Spacer(),
//                 IconButton(
//                   icon: const Icon(Icons.search),
//                   onPressed: onClose,
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.settings),
//                   onPressed: onClose,
//                 ),
//               ],
//             ),
//             Expanded(
//               child: ListView.builder(
//                 padding: EdgeInsets.zero,
//                 itemCount: chatRooms.length,
//                 itemBuilder: (context, index) => _DrawerMenuItem(
//                   key: ObjectKey(chatRooms[index]),
//                   roomEntity: chatRooms[index],
//                   onTap: onTap,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class _DrawerMenuItem extends StatelessWidget {
//   final GroupChatRooms roomEntity;
//   final Function(ChatRoomEntity) onTap;
//
//   const _DrawerMenuItem({
//     super.key,
//     required this.roomEntity,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return roomEntity.when(
//       header: (date) => _DateHeader(date: date),
//       room: (room) => _ChatRoomItem(room: room, onTap: onTap),
//     );
//   }
// }
//
// class _DateHeader extends StatelessWidget {
//   final String date;
//
//   const _DateHeader({required this.date});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
//       child: Text(
//         date,
//         style: context.textTheme.headlineSmall?.copyWith(
//           fontWeight: FontWeight.bold,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }
// }
//
// class _ChatRoomItem extends StatelessWidget {
//   final ChatRoomEntity room;
//   final Function(ChatRoomEntity) onTap;
//
//   const _ChatRoomItem({
//     required this.room,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Text(
//         room.name,
//         maxLines: 1,
//         overflow: TextOverflow.ellipsis,
//         style: context.textTheme.bodySmall,
//       ),
//       subtitle: Text(
//         DateFormat('HH:mm').format(room.updatedAt),
//         style: context.textTheme.labelSmall?.copyWith(
//           color: Colors.grey[600],
//         ),
//       ),
//       onTap: () => onTap(room),
//       // onTap: () => onTap(GroupChatRooms.room(room: room)),
//     );
//   }
// }
