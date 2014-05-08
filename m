From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [patch 2/9] mm: memcontrol: rearrange charging fast path
Date: Thu, 8 May 2014 14:22:24 -0400
Message-ID: <20140508182224.GO19914@cmpxchg.org>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-3-git-send-email-hannes@cmpxchg.org>
 <20140507143334.GH9489@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=YgHLwt8pWqBYkV46cT0OOh4b4uTduozaC9Jy9pFqLEk=;
	b=ejRDR6WbGt4esh+A7i5sQBQta7m8KYZTkAAgHL839cdVdTtSvdQgcS7g9b95GA+PDHp8Od9mM3skaj2rr6yanVK4n4P7NGwx4RHvokRXll+taUy8eBuaMWLa67B8zLvxg4FKa7UGLoWipNU8Rfvgac9lvscmYFVW94BbrkWcOac=;
Content-Disposition: inline
In-Reply-To: <20140507143334.GH9489@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, May 07, 2014 at 04:33:34PM +0200, Michal Hocko wrote:
> On Wed 30-04-14 16:25:36, Johannes Weiner wrote:
> > The charging path currently starts out with OOM condition checks when
> > OOM is the rarest possible case.
> > 
> > Rearrange this code to run OOM/task dying checks only after trying the
> > percpu charge and the res_counter charge and bail out before entering
> > reclaim.  Attempting a charge does not hurt an (oom-)killed task as
> > much as every charge attempt having to check OOM conditions. 
> 
> OK, I've never considered those to be measurable but it is true that the
> numbers accumulate over time.
> 
> So yes, this makes sense.
> 
> > Also, only check __GFP_NOFAIL when the charge would actually fail.
> 
> OK, but return ENOMEM as pointed below.
> 
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> >  mm/memcontrol.c | 31 ++++++++++++++++---------------
> >  1 file changed, 16 insertions(+), 15 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 75dfeb8fa98b..6ce59146fec7 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2598,21 +2598,6 @@ static int mem_cgroup_try_charge(struct mem_cgroup *memcg,
> >  
> >  	if (mem_cgroup_is_root(memcg))
> >  		goto done;
> > -	/*
> > -	 * Unlike in global OOM situations, memcg is not in a physical
> > -	 * memory shortage.  Allow dying and OOM-killed tasks to
> > -	 * bypass the last charges so that they can exit quickly and
> > -	 * free their memory.
> > -	 */
> > -	if (unlikely(test_thread_flag(TIF_MEMDIE) ||
> > -		     fatal_signal_pending(current)))
> > -		goto bypass;
> 
> This is missing "memcg: do not hang on OOM when killed by userspace OOM
> access to memory reserves" - trivial to resolve.

Yep, will rebase before the next submission.

> > -	if (unlikely(task_in_memcg_oom(current)))
> > -		goto nomem;
> > -
> > -	if (gfp_mask & __GFP_NOFAIL)
> > -		oom = false;
> >  retry:
> >  	if (consume_stock(memcg, nr_pages))
> >  		goto done;
> [...]
> > @@ -2662,6 +2660,9 @@ retry:
> >  	if (mem_cgroup_wait_acct_move(mem_over_limit))
> >  		goto retry;
> >  
> > +	if (gfp_mask & __GFP_NOFAIL)
> > +		goto bypass;
> > +
> 
> This is a behavior change because we have returned ENOMEM previously

__GFP_NOFAIL must never return -ENOMEM, or we'd have to rename it ;-)
It just looks like this in the patch, but this is the label code:

nomem:
	if (!(gfp_mask & __GFP_NOFAIL))
		return -ENOMEM;
bypass:
	...

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
