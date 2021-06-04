From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v7 4/6] writeback, cgroup: split out the functional part of inode_switch_wbs_work_fn()
Date: Thu, 3 Jun 2021 18:31:57 -0700
Message-ID: <20210604013159.3126180-5-guro@fb.com>
References: <20210604013159.3126180-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=3PD7flUng0j3vsCl8JvECN+6WNTm0WOf3BpqS3MXrJs=;
 b=TRSPLYI7RUPJskKdG3cuoTmTIaSOQkSHk0TXgikQi8aS6EAH7KIa6nRW2NMIppGqv2WG
 93rG8/003x3Pyk76g0rsG1DwT6fhQj4xwxkfWgmJ4AT57efI9mtqr6QsWfu+vIfvGQWE
 nvs9s24iSPL1xVPe8iOerU9he/kQusgW4yU= 
In-Reply-To: <20210604013159.3126180-1-guro@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Split out the functional part of the inode_switch_wbs_work_fn()
function as inode_do switch_wbs() to reuse it later for switching
inodes attached to dying cgwbs.

This commit doesn't bring any functional changes.

Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
 fs/fs-writeback.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index f0dfcd08073e..d46cdeeb6797 100644
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

