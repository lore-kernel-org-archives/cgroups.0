From: Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: [RFC PATCH 0/9] Add container support for cgroup
Date: Mon, 17 Dec 2012 14:43:26 +0800
Message-ID: <1355726615-15224-1-git-send-email-gaofeng@cn.fujitsu.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Gao feng <gaofeng-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Right now,if we mount cgroup in the container,we will get
host's cgroup informations and even we can change host's
cgroup in container.

So the resource controller of the container will lose
effectiveness.

This patchset try to add contianer support for cgroup.
the main idea is allocateing cgroup super-block for each
cgroup mounted in different pid namespace.

The top cgroup of container will share css with host.
When the cgroup being mounted in contianer,the tasks in
this container will be attached to this new mounted
hierarchy's top cgroup, And when unmounting cgroup in
container,these tasks will be attached back to host's cgroup.

Since the container can change the shared css through it's
cgroup subsystem files. patch 7/8 disable the write permission
of container's top cgroup files. In my TODO list, container
will have it's own css, this problem will disappear.


This patchset is sent as RFC,any comments are welcome.
Maybe this isn't the best solution, if you have better
solution,Please let me know.


Gao feng (9):
  cgroup: introduce cgroupfs_root flag ROOT_NAMESPACE
  cgroup: introduce the top root
  cgroup: use root->top_root instead of root
  introduce helper function cgroup_in_root
  cgroup: add container support for cgroup
  pidns: move next_tgid to kernel/pid.c
  cgroup: attach container's tasks to proper cgroup
  cgroup: disallow container to change top cgroup's subsys files
  cgroup: rework cgroup_path

 fs/proc/base.c        |   43 ------
 include/linux/sched.h |    8 +
 kernel/cgroup.c       |  344 ++++++++++++++++++++++++++++++++++++++----------
 kernel/pid.c          |   39 ++++++
 4 files changed, 319 insertions(+), 115 deletions(-)

-- 
1.7.7.6
