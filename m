From: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: Delete unnecessary if statement in css_visible()
Date: Sat, 29 Aug 2020 10:03:16 +0000
Message-ID: <20200829100202.GA855@haolee.github.io>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ve5Y7UpqDFbuWlDWcOR+wgYs8OkOidRTnnjW9IZXZ6U=;
        b=bs9p3/w0ksSNIWFN2OvCev28CeZY6aVLLibarFLpX9igmm3UCZ0WpSDC0RjHJVE75F
         H6W7uKT9MCe1b8AIjN2AvBuJ6gh37kMBK2eVt+hisLVudA4m5Af39dZmwu3E09DGHCKV
         cNpW5Cwsaa2UfbToWG2axFJcuWHifEaCZY3XWYMpCK7YRgK/u20e1drvosjW9UxV5DYU
         7DOmTGZmqGPYe18nCsshEyruy4jEVu4ZWmQyViWOxpBNwccL1/UnxisZ01sjNv1bPZ7K
         yrOuGOvYzmGSonLRH3hz0LQUVq28P3ZeYf8QIdh/tH5OkTIO2/6LXeg18S+ceeUI/u2T
         XRoQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

css_visible() is called in either cgroup_apply_control_enable()
or cgroup_apply_control_disable().
In cgroup_apply_control_enable(), we have checked ss_mask before calling
css_visible(), so there is no need to do the same thing again.
In cgroup_apply_control_disable():
 - If css->parent is not NULL, we have checked ss_mask in the
   second condition, so there is no need to do the same thing again.
 - If css->parent is NULL, dsct is root cgroup so the deleted if
   statement is always false and there is no need to keep it.

Signed-off-by: Hao Lee <haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index dd247747ec14..b6714166106d 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -3023,8 +3023,6 @@ static bool css_visible(struct cgroup_subsys_state *css)
 
 	if (cgroup_control(cgrp) & (1 << ss->id))
 		return true;
-	if (!(cgroup_ss_mask(cgrp) & (1 << ss->id)))
-		return false;
 	return cgroup_on_dfl(cgrp) && ss->implicit_on_dfl;
 }
 
-- 
2.24.1

