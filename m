From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: Re: [External] Re: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Sat, 8 Apr 2023 22:31:20 +0800
Message-ID: <c36f5f02-90e1-fef0-481e-828ced303a8a@bytedance.com>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
 <cab869b1-1cba-5698-55eb-a93d0596c869@acm.org>
 <1a64eaea-50ea-f273-b0a1-a6eb8483beac@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1680964287;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S/+TATq1pEgWC5XiTeJPsNxYfIUZee5yuk6ERjQ9uh0=;
        b=RV/DzU4v1M18hV8JoR6WqBlV7Q/Qe3lm4A+EgpOUtUNKLAQ5BSmMwR9vNVk8jGPw8m
         Vvax3yNYv+SOYHZV85aabqs42NfBonLDMgxPdXwliVL6x8Q7wp/r8ZBHgbhBJ++grwKN
         ZIXrTMPyXBVW5b5a48s9bQGKwjF+iUYqXjygvgkkWDWw5c1ocDnzg6ohHXRecHSynC1O
         wdvdQ1sN42QJZxCoj+pYG+AI3eJO2ui7CbsUby50Til5swcoNTB2mbya/R6/VFyvdS0w
         nrPHkx4ajNhPmFDTHpAz0FRmJuAvLOx45u1qtIm48jUJ8JLx4aquOzNPaSTXNk5Ucu8Q
         U5hQ==
Content-Language: en-US
In-Reply-To: <1a64eaea-50ea-f273-b0a1-a6eb8483beac@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Bart Van Assche <bvanassche@acm.org>
Cc: axboe@kernel.dk, tj@kernel.org, paolo.valente@linaro.org, josef@toxicpanda.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 2023/4/8 11:37, Chengming Zhou wrote:
> On 2023/4/8 02:41, Bart Van Assche wrote:
>> On 4/6/23 07:50, Chengming Zhou wrote:
>>> These are some cleanup patches of blk-cgroup. Thanks for review.
>>
>> With these patches applied, my kernel test VM crashes during boot. The following crash disappears if I revert these patches:
> 
> Thanks for the report.
> I will try to reproduce it first and look into this today.

Hi Bart,

I tried a few times to reproduce it, but still can't for now. Do you mind to share more details?

I don't know how to specify bfq as the default scheduler for the device, since "elevator="
is not working anymore. Do you use something like sysfsutils to set sysfs config during boot?

So I just boot the qemu VM, set bfq as the scheduler for the root device, run "blkid", but no bug shows.

Then I use sysfsutils to set bfq as the default scheduler during reboot, the VM still no bug shows.

I will continue to look into this issue and review related code.

BTW, my codebase is e134c93f788f ("Add linux-next specific files for 20230406") with these three patches applied.

Thanks.

> 
>>
>> BUG: KASAN: null-ptr-deref in bio_associate_blkg_from_css+0x83/0x240
>> Read of size 8 at addr 0000000000000518 by task blkid/5885
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.0-debian-1.16.0-5 04/01/2014
>> Call Trace:
>>  dump_stack_lvl+0x4a/0x80
>>  print_report+0x21e/0x260
>>  kasan_report+0xc2/0xf0
>>  __asan_load8+0x69/0x90
>>  bio_associate_blkg_from_css+0x83/0x240
>>  bfq_bio_bfqg+0xce/0x120 [bfq]
>>  bfq_bic_update_cgroup+0x2f/0x3c0 [bfq]
>>  bfq_init_rq+0x1e8/0xb10 [bfq]
>>  bfq_insert_request.isra.0+0xa3/0x420 [bfq]
>>  bfq_insert_requests+0xca/0xf0 [bfq]
>>  blk_mq_dispatch_rq_list+0x4c0/0xb00
>>  __blk_mq_sched_dispatch_requests+0x15e/0x200
>>  blk_mq_sched_dispatch_requests+0x8b/0xc0
>>  __blk_mq_run_hw_queue+0x3ff/0x500
>>  __blk_mq_delay_run_hw_queue+0x23a/0x300
>>  blk_mq_run_hw_queue+0x14e/0x350
>>  blk_mq_sched_insert_request+0x181/0x1f0
>>  blk_execute_rq+0xf4/0x300
>>  scsi_execute_cmd+0x23e/0x350
>>  sr_do_ioctl+0x173/0x3d0 [sr_mod]
>>  sr_packet+0x60/0x90 [sr_mod]
>>  cdrom_get_track_info.constprop.0+0x125/0x170 [cdrom]
>>  cdrom_get_last_written+0x1d4/0x2d0 [cdrom]
>>  mmc_ioctl_cdrom_last_written+0x85/0x120 [cdrom]
>>  mmc_ioctl+0x10b/0x1d0 [cdrom]
>>  cdrom_ioctl+0xa66/0x1270 [cdrom]
>>  sr_block_ioctl+0xee/0x130 [sr_mod]
>>  blkdev_ioctl+0x1bb/0x3f0
>>  __x64_sys_ioctl+0xc7/0xe0
>>  do_syscall_64+0x34/0x80
>>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>>
>> Bart.
