From: chengkaitao <chengkaitao@didiglobal.com>
Subject: [PATCH v4 0/2] memcontrol: support cgroup level OOM protection
Date: Wed, 17 May 2023 11:20:30 +0800
Message-ID: <20230517032032.76334-1-chengkaitao@didiglobal.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-doc-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, brauner@kernel.org, muchun.song@linux.dev
Cc: viro@zeniv.linux.org.uk, zhengqi.arch@bytedance.com, ebiederm@xmission.com, Liam.Howlett@Oracle.com, chengzhihao1@huawei.com, pilgrimtao@gmail.com, haolee.swjtu@gmail.com, yuzhao@google.com, willy@infradead.org, vasily.averin@linux.dev, vbabka@suse.cz, surenb@google.com, sfr@canb.auug.org.au, mcgrof@kernel.org, sujiaxun@uniontech.com, feng.tang@intel.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, chengkaitao <chengkaitao@didiglobal.com>

Establish a new OOM score algorithm, supports the cgroup level OOM
protection mechanism. When an global/memcg oom event occurs, we treat
all processes in the cgroup as a whole, and OOM killers need to select
the process to kill based on the protection quota of the cgroup.

Here is a more detailed comparison and introduction of the old 
oom_score_adj mechanism and the new oom_protect mechanism,

1. The regulating granularity of oom_protect is smaller than that of
   oom_score_adj. On a 512G physical machine, the minimum granularity
   adjusted by oom_score_adj is 512M, and the minimum granularity
   adjusted by oom_protect is one page (4K)
2. It may be simple to create a lightweight parent process and uniformly
   set the oom_score_adj of some important processes, but it is not a
   simple matter to make multi-level settings for tens of thousands of
   processes on the physical machine through the lightweight parent
   processes. We may need a huge table to record the value of oom_score_adj
   maintained by all lightweight parent processes, and the user process
   limited by the parent process has no ability to change its own
   oom_score_adj, because it does not know the details of the huge
   table. on the other hand, we have to set the common parent process'
   oom_score_adj, before it forks all children processes. We must strictly
   follow this setting sequence, and once oom_score_adj is set, it cannot
   be changed. To sum up, it is very difficult to apply oom_score_adj in
   other situations. The new patch adopts the cgroup mechanism. It does not
   need any parent process to manage oom_score_adj. the settings between
   each memcg are independent of each other, making it easier to plan the
   OOM order of all processes. Due to the unique nature of memory
   resources, current Service cloud vendors are not oversold in memory
   planning. I would like to use the new patch to try to achieve the
   possibility of oversold memory resources.
3. I conducted a test and deployed an excessive number of containers on
   a physical machine, By setting the oom_score_adj value of all processes
   in the container to a positive number through dockerinit, even processes
   that occupy very little memory in the container are easily killed,
   resulting in a large number of invalid kill behaviors. If dockerinit is
   also killed unfortunately, it will trigger container self-healing, and
   the container will rebuild, resulting in more severe memory
   oscillations. The new patch abandons the behavior of adding an equal
   amount of oom_score_adj to each process in the container and adopts a
   shared oom_protect quota for all processes in the container. If a
   process in the container is killed, the remaining other processes will
   receive more oom_protect quota, making it more difficult for the
   remaining processes to be killed. In my test case, the new patch reduced
   the number of invalid kill behaviors by 70%. 
4. oom_score_adj is a global configuration that cannot achieve a kill
   order that only affects a certain memcg-oom-killer. However, the
   oom_protect mechanism inherits downwards (If the oom_protect quota of
   the parent cgroup is less than the sum of sub-cgroups oom_protect quota,
   the oom_protect quota of each sub-cgroup will be proportionally reduced.
   If the oom_protect quota of the parent cgroup is greater than the sum of
   sub-cgroups oom_protect quota, the oom_protect quota of each sub-cgroup
   will be proportionally increased). The purpose of doing so is that users
   can set oom_protect quota according to their own needs, and the system
   management process can set appropriate oom_protect quota on the parent
   memcg as the final cover. If the oom_protect of the parent cgroup is 0,
   the kill order of memcg-oom or global-ooms will not be affected by user
   specific settings.
5. Per-process accounting does not count shared memory, similar to
   active page cache, which also increases the probability of OOM-kill.
   However, the memcg accounting may be more reasonable, as its memory
   statistics are more comprehensive. In the new patch, all the shared
   memory will also consume the oom_protect quota of the memcg, and the
   process's oom_protect quota of the memcg will decrease, the probability
   of they being killed will increase.
6. In the final discussion of patch v2, we discussed that although the
   adjustment range of oom_score_adj is [-1000,1000], but essentially it
   only allows two usecases(OOM_SCORE_ADJ_MIN, OOM_SCORE_ADJ_MAX) reliably.
   Everything in between is clumsy at best. In order to solve this problem
   in the new patch, I introduced a new indicator oom_kill_inherit, which
   counts the number of times the local and child cgroups have been
   selected by the OOM killer of the ancestor cgroup. oom_kill_inherit
   maintains a negative correlation with memory.oom.protect, so we have a
   ruler to measure the optimal value of memory.oom.protect. By observing
   the proportion of oom_kill_inherit in the parent cgroup, I can
   effectively adjust the value of oom_protect to achieve the best.

Changelog:
v4:
  * Fix warning: overflow in expression. (patch 1)
  * Supplementary commit information. (patch 0)
v3:
  * Add "auto" option for memory.oom.protect. (patch 1)
  * Fix division errors. (patch 1)
  * Add observation indicator oom_kill_inherit. (patch 2)
  https://lore.kernel.org/linux-mm/20230506114948.6862-1-chengkaitao@didiglobal.com/
v2:
  * Modify the formula of the process request memcg protection quota.
  https://lore.kernel.org/linux-mm/20221208034644.3077-1-chengkaitao@didiglobal.com/
v1:
  https://lore.kernel.org/linux-mm/20221130070158.44221-1-chengkaitao@didiglobal.com/

chengkaitao (2):
  mm: memcontrol: protect the memory in cgroup from being oom killed
  memcg: add oom_kill_inherit event indicator

 Documentation/admin-guide/cgroup-v2.rst |  29 ++++-
 fs/proc/base.c                          |  17 ++-
 include/linux/memcontrol.h              |  46 +++++++-
 include/linux/oom.h                     |   3 +-
 include/linux/page_counter.h            |   6 +
 mm/memcontrol.c                         | 199 ++++++++++++++++++++++++++++++++
 mm/oom_kill.c                           |  25 ++--
 mm/page_counter.c                       |  30 +++++
 8 files changed, 334 insertions(+), 21 deletions(-)

-- 
2.14.1

