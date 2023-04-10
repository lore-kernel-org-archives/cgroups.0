From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH v2 0/3] blk-cgroup: some cleanup
Date: Mon, 10 Apr 2023 11:47:34 -0700
Message-ID: <8651fa1f-7f50-03c6-cd85-e61aa44d4927@acm.org>
References: <20230406145050.49914-1-zhouchengming@bytedance.com>
 <cab869b1-1cba-5698-55eb-a93d0596c869@acm.org>
 <d23a6891-96f0-2ee0-70c7-869123d85362@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
In-Reply-To: <d23a6891-96f0-2ee0-70c7-869123d85362-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 4/9/23 18:57, Yu Kuai wrote:
> Hi, Bart
> 
> 在 2023/04/08 2:41, Bart Van Assche 写道:
>> On 4/6/23 07:50, Chengming Zhou wrote:
>>> These are some cleanup patches of blk-cgroup. Thanks for review.
>>
>> With these patches applied, my kernel test VM crashes during boot. The 
>> following crash disappears if I revert these patches:
>>
>> BUG: KASAN: null-ptr-deref in bio_associate_blkg_from_css+0x83/0x240
>> Read of size 8 at addr 0000000000000518 by task blkid/5885
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
>> 1.16.0-debian-1.16.0-5 04/01/2014
>> Call Trace:
>>   dump_stack_lvl+0x4a/0x80
>>   print_report+0x21e/0x260
>>   kasan_report+0xc2/0xf0
>>   __asan_load8+0x69/0x90
>>   bio_associate_blkg_from_css+0x83/0x240
>>   bfq_bio_bfqg+0xce/0x120 [bfq]
>>   bfq_bic_update_cgroup+0x2f/0x3c0 [bfq]
>>   bfq_init_rq+0x1e8/0xb10 [bfq]
>>   bfq_insert_request.isra.0+0xa3/0x420 [bfq]
>>   bfq_insert_requests+0xca/0xf0 [bfq]
>>   blk_mq_dispatch_rq_list+0x4c0/0xb00
> 
> I found this call trace quite weird, I can't figure out how
> bfq_insert_requests can be called from blk_mq_dispatch_rq_list,
> can you show the add2line result?

Hi Kuai,

Thanks for having taken a look. I ran my tests with this patch series on 
top of Jens' for-next branch: "[PATCH v2 00/12] Submit zoned writes in 
order" 
(https://lore.kernel.org/linux-block/20230407235822.1672286-1-bvanassche-HInyCGIudOg@public.gmane.org/T/#m4c8c7ca5a5627510dc1709847b11589e8791b6b6). 
I will take a closer look and see which of these two patch series needs 
to be adjusted.

Bart.

