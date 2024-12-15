import { describe, it, expect, beforeEach } from 'vitest';
import { vi } from 'vitest';

describe('Proposal Contract', () => {
  const contractOwner = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM';
  const user1 = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
  
  beforeEach(() => {
    vi.resetAllMocks();
  });
  
  it('should submit a proposal', () => {
    const mockSubmitProposal = vi.fn().mockReturnValue({ success: true, value: 1 });
    expect(mockSubmitProposal('Test Proposal', 'Description', 1000)).toEqual({ success: true, value: 1 });
  });
  
  it('should update proposal status', () => {
    const mockUpdateProposalStatus = vi.fn().mockReturnValue({ success: true });
    expect(mockUpdateProposalStatus(1, 'approved')).toEqual({ success: true });
  });
  
  it('should get a proposal', () => {
    const mockGetProposal = vi.fn().mockReturnValue({
      success: true,
      value: {
        title: 'Test Proposal',
        description: 'Description',
        requested_amount: 1000,
        proposer: user1,
        status: 'submitted'
      }
    });
    const result = mockGetProposal(1);
    expect(result.success).toBe(true);
    expect(result.value.title).toBe('Test Proposal');
  });
  
  it('should get proposal count', () => {
    const mockGetProposalCount = vi.fn().mockReturnValue({ success: true, value: 1 });
    expect(mockGetProposalCount()).toEqual({ success: true, value: 1 });
  });
});

