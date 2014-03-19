From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v3.14-rc7
Date: Wed, 19 Mar 2014 12:23:00 -0400
Message-ID: <20140319162300.GB19874@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        bh=cQlQdnOIcRC2OqYEbGEd2+rouaIAXB2ykubUmFXRkGc=;
        b=WdIY+dKJ3FdEjXbowjeijSy9wc2MkVYYnoMC0Jwne6NDbHnKjxs+KSjcl78ClCLxFw
         INJR3vjzO3bU55LBeMswknbPgKKJlCShhVLXi9gLpJqlNgYmihLzgB7oMdCxmkAQR+sB
         NlCAMNLigUzSa/4/Y6hcGVhdzI7QXSTOwI9Gq8VIJrzNi0G0sCd4Vq+RlO4hwnUv/bOP
         RAISFqvWEs4OsZU7mcEjO6DNbXY91faVtmhZQcAv7j7+sdxPZ/vyeBB5KCmd58+Kj23G
         +wbfPhG0FSN9vFhH+dhovnCvgeHxp506Po9GgyADXRq8X78EEUsft3cITk+RNemDSulK
         pxug==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

One really late cgroup patch to fix error path in create_css().
Hitting this bug would be pretty rare but still possible and it gets
delayed we'd need to backport it through -stable anyway.  It only
updates error path in create_css() and has low chance of new
breakages.

The following changes since commit 99afb0fd5f05aac467ffa85c36778fec4396209b:

  cpuset: fix a race condition in __cpuset_node_allowed_softwall() (2014-02-27 09:39:54 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-3.14-fixes

for you to fetch changes up to 3eb59ec64fc7a3f4576da23f811b39331b830ba2:

  cgroup: fix a failure path in create_css() (2014-03-18 17:15:36 -0400)

Thanks.

----------------------------------------------------------------
Li Zefan (1):
      cgroup: fix a failure path in create_css()

 kernel/cgroup.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 105f273..0c753dd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4112,17 +4112,17 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	err = percpu_ref_init(&css->refcnt, css_release);
 	if (err)
-		goto err_free;
+		goto err_free_css;
 
 	init_css(css, ss, cgrp);
 
 	err = cgroup_populate_dir(cgrp, 1 << ss->subsys_id);
 	if (err)
-		goto err_free;
+		goto err_free_percpu_ref;
 
 	err = online_css(css);
 	if (err)
-		goto err_free;
+		goto err_clear_dir;
 
 	dget(cgrp->dentry);
 	css_get(css->parent);
@@ -4138,8 +4138,11 @@ static int create_css(struct cgroup *cgrp, struct cgroup_subsys *ss)
 
 	return 0;
 
-err_free:
+err_clear_dir:
+	cgroup_clear_dir(css->cgroup, 1 << css->ss->subsys_id);
+err_free_percpu_ref:
 	percpu_ref_cancel_init(&css->refcnt);
+err_free_css:
 	ss->css_free(css);
 	return err;
 }
