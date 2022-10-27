From: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH v2 04/31] timers: block: Use del_timer_shutdown()
 before freeing timer
Date: Thu, 27 Oct 2022 11:19:44 -0400
Message-ID: <20221027111944.39b3a80c@gandalf.local.home>
References: <20221027150525.753064657@goodmis.org>
        <20221027150925.819019339@goodmis.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20221027150925.819019339@goodmis.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Stephen Boyd <sboyd@kernel.org>, Guenter Roeck <linux@roeck-us.net>, Philipp Reisner <philipp.reisner@linbit.com>, Lars Ellenberg <lars.ellenberg@linbit.com>, Christoph =?UTF-8?B?QsO2aG13YWxk?= =?UTF-8?B?ZXI=?= <christoph.boehmwalder@linbit.com>, Jens Axboe <axboe@kernel.dk>, drbd-dev@lists.linbit.com, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

[
  quilt mail --send still can't handle unicode characters.
    Here's the patch again
]

From: "Steven Rostedt (Google)" <rostedt@goodmis.org>

Before a timer is freed, del_timer_shutdown() must be called.

Link: https://lore.kernel.org/all/20220407161745.7d6754b3@gandalf.local.hom=
e/

Cc: Philipp Reisner <philipp.reisner@linbit.com>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: "Christoph B=C3=B6hmwalder" <christoph.boehmwalder@linbit.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Cc: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org
Cc: linux-block@vger.kernel.org
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 block/blk-iocost.c             | 2 +-
 block/blk-iolatency.c          | 2 +-
 block/blk-stat.c               | 2 +-
 block/blk-throttle.c           | 2 +-
 block/kyber-iosched.c          | 2 +-
 drivers/block/drbd/drbd_main.c | 2 +-
 drivers/block/loop.c           | 2 +-
 drivers/block/sunvdc.c         | 2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 495396425bad..e2d4bdd3d135 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -2814,7 +2814,7 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 	ioc->running =3D IOC_STOP;
 	spin_unlock_irq(&ioc->lock);
=20
-	del_timer_sync(&ioc->timer);
+	del_timer_shutdown(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
 	kfree(ioc);
 }
diff --git a/block/blk-iolatency.c b/block/blk-iolatency.c
index 571fa95aafe9..7b61f09afedd 100644
--- a/block/blk-iolatency.c
+++ b/block/blk-iolatency.c
@@ -645,7 +645,7 @@ static void blkcg_iolatency_exit(struct rq_qos *rqos)
 {
 	struct blk_iolatency *blkiolat =3D BLKIOLATENCY(rqos);
=20
-	del_timer_sync(&blkiolat->timer);
+	del_timer_shutdown(&blkiolat->timer);
 	flush_work(&blkiolat->enable_work);
 	blkcg_deactivate_policy(rqos->q, &blkcg_policy_iolatency);
 	kfree(blkiolat);
diff --git a/block/blk-stat.c b/block/blk-stat.c
index 2ea01b5c1aca..de51db302c44 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -165,7 +165,7 @@ void blk_stat_remove_callback(struct request_queue *q,
 		blk_queue_flag_clear(QUEUE_FLAG_STATS, q);
 	spin_unlock_irqrestore(&q->stats->lock, flags);
=20
-	del_timer_sync(&cb->timer);
+	del_timer_shutdown(&cb->timer);
 }
=20
 static void blk_stat_free_callback_rcu(struct rcu_head *head)
diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 847721dc2b2b..95af99f24137 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -490,7 +490,7 @@ static void throtl_pd_free(struct blkg_policy_data *pd)
 {
 	struct throtl_grp *tg =3D pd_to_tg(pd);
=20
-	del_timer_sync(&tg->service_queue.pending_timer);
+	del_timer_shutdown(&tg->service_queue.pending_timer);
 	blkg_rwstat_exit(&tg->stat_bytes);
 	blkg_rwstat_exit(&tg->stat_ios);
 	kfree(tg);
diff --git a/block/kyber-iosched.c b/block/kyber-iosched.c
index b05357bced99..59a444a47ba3 100644
--- a/block/kyber-iosched.c
+++ b/block/kyber-iosched.c
@@ -434,7 +434,7 @@ static void kyber_exit_sched(struct elevator_queue *e)
 	struct kyber_queue_data *kqd =3D e->elevator_data;
 	int i;
=20
-	del_timer_sync(&kqd->timer);
+	del_timer_shutdown(&kqd->timer);
 	blk_stat_disable_accounting(kqd->q);
=20
 	for (i =3D 0; i < KYBER_NUM_DOMAINS; i++)
diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index f3e4db16fd07..3f574f3769c3 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2184,7 +2184,7 @@ void drbd_destroy_device(struct kref *kref)
 	struct drbd_resource *resource =3D device->resource;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
=20
-	del_timer_sync(&device->request_timer);
+	del_timer_shutdown(&device->request_timer);
=20
 	/* paranoia asserts */
 	D_ASSERT(device, device->open_cnt =3D=3D 0);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ad92192c7d61..d134a5fd4ae7 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1755,7 +1755,7 @@ static void lo_free_disk(struct gendisk *disk)
 	if (lo->workqueue)
 		destroy_workqueue(lo->workqueue);
 	loop_free_idle_workers(lo, true);
-	del_timer_sync(&lo->timer);
+	del_timer_shutdown(&lo->timer);
 	mutex_destroy(&lo->lo_mutex);
 	kfree(lo);
 }
diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
index fb855da971ee..9868937a9602 100644
--- a/drivers/block/sunvdc.c
+++ b/drivers/block/sunvdc.c
@@ -1067,7 +1067,7 @@ static void vdc_port_remove(struct vio_dev *vdev)
=20
 		flush_work(&port->ldc_reset_work);
 		cancel_delayed_work_sync(&port->ldc_reset_timer_work);
-		del_timer_sync(&port->vio.timer);
+		del_timer_shutdown(&port->vio.timer);
=20
 		del_gendisk(port->disk);
 		put_disk(port->disk);
--=20
2.35.1
