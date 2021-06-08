From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v9 4/8] writeback, cgroup: switch to rcu_work API in inode_switch_wbs()
Date: Tue, 8 Jun 2021 16:02:21 -0700
Message-ID: <20210608230225.2078447-5-guro@fb.com>
References: <20210608230225.2078447-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=XHzrcLeP1URuGcDcVxjPjZJfQ6zGXzyOoJIlmU7mig8=;
 b=TE7I+A4FsBIMRNuZ+lPM2MpLGWL+AiIqiOZ0tR9V7U/y5MY9VN1C3SPMNZ3UCd5ccnAT
 BEFREIW0Rd7wfSLNfWg+cZFY/RjgqgpJheO00NGqbPNddhy660NmJw25QWvXyKJFH4hy
 G0RAEImE4SYz+Ms6okklIA15/JlAhNfguYE= 
In-Reply-To: <20210608230225.2078447-1-guro@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

Inode's wb switching requires two steps divided by an RCU grace
period. It's currently implemented as an RCU callback
inode_switch_wbs_rcu_fn(), which schedules inode_switch_wbs_work_fn()
as a work.

Switching to the rcu_work API allows to do the same in a cleaner and
slightly shorter form.

Signed-off-by: Roman Gushchin <guro@fb.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Acked-by: Tejun Heo <tj@kernel.org>
Acked-by: Dennis Zhou <dennis@kernel.org>
---
 fs/fs-writeback.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4413e005c28c..8265dccd8da5 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -335,8 +335,7 @@ struct inode_switch_wbs_context {
 	struct inode		*inode;
 	struct bdi_writeback	*new_wb;
=20
-	struct rcu_head		rcu_head;
-	struct work_struct	work;
+	struct rcu_work		work;
 };
=20
 static void bdi_down_write_wb_switch_rwsem(struct backing_dev_info *bdi)
@@ -352,7 +351,7 @@ static void bdi_up_write_wb_switch_rwsem(struct backi=
ng_dev_info *bdi)
 static void inode_switch_wbs_work_fn(struct work_struct *work)
 {
 	struct inode_switch_wbs_context *isw =3D
-		container_of(work, struct inode_switch_wbs_context, work);
+		container_of(to_rcu_work(work), struct inode_switch_wbs_context, work)=
;
 	struct inode *inode =3D isw->inode;
 	struct backing_dev_info *bdi =3D inode_to_bdi(inode);
 	struct address_space *mapping =3D inode->i_mapping;
@@ -469,16 +468,6 @@ static void inode_switch_wbs_work_fn(struct work_str=
uct *work)
 	atomic_dec(&isw_nr_in_flight);
 }
=20
-static void inode_switch_wbs_rcu_fn(struct rcu_head *rcu_head)
-{
-	struct inode_switch_wbs_context *isw =3D container_of(rcu_head,
-				struct inode_switch_wbs_context, rcu_head);
-
-	/* needs to grab bh-unsafe locks, bounce to work item */
-	INIT_WORK(&isw->work, inode_switch_wbs_work_fn);
-	queue_work(isw_wq, &isw->work);
-}
-
 /**
  * inode_switch_wbs - change the wb association of an inode
  * @inode: target inode
@@ -536,7 +525,8 @@ static void inode_switch_wbs(struct inode *inode, int=
 new_wb_id)
 	 * lock so that stat transfer can synchronize against them.
 	 * Let's continue after I_WB_SWITCH is guaranteed to be visible.
 	 */
-	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
+	INIT_RCU_WORK(&isw->work, inode_switch_wbs_work_fn);
+	queue_rcu_work(isw_wq, &isw->work);
 	return;
=20
 out_free:
--=20
2.31.1

