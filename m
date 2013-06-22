From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/6] cgroup: convert CFTYPE_* flags to enums
Date: Fri, 21 Jun 2013 18:34:09 -0700
Message-ID: <1371864854-28364-2-git-send-email-tj@kernel.org>
References: <1371864854-28364-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=krMF0MKcP7Px40fU2kDNVJhGQ40quigzmaactiv8dR8=;
        b=LLP+CgeR1NzeIFn+FmR61HOiOa0kbWy0FA6OuJZ6500Xlhzhni/xZzPnlTJSMMcTe4
         rxcqiXsnVVUMGVSkFFccxKUVByZ3z/jS3CxR/jM7mA8onkmsKXFibDLw467gSssOQ7TM
         boL2cGEYla2Y9anhENWsWxYrZkWbr4Vht6rQc6Sh8155Yqe9Wv9ZjsesU9TGHnp/CHro
         8fzeWramMUBYsIou9Dv4Eqv0KWLwNq3fhPbSZFCfnLcR/rvR6XX378sBvSKOznISrEHF
         zXXMf6cCV+rOfFL1iS5+Dp85oihgRzUs9m6iNXaW8pXBZ9t6twHFwBSLr0Onh3tDlFSI
         lo3g==
In-Reply-To: <1371864854-28364-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Purely cosmetic.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/cgroup.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 04225939..46a59d0 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -385,9 +385,11 @@ struct cgroup_map_cb {
  */
 
 /* cftype->flags */
-#define CFTYPE_ONLY_ON_ROOT	(1U << 0)	/* only create on root cg */
-#define CFTYPE_NOT_ON_ROOT	(1U << 1)	/* don't create on root cg */
-#define CFTYPE_INSANE		(1U << 2)	/* don't create if sane_behavior */
+enum {
+	CFTYPE_ONLY_ON_ROOT	= (1 << 0),	/* only create on root cg */
+	CFTYPE_NOT_ON_ROOT	= (1 << 1),	/* don't create on root cg */
+	CFTYPE_INSANE		= (1 << 2),	/* don't create if sane_behavior */
+};
 
 #define MAX_CFTYPE_NAME		64
 
-- 
1.8.2.1
