From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.14-rc4
Date: Mon, 26 Jul 2021 12:52:21 -1000
Message-ID: <YP88pSEKctnQe2v2@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=WqhFWoemQOi+naKM/w3DU5/DczHPjUx7VB4ssERw9O0=;
        b=CmcfVHMcIfbv90YU4RtOSEiZoB4RSr8IIZYy+fVwQ2tjCJLyEB5KvFVLo1foAV+m2y
         X5FIplATb2u6CIK8LQj7HgS299Hd+JLtia3Ub3BEe3CfGP6JfRQPlA76tvA1qLU5iKvH
         7xxmwLEmQNyQhOhYCR2bWGBQzmyv7dLL0nNWeUONKIu0ajEyXjFU6sDz1S2Qf+Pdd7LF
         FWDfeGBs+d94RwNRVbqMne5OyOZVA3cN2XlAklAunqL1MGBbl7aY3GsWw74dahJf+wZF
         M6rTFgp8ODmDaG3K3WscHIo1psscyymiIG5Rmd0AnXLF9Wa6Wgm3PNPATsTqTmqYMDDN
         9mUA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

One commit to fix leaked filesystem context root bug which is triggered by
LTP. Not too likely to be a problem in non-testing environments.

Thanks.

The following changes since commit 8cae8cd89f05f6de223d63e6d15e31c8ba9cf53b:

  seq_file: disallow extremely large seq buffer allocations (2021-07-19 17:18:48 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.14-fixes

for you to fetch changes up to 1e7107c5ef44431bc1ebbd4c353f1d7c22e5f2ec:

  cgroup1: fix leaked context root causing sporadic NULL deref in LTP (2021-07-21 06:39:20 -1000)

----------------------------------------------------------------
Paul Gortmaker (1):
      cgroup1: fix leaked context root causing sporadic NULL deref in LTP

 fs/internal.h              | 1 -
 include/linux/fs_context.h | 1 +
 kernel/cgroup/cgroup-v1.c  | 4 +---
 3 files changed, 2 insertions(+), 4 deletions(-)

-- 
tejun
