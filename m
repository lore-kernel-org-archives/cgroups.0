From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch] mm: memcontrol: do not iterate uninitialized memcgs
Date: Wed, 24 Sep 2014 22:57:58 -0400
Message-ID: <20140925025758.GA6903@mtj.dyndns.org>
References: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wA6DuxbvQIsdMKaIZX6oXnJYn22WnTO1RKznjrdhb7c=;
        b=Vu1nOK9p0K+csu0nVPlwua8qsO9X9dgSiEAn412+Jabbbi58R0s9ScUpMxwqvGe6xa
         Z40p+aeM9Zx3gy+nXX+22G5NgaL//lyGX0mbMFVkUM2kPLMbwKikGWQeLnAmDEktzSqr
         iog+dcnd9URLEv3ewnnnmSkJX+rxP7sk8LRvr9+hDD2ruAbRXL5lbCCTSBJQpvunVIJT
         uPxhRSZ4Fe10qV2cYX4oEtwJdkxFuuDmWpbhNaV1crFx96Gi1igEHjWzQ2KJ9B/iwCDk
         IYgrQtHEJxV+tfW3or32bZOw3Jt0A41H8evxEkdKDoreK4O615AY36GOV5zuBGIYuxJM
         J/1w==
Content-Disposition: inline
In-Reply-To: <1411612278-4707-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 24, 2014 at 10:31:18PM -0400, Johannes Weiner wrote:
..
> not meet the ordering requirements for memcg, and so we still may see
> partially initialized memcgs from the iterators.

It's mainly the other way around - a fully initialized css may not
show up in an iteration, but given that there's no memory ordering or
synchronization around the flag, anything can happen.

...
> +		if (next_css == &root->css ||
> +		    css_tryget_online(next_css)) {
> +			struct mem_cgroup *memcg;
> +
> +			memcg = mem_cgroup_from_css(next_css);
> +			if (memcg->initialized) {
> +				/*
> +				 * Make sure the caller's accesses to
> +				 * the memcg members are issued after
> +				 * we see this flag set.

I usually prefer if the comment points to the exact location that the
matching memory barriers live.  Sometimes it's difficult to locate the
partner barrier even w/ the functional explanation.

> +				 */
> +				smp_rmb();
> +				return memcg;

In an unlikely event this rmb becomes an issue, a self-pointing
pointer which is set/read using smp_store_release() and
smp_load_acquire() respectively can do with plain barrier() on the
reader side on archs which don't need data dependency barrier
(basically everything except alpha).  Not sure whether that'd be more
or less readable than this tho.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
