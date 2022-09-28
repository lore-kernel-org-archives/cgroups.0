From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: [PATCH v2] cgroup: Reorganize css_set_lock and kernfs path processing
Date: Wed, 28 Sep 2022 13:33:16 +0200
Message-ID: <YzQw/EvH9Sb58Au2@blackbook>
References: <20220905170944.23071-1-mkoutny@suse.com>
 <Yxd/sUQ/NB3NlC6f@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1664364798; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=M2mgymyLYQSEBITlSU1B1GuO4Bx/FQHXI8TQ8CJx3tk=;
        b=bN1H8DRBbqY2qZfqYkrDVdsihILQFlH7+D1I6FyL/1qnGLAhzw2Oe3+4jqpCw1uUCBn9b/
        ZceXP1aSUUHTD9cSy4Z5hS8xyPJL8JrN3fZb94Bt5FBYPfm6JbJHAT1jXui1/CJcpq2Xwg
        HvUMNYFdpSLsyG7RVbQDWUaW0a+Imkk=
Content-Disposition: inline
In-Reply-To: <Yxd/sUQ/NB3NlC6f-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

The commit 74e4b956eb1c incorrectly wrapped kernfs_walk_and_get
(might_sleep) under css_set_lock (spinlock). css_set_lock is needed by
__cset_cgroup_from_root to ensure stable cset->cgrp_links but not for
kernfs_walk_and_get.

We only need to make sure that the returned root_cgrp won't be freed
under us. This is given in the case of global root because it is static
(cgrp_dfl_root.cgrp). When the root_cgrp is lower in the hierarchy, it
is pinned by cgroup_ns->root_cset (and `current` task cannot switch
namespace asynchronously so ns_proxy pins cgroup_ns).

(Note this reasoning won't hold for root cgroups in v1 hierarchies but
the path resolution works only with the default hierarchy.)

Fixes: 74e4b956eb1c: ("cgroup: Honor caller's cgroup NS when resolving path=
")
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gma=
ne.org>
Signed-off-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

Hello.

v2: dropped changes around kernfs_path_from_node(), reworded commit
    message

I realized the pinning with reference taking won't really work
generally. The code would get the reference within RCU read section, so
it'd have to be cgroup_get_live() and if that fails there's not much to
do.

So, instead of generalization, I only post special-cased patch that
fixes the introduced bug and doesn't touch the rest.

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index c37b8265c0a3..ac71af8ef65c 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1392,11 +1392,16 @@ static void cgroup_destroy_root(struct cgroup_root =
*root)
 	cgroup_free_root(root);
 }
=20
+/*
+ * Returned cgroup is without refcount but it's valid as long as cset pins=
 it.
+ */
 static inline struct cgroup *__cset_cgroup_from_root(struct css_set *cset,
 					    struct cgroup_root *root)
 {
 	struct cgroup *res_cgroup =3D NULL;
=20
+	lockdep_assert_held(&css_set_lock);
+
 	if (cset =3D=3D &init_css_set) {
 		res_cgroup =3D &root->cgrp;
 	} else if (root =3D=3D &cgrp_dfl_root) {
@@ -6673,8 +6678,8 @@ struct cgroup *cgroup_get_from_path(const char *path)
=20
 	spin_lock_irq(&css_set_lock);
 	root_cgrp =3D current_cgns_cgroup_from_root(&cgrp_dfl_root);
-	kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
 	spin_unlock_irq(&css_set_lock);
+	kn =3D kernfs_walk_and_get(root_cgrp->kn, path);
 	if (!kn)
 		goto out;
=20
--=20
2.37.3

