From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.16-rc1
Date: Tue, 30 Jan 2018 10:35:52 -0800
Message-ID: <20180130183552.GJ1121507@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=P1xh6QqNPJcR22hPCLduMoWLHpFA3H3nD1drfSvfkQc=;
        b=Tavf6NHL2twlrJ/ar+oYK4KUk1CXZY+DKDOvTaa4DXMMcswDJsw0aZrpgkJrxmueFV
         OnhYlzE+/VcC/C6/v0SaEOQpm7M8QbPEzhNQc5U9F/gyFAw0i4oh8RJFzvkkxm8/+wq+
         xg8JiGVmGkKueGI3IRLPIFqMdbsz9JPG33mk9xQbWKmqxVkzRabGzRz8PQv8eK0vK3zC
         cLaK3xYjKRUToqJGQH/b0aDIgA6JouVwHzCwZegCTvlwdp8beFfNjJ2GVQXU6/v0AXtZ
         uiRz35B+ABAeN6kNrsqEBbkOWiuUSqrRq4e/ngCtqsv2q7QW17DC3j9OqYvAPQKie+LJ
         Fa+A==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

Nothing too interesting.  Documentation updates and trivial changes;
however, this pull request does containt he previusly discussed
dropping of __must_check from strscpy().

Thanks.

The following changes since commit 4f58424da3deead2605e39a9df65f5f06107a3cb:

  cgroup: make cgroup.threads delegatable (2018-01-10 09:42:32 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.16

for you to fetch changes up to 03eac8b22194becd77d253fc546429ebb544aebf:

  Documentation: Fix 'file_mapped' -> 'mapped_file' (2018-01-30 09:52:11 -0800)

----------------------------------------------------------------
Florian Schmidt (1):
      Documentation: Fix 'file_mapped' -> 'mapped_file'

Maciej S. Szmigiero (1):
      cgroup, docs: document the root cgroup behavior of cpu and io controllers

Matt Roper (2):
      Documentation/cgroup-v1: fix outdated programming details
      cgroup: Update documentation reference

Roman Gushchin (1):
      cgroup, docs: document cgroup v2 device controller

Tejun Heo (2):
      Merge branch 'for-4.15-fixes' into for-4.16
      string: drop __must_check from strscpy() and restore strscpy() usages in cgroup

Vladimir Rutsky (1):
      cgroup-v2.txt: fix typos

 Documentation/cgroup-v1/cgroups.txt |  7 +---
 Documentation/cgroup-v1/memory.txt  |  4 +-
 Documentation/cgroup-v2.txt         | 77 ++++++++++++++++++++++++++++++++-----
 include/linux/cgroup-defs.h         |  2 +-
 include/linux/string.h              |  2 +-
 kernel/cgroup/cgroup.c              |  6 +--
 6 files changed, 76 insertions(+), 22 deletions(-)

-- 
tejun
