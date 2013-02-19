From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for 3.9-rc1
Date: Tue, 19 Feb 2013 10:32:53 -0800
Message-ID: <20130219183253.GQ17414@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:mime-version
         :content-type:content-disposition:user-agent;
        bh=F9Cg5PvAdkL20UTadnJOOQV7as5hlJU7RQwz4v4FfmU=;
        b=FUqF2YQDHFNcBfDGWdJYP22UpPJgySyZ76gujSHicrrkRnJpuYsWeAvgf5wsCa9gPM
         6nFZucx4dKMn2odXrETlXxKYJ0W2D7+mjkAPSgKAzTGGtTXllucoC+ltUtXjRiPDSL4Z
         5VzU0ZzH3IRZPys0ZmbZuMWMsTC/Mat4yWcRBdoyAI2I0JLdBW/RHEZobolPqUdkDhWe
         IwVgGXunqtw25ak5i+Q/QS+DQRQrLdXzm+OHXgQR1Wgthz6NxxIo/EVVOWtM0MtEyW1k
         QC2eoCTP+6ZjW47MSE8csM119o/GodL8Im9WVtXWLOUQMP8teZxmoTdMY/V0RbcAx7S/
         ++RQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

These are cgroup changes for 3.9-rc1.  Nothing too drastic.

* Removal of synchronize_rcu() from userland visible paths.

* Various fixes and cleanups from Li.

* cgroup_rightmost_descendant() added which will be used by cpuset
  changes (it will be a separate pull request).

The changes are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.9

for you to fetch changes up to f169007b2773f285e098cb84c74aac0154d65ff7:

  cgroup: fail if monitored file and event_control are in different cgroup (2013-02-18 09:31:35 -0800)

----------------------------------------------------------------
Greg Thelen (2):
      cgroups: move cgroup_event_listener.c to tools/cgroup
      cgroups: fix cgroup_event_listener error handling

Li Zefan (15):
      cgroup: use new hashtable implementation
      cgroup: remove synchronize_rcu() from cgroup_attach_{task|proc}()
      cgroup: remove synchronize_rcu() from rebind_subsystems()
      cgroup: fix bogus kernel warnings when cgroup_create() failed
      cgroup: remove a NULL check in cgroup_exit()
      cgroup: initialize cgrp->dentry before css_alloc()
      sched: split out css_online/css_offline from tg creation/destruction
      sched: remove redundant NULL cgroup check in task_group_path()
      cgroup: remove duplicate RCU free on struct cgroup
      cgroup: remove synchronize_rcu() from cgroup_diput()
      cgroup: remove bogus comments in cgroup_diput()
      cgroup: fix exit() vs rmdir() race
      cpuset: fix cpuset_print_task_mems_allowed() vs rename() race
      cgroup: fix cgroup_rmdir() vs close(eventfd) race
      cgroup: fail if monitored file and event_control are in different cgroup

Tejun Heo (2):
      cgroup: remove unused dummy cgroup_fork_callbacks()
      cgroup: implement cgroup_rightmost_descendant()

 Documentation/cgroups/00-INDEX                     |   2 -
 Documentation/cgroups/memcg_test.txt               |   3 +-
 include/linux/cgroup.h                             |   3 +-
 include/linux/sched.h                              |   3 +
 kernel/cgroup.c                                    | 288 ++++++++++++---------
 kernel/cpuset.c                                    |  12 +-
 kernel/sched/auto_group.c                          |   3 +
 kernel/sched/core.c                                |  49 +++-
 kernel/sched/debug.c                               |   7 -
 tools/Makefile                                     |  19 +-
 tools/cgroup/.gitignore                            |   1 +
 tools/cgroup/Makefile                              |  11 +
 .../cgroup}/cgroup_event_listener.c                |  72 ++----
 13 files changed, 270 insertions(+), 203 deletions(-)
 create mode 100644 tools/cgroup/.gitignore
 create mode 100644 tools/cgroup/Makefile
 rename {Documentation/cgroups => tools/cgroup}/cgroup_event_listener.c (54%)

Thanks.

--
tejun
