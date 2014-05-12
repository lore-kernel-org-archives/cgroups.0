From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.15-rc5
Date: Mon, 12 May 2014 14:15:23 -0400
Message-ID: <20140512181523.GG1421@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=87JvGkJTWm0HCXn6uJ7G7uVjOfpYCbtbXCJZWMQ49Z0=;
        b=bq1Mv9loYW7TJFO3PHqAGFlLS7YZAxMTiBpEjjaKAxVU1AB0ONsIBb9Je0ji6Y4YVR
         NhxhLINTb8GgTa/am/3DxHoUI8ue9U1Y8kpn3VmpgEEzRsamXl0q3X49RmUvPOFs8z8/
         F/Z/CaTz/jx+m9cgZE4q35B1Uzh111z5PAzqc4SltmU6j64R3/9XrfGM+uBSiW1uZQsB
         Le5lg7uovcGTF4SjgNHqWG2phd7pu+c3kT/soMOQO31gO6ic7UKEcJgJLKRw0jlIZrLl
         Nojay+a7aYCJV5T4jTSGZv4+JXhlhEF31wgRxEnhEcMSl2h22nW5jLbYbzKu2qIBZ8W0
         q70g==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

During recent restructuring, device_cgroup unified config input check
and enforcement logic; unfortunately, it turned out to share too much.
Aristeu's patches fix the breakage and marked for -stable backport.

The other two patches are fallouts from kernfs conversion.  The blkcg
change is temporary and will go away once kernfs internal locking gets
simplified (patches pending).

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.15-fixes

for you to fetch changes up to 36c38fb7144aa941dc072ba8f58b2dbe509c0345:

  blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats() (2014-05-05 13:48:18 -0400)

Thanks.

----------------------------------------------------------------
Aristeu Rozanski (3):
      device_cgroup: rework device access check and exception checking
      device_cgroup: fix the comment format for recently added functions
      device_cgroup: check if exception removal is allowed

Li Zefan (1):
      cgroup: fix the retry path of cgroup_mount()

Tejun Heo (1):
      blkcg: use trylock on blkcg_pol_mutex in blkcg_reset_stats()

 block/blk-cgroup.c       |  15 +++-
 kernel/cgroup.c          |   8 +-
 security/device_cgroup.c | 202 +++++++++++++++++++++++++++++++++++++----------
 3 files changed, 177 insertions(+), 48 deletions(-)

-- 
tejun
