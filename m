From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 7/9] mm: memcontrol: do not acquire page_cgroup lock for
 kmem pages
Date: Wed, 28 May 2014 13:33:28 +0200
Message-ID: <20140528113328.GG9895@dhcp22.suse.cz>
References: <1398889543-23671-1-git-send-email-hannes@cmpxchg.org>
 <1398889543-23671-8-git-send-email-hannes@cmpxchg.org>
 <20140523133938.GC22135@dhcp22.suse.cz>
 <20140527195342.GD2878@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140527195342.GD2878-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 27-05-14 15:53:42, Johannes Weiner wrote:
> On Fri, May 23, 2014 at 03:39:38PM +0200, Michal Hocko wrote:
[...]
> > >  	if (!PageCgroupUsed(pc))
> > >  		return;
> > >  
> > > -	lock_page_cgroup(pc);
> > > -	if (PageCgroupUsed(pc)) {
> > > -		memcg = pc->mem_cgroup;
> > > -		ClearPageCgroupUsed(pc);
> > > -	}
> > > -	unlock_page_cgroup(pc);
> > 
> > maybe add
> > 	WARN_ON_ONCE(pc->flags != PCG_USED);
> > 
> > to check for an unexpected flags usage in the kmem path?
> 
> There is no overlap between page types that use PCG_USED and those
> that don't.  What would be the value of adding this?

I meant it as an early warning that something bad is going on.

-- 
Michal Hocko
SUSE Labs
