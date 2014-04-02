From: Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/3] Per-cgroup swap file support
Date: Wed,  2 Apr 2014 13:34:06 -0700
Message-ID: <1396470849-26154-1-git-send-email-yuzhao@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=wAtpFI7MwDm1oJpRU8GXqaLcSZdZ65DxaBlFqhs39I4=;
        b=lqS0sHi1oKFUjhSH1rCEUivQFCCwpVEz16w6vnFf5spcymlUjGvuHjZcee+n0vmhmm
         ZvIF20lRxLeA/a+Kb1gRk9Ej5FGxKF5gH126SNzwnvaO4mZVKdjTOIfNBX/NzggC6WfZ
         xrgyM0loZ2pyI8XXApnEMjk0Zch4lG2Mk15uxq53x32sZOPPT1oCvrOq4EzB9wnvN89K
         ItXRPjgHDMQaYotm9Zaep756hjN47s7HZtVukIQxvXBFcJ2tNqcx3TVw5ODTAEMqFUYS
         qYUlonHJ/zKfvjDgr7yT8JJp9TohCeWRovtqQbJV3Bnqt8tUsoQC4MZregECy61+3fPt
         Xc3w==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jamieliu-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This series of patches adds support to configure a cgroup to swap to a
particular file by using control file memory.swapfile.

Originally, cgroups share system-wide swap space and limiting cgroup swapping
is not possible. This patchset solves the problem by adding mechanism that
isolates cgroup swap spaces (i.e. per-cgroup swap file) so users can safely
enable swap for particular cgroups without worrying about one cgroup uses up
all swap space.

A value of "default" in memory.swapfile indicates that this cgroup should
use the default, system-wide, swap files. A value of "none" indicates that
this cgroup should never swap. Other values are interpreted as the path
to a private swap file that can only be used by the owner (and its children).

The swap file has to be created and swapon() has to be done on it with
SWAP_FLAG_PRIVATE, before it can be used. This flag ensures that the swap
file is private and does not get used by others.

Changelog since v1:
  - Fixed typos in comment and commit message
  - Added rationale to this cover letter (Johannes Weiner)

Jamie Liu (1):
  swap: do not store private swap files on swap_list

Suleiman Souhlal (2):
  mm/swap: support per memory cgroup swapfiles
  swap: Increase the max swap files to 8192 on x86_64

 Documentation/cgroups/memory.txt  |  15 ++
 arch/x86/include/asm/pgtable_64.h |  62 ++++++--
 include/linux/memcontrol.h        |   2 +
 include/linux/swap.h              |  45 +++---
 mm/memcontrol.c                   |  76 ++++++++++
 mm/memory.c                       |   3 +-
 mm/shmem.c                        |   2 +-
 mm/swap_state.c                   |   2 +-
 mm/swapfile.c                     | 307 +++++++++++++++++++++++++++++++-------
 mm/vmscan.c                       |   2 +-
 10 files changed, 422 insertions(+), 94 deletions(-)

-- 
1.9.1.423.g4596e3a
