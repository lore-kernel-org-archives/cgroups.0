From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned during
 cgroup writeback association switches
Date: Tue, 16 Feb 2016 13:24:57 -0500
Message-ID: <20160216182457.GO3741@mtj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=IlnS5z0KLmtlShPjBEbTqaNqf0ndylNwi+/MfPzX1DM=;
        b=tyNiI/8lFIFLjIqmKcuhQ6MWCTvyYOMrnlD1p8li/X48Cmxx80u26oJIwvwNueBAt/
         tm3znyA/rM/Umiq90VaFTcsh1yDZSGT4d83uJYbaCH4VaqW0O2uIJKfhwTTfSUAjbj4m
         23xFvzML5jC3Tk3mei77KblA6VoL+4QgPoP/m2uqDNqgWuwoYY0malDAD/D/ci63CZ4H
         +/0D5McrqSr0lK5GwtiGDhoRMaQnMt2xYGH6Ka0g69hgeDl+C3y/TsNnK35IXty2Burk
         QBOLnHs+zGyEm3zfiQ7zsD0zzHBnBqYr0yvOkpmmuqSnCRhPcU2V73uy4i9ahaeatH41
         LtBQ==
Content-Disposition: inline
In-Reply-To: <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

From 586afaa034bec88934bad4eb6ab38ba07031ec5a Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 16 Feb 2016 13:14:35 -0500

If cgroup writeback is in use, an inode is associated with a cgroup
for writeback.  If the inode's main dirtier changes to another cgroup,
the association gets updated asynchronously.  Nothing was pinning the
superblock while such switches are in progress and superblock could go
away while async switching is pending or in progress leading to
crashes like the following.

 kernel BUG at fs/jbd2/transaction.c:319!
 invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC
 CPU: 1 PID: 29158 Comm: kworker/1:10 Not tainted 4.5.0-rc3 #51
 Hardware name: Google Google, BIOS Google 01/01/2011
 Workqueue: events inode_switch_wbs_work_fn
 task: ffff880213dbbd40 ti: ffff880209264000 task.ti: ffff880209264000
 RIP: 0010:[<ffffffff803e6922>]  [<ffffffff803e6922>] start_this_handle+0x382/0x3e0
 RSP: 0018:ffff880209267c30  EFLAGS: 00010202
 ...
 Call Trace:
  [<ffffffff803e6be4>] jbd2__journal_start+0xf4/0x190
  [<ffffffff803cfc7e>] __ext4_journal_start_sb+0x4e/0x70
  [<ffffffff803b31ec>] ext4_evict_inode+0x12c/0x3d0
  [<ffffffff8035338b>] evict+0xbb/0x190
  [<ffffffff80354190>] iput+0x130/0x190
  [<ffffffff80360223>] inode_switch_wbs_work_fn+0x343/0x4c0
  [<ffffffff80279819>] process_one_work+0x129/0x300
  [<ffffffff80279b16>] worker_thread+0x126/0x480
  [<ffffffff8027ed14>] kthread+0xc4/0xe0
  [<ffffffff809771df>] ret_from_fork+0x3f/0x70

Fix it by bumping s_active while cgroup association switching is in
flight.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reported-and-tested-by: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Link: http://lkml.kernel.org/g/CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org
Fixes: d10c80955265 ("writeback: implement foreign cgroup inode bdi_writeback switching")
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org #v4.5+
---
 fs/fs-writeback.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 6915c95..1f76d89 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -317,6 +317,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	struct inode_switch_wbs_context *isw =
 		container_of(work, struct inode_switch_wbs_context, work);
 	struct inode *inode = isw->inode;
+	struct super_block *sb = inode->i_sb;
 	struct address_space *mapping = inode->i_mapping;
 	struct bdi_writeback *old_wb = inode->i_wb;
 	struct bdi_writeback *new_wb = isw->new_wb;
@@ -423,6 +424,7 @@ static void inode_switch_wbs_work_fn(struct work_struct *work)
 	wb_put(new_wb);
 
 	iput(inode);
+	deactivate_super(sb);
 	kfree(isw);
 }
 
@@ -469,11 +471,14 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 
 	/* while holding I_WB_SWITCH, no one else can update the association */
 	spin_lock(&inode->i_lock);
+
 	if (inode->i_state & (I_WB_SWITCH | I_FREEING) ||
-	    inode_to_wb(inode) == isw->new_wb) {
-		spin_unlock(&inode->i_lock);
-		goto out_free;
-	}
+	    inode_to_wb(inode) == isw->new_wb)
+		goto out_unlock;
+
+	if (!atomic_inc_not_zero(&inode->i_sb->s_active))
+		goto out_unlock;
+
 	inode->i_state |= I_WB_SWITCH;
 	spin_unlock(&inode->i_lock);
 
@@ -489,6 +494,8 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	call_rcu(&isw->rcu_head, inode_switch_wbs_rcu_fn);
 	return;
 
+out_unlock:
+	spin_unlock(&inode->i_lock);
 out_free:
 	if (isw->new_wb)
 		wb_put(isw->new_wb);
-- 
2.5.0
