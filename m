From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/9] cgroup: use restart_syscall() for mount retries
Date: Fri,  9 May 2014 17:13:27 -0400
Message-ID: <1399670015-23463-2-git-send-email-tj@kernel.org>
References: <1399670015-23463-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gk7db+wrDE59v+0lnv40ZDQBU1iHWccfQKWg2yifIw0=;
        b=B2DtvqE52PpyrRTOxqkLXgQeivxxZzufu7hWwIcNpaP//Rjcy4jwtCWz5KK7iEQtDo
         whGBiB+jdpZjFY9C2DQQLKRgXZcNRI/WEAVRSNaH4JFLigOtQE1thROYThRJxtuMeBeZ
         DJv4h7ugaH6+Sq/q6UE3kchxspVysHEF2YtM5XLhAWeFPx59u5wzYqb0wviQXOMs/X50
         MRJsy3V5W2QK1Y01KGv4kp8o3cZmzVu34VGTS2lmQoSWXrPAOls3azpAcbLIdJ2+oZ2C
         TefeJZHZaFzpYcISNNAahID+u5xhSClxJClu74vfVH3jimd4pyS8ocqC3Ob79ru4CkcJ
         GiHQ==
In-Reply-To: <1399670015-23463-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

cgroup_mount() uses dumb delay-and-retry logic to wait for cgroup_root
which is being destroyed.  The retry currently loops inside
cgroup_mount() proper.  This patch makes it return with
restart_syscall() instead so that retry travels out to userland
boundary.

This slightly simplifies the logic and more importantly makes the
retry logic behave better when the wait for some reason becomes
lengthy or infinite by allowing the operation to be suspended or
terminated from userland.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3083c5a..2755f33 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1681,7 +1681,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 	ret = parse_cgroupfs_options(data, &opts);
 	if (ret)
 		goto out_unlock;
-retry:
+
 	/* look for a matching existing root */
 	if (!opts.subsys_mask && !opts.none && !opts.name) {
 		cgrp_dfl_root_visible = true;
@@ -1740,8 +1740,7 @@ retry:
 		if (!atomic_inc_not_zero(&root->cgrp.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			msleep(10);
-			mutex_lock(&cgroup_mutex);
-			goto retry;
+			return ERR_PTR(restart_syscall());
 		}
 
 		ret = 0;
-- 
1.9.0
