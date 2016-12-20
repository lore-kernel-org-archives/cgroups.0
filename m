From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] kernfs: make kernfs_open_file->mmapped a bitfield
Date: Tue, 20 Dec 2016 11:12:18 -0500
Message-ID: <20161220161222.15234-2-tj@kernel.org>
References: <20161220161222.15234-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PWT8jyi+467bCCM466udrznCIcMTN1m5TFw7kY3OaZo=;
        b=pShVDpMmMEaxfV5eO5rrMtaJQkfSnrqOaff8kKbQFlIYIkp60A7QBRYpIvOCmfl7Ah
         IlzdGiA2deLmwU/mTLuGo9Ys7L6jOHsCkrhdp2akErO6XQd+yLf7Rx/Z4QWU+yq+yZh7
         afJcJlV4/ErDUx9x6z/oHgVlkQtjA2LSZWY2RpKLXVznk7xQcfD0+VJRVdPHwppfTZgy
         IvZtTrZohmrFDv1SnA2uNZI7ZvX0W05QpIy05ieL+ZoaPyXcbMZcTDe6SpnCgdLHz3zM
         /aVlXgbRItoVv12J5Qz6/d5LhZ7KtsgRhOc1j1KUK/t7slP9TwZiup3/P+MgbyrrB4yy
         wsaw==
In-Reply-To: <20161220161222.15234-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh@linuxfoundation.org, lizefan@huawei.com, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

More kernfs_open_file->mutex synchronized flags are planned to be
added.  Convert ->mmapped to a bitfield in preparation.

While at it, make kernfs_fop_mmap() use "true" instead of "1" on
->mmapped.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/kernfs/file.c       | 2 +-
 include/linux/kernfs.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 78219d5..d0b6fb1 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -516,7 +516,7 @@ static int kernfs_fop_mmap(struct file *file, struct vm_area_struct *vma)
 		goto out_put;
 
 	rc = 0;
-	of->mmapped = 1;
+	of->mmapped = true;
 	of->vm_ops = vma->vm_ops;
 	vma->vm_ops = &kernfs_vm_ops;
 out_put:
diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
index 7056238..afd4e5a 100644
--- a/include/linux/kernfs.h
+++ b/include/linux/kernfs.h
@@ -185,7 +185,7 @@ struct kernfs_open_file {
 	char			*prealloc_buf;
 
 	size_t			atomic_write_len;
-	bool			mmapped;
+	bool			mmapped:1;
 	const struct vm_operations_struct *vm_ops;
 };
 
-- 
2.9.3

