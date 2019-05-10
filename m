From: Dan Schatzberg <dschatzberg@fb.com>
Subject: [PATCH] psi: Expose pressure metrics on root cgroup
Date: Fri, 10 May 2019 10:49:34 -0700
Message-ID: <20190510174938.3361741-1-dschatzberg@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-type; s=facebook;
 bh=Vx+fboig1rRLQHiyt4x8kMFHXQDhcpUyPZUqbGASJ+s=;
 b=ZB5habr6JwKSQxVtjXM6wum/5y6gDXvf1zm3QSA0WIyWoZO0i14+TM/b/oM7egq7bYiV
 3g4QhKmma8jg8vvjz2wUOWmy60hvB5hQzF2j+cqTAiUfHn1ekIBYt1MxDskTPe6YkOVe
 PIOagbPtqJaAf4h5/koWYEhvVUOzJAzSXGs= 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: Dan Schatzberg <dschatzberg@fb.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Pressure metrics are already recorded and exposed in procfs for the
entire system, but any tool which monitors cgroup pressure has to
special case the root cgroup to read from procfs. This patch exposes
the already recorded pressure metrics on the root cgroup.

Signed-off-by: Dan Schatzberg <dschatzberg@fb.com>
---
 include/linux/psi.h    |  1 +
 kernel/cgroup/cgroup.c | 18 ++++++++++++------
 kernel/sched/psi.c     |  2 +-
 3 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index fc08da2bcc0a..64740dc42aa2 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -10,6 +10,7 @@ struct css_set;
 #ifdef CONFIG_PSI
 
 extern bool psi_disabled;
+extern struct psi_group psi_system;
 
 void psi_init(void);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dc8adb124874..3a748c746324 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3392,15 +3392,24 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 #ifdef CONFIG_PSI
 static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 {
-	return psi_show(seq, &seq_css(seq)->cgroup->psi, PSI_CPU);
+	struct cgroup *cgroup = seq_css(seq)->cgroup;
+	struct psi_group *psi = cgroup->id == 1 ? &psi_system : &cgroup->psi;
+
+	return psi_show(seq, psi, PSI_CPU);
 }
 static int cgroup_memory_pressure_show(struct seq_file *seq, void *v)
 {
-	return psi_show(seq, &seq_css(seq)->cgroup->psi, PSI_MEM);
+	struct cgroup *cgroup = seq_css(seq)->cgroup;
+	struct psi_group *psi = cgroup->id == 1 ? &psi_system : &cgroup->psi;
+
+	return psi_show(seq, psi, PSI_MEM);
 }
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
 {
-	return psi_show(seq, &seq_css(seq)->cgroup->psi, PSI_IO);
+	struct cgroup *cgroup = seq_css(seq)->cgroup;
+	struct psi_group *psi = cgroup->id == 1 ? &psi_system : &cgroup->psi;
+
+	return psi_show(seq, psi, PSI_IO);
 }
 #endif
 
@@ -4518,17 +4527,14 @@ static struct cftype cgroup_base_files[] = {
 #ifdef CONFIG_PSI
 	{
 		.name = "cpu.pressure",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_cpu_pressure_show,
 	},
 	{
 		.name = "memory.pressure",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_memory_pressure_show,
 	},
 	{
 		.name = "io.pressure",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.seq_show = cgroup_io_pressure_show,
 	},
 #endif
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index cc3faf56b614..59e67b3c3bc4 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -150,7 +150,7 @@ static u64 psi_period __read_mostly;
 
 /* System-level pressure and stall tracking */
 static DEFINE_PER_CPU(struct psi_group_cpu, system_group_pcpu);
-static struct psi_group psi_system = {
+struct psi_group psi_system = {
 	.pcpu = &system_group_pcpu,
 };
 
-- 
2.17.1

