From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 2/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed, 1 Jun 2022 14:52:50 -0400
Message-ID: <bca31669-7107-ebe4-7fbf-2449940a5cc8@redhat.com>
References: <20220601165324.60892-1-longman@redhat.com>
 <20220601165324.60892-2-longman@redhat.com>
 <YpemVpvaPomwH7mt@slm.duckdns.org>
 <ca091a5c-4ae1-e973-403e-4086d4527102@redhat.com>
 <YpexWFptr/l2Y0rU@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654109572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23W9sVLSI1R9gyjHi/xhjrSHqXfJ+ljK3ctft/U12GA=;
        b=N+uDcahFYnzjgLWq8sbD16uIuVjEmwh2VCa25+B1dZxearJm9rRfT2+zeD0I6xYJtRfswJ
        OFaycG5amcgUe9EHK+PFqu5VLWH/zRFrLJqLFITJu6SemvV5RDF1mPds3++m8PXIn+IdJS
        rcq1BaS4KBPN37aRTicTPi2gouXcvXk=
Content-Language: en-US
In-Reply-To: <YpexWFptr/l2Y0rU@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>

On 6/1/22 14:35, Tejun Heo wrote:
> Hello,
>
> On Wed, Jun 01, 2022 at 02:15:46PM -0400, Waiman Long wrote:
>> It was mentioned in the commit log, but I will add a comment to repeat that.
>> It is because lnode.next is used as a flag to indicate its presence in the
>> lockless list. By default, the first one that go into the lockless list will
>> have a NULL value in its next pointer. So I have to put a sentinel node that
>> to make sure that the next pointer is always non-NULL.
> Oh yeah, I noticed that in the commit log, but I think it really warrants an
> inline comment.
>
>>>> + * The retrieved blkg_iostat_set is immediately marked as not in the
>>>> + * lockless list by clearing its node->next pointer. It could be put
>>>> + * back into the list by a parallel update before the iostat's are
>>>> + * finally flushed. So being in the list doesn't always mean it has new
>>>> + * iostat's to be flushed.
>>>> + */
>>> Isn't the above true for any sort of mechanism which tracking pending state?
>>> You gotta clear the pending state before consuming so that you don't miss
>>> the events which happen while data is being consumed.
>> That is true. I was about thinking what race conditions can happen with
>> these changes. The above comment is for the race that can happen which is
>> benign. I am remove it if you think it is necessary.
> I don't have too strong an opinion. It just felt a bit disproportionate for
> it to be sticking out like that. Maybe toning it down a little bit would
> help?

Will do.


>>>> +	/*
>>>> +	 * No RCU protection is needed as it is assumed that blkg_iostat_set's
>>>> +	 * in the percpu lockless list won't go away until the flush is done.
>>>> +	 */
>>> Can you please elaborate on why this is safe?
>> You are right that the comment is probably not quite right. I will put the
>> rcu_read_lock/unlock() back in. However, we don't have a rcu iterator for
>> the lockless list. On the other hand, blkcg_rstat_flush() is now called with
>> irq disabled. So rcu_read_lock() is not technically needed.
> Maybe we just need an rcu_read_lock_held() - does that cover irq being
> disabled? I'm not sure what the rules are since the different rcu variants
> got merged. Anyways, the right thing to do would be asserting and
> documenting that the section is RCU protected.

I will leave rcu_read_lock() in for now. We can worry about the proper 
way to remove it or document it later on.


>
> As for llist not having rcu iterators. The llists aren't RCU protected or
> assigned. What's RCU protected is the lifetime of the elements. That said,
> we'd need an rmb after fetching llist_head to guarantee that the flusher
> sees all the updates which took place before the node got added to the
> llist, right?

Fetching of llist head is done by an atomic xchg(). So it has all the 
necessary barrier.

Iterating the nodes of the llist and clearing them are not atomic. That 
is the reason I put a comment previously about a possible race. However 
that race is benign. Making it atomic does not eliminate the race as the 
iostat update data themselves are synchronized separately with sequence 
lock.

> Can you also add an explanation on how the pending llist is synchronized
> against blkg destructions?

Sure. I will need to think about that and put a proper comment there.

Cheers,
Longman

