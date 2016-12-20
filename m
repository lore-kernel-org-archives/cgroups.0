From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/5] kernfs: make kernfs_open_file->mmapped a bitfield
Date: Tue, 20 Dec 2016 11:10:49 -0500
Message-ID: <20161220161053.14994-2-tj@kernel.org>
References: <20161220161053.14994-1-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=PWT8jyi+467bCCM466udrznCIcMTN1m5TFw7kY3OaZo=;
        b=bpf0UUk4zLO415Wf9ED5Ycq8LQ6paTJVWzl0a8tfAg9fc9P0LOM4YBUko/l2qvmcvw
         nUxzIg8bcW0HoKuPEN8xtYHXpAnxVCMOma/WwfcTuHQO+7eLNrqdsY2RxyezahtO2WZ1
         XTz5vLClxgeJSV3p4CLoF2RWWa6hzvQ5Bqq0vz36YYVWGlIImPYzSMDcvqTuNpHZUgOK
         lZUebpKtHg94bbpnlBKCJBTZ83Y9bL+ll/RdvvrNu7PQ3cugLj7n8x3STOueAEwrxzMt
         nSmZqGscHtkMVDQ33A96rrRoZ0VFhI2U7mpnb8GdtFMy+eZzyUy+LVYFL6p8yrW/39U4
         sOOg==
In-Reply-To: <20161220161053.14994-1-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

More kernfs_open_file->mutex synchronized flags are planned to be
added.  Convert ->mmapped to a bitfield in preparation.

While at it, make kernfs_fop_mmap() use "true" instead of "1" on
->mmapped.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
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
