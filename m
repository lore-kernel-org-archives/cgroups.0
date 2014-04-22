From: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup_freezer: explicitly init the early_init field
Date: Tue, 22 Apr 2014 13:28:09 +0800
Message-ID: <1398144489-9412-1-git-send-email-nasa4836@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20120113;
	h=from:to:cc:subject:date:message-id;
	bh=BR2NImQ3F/RA6S6Osao8FwZrCBNytu48HKevG7Y5rTY=;
	b=ajvVXlSFVzmjmyQJSN/RD0LAt3xauhNuucO6ayMoGw0XtD7FZL1KuICodRfssbCY6e
	NOyIZaCHHvvKNAJXbxgXdKGPt2IAd53INc3+RRKgirRVsiwYj4uvrG4IG4cBMESntpPR
	GBtVkuNR702iuAP++DH8Mc+ZnUKnGIcnONDGT2zR2KhJuH3Sxr++iC1yCR0Y8AzeZ810
	BEh9zX6bHVfCV5VJM33hR61OSlvodgtFxRVFkT/WnzAE/rR4B1nGAwpnLC2UdIVReIKr
	6SG1B3RIGOHinGxDf+VVvE6dLepT5vp8cU6rF4ohi6DHkpDG+mbVTLZu/Lq3G5jqREQE
	Xm1w==
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/containers>, 
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/containers/>
List-Post: <mailto:containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/containers>,
	<mailto:containers-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: containers-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

For a cgroup subsystem who should init early, then it should carefully
take care of the implementation of css_alloc, because it will be called
before mm_init() setup the world.

Luckily we don't, and we better explicitly assign the early_init field
to 0, for document reason.

Signed-off-by: Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup_freezer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup_freezer.c b/kernel/cgroup_freezer.c
index 2bc4a22..74fe7f7 100644
--- a/kernel/cgroup_freezer.c
+++ b/kernel/cgroup_freezer.c
@@ -501,4 +501,5 @@ struct cgroup_subsys freezer_cgrp_subsys = {
 	.attach		= freezer_attach,
 	.fork		= freezer_fork,
 	.base_cftypes	= files,
+	.early_init	= 0,
 };
-- 
2.0.0-rc0
