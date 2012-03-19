From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v3.4
Date: Mon, 19 Mar 2012 15:58:43 -0700
Message-ID: <20120319225843.GA2873@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=2btiIhU4PHWe190wTPY2m52adWHzu/LHD6pkrwFbCGU=;
        b=QydMfiQRzP0XFMQwNl6T41lFm3vaDhsWvfzslsuvS9ft7G713EkH34RzemCEXaw72F
         5jWDBbMaBiAdA4dozf8eXEa1MRHQ61ssdFvGQzIusDuZfPsEdDy5F48CEDNOQQX5PmQv
         BgAyeXUtBDGzvzx3XqsD/aWCGYGqvpKQoeUDKl/VTJVPDqWic1jfB+fDxI5ElZNHlgXF
         0+SJVfac2j/ICOz73QzPlaOjCvo2sE2jnOXYDCoLGyyI3H9u6r81iQK+TAMoLLjMOhiv
         m7bQWhB+vb6dmlKRzFSMk5RJIuQbYCKX3YnVyP1mU28hgXi/ouCnnrw3jrysU+nxVB3P
         s7Mg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mandeep Singh Baines <msb-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Hello, Linus.

Please pull from the following branch to receive cgroup changes for
v3.4.

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.4

Out of the 8 commits, one fixes a long-standing locking issue around
tasklist walking and others are cleanups.

Thanks.

Frederic Weisbecker (2):
      cgroup: Remove wrong comment on cgroup_enable_task_cg_list()
      cgroup: Walk task list under tasklist_lock in cgroup_enable_task_cg_list

Li Zefan (3):
      cgroup: remove cgroup_attach_task_current_cg()
      cgroup: move struct cgroup_pidlist out from the header file
      cgroup: remove cgroup_subsys argument from callbacks

Mandeep Singh Baines (3):
      cgroup: simplify double-check locking in cgroup_attach_proc
      cgroup: replace tasklist_lock with rcu_read_lock
      cgroup: remove extra calls to find_existing_css_set

 Documentation/cgroups/cgroups.txt |   26 ++--
 block/blk-cgroup.c                |   22 +--
 include/linux/cgroup.h            |   70 ++-------
 include/net/sock.h                |    7 +-
 include/net/tcp_memcontrol.h      |    2 +-
 kernel/cgroup.c                   |  327 +++++++++++++++---------------------
 kernel/cgroup_freezer.c           |   11 +-
 kernel/cpuset.c                   |   16 +--
 kernel/events/core.c              |   13 +-
 kernel/sched/core.c               |   20 +--
 mm/memcontrol.c                   |   48 ++----
 net/core/netprio_cgroup.c         |   10 +-
 net/core/sock.c                   |    6 +-
 net/ipv4/tcp_memcontrol.c         |    2 +-
 net/sched/cls_cgroup.c            |   10 +-
 security/device_cgroup.c          |   10 +-
 16 files changed, 228 insertions(+), 372 deletions(-)

--
tejun
