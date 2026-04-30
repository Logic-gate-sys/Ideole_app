import type { Router } from 'express';
import { ConversationControllers } from '../controllers/conversation.controller.ts';
import { authenticate, authorise } from '../middlewares/auth.middleware.ts';
import { Validator } from '../middlewares/validate.middleware.ts';
import { createMessageSchema } from '../schema/conversation.schema.ts';

export function setupConversationRoutes(router: Router) {
  router.get(
    '/ideas/:ideaId/conversations',
    authenticate,
    authorise('conversation:read:own'),
    ConversationControllers.getIdeaConversation
  );

  router.post(
    '/ideas/:ideaId/conversations',
    authenticate,
    authorise('conversation:create'),
    ConversationControllers.createIdeaConversation
  );

  router.get(
    '/conversations/:conversationId/messages',
    authenticate,
    authorise('conversation:read:own'),
    ConversationControllers.getConversationMessages
  );

  router.post(
    '/conversations/:conversationId/messages',
    authenticate,
    authorise('message:create'),
    Validator.validateBody(createMessageSchema),
    ConversationControllers.createMessage
  );
}
