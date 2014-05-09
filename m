From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 8/9] cgroup: enable refcnting for root csses
Date: Fri,  9 May 2014 17:13:34 -0400
Message-ID: <1399670015-23463-9-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qTLAV9A2tt9AJnM/ksqDMCno2pxzeocTqLAcDhIU3yY=;
        b=HXDN/azKEAgOqwAI/UoGzZcvw2kQ2PQMmvKuzuUPN9UUHTZ7ghMEbMM/KrOQNhZ/OJ
         KuHOUGePJIyAi+DKcYjgQphRH8IJHhzX2YRqFpkusqTfGr3So4pBCOoI7evUuBtLpTjl
         P6NJxvbwUoORjO8XlyQJniWTX8DspYpZGXZRNpvtkmML4TZsqWZpdASYE8fuJW4ySKvz
         iOYx9hYmnmH2raiYz/olfEjcfJ6f332B4bOdznHcEy/TQv7wB7X3XtdvAspzq4LEl5ho
         +SXikzN5Ysl+oq4oKyLXf1GC0J7bmwEW87VQpTTbRx4d3H0ElG/OhrXVAXzJ7X2cHcO2
         YEQA==
In-Reply-To: <1399670015-23463-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Currently, css_get(), css_tryget() and css_tryget_online() are noops
for root csses as an optimization; however, we're planning to use css
refcnts to track of cgroup lifetime too and root cgroups also need to
be reference counted.  Since css has been converted to percpu_refcnt,
the overhead of refcnting is miniscule and this optimization isn't too
meaningful anymore.  Furthermore, controllers which optimize the root
cgroup often never even invoke these functions in their hot paths.

This patch enables refcnting for root csses too.  This makes CSS_ROOT
flag unused and removes it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 10 ++--------
 kernel/cgroup.c        |  6 +++---
 2 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 160fcc6..286e39e 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -77,7 +77,6 @@ struct cgroup_subsys_state {
 
 /* bits in struct cgroup_subsys_state flags field */
 enum {
-	CSS_ROOT	= (1 << 0), /* this CSS is the root of the subsystem */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 };
 
@@ -89,9 +88,7 @@ enum {
  */
 static inline void css_get(struct cgroup_subsys_state *css)
 {
-	/* We don't need to reference count the root state */
-	if (!(css->flags & CSS_ROOT))
-		percpu_ref_get(&css->refcnt);
+	percpu_ref_get(&css->refcnt);
 }
 
 /**
@@ -106,8 +103,6 @@ static inline void css_get(struct cgroup_subsys_state *css)
  */
 static inline bool css_tryget_online(struct cgroup_subsys_state *css)
 {
-	if (css->flags & CSS_ROOT)
-		return true;
 	return percpu_ref_tryget_live(&css->refcnt);
 }
 
@@ -119,8 +114,7 @@ static inline bool css_tryget_online(struct cgroup_subsys_state *css)
  */
 static inline void css_put(struct cgroup_subsys_state *css)
 {
-	if (!(css->flags & CSS_ROOT))
-		percpu_ref_put(&css->refcnt);
+	percpu_ref_put(&css->refcnt);
 }
 
 /* bits in struct cgroup flags field */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b382383..5a31e61 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4157,8 +4157,6 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	if (cgrp->parent) {
 		css->parent = cgroup_css(cgrp->parent, ss);
 		css_get(css->parent);
-	} else {
-		css->flags |= CSS_ROOT;
 	}
 
 	BUG_ON(cgroup_css(cgrp, ss));
@@ -4581,9 +4579,10 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	BUG_ON(IS_ERR(css));
 	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
 	if (early) {
-		/* idr_alloc() can't be called safely during early init */
+		/* allocation can't be done safely during early init */
 		css->id = 1;
 	} else {
+		BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 		css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2, GFP_KERNEL);
 		BUG_ON(css->id < 0);
 	}
@@ -4670,6 +4669,7 @@ int __init cgroup_init(void)
 			struct cgroup_subsys_state *css =
 				init_css_set.subsys[ss->id];
 
+			BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 			css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2,
 						   GFP_KERNEL);
 			BUG_ON(css->id < 0);
-- 
1.9.0
