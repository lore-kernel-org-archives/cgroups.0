From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/4] kernfs: add dummy implementation of kernfs_path_from_node()
Date: Tue,  9 Aug 2016 01:23:21 -0400
Message-ID: <1470720204-4605-2-git-send-email-tj@kernel.org>
References: <1470720204-4605-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z/CjQkEJVGAGHLeJvQqoyNfIgEOEPg3i1Jegxb5XTho=;
        b=X3GzXFsjlO/+ffDMfxsg2PuJyd1oHBVpZYCHabDcCgWoxVk+mb1XXxMlPK+jfQ81zW
         tLH8vFK8tYAP9g4rhqr46BU2cuP/kDVNrgrvntLNpGfIBPdaFjUmEl+p6t4yrby4Fxco
         f05WKmYzcYVO6DZ6uqJ2V0CE6kMQxjjOzkc7QkfELTMDrLIQP0PnLiIJDGW8oLv2dtUL
         0JOjFnBHoXtJF4aZnQvGw7z518tS9oNmDZ8Cp39qZCP37AOqLkQs2+88/Xg+XM5HaGXz
         /2AGY9T/PNAYlNhia8QNGxoGT6/4QvobWTRm6J5Ok5ZbgTmPb9tZYt6V0W+alV4OZeiY
         kGgA==
In-Reply-To: <1470720204-4605-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, serge.hallyn@ubuntu.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, Tejun Heo <tj@kernel.org>

The dummy version of kernfs_path_from_node() was missing.  This
currently doesn't break anything.  Let's add it for consistency and to
ease adding wrappers around it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/kernfs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 96356ef..325954f 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -344,6 +344,11 @@ static inline int kernfs_name(struct kernfs_node *kn, char *buf, size_t buflen)
 static inline size_t kernfs_path_len(struct kernfs_node *kn)
 { return 0; }
 
+static inline int kernfs_path_from_node(struct kernfs_node *root_kn,
+					struct kernfs_node *kn,
+					char *buf, size_t buflen);
+{ return -ENOSYS; }
+
 static inline char *kernfs_path(struct kernfs_node *kn, char *buf,
 				size_t buflen)
 { return NULL; }
-- 
2.7.4

