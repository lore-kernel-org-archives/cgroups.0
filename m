From: Cai Xinchen <caixinchen1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4.19 0/3] Backport patches to fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date: Fri, 3 Mar 2023 04:50:47 +0000
Message-ID: <20230303045050.139985-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: mkoutny-IBi9RG/b67k@public.gmane.org, zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

We have a deadlock problem which can be solved by commit 4f7e7236435ca
("cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock").
However, it makes lock order of cpus_read_lock and cpuset_mutex
wrong in v4.19. The call sequence is as follows:
cgroup_procs_write()
        cgroup_procs_write_start()
                get_online_cpus(); // cpus_read_lock()
                percpu_down_write(&cgroup_threadgroup_rwsem)
        cgroup_attach_task
                cgroup_migrate
                        cgroup_migrate_execute
                                ss->attach (cpust_attach)
                                        mutex_lock(&cpuset_mutex)

it seems hard to make cpus_read_lock is locked before
cgroup_threadgroup_rwsem and cpuset_mutex is locked before
cpus_read_lock unless backport the commit d74b27d63a8beb
("cgroup/cpuset: Change cpuset_rwsem and hotplug lock order")

Juri Lelli (1):
  cgroup/cpuset: Change cpuset_rwsem and hotplug lock order

Tejun Heo (1):
  cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tetsuo Handa (1):
  cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

 include/linux/cpuset.h    |  8 +++----
 kernel/cgroup/cgroup-v1.c |  3 +++
 kernel/cgroup/cgroup.c    | 49 +++++++++++++++++++++++++++++++++++----
 kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
 4 files changed, 66 insertions(+), 19 deletions(-)

-- 
2.17.1

