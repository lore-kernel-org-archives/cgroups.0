From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V8 12/16] hugetlb/cgroup: Add support for cgroup removal
Date: Mon, 11 Jun 2012 15:14:11 +0200
Message-ID: <20120611131411.GN12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-13-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120611085258.GD12402@tiehlicka.suse.cz>
 <87fwa25gqj.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87fwa25gqj.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 11-06-12 15:10:20, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
[...]
> >> +static int hugetlb_cgroup_move_parent(int idx, struct cgroup *cgroup,
> >> +				      struct page *page)
> >
> > deserves a comment about the locking (needs to be called with
> > hugetlb_lock).
> 
> will do
> 
> >
> >> +{
> >> +	int csize;
> >> +	struct res_counter *counter;
> >> +	struct res_counter *fail_res;
> >> +	struct hugetlb_cgroup *page_hcg;
> >> +	struct hugetlb_cgroup *h_cg   = hugetlb_cgroup_from_cgroup(cgroup);
> >> +	struct hugetlb_cgroup *parent = parent_hugetlb_cgroup(cgroup);
> >> +
> >> +	if (!get_page_unless_zero(page))
> >> +		goto out;
> >> +
> >> +	page_hcg = hugetlb_cgroup_from_page(page);
> >> +	/*
> >> +	 * We can have pages in active list without any cgroup
> >> +	 * ie, hugepage with less than 3 pages. We can safely
> >> +	 * ignore those pages.
> >> +	 */
> >> +	if (!page_hcg || page_hcg != h_cg)
> >> +		goto err_out;
> >
> > How can we have page_hcg != NULL && page_hcg != h_cg?
> 
> pages belonging to other cgroup ?

OK, I've forgot that you are iterating over all active huge pages in
hugetlb_cgroup_pre_destroy. What prevents you from doing the filtering
in the caller? 
I am also wondering why you need to play with the page reference
counting here. You are under hugetlb_lock so the page cannot disappear
in the meantime or am I missing something?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
