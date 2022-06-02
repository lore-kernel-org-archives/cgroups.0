From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 2 Jun 2022 14:18:14 -0400
Message-ID: <c7893920-e88d-8721-320d-b57d86e6b778@redhat.com>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220602133543.128088-4-longman@redhat.com>
 <YpjsTNZx4DG+kot4@slm.duckdns.org>
 <42da456d-8f6a-3af0-4cd3-d33a07e3b81e@redhat.com>
 <Ypj3hcodkAU1MUR7@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654193898;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8cILwmtkvSQjYb8QuEETKqwmhc+FPzA1S+q/o/FgcNc=;
        b=bo+AQDk7U0j+EkdfW8iNZyrXS0HBDrLudcS22oxAHzEHBYTu8qFx0nvP5fKnW94UDFYaX4
        iV76PTF6o4MJr5wBEKcuEqCtL8ij0vlzs8jNyvdA2+nBAsBAF5L41HjbpaESmMJFn87Hw/
        HpktZLEPYp3qbd/jQDlPfxbdmJmIi/g=
Content-Language: en-US
In-Reply-To: <Ypj3hcodkAU1MUR7-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 6/2/22 13:46, Tejun Heo wrote:
> On Thu, Jun 02, 2022 at 01:26:10PM -0400, Waiman Long wrote:
>> On 6/2/22 12:58, Tejun Heo wrote:
>>> Hello,
>>>
>>> On Thu, Jun 02, 2022 at 09:35:43AM -0400, Waiman Long wrote:
>>>> @@ -2011,9 +2076,16 @@ void blk_cgroup_bio_start(struct bio *bio)
>>>>    	}
>>>>    	bis->cur.ios[rwd]++;
>>>> +	if (!READ_ONCE(bis->lnode.next)) {
>>>> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
>>>> +
>>>> +		llist_add(&bis->lnode, lhead);
>>>> +		percpu_ref_get(&bis->blkg->refcnt);
>>> Hmm... what guarantees that more than one threads race here? llist assumes
>>> that there's a single writer for a given llist_node and the ref count would
>>> be off too, right?
>> The llist_add() function is atomic. It calls into llist_add_batch() in
>> lib/llist.c which uses cmpxchg() to make the change. There is a non-atomic
>> version __llist_add() which may be problematic in this case. Note that irq
>> is disabled in the u64_stats_update* critical section, there shouldn't be a
>> racing thread running in the same cpu. Other cpus will modify their own
>> version of lhead. Perhaps the non-atomic version can be used here as well.
> Ah, right, this is per-cpu, so there can be no second writer trying to add
> the same node at the same time. Can you add a comment explaining the overall
> design / behavior? Other than that, please feel free to add
>
>   Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
> Thanks.

OK, I will send another patch to document the design in 
block/blk-cgroup.c. I don't want to touch this patch unless I need to 
correct some code here.

Thanks,
Longman

>

