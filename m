From: Waiman Long <longman@redhat.com>
Subject: [PATCH v15 00/12] Enable cpuset controller in default hierarchy
Date: Thu,  8 Nov 2018 10:08:34 -0500
Message-ID: <1541689726-20088-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Tom Hromatka <tom.hromatka@oracle.com>, Waiman Long <longman@redhat.com>

v15:
 - Change the partition state descriptive text to "root", "member" and
   "root invalid" as suggested by Tejun.
 - Move the descriptive text patch up to before the documentation patch.
 - Address comments raised by PeterZ.

v14:
 - Fix a bug about cpumask handling in patch 4 by using
   CONFIG_CPUMASK_OFFSTACK #ifdef block.
 - Add patch 12 to show descriptive name when reading
   cpuset.sched.partition (suggested by Tejun).
 - Change the function prototype of free_cpumasks() to match that of
   alloc_cpumasks() (suggested by Tom Hromatka).

v13:
 - A major rewrite of the partition code so that there will be no
   auto-turning off anymore. Instead, the partition root can enter into
   an error state that can be restored back to a partition root later on.
 - Patches 1 and 9 are the same as previous version, the rests are
   either new or substantially revised.

v12:
 - Take out the debugging patch to print partitions.
 - Add a patch to force turning off partition flag if newly modified CPU
   list doesn't meet the requirement of being a partition root.
 - Remove some unneeded checking code in update_reserved_cpumask().

v12 patch: https://lkml.org/lkml/2018/8/27/423
v13 patch: https://lkml.org/lkml/2018/10/12/861
v14 patch: https://lkml.org/lkml/2018/10/16/28

The purpose of this patchset is to provide a basic set of cpuset control
files for cgroup v2. This basic set includes the non-root "cpus",
"mems" and "sched.partition". The "cpus.effective" and "mems.effective"
will appear in all cpuset-enabled cgroups.

The new control file that is unique to v2 is "sched.partition". It is
a tristate flag file that designates if a cgroup is the root of a new
scheduling domain or partition with its own set of unique list of CPUs
from scheduling perspective disjointed from other partitions. An user
can write only "1" or "0" or the corresponding descriptive text "root" or
"member" into this file to turn on and off partition root.  Depending on
circumstances, a partition root may become invalid and has a flag value
of -1 ("root invalid"). However, if condition becomes favorable again,
it can be changed back to a partition root automatically.

The root cgroup is always a partition root. Multiple levels of partitions
are supported with some limitations. So a container partition root can
behave like a real root.

When a partition root cgroup is removed, its list of exclusive CPUs
will be returned back to the parent's cpus.effective automatically.

A container root can be a partition root with sub-partitions
created underneath it. One difference from the real root is that the
"cpuset.sched.partition" flag isn't present in the real root, but is
present in a container root. This is also true for other cpuset control
files as well as those from the other controllers. This is a general
issue that is not going to be addressed here in this patchset.

This patchset does not exclude the possibility of adding more features
in the future after careful consideration.

Patch 1 enables cpuset in cgroup v2 with cpus, mems and their effective
counterparts.

Patch 2 defines new data structures to support partitioning.

Patch 3 simplifies the allocation and freeing of cpumasks in the cpuset
code and prepares for use by subsequent patches.

Patch 4 adds a new "sched.partition" control file for setting up multiple
scheduling domains or partitions. A partition root implies cpu_exclusive.

Patch 5 makes new "sched.partition" file to have a new error value of -1
which indicates that the partition root enters into an invalid state
where some of the constraints of a partition root (like cpu_exclusive)
will still hold but it is not a real partition root anymore. This allows
the cpuset to change back to a partition root later on automatically
if the conditions become favorable again.

Patch 6 adds tracking of the number of cpusets that use the parent's
effective_cpus in order to make sure that those cpusets will be properly
updated if their parents effective cpus changes because of changes in
sibling partitions.

Patch 7 makes the hotplug code deal with partition root properly.

Patch 8 updates the scheduling domain genaration code to work with
the new partition feature.

Patch 9 exposes cpus.effective and mems.effective to the root cgroup
as enabling child partitions will take CPUs away from the root cgroup.
So it will be nice to monitor what CPUs are left there.

Patch 10 changes the output of reading cpuset.sched.partition from
integer to the descriptive text "root", "member" or "root invalid"
similar to what cgroup.type is doing. The first two text strings are
also accepted when writing into cpuset.sched.partition.

Patch 11 updates the cgroup v2 documentation file with information
about the new "sched.partition" file.

Patch 12 adds a new read-only "cpus.subpartitions" file that list the
CPUs in the subparts_cpus mask in the cpuset data structure when the
command line option "cgroup_debug" is specified. This is mostly used
for debugging and verification purposes.

A test script with various cpuset configurations was run on both regular
and debug kernels with this patchset applied to verify that the cpusets
behaved appropriate without unexpected error.


Waiman Long (12):
  cpuset: Enable cpuset controller in default hierarchy
  cpuset: Define data structures to support scheduling partition
  cpuset: Simply allocation and freeing of cpumasks
  cpuset: Add new v2 cpuset.sched.partition flag
  cpuset: Add an error state to cpuset.sched.partition
  cpuset: Track cpusets that use parent's effective_cpus
  cpuset: Make CPU hotplug work with partition
  cpuset: Make generate_sched_domains() work with partition
  cpuset: Expose cpus.effective and mems.effective on cgroup v2 root
  cpuset: Use descriptive text when reading/writing
    cpuset.sched.partition
  cpuset: Add documentation about the new "cpuset.sched.partition" flag
  cpuset: Expose cpuset.cpus.subpartitions with cgroup_debug

 Documentation/admin-guide/cgroup-v2.rst | 182 +++++-
 include/linux/cgroup-defs.h             |   1 +
 kernel/cgroup/cgroup-internal.h         |   2 +
 kernel/cgroup/cgroup.c                  |  14 +-
 kernel/cgroup/cpuset.c                  | 942 +++++++++++++++++++++++++++++---
 kernel/cgroup/debug.c                   |   4 +-
 6 files changed, 1070 insertions(+), 75 deletions(-)

-- 
1.8.3.1

