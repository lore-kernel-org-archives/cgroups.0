From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/5] kernfs: implement kernfs_path_len()
Date: Tue,  7 Jul 2015 11:10:22 -0400
Message-ID: <1436281823-1947-5-git-send-email-tj@kernel.org>
References: <1436281823-1947-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2U3xq8Tn1c6vX+brQ7N8mlKsqG8rQ8f0Zug70j54QM8=;
        b=DOOCyyqiBdiKFrilImjN/9tjuQRRyECota/Qwu7cvAQ8ukrLFiJwjV9wYgKH26Ng1I
         u1j4cC2oUwATtt4kcgJQpiNFsdLJ0G8BCkcFdOxQ8rGu/K8wSSRoMrokCwIs5ydX76y9
         R5koGxXDWMCBs3w/CDHBJbT0tfFILxWUT862rBhGdbDmwEjJWP0X2IUv3xHLmxicjA/3
         ZhkRXalbOaDOpzn2/Isis1/C6n8yxqyNLW/76MYCR0uqt8I/8+RxMMNhwiG/8R5XNRCO
         +ATFq5ox/kzeEedhu9hZVucWn7FU21/Vg8OHdwOS3/fV9ZF0aLG9UJGyOGhi/2dEllyj
         ZxHA==
In-Reply-To: <1436281823-1947-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: jack@suse.cz, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Add a function to determine the path length of a kernfs node.  This
for now will be used by writeback tracepoint updates.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/dir.c        | 23 +++++++++++++++++++++++
 include/linux/kernfs.h |  4 ++++
 2 files changed, 27 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 2d48d28..91e0045 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -92,6 +92,29 @@ int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 }
 
 /**
+ * kernfs_path_len - determine the length of the full path of a given node
+ * @kn: kernfs_node of interest
+ *
+ * The returned length doesn't include the space for the terminating '\0'.
+ */
+size_t kernfs_path_len(struct kernfs_node *kn)
+{
+	size_t len = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&kernfs_rename_lock, flags);
+
+	do {
+		len += strlen(kn->name) + 1;
+		kn = kn->parent;
+	} while (kn && kn->parent);
+
+	spin_unlock_irqrestore(&kernfs_rename_lock, flags);
+
+	return len;
+}
+
+/**
  * kernfs_path - build full path of a given node
  * @kn: kernfs_node of interest
  * @buf: buffer to copy @kn's name into
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 123be25..5d4e9c4 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -266,6 +266,7 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 }
 
 int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen);
+size_t kernfs_path_len(struct kernfs_node *kn);
 char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
 				size_t buflen);
 void pr_cont_kernfs_name(struct kernfs_node *kn);
@@ -332,6 +333,9 @@ static inline bool kernfs_ns_enabled(struct kernfs_node *kn)
 static inline int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 { return -ENOSYS; }
 
+static inline size_t kernfs_path_len(struct kernfs_node *kn)
+{ return 0; }
+
 static inline char * __must_check kernfs_path(struct kernfs_node *kn, char *buf,
 					      size_t buflen)
 { return NULL; }
-- 
2.4.3
