From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Fri, 7 Apr 2023 11:41:41 -0700
Message-ID: <cab869b1-1cba-5698-55eb-a93d0596c869@acm.org>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <20230406145050.49914-1-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 4/6/23 07:50, Chengming Zhou wrote:
> These are some cleanup patches of blk-cgroup. Thanks for review.

With these patches applied, my kernel test VM crashes during boot. The 
following crash disappears if I revert these patches:

BUG: KASAN: null-ptr-deref in bio_associate_blkg_from_css+0x83/0x240
Read of size 8 at addr 0000000000000518 by task blkid/5885
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.16.0-debian-1.16.0-5 04/01/2014
Call Trace:
  dump_stack_lvl+0x4a/0x80
  print_report+0x21e/0x260
  kasan_report+0xc2/0xf0
  __asan_load8+0x69/0x90
  bio_associate_blkg_from_css+0x83/0x240
  bfq_bio_bfqg+0xce/0x120 [bfq]
  bfq_bic_update_cgroup+0x2f/0x3c0 [bfq]
  bfq_init_rq+0x1e8/0xb10 [bfq]
  bfq_insert_request.isra.0+0xa3/0x420 [bfq]
  bfq_insert_requests+0xca/0xf0 [bfq]
  blk_mq_dispatch_rq_list+0x4c0/0xb00
  __blk_mq_sched_dispatch_requests+0x15e/0x200
  blk_mq_sched_dispatch_requests+0x8b/0xc0
  __blk_mq_run_hw_queue+0x3ff/0x500
  __blk_mq_delay_run_hw_queue+0x23a/0x300
  blk_mq_run_hw_queue+0x14e/0x350
  blk_mq_sched_insert_request+0x181/0x1f0
  blk_execute_rq+0xf4/0x300
  scsi_execute_cmd+0x23e/0x350
  sr_do_ioctl+0x173/0x3d0 [sr_mod]
  sr_packet+0x60/0x90 [sr_mod]
  cdrom_get_track_info.constprop.0+0x125/0x170 [cdrom]
  cdrom_get_last_written+0x1d4/0x2d0 [cdrom]
  mmc_ioctl_cdrom_last_written+0x85/0x120 [cdrom]
  mmc_ioctl+0x10b/0x1d0 [cdrom]
  cdrom_ioctl+0xa66/0x1270 [cdrom]
  sr_block_ioctl+0xee/0x130 [sr_mod]
  blkdev_ioctl+0x1bb/0x3f0
  __x64_sys_ioctl+0xc7/0xe0
  do_syscall_64+0x34/0x80
  entry_SYSCALL_64_after_hwframe+0x46/0xb0

Bart.
