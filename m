From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 67/99] mm: Convert cgroup writeback to XArray
Date: Wed, 17 Jan 2018 12:21:31 -0800
Message-ID: <20180117202203.19756-68-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rTshG3SBn8CWiawm3Q3Mh1fF4HgInl4fH0Vr6jnt6Uk=; b=JmZQvj40bGuuuJI7orupf3GFbl
 yJbqATQI4Ro+UDQZXpbfZt+6c5jEghelyofU1EK4rAKhzxe1BKcpz9e0jfRMnIsvER1p92R/raQ/C
 5KQ/EJy225W3bCkWILNCBkWWswamA3+m9OvIXlb5sYLx1qbwefCmRxzfJF7Vi+X3zv0U=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rTshG3SBn8CWiawm3Q3Mh1fF4HgInl4fH0Vr6jnt6Uk=; b=EytEOd7vZn+YS4IuxAyz9Bn9H1
 ibBATCCY5U7o6FYoPGodJenKAbZNfuudiHWwMlbxGsbYsbYF/d/ZSi/0gBJZ2TfwyqM+dN8f8S1Rn
 2i+OrRSiVdvzGR8diWsID0qTJqqLECCPBw6csgFReSUhvMfttX6Xm5PcloSIW3DhxTd4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rTshG3SBn8CWiawm3Q3Mh1fF4HgInl4fH0Vr6jnt6Uk=; b=ZJH5TeDIyWaN0VgN+Y/gTecoM
 e75Rz3apmCk2dYpeSBVxjwttPvfkQU7HG0rQ/LOfguMqxFwP+1vuKzTcNhFXlqMCKFsBLB+qopUcr
 c+8QpztKprkDhi47UGhCav1zN23SAjtnjV8UrLF8g42AIPxzys5ut75MX5DRw9HGv5rbk3Ssc0nfJ
 hx1vPAFQEjY438bOtwWpz/b19Zb49dEK5tPMGjkmMYw8TH1gRQxhaVejSjeuKWcLD0SMR0v09mOvw
 Rbt30nKvMeIzxMr7cHmCISScw/tkqg0ibI5JIictnc0ZvNfzUU9EAK6/EU5uuEjOkwqmQ9g37CCkg
 7XiZ+qh1g==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

This is a fairly naive conversion, leaving in place the GFP_ATOMIC
allocation.  By switching the locking around, we could use GFP_KERNEL
and probably simplify the error handling.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/backing-dev-defs.h |  2 +-
 include/linux/backing-dev.h      |  2 +-
 mm/backing-dev.c                 | 22 ++++++++++------------
 3 files changed, 12 insertions(+), 14 deletions(-)

diff --git a/include/linux/backing-dev-defs.h b/include/linux/backing-dev-defs.h
index bfe86b54f6c1..074a54aad33c 100644
--- a/include/linux/backing-dev-defs.h
+++ b/include/linux/backing-dev-defs.h
@@ -187,7 +187,7 @@ struct backing_dev_info {
 	struct bdi_writeback wb;  /* the root writeback info for this bdi */
 	struct list_head wb_list; /* list of all wbs */
 #ifdef CONFIG_CGROUP_WRITEBACK
-	struct radix_tree_root cgwb_tree; /* radix tree of active cgroup wbs */
+	struct xarray cgwb_xa;		/* radix tree of active cgroup wbs */
 	struct rb_root cgwb_congested_tree; /* their congested states */
 #else
 	struct bdi_writeback_congested *wb_congested;
diff --git a/include/linux/backing-dev.h b/include/linux/backing-dev.h
index 3df0d20e23f3..27e7b31bd802 100644
--- a/include/linux/backing-dev.h
+++ b/include/linux/backing-dev.h
@@ -271,7 +271,7 @@ static inline struct bdi_writeback *wb_find_current(struct backing_dev_info *bdi
 	if (!memcg_css->parent)
 		return &bdi->wb;
 
-	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	wb = xa_load(&bdi->cgwb_xa, memcg_css->id);
 
 	/*
 	 * %current's blkcg equals the effective blkcg of its memcg.  No
diff --git a/mm/backing-dev.c b/mm/backing-dev.c
index b5f940ce0143..aa0f85df0928 100644
--- a/mm/backing-dev.c
+++ b/mm/backing-dev.c
@@ -417,8 +417,8 @@ static void wb_exit(struct bdi_writeback *wb)
 #include <linux/memcontrol.h>
 
 /*
- * cgwb_lock protects bdi->cgwb_tree, bdi->cgwb_congested_tree,
- * blkcg->cgwb_list, and memcg->cgwb_list.  bdi->cgwb_tree is also RCU
+ * cgwb_lock protects bdi->cgwb_xa, bdi->cgwb_congested_tree,
+ * blkcg->cgwb_list, and memcg->cgwb_list.  bdi->cgwb_xa is also RCU
  * protected.
  */
 static DEFINE_SPINLOCK(cgwb_lock);
@@ -539,7 +539,7 @@ static void cgwb_kill(struct bdi_writeback *wb)
 {
 	lockdep_assert_held(&cgwb_lock);
 
-	WARN_ON(!radix_tree_delete(&wb->bdi->cgwb_tree, wb->memcg_css->id));
+	WARN_ON(xa_erase(&wb->bdi->cgwb_xa, wb->memcg_css->id) != wb);
 	list_del(&wb->memcg_node);
 	list_del(&wb->blkcg_node);
 	percpu_ref_kill(&wb->refcnt);
@@ -571,7 +571,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 
 	/* look up again under lock and discard on blkcg mismatch */
 	spin_lock_irqsave(&cgwb_lock, flags);
-	wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+	wb = xa_load(&bdi->cgwb_xa, memcg_css->id);
 	if (wb && wb->blkcg_css != blkcg_css) {
 		cgwb_kill(wb);
 		wb = NULL;
@@ -614,8 +614,7 @@ static int cgwb_create(struct backing_dev_info *bdi,
 	spin_lock_irqsave(&cgwb_lock, flags);
 	if (test_bit(WB_registered, &bdi->wb.state) &&
 	    blkcg_cgwb_list->next && memcg_cgwb_list->next) {
-		/* we might have raced another instance of this function */
-		ret = radix_tree_insert(&bdi->cgwb_tree, memcg_css->id, wb);
+		ret = xa_insert(&bdi->cgwb_xa, memcg_css->id, wb, GFP_ATOMIC);
 		if (!ret) {
 			list_add_tail_rcu(&wb->bdi_node, &bdi->wb_list);
 			list_add(&wb->memcg_node, memcg_cgwb_list);
@@ -682,7 +681,7 @@ struct bdi_writeback *wb_get_create(struct backing_dev_info *bdi,
 
 	do {
 		rcu_read_lock();
-		wb = radix_tree_lookup(&bdi->cgwb_tree, memcg_css->id);
+		wb = xa_load(&bdi->cgwb_xa, memcg_css->id);
 		if (wb) {
 			struct cgroup_subsys_state *blkcg_css;
 
@@ -704,7 +703,7 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 {
 	int ret;
 
-	INIT_RADIX_TREE(&bdi->cgwb_tree, GFP_ATOMIC);
+	xa_init(&bdi->cgwb_xa);
 	bdi->cgwb_congested_tree = RB_ROOT;
 
 	ret = wb_init(&bdi->wb, bdi, 1, GFP_KERNEL);
@@ -717,15 +716,14 @@ static int cgwb_bdi_init(struct backing_dev_info *bdi)
 
 static void cgwb_bdi_unregister(struct backing_dev_info *bdi)
 {
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &bdi->cgwb_xa, 0);
 	struct bdi_writeback *wb;
 
 	WARN_ON(test_bit(WB_registered, &bdi->wb.state));
 
 	spin_lock_irq(&cgwb_lock);
-	radix_tree_for_each_slot(slot, &bdi->cgwb_tree, &iter, 0)
-		cgwb_kill(*slot);
+	xas_for_each(&xas, wb, ULONG_MAX)
+		cgwb_kill(wb);
 
 	while (!list_empty(&bdi->wb_list)) {
 		wb = list_first_entry(&bdi->wb_list, struct bdi_writeback,
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
