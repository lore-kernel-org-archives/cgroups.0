From: Waiman Long <longman@redhat.com>
Subject: [PATCH v9 0/7] Enable cpuset controller in default hierarchy
Date: Tue, 29 May 2018 09:41:27 -0400
Message-ID: <1527601294-3444-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Waiman Long <longman@redhat.com>

v9:
 - Rename cpuset.sched.domain to cpuset.sched.domain_root to better
   identify its purpose as the root of a new scheduling domain or
   partition.
 - Clarify in the document about the purpose of domain_root and
   load_balance. Using domain_root is th only way to create new
   partition.
 - Fix a lockdep warning in update_isolated_cpumask() function.
 - Add a new patch to eliminate call to generate_sched_domains() for
   v2 when a change in cpu list does not touch a domain_root.

v8:
 - Remove cpuset.cpus.isolated and add a new cpuset.sched.domain flag
   and rework the code accordingly.

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
v7 patch: https://lkml.org/lkml/2018/4/19/448
v8 patch: https://lkml.org/lkml/2018/5/17/939

The purpose of this patchset is to provide a basic set of cpuset control
files for cgroup v2. This basic set includes the non-root "cpus", "mems",
"sched.load_balance" and "sched.domain_root". The "cpus.effective" and
"mems.effective" will appear in all cpuset-enabled cgroups.

The new control file that is unique to v2 is "sched.domain_root". It
is a boolean flag file that designates if a cgroup is the root of a new
scheduling domain or partition with its own set of unique list of CPUs
from scheduling perspective disjointed from other partitions. The root
cgroup is always a scheduling domain root. Multiple levels of scheduling
domains are supported with some limitations. So a container scheduling
domain root can behave like a real root.

When a scheduling domain root cgroup is removed, its list of exclusive
CPUs will be returned to the parent's cpus.effective automatically.

The "sched.load_balance" flag can only be changed in a scheduling
domain root with no child cpuset-enabled cgroups while the rests
inherit its value from their parents. This ensures that all cpusets
within the same partition will have the same load balancing state. The
"sched.load_balance" flag can no longer be used to create additional
partition as a side effect.

This patchset does not exclude the possibility of adding more features
in the future after careful consideration.

Patch 1 enables cpuset in cgroup v2 with cpus, mems and their
effective counterparts.

Patch 2 adds a new "sched.domain_root" control file for setting up
multiple scheduling domains or partitions. A scheduling domain root
implies cpu_exclusive.

Patch 3 adds a "sched.load_balance" flag to turn off load balancing in
a scheduling domain or partition.

Patch 4 updates the scheduling domain genaration code to work with
the new scheduling domain feature.

Patch 5 exposes cpus.effective and mems.effective to the root cgroup as
enabling child scheduling domains will take CPUs away from the root cgroup.
So it will be nice to monitor what CPUs are left there.

Patch 6 eliminates the need to rebuild sched domains for v2 if cpu list
changes occur to non-domain root cpusets only.

Patch 7 enables the printing the debug information about scheduling
domain generation.

Waiman Long (7):
  cpuset: Enable cpuset controller in default hierarchy
  cpuset: Add new v2 cpuset.sched.domain_root flag
  cpuset: Add cpuset.sched.load_balance flag to v2
  cpuset: Make generate_sched_domains() recognize isolated_cpus
  cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
  cpuset: Don't rebuild sched domains if cpu changes in non-domain root
  cpuset: Allow reporting of sched domain generation info

 Documentation/cgroup-v2.txt | 144 +++++++++++++++-
 kernel/cgroup/cpuset.c      | 396 ++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 518 insertions(+), 22 deletions(-)

-- 
1.8.3.1

