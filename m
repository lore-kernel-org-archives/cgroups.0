From: Roman Gushchin <guro@fb.com>
Subject: [PATCH v7 1/6] writeback, cgroup: do not switch inodes with I_WILL_FREE flag
Date: Thu, 3 Jun 2021 18:31:54 -0700
Message-ID: <20210604013159.3126180-2-guro@fb.com>
References: <20210604013159.3126180-1-guro@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=facebook;
 bh=0gZxeDTVwwISi0mUQNjyH9+4fnDHEWwqdGc5QqFQf6Q=;
 b=HhVza4LorKtpD1j6N2ASKf7VUTEXpzbqgg8Ze6a0E/CZ8jaXoGBBem7TxNweH+PHyTs2
 onC5tbV47NFkOFm5lrAJzJn+vdEL2qvrWwP0cmyAaQuIN8CM0DyhpwNZMZEnEnCyVhoE
 09Sf2g5B6fZD2n1kuVc8kf96+KDKMriVvbg= 
In-Reply-To: <20210604013159.3126180-1-guro@fb.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>, Tejun Heo <tj@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Alexander Viro <viro@zeniv.linux.org.uk>, Dennis Zhou <dennis@kernel.org>, Dave Chinner <dchinner@redhat.com>, cgroups@vger.kernel.org, Roman Gushchin <guro@fb.com>

If an inode's state has I_WILL_FREE flag set, the inode will be
freed soon, so there is no point in trying to switch the inode
to a different cgwb.

I_WILL_FREE was ignored since the introduction of the inode switching,
so it looks like it doesn't lead to any noticeable issues for a user.
This is why the patch is not intended for a stable backport.

Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Roman Gushchin <guro@fb.com>
---
 fs/fs-writeback.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index e91980f49388..bd99890599e0 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -389,10 +389,10 @@ static void inode_switch_wbs_work_fn(struct work_st=
ruct *work)
 	xa_lock_irq(&mapping->i_pages);
=20
 	/*
-	 * Once I_FREEING is visible under i_lock, the eviction path owns
-	 * the inode and we shouldn't modify ->i_io_list.
+	 * Once I_FREEING or I_WILL_FREE are visible under i_lock, the eviction
+	 * path owns the inode and we shouldn't modify ->i_io_list.
 	 */
-	if (unlikely(inode->i_state & I_FREEING))
+	if (unlikely(inode->i_state & (I_FREEING | I_WILL_FREE)))
 		goto skip_switch;
=20
 	trace_inode_switch_wbs(inode, old_wb, new_wb);
@@ -517,7 +517,7 @@ static void inode_switch_wbs(struct inode *inode, int=
 new_wb_id)
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
 	if (!(inode->i_sb->s_flags & SB_ACTIVE) ||
-	    inode->i_state & (I_WB_SWITCH | I_FREEING) ||
+	    inode->i_state & (I_WB_SWITCH | I_FREEING | I_WILL_FREE) ||
 	    inode_to_wb(inode) =3D=3D isw->new_wb) {
 		spin_unlock(&inode->i_lock);
 		goto out_free;
--=20
2.31.1

