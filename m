From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH -V9 14/15] hugetlb/cgroup: migrate hugetlb cgroup info
 from oldpage to new page during migration
Date: Thu, 14 Jun 2012 12:04:54 +0200
Message-ID: <20120614100454.GL27397@tiehlicka.suse.cz>
References: <1339583254-895-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1339583254-895-15-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1339583254-895-15-git-send-email-aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, dhillf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 13-06-12 15:57:33, Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
> 
> With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
> we are holding a hugepage reference, we can be sure that old page won't
> get uncharged till the last put_page().
> 
> Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>

One question below
[...]
> +void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
> +{
> +	struct hugetlb_cgroup *h_cg;
> +
> +	if (hugetlb_cgroup_disabled())
> +		return;
> +
> +	VM_BUG_ON(!PageHuge(oldhpage));
> +	spin_lock(&hugetlb_lock);
> +	h_cg = hugetlb_cgroup_from_page(oldhpage);
> +	set_hugetlb_cgroup(oldhpage, NULL);
> +	cgroup_exclude_rmdir(&h_cg->css);
> +
> +	/* move the h_cg details to new cgroup */
> +	set_hugetlb_cgroup(newhpage, h_cg);
> +	spin_unlock(&hugetlb_lock);
> +	cgroup_release_and_wakeup_rmdir(&h_cg->css);
> +	return;
> +}
> +

The changelog says that the old page won't get uncharged - which means
that the the cgroup cannot go away (even if we raced with the move
parent, hugetlb_lock makes sure we either see old or new cgroup) so why
do we need to play with css ref. counting?
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
