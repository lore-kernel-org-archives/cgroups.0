From: Paolo Valente <paolo.valente@linaro.org>
Subject: [PATCH 01/12] kernfs: add function to find kernfs_node without increasing ref counter
Date: Mon, 12 Nov 2018 10:56:21 +0100
Message-ID: <20181112095632.69114-2-paolo.valente@linaro.org>
References: <20181112095632.69114-1-paolo.valente@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gEkvf3D0ybtQ1XCiNuNOR20e0/KEmaDMFTtp87FuqbE=;
        b=N8KkHvWqCG3FPBQKMMKSv7Pg/NLzZZA7xMvcJW6U01Wj0GNYTuJeCcya4ODW4IlfDY
         bjeINPfviBlUjWGw0A/F1Z2j5xFDixkEn+Wq8pjVDa2f0IyCUhwOwJnWnNFIaWBeVVTq
         d85CwbZ1TDnYV7195SRPVFTFCEtIMsDAzsBRA=
In-Reply-To: <20181112095632.69114-1-paolo.valente@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Angelo Ruocco <angeloruocco90@gmail.com>, Dennis Zhou <dennis@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Liu Bo <bo.liu@linux.alibaba.com>, Bart Van Assche <bvanassche@acm.org>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ulf.hansson@linaro.org, linus.walleij@linaro.org, broonie@kernel.org, bfq-iosched@googlegroups.com, oleksandr@natalenko.name, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Paolo Valente <paolo.valente@linaro.org>

From: Angelo Ruocco <angeloruocco90@gmail.com>

The kernfs pseudo file system doesn't export any function to only find
a node by name, without also getting a reference on it.
But in some cases it is useful to just locate a kernfs node, while
using it or not depends on some other condition.

This commit adds a function to just look for a node, without getting
a reference on it.

Signed-off-by: Angelo Ruocco <angeloruocco90@gmail.com>
Signed-off-by: Paolo Valente <paolo.valente@linaro.org>
---
 fs/kernfs/dir.c        | 13 +++++++++++++
 include/linux/kernfs.h |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 4ca0b5c18192..0003c665869d 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -892,6 +892,19 @@ static struct kernfs_node *kernfs_walk_ns(struct kernfs_node *parent,
 	return parent;
 }
 
+struct kernfs_node *kernfs_find(struct kernfs_node *parent,
+				const unsigned char *name)
+{
+	struct kernfs_node *kn;
+
+	mutex_lock(&kernfs_mutex);
+	kn = kernfs_find_ns(parent, name, NULL);
+	mutex_unlock(&kernfs_mutex);
+
+	return kn;
+}
+EXPORT_SYMBOL_GPL(kernfs_find);
+
 /**
  * kernfs_find_and_get_ns - find and get kernfs_node with the given name
  * @parent: kernfs_node to search under
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 5b36b1287a5a..26e69d285964 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -309,6 +309,8 @@ void pr_cont_kernfs_path(struct kernfs_node *kn);
 struct kernfs_node *kernfs_get_parent(struct kernfs_node *kn);
 struct kernfs_node *kernfs_find_and_get_ns(struct kernfs_node *parent,
 					   const char *name, const void *ns);
+struct kernfs_node *kernfs_find(struct kernfs_node *parent,
+				const unsigned char *name);
 struct kernfs_node *kernfs_walk_and_get_ns(struct kernfs_node *parent,
 					   const char *path, const void *ns);
 void kernfs_get(struct kernfs_node *kn);
@@ -391,6 +393,11 @@ static inline struct kernfs_node *
 kernfs_find_and_get_ns(struct kernfs_node *parent, const char *name,
 		       const void *ns)
 { return NULL; }
+
+static inline struct kernfs_node *
+kernfs_find(struct kernfs_node *parent, const char *name)
+{ return NULL; }
+
 static inline struct kernfs_node *
 kernfs_walk_and_get_ns(struct kernfs_node *parent, const char *path,
 		       const void *ns)
-- 
2.16.1

