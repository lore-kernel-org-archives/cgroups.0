From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.14-rc6
Date: Mon, 9 Aug 2021 13:01:54 -1000
Message-ID: <YRGz4nmDZNhsKSr1@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=FIJq4ZNboXbfq5kIKSzg2GS0ml9Miy3RL/9vBFSXcYI=;
        b=BqY7udQeB6Iv9m++WzDq2lkKT1nZFRQJDUQxx+PSSO7nDEv8wlnFFTtm0sxwHaYsFO
         znYWcD776guDJPii/afFvx/fvo81dqYw21icscwKZKnrEN5e76HdqjHTWMaipCXjvTgw
         jYzPAnZij1Mp3ufJAwBoTU2jaJr3kcL9mqWltHWIiF0Ix7NJ6su97oINNZC+Clm1shHc
         miSm9Rlzj0g8oUB1EA0wufvM4Tm5qIUHQK1YzLigveqBJcfSJmWNswkFn595xgCOfyXy
         FGPxEUL15GUvozGfYLQtPhEmxgNAGyeZFkaOvmnSBVKMaf/niSWJGDeq1r0bctmS6JgS
         Gl3w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

One commit to fix a possible A-A deadlock around u64_stats_sync on
32bit machines caused by updating it without disabling IRQ when it may
be read from IRQ context.

Thanks.

The following changes since commit 1e7107c5ef44431bc1ebbd4c353f1d7c22e5f2ec:

  cgroup1: fix leaked context root causing sporadic NULL deref in LTP (2021-07-21 06:39:20 -1000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.14-fixes

for you to fetch changes up to c3df5fb57fe8756d67fd56ed29da65cdfde839f9:

  cgroup: rstat: fix A-A deadlock on 32bit around u64_stats_sync (2021-07-27 13:12:20 -1000)

----------------------------------------------------------------
Tejun Heo (1):
      cgroup: rstat: fix A-A deadlock on 32bit around u64_stats_sync

 block/blk-cgroup.c    | 14 ++++++++------
 kernel/cgroup/rstat.c | 19 +++++++++++--------
 2 files changed, 19 insertions(+), 14 deletions(-)

-- 
tejun
