From: brookxu <brookxu.cn@gmail.com>
Subject: [PATCH v2 1/3] misc_cgroup: introduce misc.events and misc_events.local
Date: Mon, 13 Sep 2021 13:00:59 +0800
Message-ID: <50b83893065acaef2a9bc3f91c03812dc872f316.1631504710.git.brookxu@tencent.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=p95e/fLIqizunh8aVzrIkU+lkS+VG6a/DFmD/UL31WA=;
        b=kWVAhqy7hBfobbxIHKiMtNj+2uESLvNw+6E5pBQDAE0r64WgxfwoYbp6DIlgJfBw7Q
         oDSkodBHPPv3nqm/n3MvDVgYC1oCeU9jl3fYGQfaJcIMbT2TTi2ZP9OGudk9TAwqrHUh
         NODRUAi7rrTrLCUWVGE/mG2qrrXnW6sGjZinPzomcn822l1YVhydCDWbHyVSKvybw0s8
         a8uieL7ycUtEJGh+ckikLsn7lpuMNV0ccaKm5xpFbufq/F36ACsIoH4qp5fU4coCDC0z
         ffi/wDiwruAKZw31hcvihcBtBHl3rmSg+hN88LEWIBM9oYXlTCv4G6NrdX5hrRchDiax
         ZL7w==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org
Cc: vipinsh@google.com, mkoutny@suse.com, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

From: Chunguang Xu <brookxu@tencent.com>

Introduce misc.events and misc.events.local to make it easier for
us to understand the pressure of resources. The main idea comes
from mem_cgroup. Currently only the 'max' event is implemented,
which indicates the times the resource exceeds the limit.

Signed-off-by: Chunguang Xu <brookxu@tencent.com>
---
 include/linux/misc_cgroup.h | 13 ++++++++++
 kernel/cgroup/misc.c        | 58 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 70 insertions(+), 1 deletion(-)

diff --git a/include/linux/misc_cgroup.h b/include/linux/misc_cgroup.h
index da2367e..602fc11 100644
--- a/include/linux/misc_cgroup.h
+++ b/include/linux/misc_cgroup.h
@@ -21,6 +21,11 @@ enum misc_res_type {
 	MISC_CG_RES_TYPES
 };
 
+enum misc_event_type {
+	MISC_CG_EVENT_MAX,
+	MISC_CG_EVENT_TYPES
+};
+
 struct misc_cg;
 
 #ifdef CONFIG_CGROUP_MISC
@@ -36,6 +41,8 @@ enum misc_res_type {
 struct misc_res {
 	unsigned long max;
 	atomic_long_t usage;
+	atomic_long_t events[MISC_CG_EVENT_TYPES];
+	atomic_long_t events_local[MISC_CG_EVENT_TYPES];
 	bool failed;
 };
 
@@ -46,6 +53,12 @@ struct misc_res {
  */
 struct misc_cg {
 	struct cgroup_subsys_state css;
+
+	/* misc.events */
+	struct cgroup_file events_file;
+	/* misc.events.local */
+	struct cgroup_file events_local_file;
+
 	struct misc_res res[MISC_CG_RES_TYPES];
 };
 
diff --git a/kernel/cgroup/misc.c b/kernel/cgroup/misc.c
index ec02d96..5f06b2a 100644
--- a/kernel/cgroup/misc.c
+++ b/kernel/cgroup/misc.c
@@ -26,6 +26,10 @@
 #endif
 };
 
+static const char *const misc_event_name[] = {
+	"max"
+};
+
 /* Root misc cgroup */
 static struct misc_cg root_cg;
 
@@ -140,7 +144,7 @@ static void misc_cg_cancel_charge(enum misc_res_type type, struct misc_cg *cg,
 int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 		       unsigned long amount)
 {
-	struct misc_cg *i, *j;
+	struct misc_cg *i, *j, *k;
 	int ret;
 	struct misc_res *res;
 	int new_usage;
@@ -171,6 +175,14 @@ int misc_cg_try_charge(enum misc_res_type type, struct misc_cg *cg,
 	return 0;
 
 err_charge:
+	atomic_long_inc(&i->res[type].events_local[MISC_CG_EVENT_MAX]);
+	cgroup_file_notify(&i->events_local_file);
+
+	for (k = i; k; k = parent_misc(k)) {
+		atomic_long_inc(&k->res[type].events[MISC_CG_EVENT_MAX]);
+		cgroup_file_notify(&k->events_file);
+	}
+
 	for (j = cg; j != i; j = parent_misc(j))
 		misc_cg_cancel_charge(type, j, amount);
 	misc_cg_cancel_charge(type, i, amount);
@@ -335,6 +347,38 @@ static int misc_cg_capacity_show(struct seq_file *sf, void *v)
 	return 0;
 }
 
+static int misc_events_show(struct seq_file *sf, void *v)
+{
+	struct misc_cg *cg = css_misc(seq_css(sf));
+	unsigned long events, i, j;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		for (j = 0; j < MISC_CG_EVENT_TYPES; j++) {
+			events = atomic_long_read(&cg->res[i].events[j]);
+			if (READ_ONCE(misc_res_capacity[i]) || events)
+				seq_printf(sf, "%s.%s %lu\n", misc_res_name[i],
+					   misc_event_name[j], events);
+		}
+	}
+	return 0;
+}
+
+static int misc_events_local_show(struct seq_file *sf, void *v)
+{
+	struct misc_cg *cg = css_misc(seq_css(sf));
+	unsigned long events, i, j;
+
+	for (i = 0; i < MISC_CG_RES_TYPES; i++) {
+		for (j = 0; j < MISC_CG_EVENT_TYPES; j++) {
+			events = atomic_long_read(&cg->res[i].events_local[j]);
+			if (READ_ONCE(misc_res_capacity[i]) || events)
+				seq_printf(sf, "%s.%s %lu\n", misc_res_name[i],
+					   misc_event_name[j], events);
+		}
+	}
+	return 0;
+}
+
 /* Misc cgroup interface files */
 static struct cftype misc_cg_files[] = {
 	{
@@ -353,6 +397,18 @@ static int misc_cg_capacity_show(struct seq_file *sf, void *v)
 		.seq_show = misc_cg_capacity_show,
 		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
+	{
+		.name = "events",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct misc_cg, events_file),
+		.seq_show = misc_events_show,
+	},
+	{
+		.name = "events.local",
+		.flags = CFTYPE_NOT_ON_ROOT,
+		.file_offset = offsetof(struct misc_cg, events_local_file),
+		.seq_show = misc_events_local_show,
+	},
 	{}
 };
 
-- 
1.8.3.1

