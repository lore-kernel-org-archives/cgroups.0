From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 20/24] block: RCU free request_queue
Date: Fri, 28 Dec 2012 12:35:42 -0800
Message-ID: <1356726946-26037-21-git-send-email-tj@kernel.org>
References: <1356726946-26037-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=i/93il11faUSnsK8DEBplVXbE9HMVTXGb6y7RonU5AM=;
        b=h6KpriW289XsbJY67xloy9HfHZAAhlI6fkuR2hGnSNPDbpiK9OMXfEHDVZdtVZtveB
         HQEPKkmcgoTnVX7gyV1ljvy1uMZYXgHVQGBjn4G3iN2F1opj1WtIrJPDGMnrakiMhHRO
         UnZOlCtH16yCVopbw/08E8pytm7cKfegP3G9l+ypvxhY1QjLDNIEZhlmJZJwgi8maUof
         koitEW982CnTOY7uB5kWEHL4ZtJVYadpC7YaRwCe/lvreIgVMjKMfnt/L9BeGhhMFHRt
         ukTlvx+eiZALjUX6rNqK/0F/btSOAgEYQVj9fANfttz3Bp2KrNfSyaxwh6GZQoZK5ekw
         cC2w==
In-Reply-To: <1356726946-26037-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, axboe@kernel.dk, vgoyal@redhat.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, ctalbott@google.com, rni@google.com, Tejun Heo <tj@kernel.org>

RCU free request_queue so that blkcg_gq->q can be dereferenced under
RCU lock.  This will be used to implement hierarchical stats.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-sysfs.c      | 9 ++++++++-
 include/linux/blkdev.h | 2 ++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 7881477..6206a93 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -497,6 +497,13 @@ queue_attr_store(struct kobject *kobj, struct attribute *attr,
 	return res;
 }
 
+static void blk_free_queue_rcu(struct rcu_head *rcu_head)
+{
+	struct request_queue *q = container_of(rcu_head, struct request_queue,
+					       rcu_head);
+	kmem_cache_free(blk_requestq_cachep, q);
+}
+
 /**
  * blk_release_queue: - release a &struct request_queue when it is no longer needed
  * @kobj:    the kobj belonging to the request queue to be released
@@ -538,7 +545,7 @@ static void blk_release_queue(struct kobject *kobj)
 	bdi_destroy(&q->backing_dev_info);
 
 	ida_simple_remove(&blk_queue_ida, q->id);
-	kmem_cache_free(blk_requestq_cachep, q);
+	call_rcu(&q->rcu_head, blk_free_queue_rcu);
 }
 
 static const struct sysfs_ops queue_sysfs_ops = {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index f94bc83..406343c 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -19,6 +19,7 @@
 #include <linux/gfp.h>
 #include <linux/bsg.h>
 #include <linux/smp.h>
+#include <linux/rcupdate.h>
 
 #include <asm/scatterlist.h>
 
@@ -437,6 +438,7 @@ struct request_queue {
 	/* Throttle data */
 	struct throtl_data *td;
 #endif
+	struct rcu_head		rcu_head;
 };
 
 #define QUEUE_FLAG_QUEUED	1	/* uses generic tag queueing */
-- 
1.8.0.2
