From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v8 3/8] writeback, cgroup: increment isw_nr_in_flight before grabbing an inode
Date: Mon, 7 Jun 2021 18:31:18 -0700
Message-ID: <20210608013123.1088882-4-guro@fb.com>
References: <20210608013123.1088882-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=UnR5/HPn3nu3OonRftQmCkI+MWqhatoGojrvOHmp0+Q=;
 b=I7Kdkfz34jOsjRUVQU6uPuOEAD4BRpnlOa7n4+gbGUK8MLFmcRK7iZyUCmT2cl4n5iWD
 9j18LYMIQLGFGtqBtLYkYyrlVdcylSNVFhHFzlWcnCNcdhlSeABRG69P3knc3j+PPOGo
 rG5dqybsYqQ3EzQmDltzLIf+pg9/9F5fUXU= 
In-Reply-To: <20210608013123.1088882-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

isw_nr_in_flight is used do determine whether the inode switch queue
should be flushed from the umount path. Currently it's increased
after grabbing an inode and even scheduling the switch work. It means
the umount path can be walked past cleanup_offline_cgwb() with active
inode references, which can result in a "Busy inodes after unmount."
message and use-after-free issues (with inode->i_sb which gets freed).

Fix it by incrementing isw_nr_in_flight before doing anything with
the inode and decrementing in the case when switching wasn't scheduled.

The problem hasn't yet been seen in the real life and was discovered
by Jan Kara by looking into the code.

Suggested-by: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 fs/fs-writeback.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 3564efcc4b78..e2cc860a001b 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -505,6 +505,8 @@ static void inode_switch_wbs(struct inode *inode, int=
 new_wb_id)
 	if (!isw)
 		return;
=20
+	atomic_inc(&isw_nr_in_flight);
+
 	/* find and pin the new wb */
 	rcu_read_lock();
 	memcg_css =3D css_from_id(new_wb_id, &memory_cgrp_subsys);
@@ -535,11 +537,10 @@ static void inode_switch_wbs(struct inode *inode, i=
nt new_wb_id)
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
-
-	atomic_inc(&isw_nr_in_flight);
 	return;
=20
 out_free:
+	atomic_dec(&isw_nr_in_flight);
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
 	kfree(isw);
--=20
2.31.1

