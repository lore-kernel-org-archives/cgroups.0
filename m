From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/4] cgroup: simplify the cgroup descendant helper
Date: Mon,  4 Oct 2021 08:49:27 +0000
Message-ID: <20211004084928.17622-3-richard.weiyang@gmail.com>
References: <20211004084928.17622-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=U+CztsD4lUTfyz/9KUwv0lAPbgM6DhNn+yw+6hcN6o8=;
        b=Dbjki+3nMY172s6qwBDLQhjVjWRsINQvJ6c/Y1HBr6z7e/LkaWJLejV73MWWBxYFC4
         Aj32cwVL2nb3FX5N1xoiWMNd7RiSVvIX6z9cEBBU9s3q5976Xc0taZo18Guvw7unbUcf
         HYB2dK5zMMgfBrqCtoiF4gUDPUVgQWWikxNBU3NlTgLOm8+3DEzKkJo5fo4N+GjnbUmo
         qqW3LyR2pvr9b9WNzAtnPGCJrl5jzX9Ua/GQvaQVPESXpmHtbPHqnwDSwTzg8OKFeIW3
         1my4tSBVH89PkNpEiusb0eTDpfTI2br07hu9fAsHwOktH9deXdCMnzDQXnHk+P4nN28r
         7NLw==
In-Reply-To: <20211004084928.17622-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

cgroup_for_each_live_descendant_[pre|post] use cgroup_css() to get the
root. While since the 2nd parameter is NULL, cgroup_css() always return
cgrp->self.

Let's simplify this a little.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 570b0c97392a..457353aeb0ca 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -732,7 +732,7 @@ EXPORT_SYMBOL_GPL(of_css);
 
 /* walk live descendants in pre order */
 #define cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp)		\
-	css_for_each_descendant_pre((d_css), cgroup_css((cgrp), NULL))	\
+	css_for_each_descendant_pre((d_css), &(cgrp)->self)		\
 		if (({ lockdep_assert_held(&cgroup_mutex);		\
 		       (dsct) = (d_css)->cgroup;			\
 		       cgroup_is_dead(dsct); }))			\
@@ -741,7 +741,7 @@ EXPORT_SYMBOL_GPL(of_css);
 
 /* walk live descendants in postorder */
 #define cgroup_for_each_live_descendant_post(dsct, d_css, cgrp)		\
-	css_for_each_descendant_post((d_css), cgroup_css((cgrp), NULL))	\
+	css_for_each_descendant_post((d_css), &(cgrp)->self)		\
 		if (({ lockdep_assert_held(&cgroup_mutex);		\
 		       (dsct) = (d_css)->cgroup;			\
 		       cgroup_is_dead(dsct); }))			\
-- 
2.23.0

