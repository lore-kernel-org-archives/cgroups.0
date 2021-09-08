From: Yi Tao <escape-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [RFC PATCH 0/2] support cgroup pool in v1
Date: Wed,  8 Sep 2021 20:15:11 +0800
Message-ID: <cover.1631102579.git.escape@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shanpeic-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org

In a scenario where containers are started with high concurrency, in
order to control the use of system resources by the container, it is
necessary to create a corresponding cgroup for each container and
attach the process. The kernel uses the cgroup_mutex global lock to
protect the consistency of the data, which results in a higher
long-tail delay for cgroup-related operations during concurrent startup.
For example, long-tail delay of creating cgroup under each subsystems
is 900ms when starting 400 containers, which becomes bottleneck of
performance. The delay is mainly composed of two parts, namely the
time of the critical section protected by cgroup_mutex and the
scheduling time of sleep. The scheduling time will increase with
the increase of the cpu overhead.

In order to solve this long-tail delay problem, we designed a cgroup
pool. The cgroup pool will create a certain number of cgroups in advance.
When a user creates a cgroup through the mkdir system call, a clean cgroup
can be quickly obtained from the pool. Cgroup pool draws on the idea of
cgroup rename. By creating pool and rename in advance, it reduces the
critical area of cgroup creation, and uses a spinlock different from
cgroup_mutex, which reduces scheduling overhead on the one hand, and eases
competition with attaching processes on the other hand.

The core idea of implementing a cgroup pool is to create a hidden kernfs
tree. Cgroup is implemented based on the kernfs file system. The user
manipulates the cgroup through the kernfs file. Therefore, we can create
a cgroup in advance and place it in a hidden kernfs tree, so that the user
can not operate the cgroup. When the user needs to create one, move the
cgroup to its original location. Because this only needs to remove a node
from one kernfs tree and move it to another tree, it does not affect other
data of the cgroup and related subsystems, so this operation is very
efficient and fast, and there is no need to hold cgroup_mutex. In this
way, we get rid of the limitation of cgroup_mutex and reduce the time
consumption of the critical section, but the kernfs_rwsem is still
protecting the kernfs-related data structure, and the scheduling time
of sleep still exists.

In order to avoid the use of kernfs_rwsem, we introduced a pinned state for
the kernfs node. When the pinned state of this node is true, the lock that
protects the data of this node is changed from kernfs_rwsem to a lock that
can be set. In the scenario of a cgroup pool, the parent cgroup will have a
corresponding spinlock. When the pool is enabled, the kernfs nodes of all
cgroups under the parent cgroup are set to the pinned state. Create,
delete, and move these kernfs nodes are protected by the spinlock of the
parent cgroup, so data consistency will not be a problem.

After opening the pool, the user creates a cgroup will take the fast path
and obtain it from the cgroup pool. Deleting cgroups still take the slow
path. When resources in the pool are insufficient, a delayed task will be
triggered, and the pool will be replenished after a period of time. This
is done to avoid competition with the current creation of cgroups and thus
affect performance. When the resources in the pool are exhausted and not
replenished in time, the creation of a cgroup will take a slow path,
so users need to set an appropriate pool size and supplementary delay time.

What we did in the patches are:
	1.add pinned flags for kernfs nodes, so that they can get rid of
	kernfs_rwsem and choose to be protected by other locks.
	2.add pool_size interface which used to open cgroup pool and
	close cgroup pool.
	3.add extra kernfs tree which used to hide cgroup in pool.
	4.add spinlock to protect kernfs nodes of cgroup in pool


Yi Tao (2):
  add pinned flags for kernfs node
  support cgroup pool in v1

 fs/kernfs/dir.c             |  74 ++++++++++++++++-------
 include/linux/cgroup-defs.h |  16 +++++
 include/linux/cgroup.h      |   2 +
 include/linux/kernfs.h      |  14 +++++
 kernel/cgroup/cgroup-v1.c   | 139 ++++++++++++++++++++++++++++++++++++++++++++
 kernel/cgroup/cgroup.c      | 113 ++++++++++++++++++++++++++++++++++-
 kernel/sysctl.c             |   8 +++
 7 files changed, 345 insertions(+), 21 deletions(-)

-- 
1.8.3.1

