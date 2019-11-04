From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 05/10] kernfs: kernfs_find_and_get_node_by_ino() should only look up activated nodes
Date: Mon,  4 Nov 2019 15:59:39 -0800
Message-ID: <20191104235944.3470866-6-tj@kernel.org>
References: <20191104235944.3470866-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3SAFhWytWRsOw7arfqXaOD5T2u5Zhg2vpO9SXodrC/A=;
        b=CTCLfdhkpDgX8suXA2/gh1Z6TjiX6DhZVUPJ8sPRgTSylvD0AFGxKvnJdEBi6n6wn3
         fMBhWroP9nhCGOI0To5j/dkt0C9nee87OfCaxB1e+kzhhr4yQQyFf0tZIlX0R3c2BmCQ
         TexU+JfD94MQ47ekObZWXLdusQHVTMvc64k+UYTbTCgg7Er1g3YPsarS+YNmvdYwFAXz
         CpDO8dFf17J8Uhh0ZluJk5Rk5D132YQC9/rUkwNZ1ynTyTq/CeG6NhLshpxg0Kc2iM+a
         emAjEZ1SiujyMWC+UN1zJMkgPkYAeLQ+QT1EkGgAlFLx6Z2XDXfJ5wGp1p/kCLmOJbp2
         BM7g==
In-Reply-To: <20191104235944.3470866-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org
Cc: kernel-team@fb.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, namhyung@kernel.org, ast@kernel.org, daniel@iogearbox.net, Tejun Heo <tj@kernel.org>

kernfs node can be created in two separate steps - allocation and
activation.  This is used to make kernfs nodes visible only after the
internal states attached to the node are fully initialized.
kernfs_find_and_get_node_by_id() currently allows lookups of nodes
which aren't activated yet and thus can expose nodes are which are
still being prepped by kernfs users.

Fix it by disallowing lookups of nodes which aren't activated yet.

kernfs_find_and_get_node_by_ino()

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
---
 fs/kernfs/dir.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 798f0f03b62b..beabb585a7d8 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -714,7 +714,13 @@ struct kernfs_node *kernfs_find_and_get_node_by_ino(struct kernfs_root *root,
 	if (!kn)
 		goto err_unlock;
 
-	if (unlikely(!atomic_inc_not_zero(&kn->count)))
+	/*
+	 * ACTIVATED is protected with kernfs_mutex but it was clear when
+	 * @kn was added to idr and we just wanna see it set.  No need to
+	 * grab kernfs_mutex.
+	 */
+	if (unlikely(!(kn->flags & KERNFS_ACTIVATED) ||
+		     !atomic_inc_not_zero(&kn->count)))
 		goto err_unlock;
 
 	spin_unlock(&kernfs_idr_lock);
-- 
2.17.1

