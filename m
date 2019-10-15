From: Valentin Schneider <valentin.schneider@arm.com>
Subject: [PATCH v3 0/2] sched/topology: Asymmetric topologies fixes
Date: Tue, 15 Oct 2019 16:42:48 +0100
Message-ID: <20191015154250.12951-1-valentin.schneider@arm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: lizefan@huawei.com, tj@kernel.org, hannes@cmpxchg.org, mingo@kernel.org, peterz@infradead.org, vincent.guittot@linaro.org, Dietmar.Eggemann@arm.com, morten.rasmussen@arm.com, qperret@google.com

Hi,

I got a nice splat while testing out the toggling of
sched_asym_cpucapacity, so this gets a new patch.

Details are in the logs.

v2 changes:
  - Use static_branch_{inc,dec} rather than enable/disable

v3 changes:
  - New patch: add fix for empty cpumap in sched domain rebuild
  - Move static_branch_dec outside of RCU read-side section (Quentin)

Cheers,
Valentin

Valentin Schneider (2):
  sched/topology: Don't try to build empty sched domains
  sched/topology: Allow sched_asym_cpucapacity to be disabled

 kernel/cgroup/cpuset.c  |  8 ++++++++
 kernel/sched/topology.c | 11 +++++++++--
 2 files changed, 17 insertions(+), 2 deletions(-)

--
2.22.0

