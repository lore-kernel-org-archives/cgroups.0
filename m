From: Li Jinlin <lijinlin3@huawei.com>
Subject: [PATCH v2] blk-iocost: fix shift-out-of-bounds in iocg_hick_delay()
Date: Mon, 28 Nov 2022 11:04:13 +0800
Message-ID: <20221128030413.882998-1-lijinlin3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <linux-block-owner@vger.kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, josef@toxicpanda.com, axboe@kernel.dk
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, liuzhiqiang26@huawei.com

We got the following UBSAN report:
====================================================================
UBSAN: shift-out-of-bounds in block/blk-iocost.c:1294:23
shift exponent 18446744073709 is too large for 64-bit type ......
CPU: 1 PID: 1088217 Comm: fsstress Kdump: loaded Not tainted ......
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996) ......
Call Trace:
 dump_stack+0x9c/0xd3
 ubsan_epilogue+0xa/0x4e
 __ubsan_handle_shift_out_of_bounds.cold+0x87/0x137
 iocg_kick_delay.cold+0x18/0x60
 ioc_rqos_throttle+0x7f8/0x870
 __rq_qos_throttle+0x40/0x60
 blk_mq_submit_bio+0x24d/0xd60
 __submit_bio_noacct_mq+0x10b/0x270
 submit_bio_noacct+0x13d/0x150
 submit_bio+0xbf/0x280
 submit_bh_wbc+0x3aa/0x450
 ext4_read_bh_nowait+0xdb/0x180 [ext4]
 ext4_read_bh_lock+0x6d/0x90 [ext4]
 ext4_bread_batch+0x24c/0x2e0 [ext4]
 __ext4_find_entry+0x2d2/0x880 [ext4]
 ext4_lookup.part.0+0xbf/0x370 [ext4]
 ext4_lookup+0x3e/0x60 [ext4]
 lookup_open.isra.0+0x343/0x630
 open_last_lookups+0x1f2/0x750
 path_openat+0x133/0x330
 do_filp_open+0x122/0x270
 do_sys_openat2+0x3a8/0x550
 __x64_sys_creat+0xae/0xe0
 do_syscall_64+0x33/0x40
 entry_SYSCALL_64_after_hwframe+0x61/0xc6
===================================================================

The result of E1 >> E2 is E1 right-shifted E2 bit positions. From the
report, we know E2 is greater than the width of E1. In the C99 standard,
if the value of the E2 is negative or is greater than or equal to the
width of E1, the behavior is undefined.

In the actual test, if the E2 is greater than or equal to the width of
E1, the result of E1 >> E2 is E1 >> (E2 % E1width), which is not what we
want.

So letting the value of the right operand be less than the width of u64
in this right shift expression.

Signed-off-by: Li Jinlin <lijinlin3@huawei.com>
---
v2:
Use min_t instead of min to resolve W=1 build warning.
---
 block/blk-iocost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index 07c1a31dd495..0dfc2c82b7d9 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -1332,7 +1332,8 @@ static bool iocg_kick_delay(struct ioc_gq *iocg, struct ioc_now *now)
 	/* calculate the current delay in effect - 1/2 every second */
 	tdelta = now->now - iocg->delay_at;
 	if (iocg->delay)
-		delay = iocg->delay >> div64_u64(tdelta, USEC_PER_SEC);
+		delay = iocg->delay >>
+			min_t(u64, div64_u64(tdelta, USEC_PER_SEC), 63);
 	else
 		delay = 0;
 
-- 
2.30.2

