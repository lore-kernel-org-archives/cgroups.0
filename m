From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-6.1] cgroup: Make cgroup_get_from_id() prettier
Date: Fri, 23 Sep 2022 07:31:58 -1000
Message-ID: <Yy3tjvIGd2j4wnSw@slm.duckdns.org>
References: <20220923115119.2035603-1-ming.lei@redhat.com>
 <Yy3tEKSV+vg6swOd@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date;
        bh=1j5Ql9rL37iPMOSlhnWDpxhkWzpqM9TX0V/l3pD1H2A=;
        b=igB1iPgGCLD9KZEhspvQpefRM95eLmbd+I+sv8MaBi0Qbu/C6e7757NtMD2t9UliqK
         fjuGtfGRfw5/7i0+/vTbW/fF/gaX61Fkyw5IW8VxEzzSBMx8rmRr85zlUUuxDwKWHEb5
         4hjxNbzZpQiX5xNrGkS+2vjHUkQSrweCDOTCIHEjw1Dbx81roj0glg251TxbPb/cur+B
         BmGCFScBEbv+3e0KEwgb9LnKiZmaEe/2S7EyMl5UP5P4/oVOLdKDa2+QedQtOxc3877j
         C8gA8VcoHOk4i6APPIREhKmky+C+FL9ELvrR0xej0a2ewf2pSesszorvo9VctdIqoV1b
         03kg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <Yy3tEKSV+vg6swOd-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Marco Patalano <mpatalan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Muneendra <muneendra.kumar-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>

From 7e1eb5437d3c3fdb61d45378579aab383cafc694 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 23 Sep 2022 07:23:06 -1000
MIME-Version: 1.0
Content-Type: text/plain; charset=3DUTF-8
Content-Transfer-Encoding: 8bit

After merging 836ac87d ("cgroup: fix cgroup_get_from_id") into for-6.1, its
combination with two commits in for-6.1 - 4534dee9 ("cgroup: cgroup: Honor
caller's cgroup NS when resolving cgroup id") and fa7e439c ("cgroup:
Homogenize cgroup_get_from_id() return value") - makes the gotos in the
error handling path too ugly while not adding anything of value.

All that the gotos are saving is one extra kernfs_put() call. Let's remove
the gotos and perform error returns directly.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
---
Hello,

Ming, Michal, you guys' changes to cgroup_get_from_id() combine to make
cgroup_get_from_id() a bit too ugly, so I applied the following patch to
cgroup/for-6.1. Please take a look and lemme know if I broke anything.

Thanks.

 kernel/cgroup/cgroup.c | 19 ++++++++++---------
 1 file changed, 10 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0d93cd17548c..c1f1ef6090da 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6066,14 +6066,16 @@ void cgroup_path_from_kernfs_id(u64 id, char *buf, =
size_t buflen)
 struct cgroup *cgroup_get_from_id(u64 id)
 {
 	struct kernfs_node *kn;
-	struct cgroup *cgrp =3D NULL, *root_cgrp;
+	struct cgroup *cgrp, *root_cgrp;
=20
 	kn =3D kernfs_find_and_get_node_by_id(cgrp_dfl_root.kf_root, id);
 	if (!kn)
-		goto out;
+		return ERR_PTR(-ENOENT);
=20
-	if (kernfs_type(kn) !=3D KERNFS_DIR)
-		goto put;
+	if (kernfs_type(kn) !=3D KERNFS_DIR) {
+		kernfs_put(kn);
+		return ERR_PTR(-ENOENT);
+	}
=20
 	rcu_read_lock();
=20
@@ -6082,21 +6084,20 @@ struct cgroup *cgroup_get_from_id(u64 id)
 		cgrp =3D NULL;
=20
 	rcu_read_unlock();
-put:
 	kernfs_put(kn);
=20
 	if (!cgrp)
-		goto out;
+		return ERR_PTR(-ENOENT);
=20
 	spin_lock_irq(&css_set_lock);
 	root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
 	spin_unlock_irq(&css_set_lock);
 	if (!cgroup_is_descendant(cgrp, root_cgrp)) {
 		cgroup_put(cgrp);
-		cgrp =3D NULL;
+		return ERR_PTR(-ENOENT);
 	}
-out:
-	return cgrp ?: ERR_PTR(-ENOENT);
+
+	return cgrp;
 }
 EXPORT_SYMBOL_GPL(cgroup_get_from_id);
=20
--=20
2.37.3

