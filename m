From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-4.5-fixes] cgroup: fix alloc_cgroup_ns() error
 handling in copy_cgroup_ns()
Date: Thu, 18 Feb 2016 11:46:58 -0500
Message-ID: <20160218164658.GD13177@mtj.duckdns.org>
References: <20160217185811.GA3472@mwanda>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=jxlzHPMufUTId1NXpWDw1qGfSvhbdlRyMsiJ1/DZspQ=;
        b=QFOxBuCJRywSAw2MyCavJLop5Nb+ijU3Gxql60b+8QLboeCa4aaudnYlKo53KVpzku
         L61VutZhGm6lyoGJ3gf7ekVON9QvEGghyW64gBTLXd55FsGnNiL2f6u/Rdn7M3CYDCKG
         BXpIpdG+4TWKqsxakm4NFWbXgBafJEJw9NT1kcUanLbjug0bvh3QfKyc4WExKBcdvFX8
         PERDQtaj8DOqKBaDtlei3nrSneGhgFL7OmvUSAygPDNVPQHAHxjIXZ/aJHY4kDF6iXM/
         faPFnNT2kKzfbjgsBBtg1DTUTT0mpGP6veRTRArHN/kUYWcsfHvWREbKm/7L0Yv+pKvr
         J82Q==
Content-Disposition: inline
In-Reply-To: <20160217185811.GA3472@mwanda>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From d22025570e2ebfc68819b35c5d457e53d9337217 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Thu, 18 Feb 2016 11:44:24 -0500

alloc_cgroup_ns() returns an ERR_PTR value on error but
copy_cgroup_ns() was checking for NULL for error.  Fix it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
Hello, Dan.

Applied to cgroup/for-4.5-fixes.

Thanks.

 kernel/cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index afb1205..d92d91a 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -6083,10 +6083,11 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
 	spin_unlock_bh(&css_set_lock);
 	mutex_unlock(&cgroup_mutex);
 
-	err = -ENOMEM;
 	new_ns = alloc_cgroup_ns();
-	if (!new_ns)
+	if (IS_ERR(new_ns)) {
+		err = PTR_ERR(new_ns);
 		goto err_out;
+	}
 
 	new_ns->user_ns = get_user_ns(user_ns);
 	new_ns->root_cset = cset;
-- 
2.5.0
