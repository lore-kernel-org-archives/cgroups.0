From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V8 10/16] hugetlb/cgroup: Add the cgroup pointer to page
 lru
Date: Mon, 11 Jun 2012 11:16:58 +0200
Message-ID: <20120611091658.GG12402@tiehlicka.suse.cz>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339232401-14392-11-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <20120611081653.GB12402@tiehlicka.suse.cz>
 <87oboq5ifb.fsf@skywalker.in.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <87oboq5ifb.fsf-6yE53ggjAfyqSkle7U1LjlaTQe2KTcn/@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon 11-06-12 14:33:52, Aneesh Kumar K.V wrote:
> Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org> writes:
> 
> > On Sat 09-06-12 14:29:55, Aneesh Kumar K.V wrote:
> >> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >> 
> >> Add the hugetlb cgroup pointer to 3rd page lru.next.
> >
> > Interesting and I really like the idea much more than tracking by
> > page_cgroup.
> >
> >> This limit the usage to hugetlb cgroup to only hugepages with 3 or
> >> more normal pages. I guess that is an acceptable limitation.
> >
> > Agreed.
> >
> >> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> >
> > Other than some nits I like this.
> > Thanks!
> >
> >> ---
> >>  include/linux/hugetlb_cgroup.h |   31 +++++++++++++++++++++++++++++++
> >>  mm/hugetlb.c                   |    4 ++++
> >>  2 files changed, 35 insertions(+)
> >> 
> >> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> >> index 5794be4..ceff1d5 100644
> >> --- a/include/linux/hugetlb_cgroup.h
> >> +++ b/include/linux/hugetlb_cgroup.h
> >> @@ -26,6 +26,26 @@ struct hugetlb_cgroup {
> >>  };
> >>  
> >>  #ifdef CONFIG_CGROUP_HUGETLB_RES_CTLR
> >> +static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
> >> +{
> >> +	if (!PageHuge(page))
> >> +		return NULL;
> >> +	if (compound_order(page) < 3)
> >
> > Why 3? I think you wanted 2 here, right?
> 
> Yes that should be 2. I updated that in an earlier. Already in v9
> version I have locally.

ohh, I should have read replies to the patch first where you already
mentioned that you are aware of that.
Maybe it would be worth something like:
/* Minimum page order trackable by hugetlb cgroup.
 * At least 3 pages are necessary for all the tracking information.
 */
#define HUGETLB_CGROUP_MIN_ORDER	2

> >> @@ -591,6 +592,7 @@ static void update_and_free_page(struct hstate *h, struct page *page)
> >>  				1 << PG_active | 1 << PG_reserved |
> >>  				1 << PG_private | 1 << PG_writeback);
> >>  	}
> >> +	BUG_ON(hugetlb_cgroup_from_page(page));
> >
> > What about VM_BUG_ON?
> 
> Will do, So when do one decide to choose VM_BUG_ON against BUG_ON ?

I think that VM_ variant is more approapriate here because it is more a
debugging thing rather than a hard failure invariant.

-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
