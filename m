From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/4] kernfs: remove kernfs_path_len()
Date: Tue,  9 Aug 2016 01:23:23 -0400
Message-ID: <1470720204-4605-4-git-send-email-tj@kernel.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qlKA1YqzrzrMhlxnAuMPMqz2mgz+b4WRjL2Hu2oG0f4=;
        b=DGrRk8pRVwmGUgRbqm5FZudczDcjMJ/QoaprzovpHHZFYaQLWz/QEb6uGfAlcD0oo6
         e2kJEUqF/pA+UZxuSWeRSdADKin/J00S85PN61cLHoF7Pbe5sLAE3rroQRz49b1RCIwE
         0Jsa4pZO/3bc2Hb4LPpSawJFHwI6wCoBbw4TvgO5ykstH1uQUnzQrtHLYSVvGc05rUqL
         M7MqVgpstyUA+qALrh/5l4/YRRIiXGdA3VWrLMeBsuv8qa6xHONIdVYaFml4x7TAlhSQ
         jqRHLWtseKG9KV4N72AHwyz/p5t2J9xgzC6p5RjBiNf61aojmeYEi6XYqwRtjZpzA5JN
         BBfA==
In-Reply-To: <1470720204-4605-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, serge.hallyn@ubuntu.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, Tejun Heo <tj@kernel.org>

It doesn't have any in-kernel user and the same result can be obtained
from kernfs_path(@kn, NULL, 0).  Remove it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@ubuntu.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c        | 23 -----------------------
 include/linux/kernfs.h |  4 ----
 2 files changed, 27 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 09242aa..6e7fd37 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -180,29 +180,6 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 }
 
 /**
- * kernfs_path_len - determine the length of the full path of a given node
- * @kn: kernfs_node of interest
- *
- * The returned length doesn't include the space for the terminating '\0'.
- */
-size_t kernfs_path_len(struct kernfs_node *kn)
-{
-	size_t len = 0;
-	unsigned long flags;
-
-	spin_lock_irqsave(&kernfs_rename_lock, flags);
-
-	do {
-		len += strlen(kn->name) + 1;
-		kn = kn->parent;
-	} while (kn && kn->parent);
-
-	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
-
-	return len;
-}
-
-/**
  * kernfs_path_from_node - build path of node @to relative to @from.
  * @from: parent kernfs_node relative to which we need to build the path
  * @to: kernfs_node of interest
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 64358d2..a410c75 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -269,7 +269,6 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 }
 
 int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
-size_t kernfs_path_len(struct kernfs_node *kn);
 int kernfs_path_from_node(struct kernfs_node *root_kn, struct kernfs_node *kn,
 			  char *buf, size_t buflen);
 void pr_cont_kernfs_name(struct kernfs_node *kn);
@@ -340,9 +339,6 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 static inline int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 { return -ENOSYS; }
 
-static inline size_t kernfs_path_len(struct kernfs_node *kn)
-{ return 0; }
-
 static inline int kernfs_path_from_node(struct kernfs_node *root_kn,
 					struct kernfs_node *kn,
 					char *buf, size_t buflen);
-- 
2.7.4

