From: Wenwei Tao <wwtao0320-9Onoh4P/yGk@public.gmane.org>
Subject: [RFC PATCH] cgroup: remove redundant cleanup in css_create
Date: Fri, 13 May 2016 22:59:20 +0800
Message-ID: <1463151560-5224-1-git-send-email-wwtao0320@163.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-Id; bh=5pKAMb6erMPxjNztQj
	BmyKJzvFwfyEJyoqDIWrhQ5ek=; b=kBDVLKEsbcIy+pDWNmWpIR2LanfaSwZvzA
	LYUKhENEyhuk8b8V3FUEDhGdfPHldMOyu+JbahTBEtdkhKWxTD0auo4XUEqR8X/7
	yJFXeVGaPcbOQLj6ydzbZhnXsZoJ82V42jp5Q5fE/UGUqxJZpbR1+8/5p7yIfwgJ
	wmRwh0rYE=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Wenwei Tao <ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

When create css failed, before call css_free_rcu_fn,
we remove the css id and exit the percpu_ref, but we
will do these again in css_free_work_fn, so they are redundant.
Especially the css id, that would cause problem if we
remove it twice, since it may be assigned to another
css after the first remove.

Signed-off-by: Wenwei Tao <ww.tao0320-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 909a7d3..9df3a29 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5088,7 +5088,7 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 
 	err = cgroup_idr_alloc(&ss->css_idr, NULL, 2, 0, GFP_KERNEL);
 	if (err < 0)
-		goto err_free_percpu_ref;
+		goto err_free_css;
 	css->id = err;
 
 	/* @css is ready to be brought online now, make it visible */
@@ -5112,9 +5112,6 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 
 err_list_del:
 	list_del_rcu(&css->sibling);
-	cgroup_idr_remove(&ss->css_idr, css->id);
-err_free_percpu_ref:
-	percpu_ref_exit(&css->refcnt);
 err_free_css:
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 	return ERR_PTR(err);
-- 
1.8.3.1

