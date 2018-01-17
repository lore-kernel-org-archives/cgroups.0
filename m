From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 80/99] blk-ioc: Convert to XArray
Date: Wed, 17 Jan 2018 12:21:44 -0800
Message-ID: <20180117202203.19756-81-willy@infradead.org>
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
 bh=LeHoKsS2mqnMzdAdH0WdGATRSD8SnSLILL861J9jbi0=; b=cXIIlJtQLbI/sKN8V0XvruKv/h
 ncpI+eGT/V6YtnhO5qYN2XC4gylh+Q432tT4QaYs9Yl6PrGL7o00CM2+HS1XNNGISKQeRCkVFmllx
 PrdAD6TNf/hh1bv/e8COGZfohSEpLhPz+Ywy7ZAbvVW/CNhpwrY0O70/AQlBV+yZ/Y+4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=LeHoKsS2mqnMzdAdH0WdGATRSD8SnSLILL861J9jbi0=; b=OgCyqgXp7bWbMBM0yQ1RGtOd7v
 22T5PvP0Lu4HYXCh6DZrprryxF+rMMegIYrjIBk2j3K/B3l3ptXoGFtcl+ICcxv5QHueWeHaqU1IW
 +gaRnwq7MnOXoydjPKgnH8QBkTjGw6jbUF27rNkhdOTegEh61eFyLP0KrOBjkTVC4vLg=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=LeHoKsS2mqnMzdAdH0WdGATRSD8SnSLILL861J9jbi0=; b=myKklxZiYih8FoupgRJMN+TVX
 G3bOydgVs68Y7q4A44g3t93nhAycTntCu8JwxL0K73P10a8FxBeYvEnvVxUljlOsbk9CmAGefPbAi
 h52Ool8V4J1FKnuSkBnr9hpmARkKtI9mFoEOt0VxF39cArPg4NNIT8A22lfHkVadCpJsx9WZlJidO
 5xnSN46JcGfVY1k1GQmbxCrjb0gicAPllWn4hqBSmYNnaEEj+OSuTvobsfcjZI/mDH9yYaWq6mZf2
 AdXSuemrY8Z7bEtfE0vcfmsKbSyq1yo7adO5HRpgmC2Wtx1B7MgQQ6kysgJhKthU7dGRB06gsabvn
 s4ViKYbmQ==;
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

Skip converting the lock to use xa_lock; I think this code can live with
the double-locking.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 block/blk-ioc.c           | 13 +++++++------
 include/linux/iocontext.h |  6 +++---
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/blk-ioc.c b/block/blk-ioc.c
index f23311e4b201..baf83c8ac503 100644
--- a/block/blk-ioc.c
+++ b/block/blk-ioc.c
@@ -68,7 +68,7 @@ static void ioc_destroy_icq(struct io_cq *icq)
 
 	lockdep_assert_held(&ioc->lock);
 
-	radix_tree_delete(&ioc->icq_tree, icq->q->id);
+	xa_erase(&ioc->icq_array, icq->q->id);
 	hlist_del_init(&icq->ioc_node);
 	list_del_init(&icq->q_node);
 
@@ -278,7 +278,7 @@ int create_task_io_context(struct task_struct *task, gfp_t gfp_flags, int node)
 	atomic_set(&ioc->nr_tasks, 1);
 	atomic_set(&ioc->active_ref, 1);
 	spin_lock_init(&ioc->lock);
-	INIT_RADIX_TREE(&ioc->icq_tree, GFP_ATOMIC | __GFP_HIGH);
+	xa_init_flags(&ioc->icq_array, XA_FLAGS_LOCK_IRQ);
 	INIT_HLIST_HEAD(&ioc->icq_list);
 	INIT_WORK(&ioc->release_work, ioc_release_fn);
 
@@ -363,7 +363,7 @@ struct io_cq *ioc_lookup_icq(struct io_context *ioc, struct request_queue *q)
 	if (icq && icq->q == q)
 		goto out;
 
-	icq = radix_tree_lookup(&ioc->icq_tree, q->id);
+	icq = xa_load(&ioc->icq_array, q->id);
 	if (icq && icq->q == q)
 		rcu_assign_pointer(ioc->icq_hint, icq);	/* allowed to race */
 	else
@@ -398,7 +398,7 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 	if (!icq)
 		return NULL;
 
-	if (radix_tree_maybe_preload(gfp_mask) < 0) {
+	if (xa_reserve(&ioc->icq_array, q->id, gfp_mask)) {
 		kmem_cache_free(et->icq_cache, icq);
 		return NULL;
 	}
@@ -412,7 +412,8 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 	spin_lock_irq(q->queue_lock);
 	spin_lock(&ioc->lock);
 
-	if (likely(!radix_tree_insert(&ioc->icq_tree, q->id, icq))) {
+	if (likely(!xa_store(&ioc->icq_array, q->id, icq,
+						GFP_ATOMIC | __GFP_HIGH))) {
 		hlist_add_head(&icq->ioc_node, &ioc->icq_list);
 		list_add(&icq->q_node, &q->icq_list);
 		if (et->uses_mq && et->ops.mq.init_icq)
@@ -421,6 +422,7 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 			et->ops.sq.elevator_init_icq_fn(icq);
 	} else {
 		kmem_cache_free(et->icq_cache, icq);
+		xa_erase(&ioc->icq_array, q->id);
 		icq = ioc_lookup_icq(ioc, q);
 		if (!icq)
 			printk(KERN_ERR "cfq: icq link failed!\n");
@@ -428,7 +430,6 @@ struct io_cq *ioc_create_icq(struct io_context *ioc, struct request_queue *q,
 
 	spin_unlock(&ioc->lock);
 	spin_unlock_irq(q->queue_lock);
-	radix_tree_preload_end();
 	return icq;
 }
 
diff --git a/include/linux/iocontext.h b/include/linux/iocontext.h
index dba15ca8e60b..e16224f70084 100644
--- a/include/linux/iocontext.h
+++ b/include/linux/iocontext.h
@@ -2,9 +2,9 @@
 #ifndef IOCONTEXT_H
 #define IOCONTEXT_H
 
-#include <linux/radix-tree.h>
 #include <linux/rcupdate.h>
 #include <linux/workqueue.h>
+#include <linux/xarray.h>
 
 enum {
 	ICQ_EXITED		= 1 << 2,
@@ -56,7 +56,7 @@ enum {
  * - ioc->icq_list and icq->ioc_node are protected by ioc lock.
  *   q->icq_list and icq->q_node by q lock.
  *
- * - ioc->icq_tree and ioc->icq_hint are protected by ioc lock, while icq
+ * - ioc->icq_array and ioc->icq_hint are protected by ioc lock, while icq
  *   itself is protected by q lock.  However, both the indexes and icq
  *   itself are also RCU managed and lookup can be performed holding only
  *   the q lock.
@@ -111,7 +111,7 @@ struct io_context {
 	int nr_batch_requests;     /* Number of requests left in the batch */
 	unsigned long last_waited; /* Time last woken after wait for request */
 
-	struct radix_tree_root	icq_tree;
+	struct xarray		icq_array;
 	struct io_cq __rcu	*icq_hint;
 	struct hlist_head	icq_list;
 
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
