From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 1/2] cgroup: delay the clearing of cgrp->kn->priv
Date: Thu, 4 Sep 2014 14:43:07 +0800
Message-ID: <540809FB.8020901@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Run these two scripts concurrently:

    for ((; ;))
    {
        mkdir /cgroup/sub
        rmdir /cgroup/sub
    }

    for ((; ;))
    {
        echo $$ > /cgroup/sub/cgroup.procs
        echo $$ > /cgroup/cgroup.procs
    }

A kernel bug will be triggered:

BUG: unable to handle kernel NULL pointer dereference at 00000038
IP: [<c10bbd69>] cgroup_put+0x9/0x80
=2E..
Call Trace:
 [<c10bbe19>] cgroup_kn_unlock+0x39/0x50
 [<c10bbe91>] cgroup_kn_lock_live+0x61/0x70
 [<c10be3c1>] __cgroup_procs_write.isra.26+0x51/0x230
 [<c10be5b2>] cgroup_tasks_write+0x12/0x20
 [<c10bb7b0>] cgroup_file_write+0x40/0x130
 [<c11aee71>] kernfs_fop_write+0xd1/0x160
 [<c1148e58>] vfs_write+0x98/0x1e0
 [<c114934d>] SyS_write+0x4d/0xa0
 [<c16f656b>] sysenter_do_call+0x12/0x12

We clear cgrp->kn->priv in the end of cgroup_rmdir(), but another
concurrent thread can access kn->priv after the clearing.

We should move the clearing to css_release_work_fn(). At that time
no one is holding reference to the cgroup and no one can gain a new
reference to access it.

v2:
- remove RCU_INIT_POINTER() into the else block. (Tejun)
- remove the cgroup_parent() check. (Tejun)
- update the comment in css_tryget_online_from_dir().

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.15+
Reported-by: Toralf F=C3=B6rster <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1c56924..205f793 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4181,6 +4181,15 @@ static void css_release_work_fn(struct work_stru=
ct *work)
 		/* cgroup release path */
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id =3D -1;
+
+		/*
+		 * There are two control paths which try to determine
+		 * cgroup from dentry without going through kernfs -
+		 * cgroupstats_build() and css_tryget_online_from_dir().
+		 * Those are supported by RCU protecting clearing of
+		 * cgrp->kn->priv backpointer.
+		 */
+		RCU_INIT_POINTER(*(void __rcu __force **)&cgrp->kn->priv, NULL);
 	}
=20
 	mutex_unlock(&cgroup_mutex);
@@ -4601,16 +4610,6 @@ static int cgroup_rmdir(struct kernfs_node *kn)
=20
 	cgroup_kn_unlock(kn);
=20
-	/*
-	 * There are two control paths which try to determine cgroup from
-	 * dentry without going through kernfs - cgroupstats_build() and
-	 * css_tryget_online_from_dir().  Those are supported by RCU
-	 * protecting clearing of cgrp->kn->priv backpointer, which should
-	 * happen after all files under it have been removed.
-	 */
-	if (!ret)
-		RCU_INIT_POINTER(*(void __rcu __force **)&kn->priv, NULL);
-
 	cgroup_put(cgrp);
 	return ret;
 }
@@ -5175,7 +5174,7 @@ struct cgroup_subsys_state *css_tryget_online_fro=
m_dir(struct dentry *dentry,
 	/*
 	 * This path doesn't originate from kernfs and @kn could already
 	 * have been or be removed at any point.  @kn->priv is RCU
-	 * protected for this access.  See cgroup_rmdir() for details.
+	 * protected for this access.  See css_release_work_fn() for details.
 	 */
 	cgrp =3D rcu_dereference(kn->priv);
 	if (cgrp)
--=20
1.8.0.2
