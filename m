From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: fix hotplugged memory zone oops
Date: Fri, 2 Nov 2012 16:37:37 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1211021631260.11106@eggly.anvils>
References: <505187D4.7070404@cn.fujitsu.com> <20120913205935.GK1560@cmpxchg.org> <alpine.LSU.2.00.1209131816070.1908@eggly.anvils> <507CF789.6050307@cn.fujitsu.com> <alpine.LSU.2.00.1210181129180.2137@eggly.anvils> <20121018220306.GA1739@cmpxchg.org>
 <alpine.LNX.2.00.1211011822190.20048@eggly.anvils> <20121102102159.GA24073@dhcp22.suse.cz> <20121102105420.GB24073@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=0SqZ+1IQWUPAdRhZa6MDrx8yE2uD9UXV+Q9xLSNSYHQ=;
        b=ARTTtWaO91W6HbhYXunqltmzNvyx3cLyLn/edaeZgrv0FmMmuEpkbxzvSAXWETbm8w
         TdqUeB+JZ6Vq/VDOvIbJz24HocdxG2UFlUC5HOfvXmPP849ablufMW1N8rnHorLAvZ8b
         m9cWyKgkTcD8vvsU7C6sNPrl0Ts3yRTKs+aO3OHyId94ymWLiNpMx2yD2FUTQPqTS+eV
         EBgKbAWcShkYxbmTTCx8aZoynnlvY194Z8/A36RTK0e9/AQsEpT40CNwYn0zcFCXFzhI
         fHEbvZblxt8/UuEQgLcTkvbK9xZ7CMgrBRjz/cMHVlQO4DDayiiiBhMKpaYtgi9cruNh
         X1WQ==
In-Reply-To: <20121102105420.GB24073-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Wen Congyang <wency-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Jiang Liu <liuj97-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org, Tang Chen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

On Fri, 2 Nov 2012, Michal Hocko wrote:
> On Fri 02-11-12 11:21:59, Michal Hocko wrote:
> > On Thu 01-11-12 18:28:02, Hugh Dickins wrote:
> [...]
> 
> And I forgot to mention that the following hunk will clash with
> "memcg: Simplify mem_cgroup_force_empty_list error handling" which is in
> linux-next already (via Tejun's tree). 

Oh, via Tejun's tree.  Right, when I checked mmotm there was no problem.

> Would it be easier to split the patch into the real fix and the hunk
> bellow? That one doesn't have to go into stable anyway and we would save
> some merging conflicts. The updated fix on top of -mm tree is bellow for
> your convinience.

I'd prefer to leave it as one patch, so even the "future proof" part
of the fix goes into 3.7 and stable.  But your point is that you have
already seen the future, and it forks in a slightly different direction!

Well, I don't want to be obstructive, but it doesn't look difficult
to resolve.  Perhaps if I hold off on splitting them, and see if akpm
barks at me or not :)

Hugh

> > >  /**
> > > @@ -3688,17 +3712,17 @@ unsigned long mem_cgroup_soft_limit_recl
> > >  static bool mem_cgroup_force_empty_list(struct mem_cgroup *memcg,
> > >  				int node, int zid, enum lru_list lru)
> > >  {
> > > -	struct mem_cgroup_per_zone *mz;
> > > +	struct lruvec *lruvec;
> > >  	unsigned long flags, loop;
> > >  	struct list_head *list;
> > >  	struct page *busy;
> > >  	struct zone *zone;
> > >  
> > >  	zone = &NODE_DATA(node)->node_zones[zid];
> > > -	mz = mem_cgroup_zoneinfo(memcg, node, zid);
> > > -	list = &mz->lruvec.lists[lru];
> > > +	lruvec = mem_cgroup_zone_lruvec(zone, memcg);
> > > +	list = &lruvec->lists[lru];
> > >  
> > > -	loop = mz->lru_size[lru];
> > > +	loop = mem_cgroup_get_lru_size(lruvec, lru);
> > >  	/* give some margin against EBUSY etc...*/
> > >  	loop += 256;
> > >  	busy = NULL;
