From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 2/9] mm: memcontrol: rearrange charging fast path
Date: Mon, 12 May 2014 09:59:38 +0200
Message-ID: <20140512075938.GB9564@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-3-git-send-email-hannes@cmpxchg.org>
 <20140507143334.GH9489@dhcp22.suse.cz>
 <20140508182224.GO19914@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140508182224.GO19914-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu 08-05-14 14:22:24, Johannes Weiner wrote:
> On Wed, May 07, 2014 at 04:33:34PM +0200, Michal Hocko wrote:
> > On Wed 30-04-14 16:25:36, Johannes Weiner wrote:
[...]
> > > -	if (unlikely(task_in_memcg_oom(current)))
> > > -		goto nomem;
> > > -
> > > -	if (gfp_mask & __GFP_NOFAIL)
> > > -		oom = false;
> > >  retry:
> > >  	if (consume_stock(memcg, nr_pages))
> > >  		goto done;
> > [...]
> > > @@ -2662,6 +2660,9 @@ retry:
> > >  	if (mem_cgroup_wait_acct_move(mem_over_limit))
> > >  		goto retry;
> > >  
> > > +	if (gfp_mask & __GFP_NOFAIL)
> > > +		goto bypass;
> > > +
> > 
> > This is a behavior change because we have returned ENOMEM previously
> 
> __GFP_NOFAIL must never return -ENOMEM, or we'd have to rename it ;-)
> It just looks like this in the patch, but this is the label code:
> 
> nomem:
> 	if (!(gfp_mask & __GFP_NOFAIL))
> 		return -ENOMEM;
> bypass:
> 	...

Ouch. Brain fart. Sorry...

-- 
Michal Hocko
SUSE Labs
