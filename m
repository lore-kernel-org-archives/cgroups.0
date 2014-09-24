From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch] mm: memcontrol: lockless page counters
Date: Wed, 24 Sep 2014 15:33:16 +0200
Message-ID: <20140924133316.GA4558@dhcp22.suse.cz>
References: <1411132928-16143-1-git-send-email-hannes@cmpxchg.org>
 <20140922144158.GC20398@esperanza>
 <20140922185736.GB6630@cmpxchg.org>
 <20140923110634.GH18526@esperanza>
 <20140923132801.GA14302@cmpxchg.org>
 <20140923152150.GL18526@esperanza>
 <20140923170525.GA28460@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140923170525.GA28460-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Hansen <dave-gkUM19QKKo4@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 23-09-14 13:05:25, Johannes Weiner wrote:
[...]
> How about the following update?  Don't be thrown by the
> page_counter_cancel(), I went back to it until we find something more
> suitable.  But as long as it's documented and has only 1.5 callsites,
> it shouldn't matter all that much TBH.
> 
> Thanks for your invaluable feedback so far, and sorry if the original
> patch was hard to review.  I'll try to break it up, to me it's usually
> easier to verify new functions by looking at the callers in the same
> patch, but I can probably remove the res_counter in a follow-up patch.

The original patch was really huge and rather hard to review. Having
res_counter removal in a separate patch would be definitely helpful.
I would even lobby to have the new page_counter in a separate patch with
the detailed description of the semantic and expected usage. Lockless
schemes are always tricky and hard to review.

[...]
> @@ -98,37 +121,44 @@ int page_counter_try_charge(struct page_counter *counter,
>  	struct page_counter *c;
>  
>  	for (c = counter; c; c = c->parent) {
> -		for (;;) {
> -			long count;
> -			long new;
> -
> -			count = atomic_long_read(&c->count);
> -
> -			new = count + nr_pages;
> -			if (new > c->limit) {
> -				c->failcnt++;
> -				*fail = c;
> -				goto failed;
> -			}
> -
> -			if (atomic_long_cmpxchg(&c->count, count, new) != count)
> -				continue;
> -
> -			if (new > c->watermark)
> -				c->watermark = new;
> +		long new;
>  
> -			break;
> +		new = atomic_long_add_return(nr_pages, &c->count);
> +		if (new > c->limit) {
> +			atomic_long_sub(nr_pages, &c->count);
> +			/*
> +			 * This is racy, but the failcnt is only a
> +			 * ballpark metric anyway.
> +			 */
> +			c->failcnt++;
> +			*fail = c;
> +			goto failed;
>  		}

I like this much more because the retry loop might lead to starvation.
As you pointed out in the other email this implementation might lead
to premature reclaim but I would find the former issue more probable
because it might happen even when we are far away from the limit (e.g.
in unlimited - root - memcg).

> +		/*
> +		 * This is racy, but with the per-cpu caches on top
> +		 * this is a ballpark metric as well, and with lazy
> +		 * cache reclaim, the majority of workloads peg the
> +		 * watermark to the group limit soon after launch.
> +		 */
> +		if (new > c->watermark)
> +			c->watermark = new;
>  	}
>  	return 0;

Btw. are you planning to post another version (possibly split up)
anytime soon so it would make sense to wait for it or should I continue
with this version?

Thanks!
-- 
Michal Hocko
SUSE Labs
