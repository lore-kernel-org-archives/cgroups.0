From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free resources
 tied to the file
Date: Mon, 26 Jun 2023 13:17:12 -0700
Message-ID: <20230626201713.1204982-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1687810637; x=1690402637;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=vzLka2g6v99bvwFV0X8erM243tNvsLeL+nN3D/Woyf0=;
        b=jl3ESW4pRptTgPA5siTyuZi4Dv3eIpwdoknSH2LtwJcVtjBKPOgQ/jrinpHbp8cp4s
         8kSuu4XpwQmNnDQ34kEm7SQ7FU/IidUCr0Es6Oq/JpJ4mxp6PHuI8lfioEOahtA7dHsb
         jU4tx4EK3uBQNEedRuvCWVgDSq0ipOoGvYFPpOAkHrQncUr7IXPp19yFx8S58+RQepSu
         gkBV0cFLMLaTSJSqn1Ngc7VTqUzsVuRg/7f1b5T22ZqC6lJiqdZNF1Rjopj9DmlBF9SL
         myqVI1CiOkrEIaXqYglvWuiSxyOn57nNgpoSKfltpgNFmeWDx7k04QmqaUfYKpfF6gKB
         kNpg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

kernfs_ops.release operation can be called from kernfs_drain_open_files
which is not tied to the file's real lifecycle. Introduce a new kernfs_ops
free operation which is called only when the last fput() of the file is
performed and therefore is strictly tied to the file's lifecycle. This
operation will be used for freeing resources tied to the file, like
waitqueues used for polling the file.

Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 fs/kernfs/file.c       | 8 +++++---
 include/linux/kernfs.h | 5 +++++
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 40c4661f15b7..acc52d23d8f6 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -766,7 +766,7 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
 
 /* used from release/drain to ensure that ->release() is called exactly once */
 static void kernfs_release_file(struct kernfs_node *kn,
-				struct kernfs_open_file *of)
+				struct kernfs_open_file *of, bool final)
 {
 	/*
 	 * @of is guaranteed to have no other file operations in flight and
@@ -787,6 +787,8 @@ static void kernfs_release_file(struct kernfs_node *kn,
 		of->released = true;
 		of_on(of)->nr_to_release--;
 	}
+	if (final && kn->attr.ops->free)
+		kn->attr.ops->free(of);
 }
 
 static int kernfs_fop_release(struct inode *inode, struct file *filp)
@@ -798,7 +800,7 @@ static int kernfs_fop_release(struct inode *inode, struct file *filp)
 		struct mutex *mutex;
 
 		mutex = kernfs_open_file_mutex_lock(kn);
-		kernfs_release_file(kn, of);
+		kernfs_release_file(kn, of, true);
 		mutex_unlock(mutex);
 	}
 
@@ -852,7 +854,7 @@ void kernfs_drain_open_files(struct kernfs_node *kn)
 		}
 
 		if (kn->flags & KERNFS_HAS_RELEASE)
-			kernfs_release_file(kn, of);
+			kernfs_release_file(kn, of, false);
 	}
 
 	WARN_ON_ONCE(on->nr_mmapped || on->nr_to_release);
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 73f5c120def8..a7e404ff31bb 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -273,6 +273,11 @@ struct kernfs_ops {
 	 */
 	int (*open)(struct kernfs_open_file *of);
 	void (*release)(struct kernfs_open_file *of);
+	/*
+	 * Free resources tied to the lifecycle of the file, like a
+	 * waitqueue used for polling.
+	 */
+	void (*free)(struct kernfs_open_file *of);
 
 	/*
 	 * Read is handled by either seq_file or raw_read().
-- 
2.41.0.162.gfafddb0af9-goog

