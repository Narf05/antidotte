import { db } from '../db/client'

export class FriendService {
  static async sendRequest(requesterId: string, recipientId: string, source: string): Promise<void> {
    // TODO: insert friend_request row
  }

  static async acceptRequest(requestId: string, userId: string): Promise<void> {
    // TODO: update request status, create friendship row
  }

  static async removeFriend(userId: string, friendId: string): Promise<void> {
    // TODO: update friendship status, revoke location/score access immediately
  }

  static async blockUser(blockerId: string, blockedId: string): Promise<void> {
    // TODO: insert user_blocks row, hide both from each other
  }

  static async generateInviteCode(userId: string): Promise<string> {
    // TODO: generate random code, store hash, return raw code
    return ''
  }
}
