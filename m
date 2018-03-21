From: Waiman Long <longman@redhat.com>
Subject: [PATCH v6 0/2] cpuset: Enable cpuset controller in default hierarchy
Date: Wed, 21 Mar 2018 12:21:47 -0400
Message-ID: <1521649309-26690-1-git-send-email-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Waiman Long <longman@redhat.com>

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

The purpose of this patchset is to provide a minimal set of cpuset
features for cgroup v2. That minimal set includes the cpus, mems,
cpus.effective and mems.effective and sched_load_balance. The last one is
needed to support use cases similar to the "isolcpus" kernel parameter.

This patchset does not exclude the possibility of adding more flags
and features in the future after careful consideration.

Patch 1 enables cpuset in cgroup v2 with cpus, mems and their
effective counterparts.

Patch 2 adds sched_load_balance whose behavior changes in v2 to become
hierarchical and includes an implicit !cpu_exclusive.

Waiman Long (2):
  cpuset: Enable cpuset controller in default hierarchy
  cpuset: Add cpuset.sched_load_balance to v2

 Documentation/cgroup-v2.txt | 112 ++++++++++++++++++++++++++++++++++++++++++--
 kernel/cgroup/cpuset.c      | 104 ++++++++++++++++++++++++++++++++++++----
 2 files changed, 201 insertions(+), 15 deletions(-)

-- 
1.8.3.1

