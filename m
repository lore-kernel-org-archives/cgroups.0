From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/3] memcg: simplify mem_cgroup_reclaim_iter
Date: Mon, 10 Jun 2013 10:02:08 +0200
Message-ID: <20130610080208.GB5138@dhcp22.suse.cz>
References: <20130605172212.GA10693@mtj.dyndns.org>
 <20130605194552.GI15721@cmpxchg.org>
 <20130605200612.GH10693@mtj.dyndns.org>
 <20130605211704.GJ15721@cmpxchg.org>
 <20130605222021.GL10693@mtj.dyndns.org>
 <20130605222709.GM10693@mtj.dyndns.org>
 <20130606115031.GE7909@dhcp22.suse.cz>
 <20130607005242.GB16160@htj.dyndns.org>
 <20130607073754.GA8117@dhcp22.suse.cz>
 <20130607232557.GL14781@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130607232557.GL14781-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Fri 07-06-13 16:25:57, Tejun Heo wrote:
> Hello, Michal.
> 
> On Fri, Jun 07, 2013 at 09:37:54AM +0200, Michal Hocko wrote:
> > > Oh yeah, it is racy.  That's what I meant by "not having to be
> > > completely strict".  The race window is small enough and it's not like
> > > we're messing up refcnt or may end up with use-after-free. 
> > 
> > But it would potentially pin (aka leak) the memcg for ever.
> 
> It wouldn't be anything systemetic tho - race condition's likliness is
> low and increases with the frequency of reclaim iteration, which at
> the same time means that it's likely to remedy itself pretty soon.

Sure a next visit on the same root subtree (same node, zone and prio)
would css_put it but what if that root goes away itself. Still fixable,
if every group checks its own cached iters and css_put everybody but
that is even uglier. So doing the up-the-hierarchy cleanup in RCU
callback is much easier.

> I'm doubtful it'd matter.  If it's still bothering, we sure can do it
> from RCU callback.

Yes, I would definitely prefer correctness over likeliness here.

-- 
Michal Hocko
SUSE Labs
