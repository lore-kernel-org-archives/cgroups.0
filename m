From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V8 11/16] hugetlb/cgroup: Add charge/uncharge routines
 for hugetlb cgroup
Date: Mon, 11 Jun 2012 14:59:52 +0200
Message-ID: <20120611125952.GM12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120611083810.GC12402@tiehlicka.suse.cz>
 <87liju5h9u.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87liju5h9u.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 11-06-12 14:58:45, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Sat 09-06-12 14:29:56, Aneesh Kumar K.V wrote:
> >> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> 
> >> This patchset add the charge and uncharge routines for hugetlb cgroup.
> >> This will be used in later patches when we allocate/free HugeTLB
> >> pages.
> >
> > Please describe the locking rules.
> 
> All the update happen within hugetlb_lock.

Yes, I figured but it is definitely worth mentioning in the patch
description.

[...]
> >> +void hugetlb_cgroup_commit_charge(int idx, unsigned long nr_pages,
> >> +				  struct hugetlb_cgroup *h_cg,
> >> +				  struct page *page)
> >> +{
> >> +	if (hugetlb_cgroup_disabled() || !h_cg)
> >> +		return;
> >> +
> >> +	spin_lock(&hugetlb_lock);
> >> +	if (hugetlb_cgroup_from_page(page)) {
> >
> > How can this happen? Is it possible that two CPUs are trying to charge
> > one page?
> 
> That is why I added that. I looked at the alloc_huge_page, and I
> don't see we would end with same page from different CPUs but then
> we have similar checks in memcg, where we drop the charge if we find
> the page cgroup already used.

Yes but memcg is little bit more complicated than hugetlb which has
which doesn't have to cope with async charges. Hugetlb allocation is
serialized by hugetlb_lock so only one caller gets the page.
I do not think the check is required here or add a comment explaining
how it can happen.

[...]
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
