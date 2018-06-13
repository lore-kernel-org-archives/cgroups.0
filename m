From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v4 1/5] sched/topology: Add check to backup comment about hotplug lock
Date: Wed, 13 Jun 2018 14:17:07 +0200
Message-ID: <20180613121711.5018-2-juri.lelli@redhat.com>
References: <20180613121711.5018-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180613121711.5018-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

From: Mathieu Poirier <mathieu.poirier@linaro.org>

The comment above function partition_sched_domains() clearly state that
the cpu_hotplug_lock should be held but doesn't mandate one to abide to
it.

Add an explicit check backing that comment, so to make it impossible
for anyone to miss the requirement.

Suggested-by: Juri Lelli <juri.lelli@redhat.com>
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
[modified changelog]
Signed-off-by: Juri Lelli <juri.lelli@redhat.com>
---
 kernel/sched/topology.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/topology.c b/kernel/sched/topology.c
index 61a1125c1ae4..96eee22fafe8 100644
--- a/kernel/sched/topology.c
+++ b/kernel/sched/topology.c
@@ -1858,6 +1858,7 @@ void partition_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
 	int i, j, n;
 	int new_topology;
 
+	lockdep_assert_cpus_held();
 	mutex_lock(&sched_domains_mutex);
 
 	/* Always unregister in case we don't destroy any domains: */
-- 
2.14.3

