From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Date: Mon, 5 May 2014 14:36:46 -0700
Message-ID: <20140505143646.c0591119522b869b79d9c77b@linux-foundation.org>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
	<20140422095923.GD29311@dhcp22.suse.cz>
	<20140428150426.GB24807@dhcp22.suse.cz>
	<20140501125450.GA23420@cmpxchg.org>
	<20140502150516.d42792bad53d86fb727816bd@linux-foundation.org>
	<20140502232908.GQ23420@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140502232908.GQ23420-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Jianyu Zhan <nasa4836-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3VaTQe2KTcn/@public.gmane.org

On Fri, 2 May 2014 19:29:08 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> Memcg zoneinfo lookup sites have either the page, the zone, or the
> node id and zone index, but sites that only have the zone have to look
> up the node id and zone index themselves, whereas sites that already
> have those two integers use a function for a simple pointer chase.
> 
> Provide mem_cgroup_zone_zoneinfo() that takes a zone pointer and let
> sites that already have node id and zone index - all for each node,
> for each zone iterators - use &memcg->nodeinfo[nid]->zoneinfo[zid].
> 
> Rename page_cgroup_zoneinfo() to mem_cgroup_page_zoneinfo() to match.

Patch shrinks my mm/memcontrol.o nicely:

   text    data     bss     dec     hex filename
  55702   15681   24560   95943   176c7 mm/memcontrol.o-before
  55489   15681   24464   95634   17592 mm/memcontrol.o-after

The bss size changes are weird - the patch doesn't touch bss afaict. 
This often happens.  One day I'll get in there and work out why.
