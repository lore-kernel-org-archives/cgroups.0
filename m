From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 06/14] cgroup: make css_sets pin the associated cgroups
Date: Wed, 14 Oct 2015 21:34:55 -0400
Message-ID: <20151015013455.GA20884@htj.duckdns.org>
References: <1444447781-16182-1-git-send-email-tj@kernel.org>
 <1444447781-16182-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=ESV4a5nVT6mV29HRki5/Yl2u9TFIWx8EVf+6r2hKwTU=;
        b=s1IVsxg2Zqr0xXuY3f5qAaMNZ3JsyrwF2u3QyLwOLdotGoPcE++GlG5I055mandkpc
         cr7+r5CxhV4Rs+hlfZlDXdKBPhTtTldFsYKTufmYjcSAY7oKuI03o90F2GJzspwEOAfS
         Wg/9LC5jo0hQRxWGpG7nVSrW3i53xvKckNj00jBjRjFB5fUZ0t79NnfS/OW9p216c6jm
         fvB3zV3cTKmPBa0+qJw/7WVz8OLNzc0UupizGObgUYHP5N1oEmhVB5zp/x1kT68FGqfv
         1b0aURbJ3pEpy1nAqSOIWv44O/6Copdq/RxAXedZPOe8m4iyRhANFcWT3HfXxSO4JnAK
         HrBg==
Content-Disposition: inline
In-Reply-To: <1444447781-16182-7-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

From 12ab687370ca062d263848b52515c839809383aa Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Wed, 14 Oct 2015 21:31:40 -0400

Currently, css_sets don't pin the associated cgroups.  This is okay as
a cgroup with css_sets associated are not allowed to be removed;
however, to help resource tracking for zombie tasks, this is scheduled
to change such that a cgroup can be removed even when it has css_sets
associated as long as none of them are populated.

To ensure that a cgroup doesn't go away while css_sets are still
associated with it, make each associated css_set hold a reference on
the cgroup if non-root.

v2: Root cgroups are special and shouldn't be ref'd by css_sets.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ab5c9a5..ea87340 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -705,6 +705,8 @@ static void put_css_set_locked(struct css_set *cset)
 	list_for_each_entry_safe(link, tmp_link, &cset->cgrp_links, cgrp_link) {
 		list_del(&link->cset_link);
 		list_del(&link->cgrp_link);
+		if (cgroup_parent(link->cgrp))
+			cgroup_put(link->cgrp);
 		kfree(link);
 	}
 
@@ -919,6 +921,9 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,
 	 * is sorted by order of hierarchy creation
 	 */
 	list_add_tail(&link->cgrp_link, &cset->cgrp_links);
+
+	if (cgroup_parent(cgrp))
+		cgroup_get(cgrp);
 }
 
 /**
@@ -4998,10 +5003,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 
 	lockdep_assert_held(&cgroup_mutex);
 
-	/*
-	 * css_set_rwsem synchronizes access to ->cset_links and prevents
-	 * @cgrp from being removed while put_css_set() is in progress.
-	 */
+	/* css_set_rwsem synchronizes access to ->cset_links */
 	down_read(&css_set_rwsem);
 	empty = list_empty(&cgrp->cset_links);
 	up_read(&css_set_rwsem);
-- 
2.4.3
