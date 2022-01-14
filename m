From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Fri, 14 Jan 2022 09:51:31 +0100
Message-ID: <YeE5k79uP3xBPCv7@dhcp22.suse.cz>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <Yd1CdJA5NelzoK1D@dhcp22.suse.cz>
 <20220112004634.dc5suwei4ymyxaxg@master>
 <Yd6Xr7K9bKGVgGtI@dhcp22.suse.cz>
 <20220114002937.fnyq3yyk36j4nb3d@master>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1642150293; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/nWKNw9opZBY8w53yyW2tw6i8XJ7sKPnF1rYIP33e7U=;
        b=BbgHB4lMU5Bw7t4w8SdHquX2ho+IFQvfmdx6G1qwqkwTk9juAzikwnAZaSjZS2by/n3y2R
        wC9rGTGeNDE6hWqWRGgWO6EryXFsCAQXxNIsWCQVPzlPnrJM1bgxJLpHBAkpuMk4FnWJLB
        uzGtDWkxQ9dNowTd6ZytR1hEJc5Xz/o=
Content-Disposition: inline
In-Reply-To: <20220114002937.fnyq3yyk36j4nb3d@master>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri 14-01-22 00:29:37, Wei Yang wrote:
> On Wed, Jan 12, 2022 at 09:56:15AM +0100, Michal Hocko wrote:
> >On Wed 12-01-22 00:46:34, Wei Yang wrote:
> >> On Tue, Jan 11, 2022 at 09:40:20AM +0100, Michal Hocko wrote:
> >> >On Tue 11-01-22 01:02:59, Wei Yang wrote:
> >> >> Instead of use "-1", let's use NUMA_NO_NODE for consistency.
> >> >> 
> >> >> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> >
> >> >I am not really sure this is worth it. After the merge window I plan to
> >> >post http://lkml.kernel.org/r/20211214100732.26335-1-mhocko-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org
> >> 
> >> Give me some time to understand it :-)
> >
> >Just for the record, here is what I have put on top of that series:
> 
> Ok, I got what you try to resolve. I am ok with the following change except
> one point.
> 
> >--- 
> >>From b7195eba02fe6308a6927450f4630057c05e808e Mon Sep 17 00:00:00 2001
> >From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >Date: Tue, 11 Jan 2022 09:45:25 +0100
> >Subject: [PATCH] memcg: do not tweak node in alloc_mem_cgroup_per_node_info
> >
> >alloc_mem_cgroup_per_node_info is allocated for each possible node and
> >this used to be a problem because not !node_online nodes didn't have
> >appropriate data structure allocated. This has changed by "mm: handle
> >uninitialized numa nodes gracefully" so we can drop the special casing
> >here.
> >
> >Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> >---
> > mm/memcontrol.c | 14 ++------------
> > 1 file changed, 2 insertions(+), 12 deletions(-)
> >
> >diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >index 781605e92015..ed19a21ee14e 100644
> >--- a/mm/memcontrol.c
> >+++ b/mm/memcontrol.c
> >@@ -5044,18 +5044,8 @@ struct mem_cgroup *mem_cgroup_from_id(unsigned short id)
> > static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
> > {
> > 	struct mem_cgroup_per_node *pn;
> >-	int tmp = node;
> >-	/*
> >-	 * This routine is called against possible nodes.
> >-	 * But it's BUG to call kmalloc() against offline node.
> >-	 *
> >-	 * TODO: this routine can waste much memory for nodes which will
> >-	 *       never be onlined. It's better to use memory hotplug callback
> >-	 *       function.
> >-	 */
> 
> Do you think this TODO is not related to this change?

It is not really related but I am not sure how useful it is. Essentially
any allocation that is per-possible node is in the same situation and if
we really need to deal with large and sparse possible nodes masks.

If you want me to keep the TODO I will do it though.

-- 
Michal Hocko
SUSE Labs
