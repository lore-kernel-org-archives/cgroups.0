From: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] psi: dont alloc memory for psi by default
Date: Thu, 26 May 2022 20:26:56 +0800
Message-ID: <20220526122656.256274-1-chenwandun@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Memory about struct psi_group is allocated by default for
each cgroup even if psi_disabled is true, in this case, these
allocated memory is waste, so alloc memory for struct psi_group
only when psi_disabled is false.

Signed-off-by: Chen Wandun <chenwandun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup-defs.h |  2 +-
 include/linux/cgroup.h      |  2 +-
 kernel/cgroup/cgroup.c      |  8 ++++----
 kernel/sched/psi.c          | 19 +++++++++++++------
 4 files changed, 19 insertions(+), 12 deletions(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 1bfcfb1af352..672de25e3ec8 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -475,7 +475,7 @@ struct cgroup {
 	struct work_struct release_agent_work;
 
 	/* used to track pressure stalls */
-	struct psi_group psi;
+	struct psi_group *psi;
 
 	/* used to store eBPF programs */
 	struct cgroup_bpf bpf;
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0d1ada8968d7..ed53bfe7c46c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -674,7 +674,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 
 static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
 {
-	return &cgrp->psi;
+	return cgrp->psi;
 }
 
 bool cgroup_psi_enabled(void);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 1779ccddb734..90a654cb8a1e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3609,21 +3609,21 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
 static int cgroup_io_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
 
 	return psi_show(seq, psi, PSI_IO);
 }
 static int cgroup_memory_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
 
 	return psi_show(seq, psi, PSI_MEM);
 }
 static int cgroup_cpu_pressure_show(struct seq_file *seq, void *v)
 {
 	struct cgroup *cgrp = seq_css(seq)->cgroup;
-	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	struct psi_group *psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
 
 	return psi_show(seq, psi, PSI_CPU);
 }
@@ -3649,7 +3649,7 @@ static ssize_t cgroup_pressure_write(struct kernfs_open_file *of, char *buf,
 		return -EBUSY;
 	}
 
-	psi = cgroup_ino(cgrp) == 1 ? &psi_system : &cgrp->psi;
+	psi = cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
 	new = psi_trigger_create(psi, buf, nbytes, res);
 	if (IS_ERR(new)) {
 		cgroup_put(cgrp);
diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index a337f3e35997..ec66b40bdd40 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -957,10 +957,16 @@ int psi_cgroup_alloc(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return 0;
 
-	cgroup->psi.pcpu = alloc_percpu(struct psi_group_cpu);
-	if (!cgroup->psi.pcpu)
+	cgroup->psi = kmalloc(sizeof(struct psi_group), GFP_KERNEL);
+	if (!cgroup->psi)
 		return -ENOMEM;
-	group_init(&cgroup->psi);
+
+	cgroup->psi->pcpu = alloc_percpu(struct psi_group_cpu);
+	if (!cgroup->psi->pcpu) {
+		kfree(cgroup->psi);
+		return -ENOMEM;
+	}
+	group_init(cgroup->psi);
 	return 0;
 }
 
@@ -969,10 +975,11 @@ void psi_cgroup_free(struct cgroup *cgroup)
 	if (static_branch_likely(&psi_disabled))
 		return;
 
-	cancel_delayed_work_sync(&cgroup->psi.avgs_work);
-	free_percpu(cgroup->psi.pcpu);
+	cancel_delayed_work_sync(&cgroup->psi->avgs_work);
+	free_percpu(cgroup->psi->pcpu);
 	/* All triggers must be removed by now */
-	WARN_ONCE(cgroup->psi.poll_states, "psi: trigger leak\n");
+	WARN_ONCE(cgroup->psi->poll_states, "psi: trigger leak\n");
+	kfree(cgroup->psi);
 }
 
 /**
-- 
2.25.1

