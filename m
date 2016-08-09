From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2 1/4] kernfs: add dummy implementation of
 kernfs_path_from_node()
Date: Tue, 9 Aug 2016 02:14:17 -0400
Message-ID: <20160809061417.GB4906@mtj.duckdns.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
 <1470720204-4605-2-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=J8jDkW9f85HQThpnldxpHr02tppso0BXtC6o2bEjSzk=;
        b=SAgVtl6jGIfhDzoTfcSwx6teJiBl4n9pncdkXNlw1aoi4PTfDNtINp1SAbN1+/oyN4
         m1Dr+WE4hjuX6lPeAaOD2OdC9pSmy85ilKfrCFG0ABcfaCDIXcDfDQ/H+py90Bj1Zf9y
         9twEY90AI4roH/4vuEKmV22mCU6eP3sEa+uD330xturmOLv3hRkbmhloIOtFT8JegumY
         oSsZ6kAOuvoJmdpnDcFkbBRiDGUAPcQtIM2CyrB0RVS6B1s9EnyBJnMlBz4l5wD0JZw9
         l5PMOgnykrNF5h8BSQEU+q48eyd9j/pgvbP7pdJaeoTp9UYlxy2lm+45xnKNFo/ODxFB
         wrag==
Content-Disposition: inline
In-Reply-To: <1470720204-4605-2-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From 17d6dfb3afa88253bf1ceee2d4a5e461970fc593 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 9 Aug 2016 02:12:21 -0400

The dummy version of kernfs_path_from_node() was missing.  This
currently doesn't break anything.  Let's add it for consistency and to
ease adding wrappers around it.

v2: Removed stray ';' which was causing build failures.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
---
 include/linux/kernfs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 96356ef..7d2efd2 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -344,6 +344,11 @@ static inline int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 static inline size_t kernfs_path_len(struct kernfs_node *kn)
 { return 0; }
 
+static inline int kernfs_path_from_node(struct kernfs_node *root_kn,
+					struct kernfs_node *kn,
+					char *buf, size_t buflen)
+{ return -ENOSYS; }
+
 static inline char *kernfs_path(struct kernfs_node *kn, char *buf,
 				size_t buflen)
 { return NULL; }
-- 
2.7.4
