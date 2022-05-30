From: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH AUTOSEL 5.18 139/159] blk-throttle: Set BIO_THROTTLED when bio has been throttled
Date: Mon, 30 May 2022 09:24:04 -0400
Message-ID: <20220530132425.1929512-139-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917443;
        bh=ycLUjmMHzdDC3CERFJqNRWnivcnpn9dj7vhSjrVVdc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cq+7Rb9JtmSMIkrtrAFXWWmuEEDMNHvsPdHLhTlOEydjewe2/keC4hkVE2lBvIGEj
         ahiA1tG+rR9rf81dgFvK1yOw7V+19aeVukVhU1+YMp0brqjHrL0VSeralgYBOUO5KT
         OowMeXRGcqdRKDbEaGwDqBBcgP052+eHfAKUmpIQQCPdvFxg75Fn/oy3z3tV/N9d56
         yBsd7wrb3+WIvKXOiZOloNu3Vv33IhFYEUDQiFqHfv+FWTVXjRupCxTXBoz0PYrorN
         sUY9zwn+JXpSZ10eQtqXS0AqHAfxJonw4JQrD73QxV45rtOgCIBV61kiJIFABKYNXg
         p66WBMq+pTzzg==
In-Reply-To: <20220530132425.1929512-1-sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Laibin Qiu <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Laibin Qiu <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

[ Upstream commit 5a011f889b4832aa80c2a872a5aade5c48d2756f ]

1.In current process, all bio will set the BIO_THROTTLED flag
after __blk_throtl_bio().

2.If bio needs to be throttled, it will start the timer and
stop submit bio directly. Bio will submit in
blk_throtl_dispatch_work_fn() when the timer expires.But in
the current process, if bio is throttled. The BIO_THROTTLED
will be set to bio after timer start. If the bio has been
completed, it may cause use-after-free blow.

BUG: KASAN: use-after-free in blk_throtl_bio+0x12f0/0x2c70
Read of size 2 at addr ffff88801b8902d4 by task fio/26380

 dump_stack+0x9b/0xce
 print_address_description.constprop.6+0x3e/0x60
 kasan_report.cold.9+0x22/0x3a
 blk_throtl_bio+0x12f0/0x2c70
 submit_bio_checks+0x701/0x1550
 submit_bio_noacct+0x83/0xc80
 submit_bio+0xa7/0x330
 mpage_readahead+0x380/0x500
 read_pages+0x1c1/0xbf0
 page_cache_ra_unbounded+0x471/0x6f0
 do_page_cache_ra+0xda/0x110
 ondemand_readahead+0x442/0xae0
 page_cache_async_ra+0x210/0x300
 generic_file_buffered_read+0x4d9/0x2130
 generic_file_read_iter+0x315/0x490
 blkdev_read_iter+0x113/0x1b0
 aio_read+0x2ad/0x450
 io_submit_one+0xc8e/0x1d60
 __se_sys_io_submit+0x125/0x350
 do_syscall_64+0x2d/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Allocated by task 26380:
 kasan_save_stack+0x19/0x40
 __kasan_kmalloc.constprop.2+0xc1/0xd0
 kmem_cache_alloc+0x146/0x440
 mempool_alloc+0x125/0x2f0
 bio_alloc_bioset+0x353/0x590
 mpage_alloc+0x3b/0x240
 do_mpage_readpage+0xddf/0x1ef0
 mpage_readahead+0x264/0x500
 read_pages+0x1c1/0xbf0
 page_cache_ra_unbounded+0x471/0x6f0
 do_page_cache_ra+0xda/0x110
 ondemand_readahead+0x442/0xae0
 page_cache_async_ra+0x210/0x300
 generic_file_buffered_read+0x4d9/0x2130
 generic_file_read_iter+0x315/0x490
 blkdev_read_iter+0x113/0x1b0
 aio_read+0x2ad/0x450
 io_submit_one+0xc8e/0x1d60
 __se_sys_io_submit+0x125/0x350
 do_syscall_64+0x2d/0x40
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Freed by task 0:
 kasan_save_stack+0x19/0x40
 kasan_set_track+0x1c/0x30
 kasan_set_free_info+0x1b/0x30
 __kasan_slab_free+0x111/0x160
 kmem_cache_free+0x94/0x460
 mempool_free+0xd6/0x320
 bio_free+0xe0/0x130
 bio_put+0xab/0xe0
 bio_endio+0x3a6/0x5d0
 blk_update_request+0x590/0x1370
 scsi_end_request+0x7d/0x400
 scsi_io_completion+0x1aa/0xe50
 scsi_softirq_done+0x11b/0x240
 blk_mq_complete_request+0xd4/0x120
 scsi_mq_done+0xf0/0x200
 virtscsi_vq_done+0xbc/0x150
 vring_interrupt+0x179/0x390
 __handle_irq_event_percpu+0xf7/0x490
 handle_irq_event_percpu+0x7b/0x160
 handle_irq_event+0xcc/0x170
 handle_edge_irq+0x215/0xb20
 common_interrupt+0x60/0x120
 asm_common_interrupt+0x1e/0x40

Fix this by move BIO_THROTTLED set into the queue_lock.

Signed-off-by: Laibin Qiu <qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Link: https://lore.kernel.org/r/20220301123919.2381579-1-qiulaibin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Signed-off-by: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Signed-off-by: Sasha Levin <sashal-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-throttle.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-throttle.c b/block/blk-throttle.c
index 469c483719be..5c5f2741a95f 100644
--- a/block/blk-throttle.c
+++ b/block/blk-throttle.c
@@ -2189,13 +2189,14 @@ bool __blk_throtl_bio(struct bio *bio)
 	}
 
 out_unlock:
-	spin_unlock_irq(&q->queue_lock);
 	bio_set_flag(bio, BIO_THROTTLED);
 
 #ifdef CONFIG_BLK_DEV_THROTTLING_LOW
 	if (throttled || !td->track_bio_latency)
 		bio->bi_issue.value |= BIO_ISSUE_THROTL_SKIP_LATENCY;
 #endif
+	spin_unlock_irq(&q->queue_lock);
+
 	rcu_read_unlock();
 	return throttled;
 }
-- 
2.35.1

