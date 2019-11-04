From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 01/10] kernfs: fix ino wrap-around detection
Date: Mon,  4 Nov 2019 15:59:35 -0800
Message-ID: <20191104235944.3470866-2-tj@kernel.org>
References: <20191104235944.3470866-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LMhymltIw4we4fZsZLdmQ/16XCXhEvoGcZblYC0fAkI=;
        b=sqhJlONVSwk7PR1KsI0/z7ceSN3Yxbham9y89DftqEQCIhYyFExXMklDI1poiTc5dc
         478Ypm29RblYnPiZVNQ/XltUCHE0b4AUQw8BE5b0ruvd1hV77jxiJ98p0h5Y+UADNkEM
         FkCZDZmIqbJm4SB3A/N8NVQ3E181FsliQa+otNX3bFuaD+2Qe/dZWwNZgMDc87g8tkrK
         HdQE7gADZBjojBd6+XivqHB+Rslbe6gHaZvlKn8RKGUX6I0gjxjRfsa9M+tKZuqOCGxD
         DGYOLQvqs4xvmSOX4IODQlJizmEyMM1TCCCR6Ysx9hitXpLg1VS8chyK/IPaKBJ+zQYB
         UwHg==
In-Reply-To: <20191104235944.3470866-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net, Tejun Heo <tj@kernel.org>, stable@vger.kernel.org

When the 32bit ino wraps around, kernfs increments the generation
number to distinguish reused ino instances.  The wrap-around detection
tests whether the allocated ino is lower than what the cursor but the
cursor is pointing to the next ino to allocate so the condition never
triggers.

Fix it by remembering the last ino and comparing against that.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: 4a3ef68acacf ("kernfs: implement i_generation")
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org # v4.14+
---
 fs/kernfs/dir.c        | 5 ++---
 include/linux/kernfs.h | 1 +
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 6ebae6bbe6a5..7d4af6cea2a6 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -622,7 +622,6 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 {
 	struct kernfs_node *kn;
 	u32 gen;
-	int cursor;
 	int ret;
 
 	name = kstrdup_const(name, GFP_KERNEL);
@@ -635,11 +634,11 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 
 	idr_preload(GFP_KERNEL);
 	spin_lock(&kernfs_idr_lock);
-	cursor = idr_get_cursor(&root->ino_idr);
 	ret = idr_alloc_cyclic(&root->ino_idr, kn, 1, 0, GFP_ATOMIC);
-	if (ret >= 0 && ret < cursor)
+	if (ret >= 0 && ret < root->last_ino)
 		root->next_generation++;
 	gen = root->next_generation;
+	root->last_ino = ret;
 	spin_unlock(&kernfs_idr_lock);
 	idr_preload_end();
 	if (ret < 0)
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 936b61bd504e..f797ccc650e7 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -187,6 +187,7 @@ struct kernfs_root {
 
 	/* private fields, do not use outside kernfs proper */
 	struct idr		ino_idr;
+	u32			last_ino;
 	u32			next_generation;
 	struct kernfs_syscall_ops *syscall_ops;
 
-- 
2.17.1

