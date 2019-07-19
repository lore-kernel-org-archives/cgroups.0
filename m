From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH] cgroup writeback: use online cgroup when switching from
 dying bdi_writebacks
Date: Fri, 19 Jul 2019 20:46:35 +0300
Message-ID: <156355839560.2063.5265687291430814589.stgit@buzz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1563558396; bh=1Z3L2rCQwZ1u7nVoekpSRwgzFoMR8NsFTnt2HHesBaM=;
        h=Message-ID:Date:To:From:Subject;
        b=G9TOwr2rBmfREw3RPgVRGhOib+9KfKfXg7eGJs92C82XO+TzZdmfUlsdu83GtwFP2
         Owe7Ncyh2YWSmj+VLAMHq0GEUgfLLCzsgU6lS4EgQ+/5Rp09NDlCi8dyT67snEocI/
         Ej2WIi+3xDW5HS6wtiZQm1tCkBz1HU6MULzYQ6c8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jens Axboe <axboe@fb.com>, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org

Offline memory cgroups forbids creation new bdi_writebacks.
Each try wastes cpu cycles and increases contention around cgwb_lock.

For example each O_DIRECT read calls filemap_write_and_wait_range()
if inode has cached pages which tries to switch from dying writeback.

This patch switches inode writeback to closest online parent cgroup.

Fixes: e8a7abf5a5bd ("writeback: disassociate inodes from dying bdi_writebacks")
Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 fs/fs-writeback.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 542b02d170f8..3af44591a106 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -505,7 +505,7 @@ static void inode_switch_wbs(struct inode *inode, int new_wb_id)
 	/* find and pin the new wb */
 	rcu_read_lock();
 	memcg_css = css_from_id(new_wb_id, &memory_cgrp_subsys);
-	if (memcg_css)
+	if (memcg_css && (memcg_css->flags & CSS_ONLINE))
 		isw->new_wb = wb_get_create(bdi, memcg_css, GFP_ATOMIC);
 	rcu_read_unlock();
 	if (!isw->new_wb)
@@ -579,9 +579,16 @@ void wbc_attach_and_unlock_inode(struct writeback_control *wbc,
 	/*
 	 * A dying wb indicates that the memcg-blkcg mapping has changed
 	 * and a new wb is already serving the memcg.  Switch immediately.
+	 * If memory cgroup is offline switch to closest online parent.
 	 */
-	if (unlikely(wb_dying(wbc->wb)))
-		inode_switch_wbs(inode, wbc->wb_id);
+	if (unlikely(wb_dying(wbc->wb))) {
+		struct cgroup_subsys_state *memcg_css = wbc->wb->memcg_css;
+
+		while (!(memcg_css->flags & CSS_ONLINE))
+			memcg_css = memcg_css->parent;
+
+		inode_switch_wbs(inode, memcg_css->id);
+	}
 }
 EXPORT_SYMBOL_GPL(wbc_attach_and_unlock_inode);
 

