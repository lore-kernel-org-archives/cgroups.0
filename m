From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH-block v2 3/3] blk-cgroup: Flush stats at blkgs destruction
 path
Date: Mon, 12 Dec 2022 19:19:05 -0500
Message-ID: <81f14365-a153-44aa-8ee7-4910f6988d7c@redhat.com>
References: <20221211222058.2946830-1-longman@redhat.com>
 <20221211222058.2946830-4-longman@redhat.com>
 <Y5eqAtwnpfEUG0EL@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670890755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gI+6HXmXS35AZXXUiiiCAtaTnfFzC0toG7xNuA9nRrA=;
        b=Tu1dO6itKgbnEFFelRlVXxzPTq6mFmu4Rkftw5zqg0dbH/wmNWUDRwKJuZ3pr+/bmC0Ntt
        2VeIX0t8BbBPXKo3i3Q+qQ2AuHxBpwaQz2B0X1yZjeXEW/z2448yAmdVBxvlRuLl3la4r6
        gTHD/he75AoLPDslFvC6u7WYNVFl6pw=
Content-Language: en-US
In-Reply-To: <Y5eqAtwnpfEUG0EL@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>


On 12/12/22 17:24, Tejun Heo wrote:
> On Sun, Dec 11, 2022 at 05:20:58PM -0500, Waiman Long wrote:
>> As noted by Michal, the blkg_iostat_set's in the lockless list
>> hold reference to blkg's to protect against their removal. Those
>> blkg's hold reference to blkcg. When a cgroup is being destroyed,
>> cgroup_rstat_flush() is only called at css_release_work_fn() which is
>> called when the blkcg reference count reaches 0. This circular dependency
>> will prevent blkcg from being freed until some other events cause
>> cgroup_rstat_flush() to be called to flush out the pending blkcg stats.
>>
>> To prevent this delayed blkcg removal, add a new cgroup_rstat_css_flush()
>> function to flush stats for a given css and cpu and call it at the blkgs
>> destruction path, blkcg_destroy_blkgs(), whenever there are still some
>> pending stats to be flushed. This will ensure that blkcg reference
>> count can reach 0 ASAP.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> Acked-by: Tejun Heo <tj@kernel.org>
>
> But a nit below
>
>> +	/*
>> +	 * Flush all the non-empty percpu lockless lists.
>> +	 */
> Can you please explain the deadlock that's being avoided in the above
> comment? ie. it should say why this flush is necessary.

Sure. I will expand the comment to elaborate a bit more.

Cheers,
Longman

>
>> +	for_each_possible_cpu(cpu) {
>> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
>> +
>> +		if (!llist_empty(lhead))
>> +			cgroup_rstat_css_cpu_flush(&blkcg->css, cpu);
>> +	}

