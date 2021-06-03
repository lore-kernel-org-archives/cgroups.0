From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: [PATCH v6 3/5] writeback, cgroup: split out the functional part of inode_switch_wbs_work_fn()
Date: Wed, 2 Jun 2021 17:55:15 -0700
Message-ID: <20210603005517.1403689-4-guro@fb.com>
References: <20210603005517.1403689-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=/DBsTJC33bFhaEU3PBMQzj0ujRVVcUYAVrv4stXzc5Y=;
 b=mV6W9OHNSFdLKkOytySRMra32H+5DcojjlazYqhuwG0wAoXwFpXCWOHGVtWQP9VZsNak
 1OJLBio2gXM20+fMWG2i4eH+7otfjKW3MYdUqb6K7iYTxSALySh+OiNMB/z4sd34YR/Y
 l3xBcdhgh0KAlu9RLOGJbd9PN/xgd7jGhyo= 
In-Reply-To: <20210603005517.1403689-1-guro-b10kYP2dOMg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Chinner <dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Split out the functional part of the inode_switch_wbs_work_fn()
function as inode_do switch_wbs() to reuse it later for switching
inodes attached to dying cgwbs.

This commit doesn't bring any functional changes.

Signed-off-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 fs/fs-writeback.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 09d2770449ef..212494d89cc2 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -351,15 +351,12 @@ static void bdi_up_write_wb_switch_rwsem(struct bac=
king_dev_info *bdi)
 	up_write(&bdi->wb_switch_rwsem);
 }
=20
-static void inode_switch_wbs_work_fn(struct work_struct *work)
+static void inode_do_switch_wbs(struct inode *inode,
+				struct bdi_writeback *new_wb)
 {
-	struct inode_switch_wbs_context *isw =3D
-		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work)=
;
-	struct inode *inode =3D isw->inode;
 	struct backing_dev_info *bdi =3D inode_to_bdi(inode);
 	struct address_space *mapping =3D inode->i_mapping;
 	struct bdi_writeback *old_wb =3D inode->i_wb;
-	struct bdi_writeback *new_wb =3D isw->new_wb;
 	XA_STATE(xas, &mapping->i_pages, 0);
 	struct page *page;
 	bool switched =3D false;
@@ -470,11 +467,17 @@ static void inode_switch_wbs_work_fn(struct work_st=
ruct *work)
 		wb_wakeup(new_wb);
 		wb_put(old_wb);
 	}
-	wb_put(new_wb);
+}
=20
-	iput(inode);
-	kfree(isw);
+static void inode_switch_wbs_work_fn(struct work_struct *work)
+{
+	struct inode_switch_wbs_context *isw =3D
+		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work)=
;
=20
+	inode_do_switch_wbs(isw->inode, isw->new_wb);
+	wb_put(isw->new_wb);
+	iput(isw->inode);
+	kfree(isw);
 	atomic_dec(&isw_nr_in_flight);
 }
=20
--=20
2.31.1

