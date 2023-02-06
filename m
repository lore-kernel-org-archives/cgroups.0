From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.2-rc7
Date: Mon, 6 Feb 2023 11:49:23 -1000
Message-ID: <Y+F149pNVNcMJQIn@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ8nBL9fnm50KWgUG103EnYdV8ecPmtZB51kTE6QsSA=;
        b=DQQkID5hUpP033/mOHpgBQZWTHKCSByRDkLaZoT/cPufR557J/8Q0jWWOO5KDPuirY
         zzyyIGeUz7UGnoPyzkwVPfjyRPt/Vt/bepBP4vLh9cM5B/VXeadsX75tAGKuTR1WWyVI
         7gVjiEnnptVUCLs+uXMNODpZulbQtCyxtsFSYzIARHsaqpoOIQnMBv0iENEc2iF9tdPZ
         zy9lDvznqeVkWe6tFhx93C6wil2jSimcRah/5T1Em3FfQ/mzRa+A25LeYIxQ0MPCLx/W
         54NkKo1sCBPU5GwWhjWnaSXsdDOX1AzvJKj8MfNh5zCyCK5j4gyc/YNkf+8p6qYtoTqR
         IwVg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

The following changes since commit d2d11f342b179f1894a901f143ec7c008caba43e:

  Merge branch 'fixes' of git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs (2023-02-05 17:17:10 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.2-rc7-fixes

for you to fetch changes up to 7a2127e66a00e073db8d90f9aac308f4a8a64226:

  cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task (2023-02-06 10:18:36 -1000)

----------------------------------------------------------------
cgroup fixes for v6.2-rc7

During v6.2 cycle, there were a series of changes to task cpu affinity
handling which fixed cpuset inadvertently clobbering user-configured
affinity masks. Unfortunately, they broke the affinity handling on hybrid
heterogeneous CPUs which have cores that can execute both 64 and 32bit along
with cores that can only execute 32bit code.

This late pull request contains two fix patches for the above issue. While
reverting the changes that caused the regression is definitely an option,
the origial patches do improve how cpuset behave signficantly in some cases
and the fixes seem fairly safe, so I think it'd be better to try to fix them
first.

----------------------------------------------------------------
Waiman Long (1):
      cgroup/cpuset: Don't filter offline CPUs in cpuset_cpus_allowed() for top cpuset tasks

Will Deacon (1):
      cpuset: Call set_cpus_allowed_ptr() with appropriate mask for task

 kernel/cgroup/cpuset.c | 45 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 9 deletions(-)
