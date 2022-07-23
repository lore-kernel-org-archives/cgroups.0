From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH RESEND 3/3 cgroup/for-5.20] cgroup: Make !percpu
 threadgroup_rwsem operations optional
Date: Sat, 23 Jul 2022 04:28:28 -1000
Message-ID: <YtwFjPnCtw8ySnuv@slm.duckdns.org>
References: <YtDvN0wJ6CKaEPN8@slm.duckdns.org>
 <YtDvU4jRPSsarcNp@slm.duckdns.org>
 <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=iXTEGIWZmjgwfsJ/RdqwpvQ7Oe1IR7cF5Wjfs1PckEA=;
        b=h9PL3fbnsUBo/gnY69vnKa0otkR5ryMB3SgIyfWBCDml8ASbNc4zGdsX9BXKE6Z3Go
         eDroGnkHR+2lW1V5+7abkPqDIMGThijkEj4lVifGrMlhmucXmx7cA6sKJaLTLwZIO4UP
         ZFFfMKs/S+EVxTUT0hwc0nPmd/SQm825cTwb+y5nnuQWqm5o893SdsL8IT2MuEd/APiy
         KmSJ6MaHxwaAix1kX/cyjOnsSwiz+tXLA2jBnsa+9Q6kE1ewTmMKhpAJ2TiRHImCgPpN
         SXcxNW8bV6Y0ZRXjRjRkcIdTTayHMo4bwt9UknTtThI1o9cUb5+Z2BKj3keeMGorRVDd
         85JQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YtDvl7Qjc5zI3e/b@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

3942a9bd7b58 ("locking, rcu, cgroup: Avoid synchronize_sched() in
__cgroup_procs_write()") disabled percpu operations on threadgroup_rwsem
because the impiled synchronize_rcu() on write locking was pushing up the
latencies too much for android which constantly moves processes between
cgroups.

This makes the hotter paths - fork and exit - slower as they're always
forced into the slow path. There is no reason to force this on everyone
especially given that more common static usage pattern can now completely
avoid write-locking the rwsem. Write-locking is elided when turning on and
off controllers on empty sub-trees and CLONE_INTO_CGROUP enables seeding a
cgroup without grabbing the rwsem.

Restore the default percpu operations and introduce the mount option
"favordynmods" and config option CGROUP_FAVOR_DYNMODS for users who need
lower latencies for the dynamic operations.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: John Stultz <john.stultz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dmitry Shmidt <dimitrysh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
I messed up patch generation and the patch was missing diffs for a few
files.

Thanks.

 Documentation/admin-guide/cgroup-v2.rst |    8 +++++
 include/linux/cgroup-defs.h             |   19 +++++++++++---
 init/Kconfig                            |   10 +++++++
 kernel/cgroup/cgroup-internal.h         |    1=20
 kernel/cgroup/cgroup-v1.c               |   17 +++++++++++-
 kernel/cgroup/cgroup.c                  |   43 ++++++++++++++++++++++++++-=
-----
 6 files changed, 87 insertions(+), 11 deletions(-)

--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -184,6 +184,14 @@ cgroup v2 currently supports the followi
 	ignored on non-init namespace mounts.  Please refer to the
 	Delegation section for details.
=20
+  [no]favordynmods
+        Reduce the latencies of dynamic cgroup modifications such as
+        task migrations and controller on/offs at the cost of making
+        hot path operations such as forks and exits more expensive.
+        The static usage pattern of creating a cgroup, enabling
+        controllers, and then seeding it with CLONE_INTO_CGROUP is
+        not affected by this option.
+
   memory_[no]localevents
         Only populate memory.events with data for the current cgroup,
         and not any subtrees. This is legacy behaviour, the default
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -89,19 +89,32 @@ enum {
 	CGRP_ROOT_NS_DELEGATE	=3D (1 << 3),
=20
 	/*
+	 * Reduce latencies on dynamic cgroup modifications such as task
+	 * migrations and controller on/offs by disabling percpu operation on
+	 * cgroup_threadgroup_rwsem. This makes hot path operations such as
+	 * forks and exits into the slow path and more expensive.
+	 *
+	 * The static usage pattern of creating a cgroup, enabling controllers,
+	 * and then seeding it with CLONE_INTO_CGROUP doesn't require write
+	 * locking cgroup_threadgroup_rwsem and thus doesn't benefit from
+	 * favordynmod.
+	 */
+	CGRP_ROOT_FAVOR_DYNMODS =3D (1 << 4),
+
+	/*
 	 * Enable cpuset controller in v1 cgroup to use v2 behavior.
 	 */
-	CGRP_ROOT_CPUSET_V2_MODE =3D (1 << 4),
+	CGRP_ROOT_CPUSET_V2_MODE =3D (1 << 16),
=20
 	/*
 	 * Enable legacy local memory.events.
 	 */
-	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 5),
+	CGRP_ROOT_MEMORY_LOCAL_EVENTS =3D (1 << 17),
=20
 	/*
 	 * Enable recursive subtree protection
 	 */
-	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 6),
+	CGRP_ROOT_MEMORY_RECURSIVE_PROT =3D (1 << 18),
 };
=20
 /* cftype->flags */
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -936,6 +936,16 @@ if CGROUPS
 config PAGE_COUNTER
 	bool
=20
+config CGROUP_FAVOR_DYNMODS
+        bool "Favor dynamic modification latency reduction by default"
+        help
+          This option enables the "favordynmods" mount option by default
+          which reduces the latencies of dynamic cgroup modifications such
+          as task migrations and controller on/offs at the cost of making
+          hot path operations such as forks and exits more expensive.
+
+          Say N if unsure.
+
 config MEMCG
 	bool "Memory controller"
 	select PAGE_COUNTER
--- a/kernel/cgroup/cgroup-internal.h
+++ b/kernel/cgroup/cgroup-internal.h
@@ -233,6 +233,7 @@ void cgroup_kn_unlock(struct kernfs_node
 int cgroup_path_ns_locked(struct cgroup *cgrp, char *buf, size_t buflen,
 			  struct cgroup_namespace *ns);
=20
+void cgroup_favor_dynmods(struct cgroup_root *root, bool favor);
 void cgroup_free_root(struct cgroup_root *root);
 void init_cgroup_root(struct cgroup_fs_context *ctx);
 int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask);
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -875,6 +875,8 @@ static int cgroup1_show_options(struct s
 		seq_puts(seq, ",xattr");
 	if (root->flags & CGRP_ROOT_CPUSET_V2_MODE)
 		seq_puts(seq, ",cpuset_v2_mode");
+	if (root->flags & CGRP_ROOT_FAVOR_DYNMODS)
+		seq_puts(seq, ",favordynmods");
=20
 	spin_lock(&release_agent_path_lock);
 	if (strlen(root->release_agent_path))
@@ -898,6 +900,8 @@ enum cgroup1_param {
 	Opt_noprefix,
 	Opt_release_agent,
 	Opt_xattr,
+	Opt_favordynmods,
+	Opt_nofavordynmods,
 };
=20
 const struct fs_parameter_spec cgroup1_fs_parameters[] =3D {
@@ -909,6 +913,8 @@ const struct fs_parameter_spec cgroup1_f
 	fsparam_flag  ("noprefix",	Opt_noprefix),
 	fsparam_string("release_agent",	Opt_release_agent),
 	fsparam_flag  ("xattr",		Opt_xattr),
+	fsparam_flag  ("favordynmods",	Opt_favordynmods),
+	fsparam_flag  ("nofavordynmods", Opt_nofavordynmods),
 	{}
 };
=20
@@ -960,6 +966,12 @@ int cgroup1_parse_param(struct fs_contex
 	case Opt_xattr:
 		ctx->flags |=3D CGRP_ROOT_XATTR;
 		break;
+	case Opt_favordynmods:
+		ctx->flags |=3D CGRP_ROOT_FAVOR_DYNMODS;
+		break;
+	case Opt_nofavordynmods:
+		ctx->flags &=3D ~CGRP_ROOT_FAVOR_DYNMODS;
+		break;
 	case Opt_release_agent:
 		/* Specifying two release agents is forbidden */
 		if (ctx->release_agent)
@@ -1211,8 +1223,11 @@ static int cgroup1_root_to_use(struct fs
 	init_cgroup_root(ctx);
=20
 	ret =3D cgroup_setup_root(root, ctx->subsys_mask);
-	if (ret)
+	if (!ret)
+		cgroup_favor_dynmods(root, ctx->flags & CGRP_ROOT_FAVOR_DYNMODS);
+	else
 		cgroup_free_root(root);
+
 	return ret;
 }
=20
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1305,6 +1305,20 @@ struct cgroup_root *cgroup_root_from_kf(
 	return root_cgrp->root;
 }
=20
+void cgroup_favor_dynmods(struct cgroup_root *root, bool favor)
+{
+	bool favoring =3D root->flags & CGRP_ROOT_FAVOR_DYNMODS;
+
+	/* see the comment above CGRP_ROOT_FAVOR_DYNMODS definition */
+	if (favor && !favoring) {
+		rcu_sync_enter(&cgroup_threadgroup_rwsem.rss);
+		root->flags |=3D CGRP_ROOT_FAVOR_DYNMODS;
+	} else if (!favor && favoring) {
+		rcu_sync_exit(&cgroup_threadgroup_rwsem.rss);
+		root->flags &=3D ~CGRP_ROOT_FAVOR_DYNMODS;
+	}
+}
+
 static int cgroup_init_root_id(struct cgroup_root *root)
 {
 	int id;
@@ -1365,6 +1379,7 @@ static void cgroup_destroy_root(struct c
 		cgroup_root_count--;
 	}
=20
+	cgroup_favor_dynmods(root, false);
 	cgroup_exit_root_id(root);
=20
 	mutex_unlock(&cgroup_mutex);
@@ -1858,6 +1873,7 @@ int cgroup_show_path(struct seq_file *sf
=20
 enum cgroup2_param {
 	Opt_nsdelegate, Opt_nonsdelegate,
+	Opt_favordynmods, Opt_nofavordynmods,
 	Opt_memory_localevents, Opt_memory_nolocalevents,
 	Opt_memory_recursiveprot, Opt_memory_norecursiveprot,
 	nr__cgroup2_params
@@ -1866,6 +1882,8 @@ enum cgroup2_param {
 static const struct fs_parameter_spec cgroup2_fs_parameters[] =3D {
 	fsparam_flag("nsdelegate",		Opt_nsdelegate),
 	fsparam_flag("nonsdelegate",		Opt_nonsdelegate),
+	fsparam_flag("favordynmods",		Opt_favordynmods),
+	fsparam_flag("nofavordynmods",		Opt_nofavordynmods),
 	fsparam_flag("memory_localevents",	Opt_memory_localevents),
 	fsparam_flag("memory_nolocalevents",	Opt_memory_nolocalevents),
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
@@ -1890,6 +1908,12 @@ static int cgroup2_parse_param(struct fs
 	case Opt_nonsdelegate:
 		ctx->flags &=3D ~CGRP_ROOT_NS_DELEGATE;
 		return 0;
+	case Opt_favordynmods:
+		ctx->flags |=3D CGRP_ROOT_FAVOR_DYNMODS;
+		return 0;
+	case Opt_nofavordynmods:
+		ctx->flags &=3D ~CGRP_ROOT_FAVOR_DYNMODS;
+		return 0;
 	case Opt_memory_localevents:
 		ctx->flags |=3D CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 		return 0;
@@ -1914,6 +1938,9 @@ static void apply_cgroup_root_flags(unsi
 		else
 			cgrp_dfl_root.flags &=3D ~CGRP_ROOT_NS_DELEGATE;
=20
+		cgroup_favor_dynmods(&cgrp_dfl_root,
+				     root_flags & CGRP_ROOT_FAVOR_DYNMODS);
+
 		if (root_flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
 			cgrp_dfl_root.flags |=3D CGRP_ROOT_MEMORY_LOCAL_EVENTS;
 		else
@@ -1930,6 +1957,8 @@ static int cgroup_show_options(struct se
 {
 	if (cgrp_dfl_root.flags & CGRP_ROOT_NS_DELEGATE)
 		seq_puts(seq, ",nsdelegate");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_FAVOR_DYNMODS)
+		seq_puts(seq, ",favordynmods");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_LOCAL_EVENTS)
 		seq_puts(seq, ",memory_localevents");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT)
@@ -1980,7 +2009,8 @@ void init_cgroup_root(struct cgroup_fs_c
 	cgrp->root =3D root;
 	init_cgroup_housekeeping(cgrp);
=20
-	root->flags =3D ctx->flags;
+	/* DYNMODS must be modified through cgroup_favor_dynmods() */
+	root->flags =3D ctx->flags & ~CGRP_ROOT_FAVOR_DYNMODS;
 	if (ctx->release_agent)
 		strscpy(root->release_agent_path, ctx->release_agent, PATH_MAX);
 	if (ctx->name)
@@ -2202,6 +2232,10 @@ static int cgroup_init_fs_context(struct
 	put_user_ns(fc->user_ns);
 	fc->user_ns =3D get_user_ns(ctx->ns->user_ns);
 	fc->global =3D true;
+
+#ifdef CONFIG_CGROUP_FAVOR_DYNMODS
+	ctx->flags |=3D CGRP_ROOT_FAVOR_DYNMODS;
+#endif
 	return 0;
 }
=20
@@ -5854,12 +5888,6 @@ int __init cgroup_init(void)
=20
 	cgroup_rstat_boot();
=20
-	/*
-	 * The latency of the synchronize_rcu() is too high for cgroups,
-	 * avoid it at the cost of forcing all readers into the slow path.
-	 */
-	rcu_sync_enter_start(&cgroup_threadgroup_rwsem.rss);
-
 	get_user_ns(init_cgroup_ns.user_ns);
=20
 	mutex_lock(&cgroup_mutex);
@@ -6771,6 +6799,7 @@ static ssize_t features_show(struct kobj
 {
 	return snprintf(buf, PAGE_SIZE,
 			"nsdelegate\n"
+			"favordynmods\n"
 			"memory_localevents\n"
 			"memory_recursiveprot\n");
 }
