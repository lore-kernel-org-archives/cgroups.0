From: Tejun Heo <tj@kernel.org>
Subject: [PATCH] cgroup: remove redundant cleanup in css_create
Date: Thu, 26 May 2016 15:13:58 -0400
Message-ID: <20160526191358.GB23194@mtj.duckdns.org>
References: <1463151560-5224-1-git-send-email-wwtao0320@163.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xqbwSFM5B8Q/iw0CvAeG+EJInkz+gJ5o6DbX047ayZk=;
        b=fAqxO4W2mmWy7KxaEPhJNEGx9d7oHh3pTS+0YVzWPGcBnYom+fxmJ9YISCFIaump9p
         gTJzsYYLlSQRKkS7u0vvekcyJnBeSaKGsYZRVK0txGJ1PiHMlEH1Ts1V/Fv/i3B2hKQy
         KkBV//VJNhzMPUDqhgwLYTqKC8rF2/1BXGVHTUF0V4g6vjjjJQuFACeSeLljewUY7z1r
         KqwkWMJw9MMgedjdXfjX5EZAYGvKsXDAjq48s15rPoUyrjvgAvsZyIyb7FaLfGjsODrl
         Xa/jTeW/F9UkF1ZrRb0Q2T/ZsXyNy3Fm+XiUT2gMO+nCUtxa/QncTuxjfQNvaAHZsBiM
         1Bag==
Content-Disposition: inline
In-Reply-To: <1463151560-5224-1-git-send-email-wwtao0320@163.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wenwei Tao <wwtao0320@163.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, ww.tao0320@gmail.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

Nice catch.  I added more details to the changelog, tagged it for
-stable and applied it to cgroup/for-4.7-fixes.

Thanks!

------ 8< ------
From b00c52dae6d9ee8d0f2407118ef6544ae5524781 Mon Sep 17 00:00:00 2001
From: Wenwei Tao <ww.tao0320@gmail.com>
Date: Fri, 13 May 2016 22:59:20 +0800

When create css failed, before call css_free_rcu_fn, we remove the css
id and exit the percpu_ref, but we will do these again in
css_free_work_fn, so they are redundant.  Especially the css id, that
would cause problem if we remove it twice, since it may be assigned to
another css after the first remove.

tj: This was broken by two commits updating the free path without
    synchronizing the creation failure path.  This can be easily
    triggered by trying to create more than 64k memory cgroups.

Signed-off-by: Wenwei Tao <ww.tao0320@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>
Fixes: 9a1049da9bd2 ("percpu-refcount: require percpu_ref to be exited explicitly")
Fixes: 01e586598b22 ("cgroup: release css->id after css_free")
Cc: stable@vger.kernel.org # v3.17+
---
 kernel/cgroup.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 86cb5c6..789b84f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5150,7 +5150,7 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 
 	err = cgroup_idr_alloc(&ss->css_idr, NULL, 2, 0, GFP_KERNEL);
 	if (err < 0)
-		goto err_free_percpu_ref;
+		goto err_free_css;
 	css->id = err;
 
 	/* @css is ready to be brought online now, make it visible */
@@ -5174,9 +5174,6 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 
 err_list_del:
 	list_del_rcu(&css->sibling);
-	cgroup_idr_remove(&ss->css_idr, css->id);
-err_free_percpu_ref:
-	percpu_ref_exit(&css->refcnt);
 err_free_css:
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 	return ERR_PTR(err);
-- 
2.7.4

