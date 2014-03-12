From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [patch 3/8] mm: memcg: inline mem_cgroup_charge_common()
Date: Wed, 12 Mar 2014 16:19:24 +0100
Message-ID: <20140312151924.GH11831@dhcp22.suse.cz>
References: <1394587714-6966-1-git-send-email-hannes@cmpxchg.org>
 <1394587714-6966-4-git-send-email-hannes@cmpxchg.org>
 <20140312125213.GB11831@dhcp22.suse.cz>
 <20140312145300.GC14688@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140312145300.GC14688-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 12-03-14 10:53:00, Johannes Weiner wrote:
> On Wed, Mar 12, 2014 at 01:52:13PM +0100, Michal Hocko wrote:
> > On Tue 11-03-14 21:28:29, Johannes Weiner wrote:
> > [...]
> > > @@ -3919,20 +3919,21 @@ out:
> > >  	return ret;
> > >  }
> > >  
> > > -/*
> > > - * Charge the memory controller for page usage.
> > > - * Return
> > > - * 0 if the charge was successful
> > > - * < 0 if the cgroup is over its limit
> > > - */
> > > -static int mem_cgroup_charge_common(struct page *page, struct mm_struct *mm,
> > > -				gfp_t gfp_mask, enum charge_type ctype)
> > > +int mem_cgroup_newpage_charge(struct page *page,
> > > +			      struct mm_struct *mm, gfp_t gfp_mask)
> > 
> > s/mem_cgroup_newpage_charge/mem_cgroup_anon_charge/ ?
> > 
> > Would be a better name? The patch would be bigger but the name more
> > apparent...
> 
> I wouldn't be opposed to fixing those names at all, but I think that
> is out of the scope of this patch.

OK.

> Want to send one?

will do

> mem_cgroup_charge_anon() would be a good name, but then we should also
> rename mem_cgroup_cache_charge() to mem_cgroup_charge_file() to match.

Yes that sounds good to me.

> Or charge_private() vs. charge_shared()...

anon vs. file is easier to follow but I do not have any preference here.

-- 
Michal Hocko
SUSE Labs
