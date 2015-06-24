From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/7] blkcg: make blkcg_activate_policy() allow NULL ->pd_init_fn
Date: Tue, 23 Jun 2015 22:44:09 -0400
Message-ID: <1435113853-12053-4-git-send-email-tj@kernel.org>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=omlVTWKzWCrH8anprEL85RCqpC2oYK2YLJnRCH/0Sx0=;
        b=XQVMgxVVyz0Nz4wTEryWY1RPPDb3niLwj4AcdeZ1fbH3F37n7ZvSb9TlVabCgeznux
         8xS+yJHBM0JwijYEPgBaDOlXzrG0nGug6WreoCaE22D4PegAJ30yhqTCaOzKEO8SShMu
         PQBKzh6MzTenrcWhyqQrFMIjBT1gP3765yWl3WIPUaw9Zn2apQjxaazKpxDWHUk2NYjT
         cSeieyZ8ahZspXg33GEeW6WrgRIH4820PTYhGzqiRz8O8LBnJFyQRlhY8xXgTFXIipn9
         7zp2zjtvv3ODZmiLSwYy/4vel+cXTtlCPLu3zRu7E/b8FWXRec89p2GI/Z1lVjAqWlxN
         XgYg==
In-Reply-To: <1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

blkg_create() allows NULL ->pd_init_fn() but blkcg_activate_policy()
doesn't.  As both in-kernel policies implement ->pd_init_fn, it
currently doesn't break anything.  Update blkcg_activate_policy() so
that its behavior is consistent with blkg_create().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 898f560..617a586 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1045,7 +1045,8 @@ int blkcg_activate_policy(struct request_queue *q,
 		blkg->pd[pol->plid] = pd;
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
-		pol->pd_init_fn(blkg);
+		if (pol->pd_init_fn)
+			pol->pd_init_fn(blkg);
 
 		spin_unlock(&blkg->blkcg->lock);
 	}
-- 
2.4.3
