From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] slub: make sysfs directories for memcg sub-caches optional
Date: Sat, 4 Feb 2017 09:52:03 -0500
Message-ID: <20170204145203.GB26958@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DU4ZCTTltuCp2lxF3l6lmCCjTPKsfrBlceWJJtmkFh8=;
        b=cQqDLiZaLtG0WRTzUAt3s7waq3Xkiv3P7l3onmmMJ1wNx7j+Y8QNGel/lfVWASaJlv
         DbtA8rdebj4q+lrdWhUrWW3SqKwfw/Pi7PQtgwr9RHobpar33rXQ1HAdgsw18xg7CkFO
         Joc705Ly6LzwEQ2q2AYYL8t4JSJviL3UcIsPnLSt+MNAvxQbq2edpTMmntmwM4Du2XNO
         1kFhmFfWlghVYITov/FUhCHfibfEKRnA1wpk8Z7Scui6PDLeOwvs/+363e+p1zErvJWY
         p2nnLmq0C7vI9wFw+58EGsyICUeQIDhbgDnE8O0dSe9PfZmCcW3AHLLW0Z3aFtk3H8xJ
         Eblw==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org

SLUB creates a per-cache directory under /sys/kernel/slab which hosts
a bunch of debug files.  Usually, there aren't that many caches on a
system and this doesn't really matter; however, if memcg is in use,
each cache can have per-cgroup sub-caches.  SLUB creates the same
directories for these sub-caches under /sys/kernel/slab/$CACHE/cgroup.

Unfortunately, because there can be a lot of cgroups, active or
draining, the product of the numbers of caches, cgroups and files in
each directory can reach a very high number - hundreds of thousands is
commonplace.  Millions and beyond aren't difficult to reach either.

What's under /sys/kernel/slab is primarily for debugging and the
information and control on the a root cache already cover its
sub-caches.  While having a separate directory for each sub-cache can
be helpful for development, it doesn't make much sense to pay this
amount of overhead by default.

This patch introduces a boot parameter slub_memcg_sysfs which
determines whether to create sysfs directories for per-memcg
sub-caches.  It also adds CONFIG_SLUB_MEMCG_SYSFS_ON which determines
the boot parameter's default value and defaults to 0.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 Documentation/kernel-parameters.txt |    8 ++++++++
 init/Kconfig                        |   14 ++++++++++++++
 mm/slub.c                           |   29 ++++++++++++++++++++++++++---
 3 files changed, 48 insertions(+), 3 deletions(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3517,6 +3517,14 @@ bytes respectively. Such letter suffixes
 			last alloc / free. For more information see
 			Documentation/vm/slub.txt.
 
+	slub_memcg_sysfs=	[MM, SLUB]
+			Determines whether to enable sysfs directories for
+			memory cgroup sub-caches. 1 to enable, 0 to disable.
+			The default is determined by CONFIG_SLUB_MEMCG_SYSFS_ON.
+			Enabling this can lead to a very high number of	debug
+			directories and files being created under
+			/sys/kernel/slub.
+
 	slub_max_order= [MM, SLUB]
 			Determines the maximum allowed order for slabs.
 			A high setting may cause OOMs due to memory
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1786,6 +1786,20 @@ config SLUB_DEBUG
 	  SLUB sysfs support. /sys/slab will not exist and there will be
 	  no support for cache validation etc.
 
+config SLUB_MEMCG_SYSFS_ON
+	default n
+	bool "Enable memcg SLUB sysfs support by default" if EXPERT
+	depends on SLUB && SYSFS && MEMCG
+	help
+	  SLUB creates a directory under /sys/kernel/slab for each
+	  allocation cache to host info and debug files. If memory
+	  cgroup is enabled, each cache can have per memory cgroup
+	  caches. SLUB can create the same sysfs directories for these
+	  caches under /sys/kernel/slab/CACHE/cgroup but it can lead
+	  to a very high number of debug files being created. This is
+	  controlled by slub_memcg_sysfs boot parameter and this
+	  config option determines the parameter's default value.
+
 config COMPAT_BRK
 	bool "Disable heap randomization"
 	default y
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4700,6 +4700,22 @@ enum slab_stat_type {
 #define SO_OBJECTS	(1 << SL_OBJECTS)
 #define SO_TOTAL	(1 << SL_TOTAL)
 
+#ifdef CONFIG_MEMCG
+static bool memcg_sysfs_enabled = IS_ENABLED(CONFIG_SLUB_MEMCG_SYSFS_ON);
+
+static int __init setup_slub_memcg_sysfs(char *str)
+{
+	int v;
+
+	if (get_option(&str, &v) > 0)
+		memcg_sysfs_enabled = v;
+
+	return 1;
+}
+
+__setup("slub_memcg_sysfs=", setup_slub_memcg_sysfs);
+#endif
+
 static ssize_t show_slab_objects(struct kmem_cache *s,
 			    char *buf, unsigned long flags)
 {
@@ -5603,8 +5619,14 @@ static int sysfs_slab_add(struct kmem_ca
 {
 	int err;
 	const char *name;
+	struct kset *kset = cache_kset(s);
 	int unmergeable = slab_unmergeable(s);
 
+	if (!kset) {
+		kobject_init(&s->kobj, &slab_ktype);
+		return 0;
+	}
+
 	if (unmergeable) {
 		/*
 		 * Slabcache can never be merged so we can use the name proper.
@@ -5621,7 +5643,7 @@ static int sysfs_slab_add(struct kmem_ca
 		name = create_unique_id(s);
 	}
 
-	s->kobj.kset = cache_kset(s);
+	s->kobj.kset = kset;
 	err = kobject_init_and_add(&s->kobj, &slab_ktype, NULL, "%s", name);
 	if (err)
 		goto out;
@@ -5631,7 +5653,7 @@ static int sysfs_slab_add(struct kmem_ca
 		goto out_del_kobj;
 
 #ifdef CONFIG_MEMCG
-	if (is_root_cache(s)) {
+	if (is_root_cache(s) && memcg_sysfs_enabled) {
 		s->memcg_kset = kset_create_and_add("cgroup", NULL, &s->kobj);
 		if (!s->memcg_kset) {
 			err = -ENOMEM;
@@ -5673,7 +5695,8 @@ static void sysfs_slab_remove(struct kme
 		return;
 
 #ifdef CONFIG_MEMCG
-	kset_unregister(s->memcg_kset);
+	if (s->memcg_kset)
+		kset_unregister(s->memcg_kset);
 #endif
 	kobject_uevent(&s->kobj, KOBJ_REMOVE);
 	kobject_del(&s->kobj);
