From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.6-rc5
Date: Wed, 27 Apr 2016 12:01:35 -0400
Message-ID: <20160427160135.GN7822@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=fDvoaennlzV+a77jXTDZbV10ZAxzZ7rJxUn3Sep9Dr0=;
        b=nQISS58UXvSljVV3GPyvMNgfiRlzWxf2VXe2wVRScXdqaQzgsAy4jt9pMOpBMSqsMk
         OoIJFvbDxLMkXZtcVxnzJKEHWnHtn1Edy+KxWAvrUpAj1f6spRfhc1ba9NPIaIDCGLCY
         WO3MiLwMcbdn2t3gr84Eai0xoMyBvHwOZ9q+Lxjy125vagc+2is+7uM7mc2X2hr3Kgla
         rz/o/5kftMU5x2lZLmLd2OCJy+etdslvxK+MJiarSJYxu04iv/95pMzGt6Vayft2KfuU
         Qvb50s+r8loaMvBRNiqyqz0VV83Pu/lfBQWZfh5CmCFUWW4AeLh3bP9+xFSX1RJb6hAD
         UrNg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Hello, Linus.

Two patches to fix a deadlock which can be easily triggered if memcg
charge moving is used.  This bug was introduced while converting
threadgroup locking to a global percpu_rwsem and is caused by cgroup
controller task migration path depending on the ability to create new
kthreads.  cpuset had a similar issue which was fixed by performing
heavy-lifting operations asynchronous to task migration.  The two
patches fix the same issue in memcg in a similar way.  The first patch
makes the mechanism generic and the second relocates memcg charge
moving outside the migration path.

Given that we don't want to perform heavy operations while
writelocking threadgroup lock anyway, moving them out of the way is a
desirable solution.  One thing to note is that the problem was
difficult to debug because lockdep couldn't figure out the deadlock
condition.  Looking into how to improve that.

Thanks.

The following changes since commit bcc981e9ed84c678533299d7eff17d2c81e4d5de:

  Merge branch 'linus' of git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2016-04-25 09:32:45 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.6-fixes

for you to fetch changes up to 264a0ae164bc0e9144bebcd25ff030d067b1a878:

  memcg: relocate charge moving from ->attach to ->post_attach (2016-04-25 15:45:14 -0400)

----------------------------------------------------------------
Tejun Heo (2):
      cgroup, cpuset: replace cpuset_post_attach_flush() with cgroup_subsys->post_attach callback
      memcg: relocate charge moving from ->attach to ->post_attach

 include/linux/cgroup-defs.h |  1 +
 include/linux/cpuset.h      |  6 ------
 kernel/cgroup.c             |  7 +++++--
 kernel/cpuset.c             |  4 ++--
 mm/memcontrol.c             | 37 +++++++++++++++++++------------------
 5 files changed, 27 insertions(+), 28 deletions(-)

-- 
tejun
