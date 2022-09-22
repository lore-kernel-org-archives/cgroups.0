From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [RFC PATCH 19/20] x86/sgx: Add stats and events interfaces to EPC cgroup controller
Date: Thu, 22 Sep 2022 10:10:56 -0700
Message-ID: <20220922171057.1236139-20-kristen@linux.intel.com>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866821; x=1695402821;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Zhko5yUObMvnwMj2ppPRiU1c++lm7yggSa7NwT4K8xo=;
  b=jfkTG6mc0ySGFA+oXCY9GEW/MgOnNB0FvGUDO3Nb0hQJ4FSgvJKUlM0d
   Z0wWMB7jiAgrjYj+CCAPRAYj+EkdqjinBmcpXzPXjh3VDRqE33lvM2TNQ
   OdUGShRO9wlS307grgxqWM4Gg/GPMa7qIo7xwvsW+osaEyO0lrFBZiSZn
   xyJhVKA7oVIehcQRxztDDDoiyAIDdH/OACm1g1twp8p2KZ52+y84PDd3p
   +TL4cAJsD7Ru+YRfvfiYf63HU5qup7mCdr/pm4A6WMOTOEhz0pv9DAq3S
   1vuGF1PEjFAuyHCUjvfXPdTxGpA+wfsg+sEWf08J49n8PV+JnadZZXDmC
   A==;
In-Reply-To: <20220922171057.1236139-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Enable the cgroup sgx_epc.stats and sgx_epc.events files and
associated counters.

Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 arch/x86/kernel/cpu/sgx/epc_cgroup.c | 134 +++++++++++++++++++++++++--
 arch/x86/kernel/cpu/sgx/epc_cgroup.h |  16 +++-
 arch/x86/kernel/cpu/sgx/main.c       |   6 +-
 3 files changed, 145 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/cpu/sgx/epc_cgroup.c b/arch/x86/kernel/cpu/sgx/epc_cgroup.c
index 71da3b499950..8541029b86be 100644
--- a/arch/x86/kernel/cpu/sgx/epc_cgroup.c
+++ b/arch/x86/kernel/cpu/sgx/epc_cgroup.c
@@ -77,6 +77,43 @@ static struct sgx_epc_cgroup *parent_epc_cgroup(struct sgx_epc_cgroup *epc_cg)
 	return sgx_epc_cgroup_from_css(epc_cg->css.parent);
 }
 
+static inline unsigned long sgx_epc_cgroup_cnt_read(struct sgx_epc_cgroup *epc_cg,
+						    enum sgx_epc_cgroup_counter i)
+{
+	return atomic_long_read(&epc_cg->cnt[i]);
+}
+
+static inline void sgx_epc_cgroup_cnt_reset(struct sgx_epc_cgroup *epc_cg,
+					    enum sgx_epc_cgroup_counter i)
+{
+	atomic_long_set(&epc_cg->cnt[i], 0);
+}
+
+static inline void sgx_epc_cgroup_cnt_add(struct sgx_epc_cgroup *epc_cg,
+					  enum sgx_epc_cgroup_counter i,
+					  unsigned long cnt)
+{
+	atomic_long_add(cnt, &epc_cg->cnt[i]);
+}
+
+static inline void sgx_epc_cgroup_event(struct sgx_epc_cgroup *epc_cg,
+					enum sgx_epc_cgroup_counter i,
+					unsigned long cnt)
+{
+	sgx_epc_cgroup_cnt_add(epc_cg, i, cnt);
+
+	if (i == SGX_EPC_CGROUP_LOW || i == SGX_EPC_CGROUP_HIGH ||
+	    i == SGX_EPC_CGROUP_MAX)
+		cgroup_file_notify(&epc_cg->events_file);
+}
+
+static inline void sgx_epc_cgroup_cnt_sub(struct sgx_epc_cgroup *epc_cg,
+					  enum sgx_epc_cgroup_counter i,
+					  unsigned long cnt)
+{
+	atomic_long_sub(cnt, &epc_cg->cnt[i]);
+}
+
 /**
  * sgx_epc_cgroup_iter - iterate over the EPC cgroup hierarchy
  * @root:		hierarchy root
@@ -368,7 +405,9 @@ void sgx_epc_cgroup_isolate_pages(struct sgx_epc_cgroup *root,
                          */
                         if (!sgx_epc_cgroup_all_in_use_are_low(root))
                                 continue;
+			sgx_epc_cgroup_event(epc_cg, SGX_EPC_CGROUP_LOW, 1);
                 }
+		sgx_epc_cgroup_event(epc_cg, SGX_EPC_CGROUP_RECLAMATIONS, 1);
 
                 sgx_isolate_epc_pages(&epc_cg->lru, nr_to_scan, dst);
                 if (!*nr_to_scan) {
@@ -383,8 +422,11 @@ void sgx_epc_cgroup_isolate_pages(struct sgx_epc_cgroup *root,
 }
 
 static int sgx_epc_cgroup_reclaim_pages(unsigned long nr_pages,
-					struct sgx_epc_reclaim_control *rc)
+					struct sgx_epc_reclaim_control *rc,
+					enum sgx_epc_cgroup_counter c)
 {
+	sgx_epc_cgroup_event(rc->epc_cg, c, 1);
+
 	/*
 	 * Ensure sgx_reclaim_pages is called with a minimum and maximum
 	 * number of pages.  Attempting to reclaim only a few pages will
@@ -434,7 +476,8 @@ static inline void __sgx_epc_cgroup_reclaim_high(struct sgx_epc_cgroup *epc_cg)
 		if (cur <= high)
 			break;
 
-		if (!sgx_epc_cgroup_reclaim_pages(cur - high, &rc)) {
+		if (!sgx_epc_cgroup_reclaim_pages(cur - high, &rc,
+						  SGX_EPC_CGROUP_HIGH)) {
 			if (sgx_epc_cgroup_reclaim_failed(&rc))
 				break;
 		}
@@ -494,7 +537,8 @@ static void sgx_epc_cgroup_reclaim_work_func(struct work_struct *work)
 		if (cur <= max)
 			break;
 
-		if (!sgx_epc_cgroup_reclaim_pages(cur - max, &rc)) {
+		if (!sgx_epc_cgroup_reclaim_pages(cur - max, &rc,
+						  SGX_EPC_CGROUP_MAX)) {
 			if (sgx_epc_cgroup_reclaim_failed(&rc))
 				break;
 		}
@@ -539,7 +583,8 @@ static int __sgx_epc_cgroup_try_charge(struct sgx_epc_cgroup *epc_cg,
 		over = ((cur + nr_pages) > max) ?
 			(cur + nr_pages) - max : SGX_EPC_RECLAIM_MIN_PAGES;
 
-		if (!sgx_epc_cgroup_reclaim_pages(over, &rc)) {
+		if (!sgx_epc_cgroup_reclaim_pages(over, &rc,
+						  SGX_EPC_CGROUP_MAX)) {
 			if (sgx_epc_cgroup_reclaim_failed(&rc)) {
 				if (++nr_empty > SGX_EPC_RECLAIM_OOM_THRESHOLD)
 					return -ENOMEM;
@@ -586,6 +631,8 @@ struct sgx_epc_cgroup *sgx_epc_cgroup_try_charge(struct mm_struct *mm,
 
 	if (ret)
 		return ERR_PTR(ret);
+
+	sgx_epc_cgroup_cnt_add(epc_cg, SGX_EPC_CGROUP_PAGES, 1);
 	return epc_cg;
 }
 
@@ -593,13 +640,17 @@ struct sgx_epc_cgroup *sgx_epc_cgroup_try_charge(struct mm_struct *mm,
  * sgx_epc_cgroup_uncharge - hierarchically uncharge EPC pages
  * @epc_cg:	the charged epc cgroup
  * @nr_pages:	the number of pages to uncharge
+ * @reclaimed:	whether the pages were reclaimed (vs. freed)
  */
-void sgx_epc_cgroup_uncharge(struct sgx_epc_cgroup *epc_cg)
+void sgx_epc_cgroup_uncharge(struct sgx_epc_cgroup *epc_cg, bool reclaimed)
 {
 	if (sgx_epc_cgroup_disabled())
 		return;
 
 	page_counter_uncharge(&epc_cg->pc, 1);
+	sgx_epc_cgroup_cnt_sub(epc_cg, SGX_EPC_CGROUP_PAGES, 1);
+	if (reclaimed)
+		sgx_epc_cgroup_event(epc_cg, SGX_EPC_CGROUP_RECLAIMED, 1);
 
 	if (epc_cg != root_epc_cgroup)
 		css_put_many(&epc_cg->css, 1);
@@ -665,6 +716,61 @@ static u64 sgx_epc_current_read(struct cgroup_subsys_state *css,
 	return (u64)page_counter_read(&epc_cg->pc) * PAGE_SIZE;
 }
 
+static int sgx_epc_stats_show(struct seq_file *m, void *v)
+{
+	struct sgx_epc_cgroup *epc_cg = sgx_epc_cgroup_from_css(seq_css(m));
+
+	unsigned long cur, dir, rec, recs;
+	cur = page_counter_read(&epc_cg->pc);
+	dir = sgx_epc_cgroup_cnt_read(epc_cg, SGX_EPC_CGROUP_PAGES);
+	rec = sgx_epc_cgroup_cnt_read(epc_cg, SGX_EPC_CGROUP_RECLAIMED);
+	recs= sgx_epc_cgroup_cnt_read(epc_cg, SGX_EPC_CGROUP_RECLAMATIONS);
+
+	seq_printf(m, "pages            %lu\n", cur);
+	seq_printf(m, "direct           %lu\n", dir);
+	seq_printf(m, "indirect         %lu\n", (cur - dir));
+	seq_printf(m, "reclaimed        %lu\n", rec);
+	seq_printf(m, "reclamations	%lu\n", recs);
+
+	return 0;
+}
+
+static ssize_t sgx_epc_stats_reset(struct kernfs_open_file *of,
+				   char *buf, size_t nbytes, loff_t off)
+{
+	struct sgx_epc_cgroup *epc_cg = sgx_epc_cgroup_from_css(of_css(of));
+	sgx_epc_cgroup_cnt_reset(epc_cg, SGX_EPC_CGROUP_RECLAIMED);
+	sgx_epc_cgroup_cnt_reset(epc_cg, SGX_EPC_CGROUP_RECLAMATIONS);
+	return nbytes;
+}
+
+
+static int sgx_epc_events_show(struct seq_file *m, void *v)
+{
+	struct sgx_epc_cgroup *epc_cg = sgx_epc_cgroup_from_css(seq_css(m));
+
+	unsigned long low, high, max;
+	low  = sgx_epc_cgroup_cnt_read(epc_cg, SGX_EPC_CGROUP_LOW);
+	high = sgx_epc_cgroup_cnt_read(epc_cg, SGX_EPC_CGROUP_HIGH);
+	max  = sgx_epc_cgroup_cnt_read(epc_cg, SGX_EPC_CGROUP_MAX);
+
+	seq_printf(m, "low      %lu\n", low);
+	seq_printf(m, "high     %lu\n", high);
+	seq_printf(m, "max      %lu\n", max);
+
+	return 0;
+}
+
+static ssize_t sgx_epc_events_reset(struct kernfs_open_file *of,
+				    char *buf, size_t nbytes, loff_t off)
+{
+	struct sgx_epc_cgroup *epc_cg = sgx_epc_cgroup_from_css(of_css(of));
+	sgx_epc_cgroup_cnt_reset(epc_cg, SGX_EPC_CGROUP_LOW);
+	sgx_epc_cgroup_cnt_reset(epc_cg, SGX_EPC_CGROUP_HIGH);
+	sgx_epc_cgroup_cnt_reset(epc_cg, SGX_EPC_CGROUP_MAX);
+	return nbytes;
+}
+
 static int sgx_epc_low_show(struct seq_file *m, void *v)
 {
 	struct sgx_epc_cgroup *epc_cg = sgx_epc_cgroup_from_css(seq_css(m));
@@ -733,7 +839,8 @@ static ssize_t sgx_epc_high_write(struct kernfs_open_file *of,
 		if (signal_pending(current))
 			break;
 
-		if (!sgx_epc_cgroup_reclaim_pages(cur - high, &rc)) {
+		if (!sgx_epc_cgroup_reclaim_pages(cur - high, &rc,
+						  SGX_EPC_CGROUP_HIGH)) {
 			if (sgx_epc_cgroup_reclaim_failed(&rc))
 				break;
 		}
@@ -782,7 +889,8 @@ static ssize_t sgx_epc_max_write(struct kernfs_open_file *of, char *buf,
 		if (signal_pending(current))
 			break;
 
-		if (!sgx_epc_cgroup_reclaim_pages(cur - max, &rc)) {
+		if (!sgx_epc_cgroup_reclaim_pages(cur - max, &rc,
+						  SGX_EPC_CGROUP_MAX)) {
 			if (sgx_epc_cgroup_reclaim_failed(&rc)) {
 				if (++nr_empty > SGX_EPC_RECLAIM_OOM_THRESHOLD)
 					sgx_epc_cgroup_oom(epc_cg);
@@ -799,6 +907,18 @@ static struct cftype sgx_epc_cgroup_files[] = {
 		.name = "current",
 		.read_u64 = sgx_epc_current_read,
 	},
+	{
+		.name = "stats",
+		.seq_show = sgx_epc_stats_show,
+		.write = sgx_epc_stats_reset,
+	},
+	{
+		.name = "events",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct sgx_epc_cgroup, events_file),
+		.seq_show = sgx_epc_events_show,
+		.write = sgx_epc_events_reset,
+	},
 	{
 		.name = "low",
 		.flags = CFTYPE_NOT_ON_ROOT,
diff --git a/arch/x86/kernel/cpu/sgx/epc_cgroup.h b/arch/x86/kernel/cpu/sgx/epc_cgroup.h
index 226304a3d523..656c9f386b48 100644
--- a/arch/x86/kernel/cpu/sgx/epc_cgroup.h
+++ b/arch/x86/kernel/cpu/sgx/epc_cgroup.h
@@ -14,6 +14,16 @@
 #ifndef CONFIG_CGROUP_SGX_EPC
 struct sgx_epc_cgroup;
 #else
+enum sgx_epc_cgroup_counter {
+	SGX_EPC_CGROUP_PAGES,
+	SGX_EPC_CGROUP_RECLAIMED,
+	SGX_EPC_CGROUP_RECLAMATIONS,
+	SGX_EPC_CGROUP_LOW,
+	SGX_EPC_CGROUP_HIGH,
+	SGX_EPC_CGROUP_MAX,
+	SGX_EPC_CGROUP_NR_COUNTERS,
+};
+
 struct sgx_epc_cgroup {
 	struct cgroup_subsys_state	css;
 
@@ -24,11 +34,15 @@ struct sgx_epc_cgroup {
 	struct sgx_epc_cgroup	*reclaim_iter;
 	struct work_struct	reclaim_work;
 	unsigned int		epoch;
+
+	atomic_long_t           cnt[SGX_EPC_CGROUP_NR_COUNTERS];
+
+	struct cgroup_file      events_file;
 };
 
 struct sgx_epc_cgroup *sgx_epc_cgroup_try_charge(struct mm_struct *mm,
 						 bool reclaim);
-void sgx_epc_cgroup_uncharge(struct sgx_epc_cgroup *epc_cg);
+void sgx_epc_cgroup_uncharge(struct sgx_epc_cgroup *epc_cg, bool reclaimed);
 bool sgx_epc_cgroup_lru_empty(struct sgx_epc_cgroup *root);
 void sgx_epc_cgroup_isolate_pages(struct sgx_epc_cgroup *root,
 				  int *nr_to_scan, struct list_head *dst);
diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
index 29653a0d4670..3330ed4d0d43 100644
--- a/arch/x86/kernel/cpu/sgx/main.c
+++ b/arch/x86/kernel/cpu/sgx/main.c
@@ -412,7 +412,7 @@ int sgx_reclaim_epc_pages(int nr_to_scan, bool ignore_age,
 
 #ifdef CONFIG_CGROUP_SGX_EPC
 		if (epc_page->epc_cg) {
-			sgx_epc_cgroup_uncharge(epc_page->epc_cg);
+			sgx_epc_cgroup_uncharge(epc_page->epc_cg, true);
 			epc_page->epc_cg = NULL;
 		}
 #endif
@@ -663,7 +663,7 @@ struct sgx_epc_page *sgx_alloc_epc_page(void *owner, bool reclaim)
 		WARN_ON(page->epc_cg);
 		page->epc_cg = epc_cg;
 	} else {
-		sgx_epc_cgroup_uncharge(epc_cg);
+		sgx_epc_cgroup_uncharge(epc_cg, false);
 	}
 #endif
 	if (sgx_should_reclaim(SGX_NR_LOW_PAGES))
@@ -698,7 +698,7 @@ void sgx_free_epc_page(struct sgx_epc_page *page)
 	spin_unlock(&node->lock);
 #ifdef CONFIG_CGROUP_SGX_EPC
 	if (page->epc_cg) {
-		sgx_epc_cgroup_uncharge(page->epc_cg);
+		sgx_epc_cgroup_uncharge(page->epc_cg, false);
 		page->epc_cg = NULL;
 	}
 #endif
-- 
2.37.3

