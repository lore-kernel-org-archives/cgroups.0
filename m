From: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Subject: [PATCH v2 2/2] blk-iocost: add refcounting for ioc
Date: Tue, 27 Dec 2022 20:55:02 +0800
Message-ID: <20221227125502.541931-3-yukuai1@huaweicloud.com>
References: <20221227125502.541931-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20221227125502.541931-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Our test found the following problem in kernel 5.10, and the same problem
should exist in mainline:

BUG: KASAN: use-after-free in _raw_spin_lock_irqsave+0x71/0xe0
Write of size 4 at addr ffff8881432000e0 by task swapper/4/0
...
Call Trace:
 <IRQ>
 dump_stack+0x9c/0xd3
 print_address_description.constprop.0+0x19/0x170
 __kasan_report.cold+0x6c/0x84
 kasan_report+0x3a/0x50
 check_memory_region+0xfd/0x1f0
 _raw_spin_lock_irqsave+0x71/0xe0
 ioc_pd_free+0x9d/0x250
 blkg_free.part.0+0x80/0x100
 __blkg_release+0xf3/0x1c0
 rcu_do_batch+0x292/0x700
 rcu_core+0x270/0x2d0
 __do_softirq+0xfd/0x402
  </IRQ>
 asm_call_irq_on_stack+0x12/0x20
 do_softirq_own_stack+0x37/0x50
 irq_exit_rcu+0x134/0x1a0
 sysvec_apic_timer_interrupt+0x36/0x80
 asm_sysvec_apic_timer_interrupt+0x12/0x20

 Freed by task 57:
 kfree+0xba/0x680
 rq_qos_exit+0x5a/0x80
 blk_cleanup_queue+0xce/0x1a0
 virtblk_remove+0x77/0x130 [virtio_blk]
 virtio_dev_remove+0x56/0xe0
 __device_release_driver+0x2ba/0x450
 device_release_driver+0x29/0x40
 bus_remove_device+0x1d8/0x2c0
 device_del+0x333/0x7e0
 device_unregister+0x27/0x90
 unregister_virtio_device+0x22/0x40
 virtio_pci_remove+0x53/0xb0
 pci_device_remove+0x7a/0x130
 __device_release_driver+0x2ba/0x450
 device_release_driver+0x29/0x40
 pci_stop_bus_device+0xcf/0x100
 pci_stop_and_remove_bus_device+0x16/0x20
 disable_slot+0xa1/0x110
 acpiphp_disable_and_eject_slot+0x35/0xe0
 hotplug_event+0x1b8/0x3c0
 acpiphp_hotplug_notify+0x37/0x70
 acpi_device_hotplug+0xee/0x320
 acpi_hotplug_work_fn+0x69/0x80
 process_one_work+0x3c5/0x730
 worker_thread+0x93/0x650
 kthread+0x1ba/0x210
 ret_from_fork+0x22/0x30

Root cause is that blkg_free() can be asynchronously, and it can race
with delete device:

T1			T2		T3
//delete device
del_gendisk
 bdi_unregister
  bdi_remove_from_list
   synchronize_rcu_expedited

			//rmdir cgroup
			blkcg_destroy_blkgs
			 blkg_destroy
			  percpu_ref_kill
			   blkg_release
			    call_rcu
 rq_qos_exit
  ioc_rqos_exit
   kfree(ioc)
					__blkg_release
					 blkg_free
					  blkg_free_workfn
					   pd_free_fn
					    ioc_pd_free
					     spin_lock_irqsave

Fix the problem by add refcounting for ioc, and iocg will grab reference
of ioc, so that ioc won't be freed until all the iocg is exited.

Signed-off-by: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 block/blk-iocost.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 525e93e1175a..d168d3f5f78e 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -404,6 +404,7 @@ struct ioc_pcpu_stat {
 struct ioc {
 	struct rq_qos			rqos;
 
+	refcount_t			ref;
 	bool				enabled;
 
 	struct ioc_params		params;
@@ -2816,6 +2817,12 @@ static void ioc_rqos_queue_depth_changed(struct rq_qos *rqos)
 	spin_unlock_irq(&ioc->lock);
 }
 
+static void ioc_put(struct ioc *ioc)
+{
+	if (refcount_dec_and_test(&ioc->ref))
+		kfree(ioc);
+}
+
 static void ioc_rqos_exit(struct rq_qos *rqos)
 {
 	struct ioc *ioc = rqos_to_ioc(rqos);
@@ -2828,7 +2835,7 @@ static void ioc_rqos_exit(struct rq_qos *rqos)
 
 	del_timer_sync(&ioc->timer);
 	free_percpu(ioc->pcpu_stat);
-	kfree(ioc);
+	ioc_put(ioc);
 }
 
 static struct rq_qos_ops ioc_rqos_ops = {
@@ -2883,6 +2890,7 @@ static int blk_iocost_init(struct gendisk *disk)
 	ioc->period_at = ktime_to_us(ktime_get());
 	atomic64_set(&ioc->cur_period, 0);
 	atomic_set(&ioc->hweight_gen, 0);
+	refcount_set(&ioc->ref, 1);
 
 	spin_lock_irq(&ioc->lock);
 	ioc->autop_idx = AUTOP_INVALID;
@@ -2983,6 +2991,7 @@ static void iocg_put(struct ioc_gq *iocg)
 		spin_unlock_irqrestore(&ioc->lock, flags);
 
 		hrtimer_cancel(&iocg->waitq_timer);
+		ioc_put(ioc);
 	}
 
 	free_percpu(iocg->pcpu_stat);
@@ -3004,6 +3013,7 @@ static void ioc_pd_init(struct blkg_policy_data *pd)
 	ioc_now(ioc, &now);
 
 	iocg->ioc = ioc;
+	refcount_inc(&ioc->ref);
 	atomic64_set(&iocg->vtime, now.vnow);
 	atomic64_set(&iocg->done_vtime, now.vnow);
 	atomic64_set(&iocg->active_period, atomic64_read(&ioc->cur_period));
-- 
2.31.1

