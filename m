From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fix for v4.10-rc6
Date: Tue, 31 Jan 2017 12:00:08 -0500
Message-ID: <20170131170008.GD23970@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=S1HD4L7UeVdnn7nwOREfp8aJrgbDh7/IQp0gZWYksp4=;
        b=kU88I4tKrnqOCsDRECX3MPAGeZR7KIUH2fhvipWUt5TDRpEFHahQOJAnKOUPoWNmp0
         Pxqr9AOhVUc+O5lCLh9q0d3hgOHXOczt2hUusZreOouAFAvAuqXe634CADathO+akr6L
         3snnLATx5LesYHvKprXVg7kfIl7HcCE1pWd0JSXjysNLfiOAFxpU6rU5VsgjHZk4UrWg
         JbYDLtwUVEA+VFOHTjn9cvrMaAv263pufHfq2dWQ7KNfgVgpJ0yzHKpZIuwyX4hBQ9At
         zyrF3Qq+0Eezs7CTv3X5ufXuovxQk36i8k/7XbrMOT+U9Y4dnZOPZjqqis00PeoA65Kc
         zBBA==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

The cgroup creation path was getting the order of operations wrong and
exposing cgroups which don't have their names set yet to controllers
which can lead to NULL derefs.  This pull request contains the fix for
the bug.

Thanks.

The following changes since commit 7ce7d89f48834cefece7804d38fc5d85382edf77:

  Linux 4.10-rc1 (2016-12-25 16:13:08 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.10-fixes

for you to fetch changes up to 07cd12945551b63ecb1a349d50a6d69d1d6feb4a:

  cgroup: don't online subsystems before cgroup_name/path() are operational (2017-01-26 16:47:28 -0500)

----------------------------------------------------------------
Tejun Heo (1):
      cgroup: don't online subsystems before cgroup_name/path() are operational

 kernel/cgroup.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 2ee9ec3..688dd02 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5221,6 +5221,11 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 	return ERR_PTR(err);
 }
 
+/*
+ * The returned cgroup is fully initialized including its control mask, but
+ * it isn't associated with its kernfs_node and doesn't have the control
+ * mask applied.
+ */
 static struct cgroup *cgroup_create(struct cgroup *parent)
 {
 	struct cgroup_root *root = parent->root;
@@ -5288,11 +5293,6 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 
 	cgroup_propagate_control(cgrp);
 
-	/* @cgrp doesn't have dir yet so the following will only create csses */
-	ret = cgroup_apply_control_enable(cgrp);
-	if (ret)
-		goto out_destroy;
-
 	return cgrp;
 
 out_cancel_ref:
@@ -5300,9 +5300,6 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 out_free_cgrp:
 	kfree(cgrp);
 	return ERR_PTR(ret);
-out_destroy:
-	cgroup_destroy_locked(cgrp);
-	return ERR_PTR(ret);
 }
 
 static int cgroup_mkdir(struct kernfs_node *parent_kn, const char *name,

-- 
tejun
