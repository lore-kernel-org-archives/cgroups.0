From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH 2/2] sched/topology: Update init_sched_domains() comment
Date: Wed, 19 Dec 2018 14:34:45 +0100
Message-ID: <20181219133445.31982-2-juri.lelli@redhat.com>
References: <20181219133445.31982-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181219133445.31982-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

Holding hotplug lock is not a requirement anymore for callers of sched_
init_domains after commit 6acce3ef8452 ("sched: Remove get_online_cpus()
usage").

Update the relative comment preceding init_sched_domains().

Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
---
 kernel/sched/topology.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 8d7f15ba5916..10e61b62f138 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1850,9 +1850,8 @@ void free_sched_domains(cpumask_var_t doms[], unsigned int ndoms)
 }
 
 /*
- * Set up scheduler domains and groups. Callers must hold the hotplug lock.
- * For now this just excludes isolated CPUs, but could be used to
- * exclude other special cases in the future.
+ * Set up scheduler domains and groups.  For now this just excludes isolated
+ * CPUs, but could be used to exclude other special cases in the future.
  */
 int sched_init_domains(const struct cpumask *cpu_map)
 {
-- 
2.17.2

