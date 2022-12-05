From: Yu Kuai <yukuai1@huaweicloud.com>
Subject: Re: [PATCH -next v2 8/9] block: fix null-pointer dereference in
 ioc_pd_init
Date: Mon, 5 Dec 2022 17:32:17 +0800
Message-ID: <96487803-12cc-a694-0099-784106596fd1@huaweicloud.com>
References: <20221130132156.2836184-1-linan122@huawei.com>
 <20221130132156.2836184-9-linan122@huawei.com>
 <Y4fCE7XxcpDfWyDJ@slm.duckdns.org>
 <9ca2b7ab-7fd3-a9a3-12a6-021a78886b54@huaweicloud.com>
 <Y4h94m8QMPtS4xJV@slm.duckdns.org>
 <431dcb3f-4572-7fd0-9e5d-90b6c34d577c@huaweicloud.com>
 <Y4iCbuALBBGLODWI@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <Y4iCbuALBBGLODWI@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>, Christoph Hellwig <hch@infradead.org>
Cc: Li Nan <linan122@huawei.com>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com, "yukuai (C)" <yukuai3@huawei.com>

Hi, Tejun!

While reviewing rq_qos code, I found that there are some other possible
defects:

1) queue_lock is held to protect rq_qos_add() and rq_qos_del(), whlie
it's not held to protect rq_qos_exit(), which is absolutely not safe
because they can be called concurrently by configuring iocost and
removing device.
I'm thinking about holding the lock to fetch the list and reset
q->rq_qos first:

diff --git a/block/blk-rq-qos.c b/block/blk-rq-qos.c
index 88f0fe7dcf54..271ad65eebd9 100644
--- a/block/blk-rq-qos.c
+++ b/block/blk-rq-qos.c
@@ -288,9 +288,15 @@ void rq_qos_wait(struct rq_wait *rqw, void 
*private_data,

  void rq_qos_exit(struct request_queue *q)
  {
-       while (q->rq_qos) {
-               struct rq_qos *rqos = q->rq_qos;
-               q->rq_qos = rqos->next;
+       struct rq_qos *rqos;
+
+       spin_lock_irq(&q->queue_lock);
+       rqos = q->rq_qos;
+       q->rq_qos = NULL;
+       spin_unlock_irq(&q->queue_lock);
+
+       while (rqos) {
                 rqos->ops->exit(rqos);
+               rqos = rqos->next;
         }
  }

2) rq_qos_add() can still succeed after rq_qos_exit() is done, which
will cause memory leak. Hence a checking is required beforing adding
to q->rq_qos. I'm thinking about flag QUEUE_FLAG_DYING first, but the
flag will not set if disk state is not marked GD_OWNS_QUEUE. Since
blk_unregister_queue() is called before rq_qos_exit(), use the queue
flag QUEUE_FLAG_REGISTERED should be OK.

For the current problem that device can be removed while initializing
, I'm thinking about some possible solutions:

Since bfq is initialized in elevator initialization, and others are
in queue initialization, such problem is only possible in iocost, hence
it make sense to fix it in iocost:

1) use open mutex to prevet concurrency, however, this will cause
that configuring iocost will block some other operations that is relied
on open_mutex.

@@ -2889,7 +2889,15 @@ static int blk_iocost_init(struct gendisk *disk)
         if (ret)
                 goto err_free_ioc;

+       mutex_lock(&disk->open_mutex);
+       if (!disk_live(disk)) {
+               mutex_unlock(&disk->open_mutex);
+               ret = -ENODEV;
+               goto err_del_qos;
+       }
+
         ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
+       mutex_unlock(&disk->open_mutex);
         if (ret)
                 goto err_del_qos;

2) like 1), the difference is that define a new mutex just in iocst.

3) Or is it better to fix it in the higher level? For example:
add a new restriction that blkcg_deactivate_policy() should be called
with blkcg_activate_policy() in pairs, and blkcg_deactivate_policy()
will wait for blkcg_activate_policy() to finish. Something like:

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index ef4fef1af909..6266f702157f 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1410,7 +1410,7 @@ int blkcg_activate_policy(struct request_queue *q,
         struct blkcg_gq *blkg, *pinned_blkg = NULL;
         int ret;

-       if (blkcg_policy_enabled(q, pol))
+       if (WARN_ON_ONCE(blkcg_policy_enabled(q, pol)))
                 return 0;

         if (queue_is_mq(q))
@@ -1477,6 +1477,8 @@ int blkcg_activate_policy(struct request_queue *q,
                 blkg_put(pinned_blkg);
         if (pd_prealloc)
                 pol->pd_free_fn(pd_prealloc);
+       if (!ret)
+               wake_up(q->policy_waitq);
         return ret;

  enomem:
@@ -1512,7 +1514,7 @@ void blkcg_deactivate_policy(struct request_queue *q,
         struct blkcg_gq *blkg;

         if (!blkcg_policy_enabled(q, pol))
-               return;
+               wait_event(q->policy_waitq, blkcg_policy_enabled(q, pol));
    wait_event(q->xxx, blkcg_policy_enabled(q, pol));

