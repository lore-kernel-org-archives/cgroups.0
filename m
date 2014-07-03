From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 4/5] cgroup: distinguish the default and legacy
 hierarchies when handling cftypes
Date: Thu, 3 Jul 2014 11:20:30 -0400
Message-ID: <20140703152030.GE16191@htj.dyndns.org>
References: <1404345055-8196-1-git-send-email-tj@kernel.org>
 <1404345055-8196-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=HR4VaNs/QBrT6rFZEgh+TcsXtD8Nmuc67fSs7oSxjbQ=;
        b=SpL8R6hM5N4Ieob/H1fkdOABQnYFMKdKx7lMJC7Fl92T4kYKS6n/nmRQTn1aFM1jei
         gabHDkIGajn1xvxvWw2/zx8JxVsWIo8m9R7oyjX7K7QygVm75t46P77cHnfPltaEx8x1
         wteJirLQXQ2yBNZmhQI2WngPJ4A3Xa/2evWjZPzcr1/zQ8GwrdAVKaG2exYomE1+51u8
         n/Kz2TWafGVfIoTLWMOi8aVwXgmWmqSJ4jJ8FOmpnE588/pHpnX1sR/t+AZKqQRYFZuh
         UaR7pxu5ed/B04YuQYfgxcNZu6OuTmSBDmFNgPNs9ddi71KwEVIfY5JH+rrG3CB5Crb0
         h5mw==
Content-Disposition: inline
In-Reply-To: <1404345055-8196-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

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

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>
Cc: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
---
 Documentation/cgroups/unified-hierarchy.txt | 18 ++++++---
 include/linux/cgroup.h                      |  9 ++++-
 kernel/cgroup.c                             | 59 +++++++++++++++++++++++++++--
 mm/memcontrol.c                             |  1 -
 4 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index 324b182..185c2d4 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -94,12 +94,18 @@ change soon.
 
  mount -t cgroup -o __DEVEL__sane_behavior cgroup $MOUNT_POINT
 
-All controllers which are not bound to other hierarchies are
-automatically bound to unified hierarchy and show up at the root of
-it.  Controllers which are enabled only in the root of unified
-hierarchy can be bound to other hierarchies at any time.  This allows
-mixing unified hierarchy with the traditional multiple hierarchies in
-a fully backward compatible way.
+All controllers which support the unified hierarchy and are not bound
+to other hierarchies are automatically bound to unified hierarchy and
+show up at the root of it.  Controllers which are enabled only in the
+root of unified hierarchy can be bound to other hierarchies at any
+time.  This allows mixing unified hierarchy with the traditional
+multiple hierarchies in a fully backward compatible way.
+
+For development purposes, the following boot parameter makes all
+controllers to appear on the unified hierarchy whether supported or
+not.
+
+ cgroup__DEVEL__legacy_files_on_dfl
 
 
 2-2. cgroup.subtree_control
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
index 311d42b..650f514 100644
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
 
@@ -5173,6 +5218,14 @@ static int __init cgroup_disable(char *str)
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
