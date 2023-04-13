From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v6.3-rc6
Date: Thu, 13 Apr 2023 13:03:31 -1000
Message-ID: <ZDiKQ7Bia-ki3Vmh@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681427013; x=1684019013;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=D/XQvUMbd184V0d688Zwv75YAW0duMFHkNATV/mO7aw=;
        b=h4UtgBPumQArhAxQCuQPYMTKctURq6HR3viTzmbHWGpGY814xtwyXhtOruu4Gr2MKW
         WJIRqalJgwnq5W8HTNGZPk6plfg8WoJoXTFDG2p24lycnFLqgZQPK/nRw4gjOHPgCNNn
         q+KRpfwDpnuykgOiYgnoRJzV+rShDe6RYDRC4Kl69kBJs1RlBdfJ3ElsG6qBdgem/H+y
         WPpnlvsMgGvpCqydYphqJUWP6Td1CpcKD+QTkYfz8xBsUSjvTWBl6xdpa7TIUTtPtumI
         F9Q/28MgGIOqbvW8i1xVfp7UngobLIX5PiloGu0gtvc1cQmb2xi221N1nJleujA4TcSg
         SUgg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The following changes since commit 8d3c682a5e3d9dfc2448ecbb22f4cd48359b9e21:

  Merge tag 'block-6.3-2023-03-16' of git://git.kernel.dk/linux (2023-03-17 11:20:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/ tags/cgroup-for-6.3-rc6-fixes

for you to fetch changes up to 7e27cb6ad4d85fc8bac2a2a896da62ef66b8598e:

  cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for top_cpuset (2023-04-12 08:23:58 -1000)

----------------------------------------------------------------
cgroup: Fixes for v6.3-rc6

* Fix several cpuset bugs including one where it wasn't applying the target
  cgroup when tasks are created with CLONE_INTO_CGROUP.

* Fix inversed locking order in cgroup1 freezer implementation.

* Fix garbage cpu.stat::core_sched.forceidle_usec reporting in the root
  cgroup.

This is a relatively big pull request this late in the cycle but the major
contributor is the above mentioned cpuset bug which is rather significant.

----------------------------------------------------------------
Josh Don (1):
      cgroup: fix display of forceidle time at root

Tetsuo Handa (1):
      cgroup,freezer: hold cpu_hotplug_lock before freezer_mutex

Waiman Long (5):
      cgroup/cpuset: Fix partition root's cpuset.cpus update bug
      cgroup/cpuset: Wake up cpuset_attach_wq tasks in cpuset_cancel_attach()
      cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
      cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
      cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for top_cpuset

 kernel/cgroup/cpuset.c         | 178 +++++++++++++++++++++++++++++++++--------
 kernel/cgroup/legacy_freezer.c |   7 +-
 kernel/cgroup/rstat.c          |   4 +-
 3 files changed, 150 insertions(+), 39 deletions(-)
