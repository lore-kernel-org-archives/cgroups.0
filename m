From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.7-rc7
Date: Wed, 27 May 2020 10:21:19 -0400
Message-ID: <20200527142119.GJ83516@mtj.thefacebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=PmfbmDEwWXL4BvaLDwT2z4rZRjeL8v9u316orBCGPsE=;
        b=DLCV/9qp/eo/ydm2hUV10ZlWLk6rheVtyjcRfQ+8f/LMjMkhpz22lWZg3MvQwxHhs3
         CHOnqxsMW1BIGdZ94iLc0LS3sc5JXalpHzd4cF3cp9CRoHIpeC+gW/uyUxTJxfO8Ul4V
         JVfrzYFZzKvBL8i6ZDDZH6H3rOlSXRc56iFSAvbsbXi59riI5jYGK3akTKSrsmErr/3L
         rxAWXOu46hcqmboR1f1aK4GeJckXcTonukZOWfZs8jNdv1cGw91nHofl+lXy8bFjEqmN
         j3tA9he2fixBEaLwxstJpyNbX0evnrPvVY1KrLt+BS4kr34o8Olnti7/MCLhB4E9PczS
         PhDA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

* Reverted stricter synchronization for cgroup recursive stats which was
  prepping it for event counter usage which never got merged. The change was
  causing performation regressions in some cases.

* Restore bpf-based device-cgroup operation even when cgroup1 device cgroup
  is disabled.

* An out-param init fix.

Thanks.

The following changes since commit 87ebc45d2d32936fb1c8242032eb0b9bcd058858:

  Merge tag 'arm64-fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux (2020-04-09 11:04:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.7-fixes

for you to fetch changes up to eec8fd0277e37cf447b88c6be181e81df867bcf1:

  device_cgroup: Cleanup cgroup eBPF device filter code (2020-04-13 14:41:54 -0400)

----------------------------------------------------------------
Daniel Xu (1):
      xattr: fix uninitialized out-param

Odin Ugedal (1):
      device_cgroup: Cleanup cgroup eBPF device filter code

Tejun Heo (1):
      Revert "cgroup: Add memory barriers to plug cgroup_rstat_updated() race window"

 drivers/gpu/drm/amd/amdkfd/kfd_priv.h |  2 +-
 fs/xattr.c                            |  6 +++---
 include/linux/device_cgroup.h         | 14 +++++---------
 kernel/cgroup/rstat.c                 | 16 +++-------------
 security/Makefile                     |  2 +-
 security/device_cgroup.c              | 19 ++++++++++++++++---
 6 files changed, 29 insertions(+), 30 deletions(-)

-- 
tejun
