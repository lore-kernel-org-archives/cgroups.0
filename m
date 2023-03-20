From: Cai Xinchen <caixinchen1@huawei.com>
Subject: [PATCH v2 4.19 0/3] Backport patches to fix threadgroup_rwsem <-> cpus_read_lock() deadlock
Date: Mon, 20 Mar 2023 01:15:04 +0000
Message-ID: <20230320011507.129441-1-caixinchen1@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: longman@redhat.com, lizefan.x@bytedance.com, tj@kernel.org, hannes@cmpxchg.org, gregkh@linuxfoundation.org, sashal@kernel.org
Cc: mkoutny@suse.com, zhangqiao22@huawei.com, juri.lelli@redhat.com, penguin-kernel@I-love.SAKURA.ne.jp, stable@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

I am very sorry. My gcc version is 7.5 and it does not report error.

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

Changes in v2:
        * Add #include <linux/cpu.h> in kernel/cgroup/cgroup.c to
         avoid some compile error.
        * Exchange get_online_cpus() location in cpuset_attach to
         keep cpu_hotplug_lock->cpuset_mutex order, although it will
          be remove by ("cgroup: Fix threadgroup_rwsem <->
         cpus_read_lock() deadlock")

Juri Lelli (1):
  cgroup/cpuset: Change cpuset_rwsem and hotplug lock order

Tejun Heo (1):
  cgroup: Fix threadgroup_rwsem <-> cpus_read_lock() deadlock

Tetsuo Handa (1):
  cgroup: Add missing cpus_read_lock() to cgroup_attach_task_all()

 include/linux/cpuset.h    |  8 +++----
 kernel/cgroup/cgroup-v1.c |  3 +++
 kernel/cgroup/cgroup.c    | 50 +++++++++++++++++++++++++++++++++++----
 kernel/cgroup/cpuset.c    | 25 ++++++++++++--------
 4 files changed, 67 insertions(+), 19 deletions(-)

-- 
2.17.1

