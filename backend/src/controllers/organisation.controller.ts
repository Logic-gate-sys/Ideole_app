import type { Request, Response } from 'express';
import { OrganisationService } from '../services/organisation.service.ts';

export const OrganisationControllers = {
  async create(req: Request, res: Response) {
    try {
      const body = req.body;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const org = await OrganisationService.createOrganisation(body, userId);

      return res.status(201).json({
        success: true,
        data: org,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async getById(req: Request, res: Response) {
    try {
      const { id } = req.params;

      const org = await OrganisationService.getOrganisation(id);

      return res.status(200).json({
        success: true,
        data: org,
      });
    } catch (err: any) {
      if (err.message === 'Organisation not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async list(req: Request, res: Response) {
    try {
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const orgs = await OrganisationService.listOrganisations(userId);

      return res.status(200).json({
        success: true,
        data: orgs,
      });
    } catch (err: any) {
      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async update(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const body = req.body;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      const org = await OrganisationService.updateOrganisation(id, userId, body);

      return res.status(200).json({
        success: true,
        data: org,
      });
    } catch (err: any) {
      if (err.message === 'Organisation not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('Unauthorized')) {
        return res.status(403).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },

  async delete(req: Request, res: Response) {
    try {
      const { id } = req.params;
      const userId = req.user?.id;

      if (!userId) {
        return res.status(401).json({
          message: 'error',
          details: 'User not authenticated',
        });
      }

      await OrganisationService.deleteOrganisation(id, userId);

      return res.status(200).json({
        success: true,
      });
    } catch (err: any) {
      if (err.message === 'Organisation not found') {
        return res.status(404).json({
          message: 'error',
          details: err.message,
        });
      }

      if (err.message.includes('Unauthorized')) {
        return res.status(403).json({
          message: 'error',
          details: err.message,
        });
      }

      return res.status(500).json({
        message: 'error',
        details: err.message,
      });
    }
  },
};
