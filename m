From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V4 04/10] memcg: Add HugeTLB extension
Date: Thu, 29 Mar 2012 09:57:22 +0200
Message-ID: <20120329075722.GB30465@tiehlicka.suse.cz>
References: <1331919570-2264-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1331919570-2264-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120328134020.GG20949@tiehlicka.suse.cz>
 <87y5qk1vat.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87y5qk1vat.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 28-03-12 23:07:14, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Fri 16-03-12 23:09:24, Aneesh Kumar K.V wrote:
> > [...]
> >> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> >> index 6728a7a..4b36c5e 100644
> >> --- a/mm/memcontrol.c
> >> +++ b/mm/memcontrol.c
> > [...]
> >> @@ -4887,6 +5013,7 @@ err_cleanup:
> >>  static struct cgroup_subsys_state * __ref
> >>  mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
> >>  {
> >> +	int idx;
> >>  	struct mem_cgroup *memcg, *parent;
> >>  	long error = -ENOMEM;
> >>  	int node;
> >> @@ -4929,9 +5056,14 @@ mem_cgroup_create(struct cgroup_subsys *ss, struct cgroup *cont)
> >>  		 * mem_cgroup(see mem_cgroup_put).
> >>  		 */
> >>  		mem_cgroup_get(parent);
> >> +		for (idx = 0; idx < HUGE_MAX_HSTATE; idx++)
> >> +			res_counter_init(&memcg->hugepage[idx],
> >> +					 &parent->hugepage[idx]);
> >
> > Hmm, I do not think we want to make groups deeper in the hierarchy
> > unlimited as we cannot reclaim. Shouldn't we copy the limit from the parent?
> > Still not ideal but slightly more expected behavior IMO.
> 
> But we should be limiting the child group based on parent's limit only
> when hierarchy is set right ?

Yes. Everything else should be unlimited by default.

> 
> >
> > The hierarchy setups are still interesting and the limitations should be
> > described in the documentation...
> >
> 
> It should behave similar to memcg. ie, if hierarchy is set, then we limit
> using MIN(parent's limit, child's limit). May be I am missing some of
> the details of memcg use_hierarchy config. My goal was to keep it
> similar to memcg. Can you explain why do you think the patch would
> make it any different ?

Yes, the patch tries to be consistent with the memcg limits. That is OK
and I have no objections for that. It is just that consequences are
different. The hugetlb limit is really hard...

> 
> -aneesh
> 
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
