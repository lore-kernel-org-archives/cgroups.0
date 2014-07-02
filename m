From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] cgroup: distinguish the default and legacy hierarchies when handling cftypes
Date: Wed,  2 Jul 2014 19:50:54 -0400
Message-ID: <1404345055-8196-5-git-send-email-tj@kernel.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Ltwzd/U1/PNIK5PjkatZtdW4Bo+p7noE4Oba8kbuZPo=;
        b=UjaKwyJWpDHvAy61vJNWFVdwYzVqD9U4hIkn30+HzKEIDlBkhUukT0FdjuGbuJSMuq
         /SjzlQ2DBIcygG71f9kpl445Mqh8jHWcVckMSAfj/8oRgIAHr0J85kCErtVTsK60o9oV
         mhAYiidbRXwNnyA0AFcyRaPhByK1+aYkigFQ4ZEoTNhF7+fFQKiIQzSKSxJe5mOaxiCN
         yeV7T83V19kd8ZVHW9SvQDMWIiUjI1iEy57+D6jSmfF4B3uFeU7TzicWo+iTqTTwYtWU
         J9VVVL9myv7mNr9G6tvlDIpeY2EqbbwHSm/uXpGeMDlV7qZbRI1Llv6iocvvA8Hm2Kgb
         vyyQ==
In-Reply-To: <1404345055-8196-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Vivek Goyal <vgoyal@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>, Aristeu Rozanski <aris@redhat.com>, Neil Horman <nhorman@tuxdriver.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

Until now, cftype arrays carried files for both the default and legacy
hierarchies and the files which needed to be used on only one of them
were flagged with either CFTYPE_ONLY_ON_DFL or CFTYPE_INSANE.  This
gets confusing very quickly and we may end up exposing interface files
to the default hierarchy without thinking it through.

This patch makes cgroup core provide separate sets of interfaces for
cftype handling so that the cftypes for the default and legacy
hierarchies are clearly distinguished.  The previous two patches
renamed the existing ones so that they clearly indicate that they're
for the legacy hierarchies.  This patch adds the interface for the
default hierarchy and apply them selectively depending on the
hierarchy type.

* cftypes added through cgroup_subsys->dfl_cftypes and
  cgroup_add_dfl_cftypes() only show up on the default hierarchy.

* cftypes added through cgroup_subsys->legacy_cftypes and
  cgroup_add_legacy_cftypes() only show up on the legacy hierarchies.

* cgroup_subsys->dfl_cftypes and ->legacy_cftypes can point to the
  same array for the cases where the interface files are identical on
  both types of hierarchies.

* This makes all the existing subsystem interface files legacy-only by
  default and all subsystems will have no interface file created when
  enabled on the default hierarchy.  Each subsystem should explicitly
  review and compose the interface for the default hierarchy.

* A boot param "cgroup__DEVEL__legacy_files_on_dfl" is added which
  makes subsystems which haven't decided the interface files for the
  default hierarchy to present the legacy files on the default
  hierarchy so that its behavior on the default hierarchy can be
  tested.  As the awkward name suggests, this is for development only.

* memcg's CFTYPE_INSANE on "use_hierarchy" is noop now as the whole
  array isn't used on the default hierarchy.  The flag is removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 include/linux/cgroup.h |  9 ++++++--
 kernel/cgroup.c        | 58 +++++++++++++++++++++++++++++++++++++++++++++++---
 mm/memcontrol.c        |  1 -
 3 files changed, 62 insertions(+), 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index a75a37f..62a2be1 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -582,6 +582,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 
+int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cftype *cfts);
 
@@ -662,8 +663,12 @@ struct cgroup_subsys {
 	 */
 	struct list_head cfts;
 
-	/* base cftypes, automatically registered with subsys itself */
-	struct cftype *legacy_cftypes;	/* used on the legacy hierarchies */
+	/*
+	 * Base cftypes which are automatically registered.  The two can
+	 * point to the same array.
+	 */
+	struct cftype *dfl_cftypes;	/* for the default hierarchy */
+	struct cftype *legacy_cftypes;	/* for the legacy hierarchies */
 };
 
 #define SUBSYS(_x) extern struct cgroup_subsys _x ## _cgrp_subsys;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 311d42b..94cdb7b 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -149,6 +149,12 @@ struct cgroup_root cgrp_dfl_root;
  */
 static bool cgrp_dfl_root_visible;
 
+/*
+ * Set by the boot param of the same name and makes subsystems with NULL
+ * ->dfl_files to use ->legacy_files on the default hierarchy.
+ */
+static bool cgroup_legacy_files_on_dfl;
+
 /* some controllers are not supported in the default hierarchy */
 static const unsigned int cgrp_dfl_root_inhibit_ss_mask = 0
 #ifdef CONFIG_CGROUP_DEBUG
@@ -3085,8 +3091,37 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 	return ret;
 }
 
+/**
+ * cgroup_add_dfl_cftypes - add an array of cftypes for default hierarchy
+ * @ss: target cgroup subsystem
+ * @cfts: zero-length name terminated array of cftypes
+ *
+ * Similar to cgroup_add_cftypes() but the added files are only used for
+ * the default hierarchy.
+ */
+int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
+{
+	struct cftype *cft;
+
+	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
+		cft->flags |= CFTYPE_ONLY_ON_DFL;
+	return cgroup_add_cftypes(ss, cfts);
+}
+
+/**
+ * cgroup_add_legacy_cftypes - add an array of cftypes for legacy hierarchies
+ * @ss: target cgroup subsystem
+ * @cfts: zero-length name terminated array of cftypes
+ *
+ * Similar to cgroup_add_cftypes() but the added files are only used for
+ * the legacy hierarchies.
+ */
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
 {
+	struct cftype *cft;
+
+	for (cft = cfts; cft && cft->name[0] != '\0'; cft++)
+		cft->flags |= CFTYPE_INSANE;
 	return cgroup_add_cftypes(ss, cfts);
 }
 
@@ -4775,9 +4810,19 @@ int __init cgroup_init(void)
 		 * disabled flag and cftype registration needs kmalloc,
 		 * both of which aren't available during early_init.
 		 */
-		if (!ss->disabled) {
-			cgrp_dfl_root.subsys_mask |= 1 << ss->id;
-			WARN_ON(cgroup_add_cftypes(ss, ss->legacy_cftypes));
+		if (ss->disabled)
+			continue;
+
+		cgrp_dfl_root.subsys_mask |= 1 << ss->id;
+
+		if (cgroup_legacy_files_on_dfl && !ss->dfl_cftypes)
+			ss->dfl_cftypes = ss->legacy_cftypes;
+
+		if (ss->dfl_cftypes == ss->legacy_cftypes) {
+			WARN_ON(cgroup_add_cftypes(ss, ss->dfl_cftypes));
+		} else {
+			WARN_ON(cgroup_add_dfl_cftypes(ss, ss->dfl_cftypes));
+			WARN_ON(cgroup_add_legacy_cftypes(ss, ss->legacy_cftypes));
 		}
 	}
 
@@ -5173,6 +5218,13 @@ static int __init cgroup_disable(char *str)
 }
 __setup("cgroup_disable=", cgroup_disable);
 
+static int __init cgroup_set_legacy_files_on_dfl(char *str)
+{
+	cgroup_legacy_files_on_dfl = true;
+	return 0;
+}
+__setup("cgroup__DEVEL__legacy_files_on_dfl", cgroup_set_legacy_files_on_dfl);
+
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a629611..3b37586 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6003,7 +6003,6 @@ static struct cftype mem_cgroup_files[] = {
 	},
 	{
 		.name = "use_hierarchy",
-		.flags = CFTYPE_INSANE,
 		.write_u64 = mem_cgroup_hierarchy_write,
 		.read_u64 = mem_cgroup_hierarchy_read,
 	},
-- 
1.9.3
