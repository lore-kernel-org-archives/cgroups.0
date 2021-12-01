From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: fix a typo in comment
Date: Wed,  1 Dec 2021 01:17:36 +0000
Message-ID: <20211201011736.10988-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Fq8BRlHQip6soD4MoiTVE5ZeVUWI7smXdjqRV9fIryk=;
        b=Q97bIACX7BwWm5elsSdrBYHiMGe60S4Qij+w8V3Ah60WudJSar4xv9CxK7OLbC+k35
         pCD5q9kHRg916PhilswOzQsTynUACFMsgC5K0okcihgdL6tWzDMYCDgI60NQWsdcYsmK
         3TOqHQnrF0HZW7dHv+uNSXcD45QpN1llHS4yMlwrgP0ZGAT6SPI4M/E2lNCcaXpHIaOh
         YPYhrBCR+wBfxngu6H9pwcQv5ECKm+nntQxWq46/Rm+vGCkM90qA2w4aM/mpoN6pMZwh
         bFQJBk6d+IhPcha1DrUq446O7CX8TfvT6FTqYfWXUTRtjTQX3vvv4axNHcS+GVp5cpzO
         eC4w==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

In commit 8699b7762a62 ("cgroup: s/child_subsys_mask/subtree_ss_mask/"),
we rename child_subsys_mask to subtree_ss_mask. While it missed to
rename this in comment.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup-defs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 4649d09396fd..e4763c892a3b 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -413,7 +413,7 @@ struct cgroup {
 	/*
 	 * The bitmask of subsystems enabled on the child cgroups.
 	 * ->subtree_control is the one configured through
-	 * "cgroup.subtree_control" while ->child_ss_mask is the effective
+	 * "cgroup.subtree_control" while ->subtree_ss_mask is the effective
 	 * one which may have more subsystems enabled.  Controller knobs
 	 * are made available iff it's enabled in ->subtree_control.
 	 */
-- 
2.33.1

