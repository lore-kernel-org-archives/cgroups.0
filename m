From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v3 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 17:30:53 -0400
Message-ID: <9b1c20a7-ef93-d6c9-9054-64688cf48625@redhat.com>
References: <20220601211824.89626-1-longman@redhat.com>
 <20220601211824.89626-3-longman@redhat.com>
 <YpfZh6JZZMzUQIAt@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654119055;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5Q5Yw9t0Y+2Q0d6nFtht5jV9c3xFTEYinX8tRSP5cPo=;
        b=Q1PHh+Ctq5dBuipp5VLqLUaRMGU3QX+A0gK8RI1xPAxCZGK5wsSV/QSxWmc7wemtKDkXez
        iqxjRJzDgq7lf8Q+sSDS2E42ZnytZNrtj8fdOBYLgQ0E/Bh+PkmP3hjUg0pN642386/OWV
        uqitPbGxWXTvZfusRuzAuki8S5ovTf8=
Content-Language: en-US
In-Reply-To: <YpfZh6JZZMzUQIAt@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>


On 6/1/22 17:26, Tejun Heo wrote:
> On Wed, Jun 01, 2022 at 05:18:24PM -0400, Waiman Long wrote:
>> @@ -59,6 +59,57 @@ static struct workqueue_struct *blkcg_punt_bio_wq;
>>   
>>   #define BLKG_DESTROY_BATCH_SIZE  64
>>   
>> +/*
>> + * lnode.next of the last entry in a lockless list is NULL. To make it
>> + * always non-NULL for lnode's, a sentinel node has to be put at the
>> + * end of the lockless list. So all the percpu lhead's are initialized
>> + * to point to that sentinel node.
>> + */
> Can you please add why we want all entries to have non-NULL next?

As said elsewhere, lnode->next is used as a flag to indicate its 
presence in a lockless list. Sorry for not being explicit here.


>
>> +static inline bool blkcg_llist_empty(struct llist_head *lhead)
>> +{
>> +	return lhead->first == &llist_last;
>> +}
>> +
>> +static inline void init_blkcg_llists(struct blkcg *blkcg)
>> +{
>> +	int cpu;
>> +
>> +	for_each_possible_cpu(cpu)
>> +		per_cpu_ptr(blkcg->lhead, cpu)->first = &llist_last;
>> +}
>> +
>> +static inline struct llist_node *
>> +fetch_delete_blkcg_llist(struct llist_head *lhead)
>> +{
>> +	return xchg(&lhead->first, &llist_last);
>> +}
>> +
>> +static inline struct llist_node *
>> +fetch_delete_lnode_next(struct llist_node *lnode)
>> +{
>> +	struct llist_node *next = READ_ONCE(lnode->next);
>> +	struct blkcg_gq *blkg = llist_entry(lnode, struct blkg_iostat_set,
>> +					    lnode)->blkg;
>> +
>> +	WRITE_ONCE(lnode->next, NULL);
>> +	percpu_ref_put(&blkg->refcnt);
>> +	return next;
>> +}
> It's not a strong opinion but I'm not too fond of using inlines to mark
> trivial functions. The compiler should be able to make these decisions,
> right?
>
> Other than the above two bikesheddings,

Sure, I can remove the inline keywords. I think I do it out of habit:-)

Regards,
Longman

>
>   Acked-by: Tejun Heo <tj@kernel.org>
>
> Thanks.
>

