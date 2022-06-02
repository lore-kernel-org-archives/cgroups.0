From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Thu, 2 Jun 2022 13:26:10 -0400
Message-ID: <42da456d-8f6a-3af0-4cd3-d33a07e3b81e@redhat.com>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220602133543.128088-4-longman@redhat.com>
 <YpjsTNZx4DG+kot4@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654190775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ymlh+gFPOVRynjflxpfzP7WrlZXM93cHsXOM1rPvKYM=;
        b=EtpVKsKM/EBpMt/2ZQEggugL0Vs9Mn/000Wv8vqlbUNAJk7u2D4xw3PladqX8aA4sekRnU
        29zxu+yGYLSHE1xAyP4MCmFMzelS/7kIJU9Wj5AYtAlULyWrA0zMyVpHYBrZ1bM7snaUrv
        d53SyI2iAf3RYkw7iUDuSaaezivN2no=
Content-Language: en-US
In-Reply-To: <YpjsTNZx4DG+kot4-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>


On 6/2/22 12:58, Tejun Heo wrote:
> Hello,
>
> On Thu, Jun 02, 2022 at 09:35:43AM -0400, Waiman Long wrote:
>> @@ -2011,9 +2076,16 @@ void blk_cgroup_bio_start(struct bio *bio)
>>   	}
>>   	bis->cur.ios[rwd]++;
>>   
>> +	if (!READ_ONCE(bis->lnode.next)) {
>> +		struct llist_head *lhead = per_cpu_ptr(blkcg->lhead, cpu);
>> +
>> +		llist_add(&bis->lnode, lhead);
>> +		percpu_ref_get(&bis->blkg->refcnt);
> Hmm... what guarantees that more than one threads race here? llist assumes
> that there's a single writer for a given llist_node and the ref count would
> be off too, right?

The llist_add() function is atomic. It calls into llist_add_batch() in 
lib/llist.c which uses cmpxchg() to make the change. There is a 
non-atomic version __llist_add() which may be problematic in this case. 
Note that irq is disabled in the u64_stats_update* critical section, 
there shouldn't be a racing thread running in the same cpu. Other cpus 
will modify their own version of lhead. Perhaps the non-atomic version 
can be used here as well.

Cheers,
Longman

