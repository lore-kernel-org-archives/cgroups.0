From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.16] cgroup: introduce CSS_NO_REF and skip
 refcnting on normal root csses
Date: Fri, 16 May 2014 11:43:30 -0400
Message-ID: <20140516154330.GB5379@htj.dyndns.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
 <1399670015-23463-10-git-send-email-tj@kernel.org>
 <53751062.2050401@wwwdotorg.org>
 <53753823.2090402@wwwdotorg.org>
 <20140516143718.GA5379@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wOQHaEeFYeI7856wbqDiM3X97W5DTThCmYjsQM5kEZk=;
        b=B02SGjfT6gqViB/lxz6i+szzmw5z8gUO478sNLRDQ2LxewPNIAD2fcv15r4G6GY+Ky
         g6E/yqAQ63f1itHmbcDKUHLv82Hyddeej5fPRbk/O0J2EUPqbQsuG7sqY98gJK93gjPL
         M+Gy7CHyhXcy8/zlNi3Owbi5nKai1plqXE1vFDGIIK2NPfDFOorBAm7ofkjbfVqrOSz3
         1c7m0a67/nsPIu0xFc2X1rfVBP2gfg8LcnblEE3NW5PMTFvw51scecnBs10Tp27SrZg4
         ffpstzi3L/2AJy1hHdtdb7a3gnGMyWwU+VNUTGxWgO9BdFm80VHUJl2x4te3uni7P4au
         qTAA==
Content-Disposition: inline
In-Reply-To: <20140516143718.GA5379-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-tegra-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, ARM kernel mailing list <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>

From 49035d695d8f1c4bbe4e37480e5d06812818947c Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Fri, 16 May 2014 11:40:33 -0400

9395a4500404 ("cgroup: enable refcnting for root csses") enabled
reference counting for root csses (cgroup_subsys_states) so that
cgroup's self csses can be used to manage the lifetime of the
containing cgroups.

Unfortunately, this change was incorrect.  cpu controller uses
early_init and starts using css reference counts on its root css from
then on.  percpu_ref can't initialized during early init and its
initialization is deferred till cgroup_init() time.  This means that
cpu was using percpu_ref which wasn't properly initialized.  Due to
the way percpu variables are laid out on x86, this didn't blow up
immediately on x86 but ended up incrementing and decrementing the
percpu variable at offset zero, whatever it may be; however, on other
archs, this caused fault and early boot failure.

As cgroup self csses still need working refcounting, we can't revert
9395a4500404.  This patch adds CSS_NO_REF which explicitly inhibits
reference counting on the css and sets it on all normal (non-self)
csses.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-by: Stephen Warren <swarren-3lzwWm7+Weoh9ZMKESR00Q@public.gmane.org>
Fixes: 9395a4500404 ("cgroup: enable refcnting for root csses")
---
Patch applied to cgroup/for-3.16.

Thanks.

 include/linux/cgroup.h | 11 ++++++++---
 kernel/cgroup.c        |  9 +++++++--
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 76dadd77..1737db0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -77,6 +77,7 @@ struct cgroup_subsys_state {
 
 /* bits in struct cgroup_subsys_state flags field */
 enum {
+	CSS_NO_REF	= (1 << 0), /* no reference counting for this css */
 	CSS_ONLINE	= (1 << 1), /* between ->css_online() and ->css_offline() */
 };
 
@@ -88,7 +89,8 @@ enum {
  */
 static inline void css_get(struct cgroup_subsys_state *css)
 {
-	percpu_ref_get(&css->refcnt);
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_get(&css->refcnt);
 }
 
 /**
@@ -103,7 +105,9 @@ static inline void css_get(struct cgroup_subsys_state *css)
  */
 static inline bool css_tryget_online(struct cgroup_subsys_state *css)
 {
-	return percpu_ref_tryget_live(&css->refcnt);
+	if (!(css->flags & CSS_NO_REF))
+		return percpu_ref_tryget_live(&css->refcnt);
+	return true;
 }
 
 /**
@@ -114,7 +118,8 @@ static inline bool css_tryget_online(struct cgroup_subsys_state *css)
  */
 static inline void css_put(struct cgroup_subsys_state *css)
 {
-	percpu_ref_put(&css->refcnt);
+	if (!(css->flags & CSS_NO_REF))
+		percpu_ref_put(&css->refcnt);
 }
 
 /* bits in struct cgroup flags field */
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index c01e8e8..ad15bb7 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4593,11 +4593,17 @@ static void __init cgroup_init_subsys(struct cgroup_subsys *ss, bool early)
 	/* We don't handle early failures gracefully */
 	BUG_ON(IS_ERR(css));
 	init_and_link_css(css, ss, &cgrp_dfl_root.cgrp);
+
+	/*
+	 * Root csses are never destroyed and we can't initialize
+	 * percpu_ref during early init.  Disable refcnting.
+	 */
+	css->flags |= CSS_NO_REF;
+
 	if (early) {
 		/* allocation can't be done safely during early init */
 		css->id = 1;
 	} else {
-		BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 		css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2, GFP_KERNEL);
 		BUG_ON(css->id < 0);
 	}
@@ -4684,7 +4690,6 @@ int __init cgroup_init(void)
 			struct cgroup_subsys_state *css =
 				init_css_set.subsys[ss->id];
 
-			BUG_ON(percpu_ref_init(&css->refcnt, css_release));
 			css->id = cgroup_idr_alloc(&ss->css_idr, css, 1, 2,
 						   GFP_KERNEL);
 			BUG_ON(css->id < 0);
-- 
1.9.0
