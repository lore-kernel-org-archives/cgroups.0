From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/6] cgroup: distinguish the default and legacy hierarchies when handling cftypes
Date: Mon, 14 Jul 2014 11:44:06 -0400
Message-ID: <1405352648-4279-5-git-send-email-tj@kernel.org>
References: <1405352648-4279-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=31D21t720lvLnS3KG6lWdW6HfMpQPTUqFTBKH/nIshs=;
        b=0HKxXjoRj+UuuTMKs65S1FLjTUl1tC5Pf0UNTJ3W5TNSnftypd73V29SCGVBzfh2Ey
         xmC9ISjOn7Ar4P2zRhRlDoxpmGgS0Q9KcjND41bi3xDf8CvPERj5Xu8iTfAAtx7CTf8G
         Vt3clw/M/lOSjyL9yAYS+uVe+eL1+YJfMxPpJ/RrFLdwHLHV88ZSg+zvkDnouWBrAsXO
         eCRleUiScgQvWr9RaOeP37hhmilk9b0S5vqSulgnzNJYH/qBEwe6wxkPQCtWEO4KwIXq
         pkhxBFzcj4xhQjymd9Lv75Vn8ZDZfGV4OMVlhgxIVviK2FAPcdQceYrLNJdqk5asbIzj
         rhDQ==
In-Reply-To: <1405352648-4279-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

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

v2: Updated documentation for cgroup__DEVEL__legacy_files_on_dfl.

v3: Clear CFTYPE_ONLY_ON_DFL and CFTYPE_INSANE when cfts are removed
    as suggested by Li.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Acked-by: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt | 18 ++++++---
 include/linux/cgroup.h                      |  9 ++++-
 kernel/cgroup.c                             | 62 +++++++++++++++++++++++++++--
 mm/memcontrol.c                             |  1 -
 4 files changed, 78 insertions(+), 12 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index a7a2205..4f45632 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -94,12 +94,18 @@ change soon.
 
  mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
 
-All controllers which are not bound to other hierarchies are
-automatically bound to unified hierarchy and show up at the root of
-it.  Controllers which are enabled only in the root of unified
-hierarchy can be bound to other hierarchies.  This allows mixing
-unified hierarchy with the traditional multiple hierarchies in a fully
-backward compatible way.
+All controllers which support the unified hierarchy and are not bound
+to other hierarchies are automatically bound to unified hierarchy and
+show up at the root of it.  Controllers which are enabled only in the
+root of unified hierarchy can be bound to other hierarchies.  This
+allows mixing unified hierarchy with the traditional multiple
+hierarchies in a fully backward compatible way.
+
+For development purposes, the following boot parameter makes all
+controllers to appear on the unified hierarchy whether supported or
+not.
+
+ cgroup__DEVEL__legacy_files_on_dfl
 
 A controller can be moved across hierarchies only after the controller
 is no longer referenced in its current hierarchy.  Because per-cgroup
diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index f5f0fee..9f76236 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -590,6 +590,7 @@ static inline void pr_cont_cgroup_path(struct cgroup *cgrp)
 
 char *task_cgroup_path(struct task_struct *task, char *buf, size_t buflen);
 
+int cgroup_add_dfl_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_add_legacy_cftypes(struct cgroup_subsys *ss, struct cftype *cfts);
 int cgroup_rm_cftypes(struct cftype *cfts);
 
@@ -671,8 +672,12 @@ struct cgroup_subsys {
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
 
 	/*
 	 * A subsystem may depend on other subsystems.  When such subsystem
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c275aa4..374ebdf 100644
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
@@ -3085,6 +3091,9 @@ static void cgroup_exit_cftypes(struct cftype *cfts)
 			kfree(cft->kf_ops);
 		cft->kf_ops = NULL;
 		cft->ss = NULL;
+
+		/* revert flags set by cgroup core while adding @cfts */
+		cft->flags &= ~(CFTYPE_ONLY_ON_DFL | CFTYPE_INSANE);
 	}
 }
 
@@ -3195,8 +3204,37 @@ static int cgroup_add_cftypes(struct cgroup_subsys *ss, struct cftype *cfts)
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
 
@@ -4893,9 +4931,19 @@ int __init cgroup_init(void)
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
 
@@ -5291,6 +5339,14 @@ static int __init cgroup_disable(char *str)
 }
 __setup("cgroup_disable=", cgroup_disable);
 
+static int __init cgroup_set_legacy_files_on_dfl(char *str)
+{
+	printk("cgroup: using legacy files on the default hierarchy\n");
+	cgroup_legacy_files_on_dfl = true;
+	return 0;
+}
+__setup("cgroup__DEVEL__legacy_files_on_dfl", cgroup_set_legacy_files_on_dfl);
+
 /**
  * css_tryget_online_from_dir - get corresponding css from a cgroup dentry
  * @dentry: directory dentry of interest
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b6b3c6f..45c10c6 100644
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
