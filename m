From: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Use cond_resched() when destroy blkgs
Date: Thu, 28 Jan 2021 09:35:40 +0800
Message-ID: <ace471fc-4ba9-c16a-65af-102a5425e4e4@linux.alibaba.com>
References: <8f4fb91ced02e58ef425189c83214086f1154a0c.1611664710.git.baolin.wang@linux.alibaba.com>
 <YBF6uiFcU8k4u0Da@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <YBF6uiFcU8k4u0Da-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, joseph.qi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Tejun,

> Hello, Baolin.
> 
> On Tue, Jan 26, 2021 at 09:33:25PM +0800, Baolin Wang wrote:
>> On !PREEMPT kernel, we can get below softlockup when doing stress
>> testing with creating and destroying block cgroup repeatly. The
>> reason is it may take a long time to acquire the queue's lock in
>> the loop of blkcg_destroy_blkgs(), thus we can use cond_resched()
>> instead of cpu_relax() to avoid this issue, since the
>> blkcg_destroy_blkgs() is not called from atomic contexts.
>>
>> [ 4757.010308] watchdog: BUG: soft lockup - CPU#11 stuck for 94s!
>> [ 4757.010698] Call trace:
>> [ 4757.010700]  blkcg_destroy_blkgs+0x68/0x150
>> [ 4757.010701]  cgwb_release_workfn+0x104/0x158
>> [ 4757.010702]  process_one_work+0x1bc/0x3f0
>> [ 4757.010704]  worker_thread+0x164/0x468
>> [ 4757.010705]  kthread+0x108/0x138
>>
>> Signed-off-by: Baolin Wang <baolin.wang-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> 
> * Can you please add might_sleep() at the top of the function?

Sure.

> 
> * Given that the system can accumulate a huge number of blkgs in
>    pathological cases, I wonder whether a better way to go about it is
>    explicitly testing need_resched() on each loop and release locks and do
>    cond_resched() if true?

Yes, sound better to to me and will update in next version. Thanks for 
your sugestion.
