From: Waiman Long <longman@redhat.com>
Subject: [PATCH v7 0/5] cpuset: Enable cpuset controller in default hierarchy
Date: Thu, 19 Apr 2018 09:46:59 -0400
Message-ID: <1524145624-23655-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Waiman Long <longman@redhat.com>

v7:
 - Add a root-only cpuset.cpus.isolated control file for CPU isolation.
 - Enforce that load_balancing can only be turned off on cpusets with
   CPUs from the isolated list.
 - Update sched domain generation to allow cpusets with CPUs only
   from the isolated CPU list to be in separate root domains.

v6:
 - Hide cpuset control knobs in root cgroup.
 - Rename effective_cpus and effective_mems to cpus.effective and
   mems.effective respectively.
 - Remove cpuset.flags and add cpuset.sched_load_balance instead
   as the behavior of sched_load_balance has changed and so is
   not a simple flag.
 - Update cgroup-v2.txt accordingly.

v5:
 - Add patch 2 to provide the cpuset.flags control knob for the
   sched_load_balance flag which should be the only feature that is
   essential as a replacement of the "isolcpus" kernel boot parameter.

v4:
 - Further minimize the feature set by removing the flags control knob.

v3:
 - Further trim the additional features down to just memory_migrate.
 - Update Documentation/cgroup-v2.txt.

v6 patch: https://lkml.org/lkml/2018/3/21/530

The purpose of this patchset is to provide a basic set of cpuset
features for cgroup v2. This basic set includes the non-root "cpus",
"mems", "cpus.effective" and "mems.effective", "sched_load_balance"
control file as well as a root-only "cpus.isolated".

The root-only "cpus.isolated" file is added to support use cases similar
to the "isolcpus" kernel parameter. CPUs from the isolated list can be
put into child cpusets where "sched_load_balance" can be disabled to
allow finer control of task-cpu mappings of those isolated CPUs.

On the other hand, enabling the "sched_load_balance" on a cpuset with
only CPUs from the isolated list will allow those CPUs to use a separate
root domain from that of the root cpuset.

This patchset does not exclude the possibility of adding more features
in the future after careful consideration.

Patch 1 enables cpuset in cgroup v2 with cpus, mems and their
effective counterparts.

Patch 2 adds sched_load_balance whose behavior changes in v2 to become
hierarchical and includes an implicit !cpu_exclusive.

Patch 3 adds a new root-only "cpuset.cpus.isolated" control file for
CPU isolation purpose.

Patch 4 adds the limitation that "sched_load_balance" can only be turned
off in a cpuset if all the CPUs in the cpuset are already in the root's
"cpuset.cpus.isolated".

Patch 5 modifies the sched domain generation code to generate separate root
sched domains if all the CPUs in a cpuset comes from "cpuset.cpus.isolated".

In other words, all the CPUs that need to be isolated or in separate
root domains have to be put into the "cpuset.cpus.isolated" first. Then
child cpusets can be created to partition those isolated CPUs into
either separate root domains with "sched_load_balance" on or really
isolated CPUs with "sched_load_balance" off. Load balancing cannot
be turned off at root.

Waiman Long (5):
  cpuset: Enable cpuset controller in default hierarchy
  cpuset: Add cpuset.sched_load_balance to v2
  cpuset: Add a root-only cpus.isolated v2 control file
  cpuset: Restrict load balancing off cpus to subset of cpus.isolated
  cpuset: Make generate_sched_domains() recognize isolated_cpus

 Documentation/cgroup-v2.txt | 138 ++++++++++++++++++++-
 kernel/cgroup/cpuset.c      | 287 +++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 404 insertions(+), 21 deletions(-)

-- 
1.8.3.1

