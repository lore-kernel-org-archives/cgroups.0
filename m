From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH -V8 15/16] hugetlb/cgroup: migrate hugetlb cgroup info
 from oldpage to new page during migration
Date: Tue, 12 Jun 2012 17:51:53 +0900
Message-ID: <4FD70329.4080009@jp.fujitsu.com>
References: <1339232401-14392-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1339232401-14392-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1339232401-14392-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, dhillf@gmail.com, rientjes@google.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

(2012/06/09 18:00), Aneesh Kumar K.V wrote:
> From: "Aneesh Kumar K.V"<aneesh.kumar@linux.vnet.ibm.com>
> 
> With HugeTLB pages, hugetlb cgroup is uncharged in compound page destructor.  Since
> we are holding a hugepage reference, we can be sure that old page won't
> get uncharged till the last put_page().
> 
> Signed-off-by: Aneesh Kumar K.V<aneesh.kumar@linux.vnet.ibm.com>

one comment.

> ---
>   include/linux/hugetlb_cgroup.h |    8 ++++++++
>   mm/hugetlb_cgroup.c            |   21 +++++++++++++++++++++
>   mm/migrate.c                   |    5 +++++
>   3 files changed, 34 insertions(+)
> 
> diff --git a/include/linux/hugetlb_cgroup.h b/include/linux/hugetlb_cgroup.h
> index ba4836f..b64d067 100644
> --- a/include/linux/hugetlb_cgroup.h
> +++ b/include/linux/hugetlb_cgroup.h
> @@ -63,6 +63,8 @@ extern void hugetlb_cgroup_uncharge_page(int idx, unsigned long nr_pages,
>   extern void hugetlb_cgroup_uncharge_cgroup(int idx, unsigned long nr_pages,
>   					   struct hugetlb_cgroup *h_cg);
>   extern int hugetlb_cgroup_file_init(int idx) __init;
> +extern void hugetlb_cgroup_migrate(struct page *oldhpage,
> +				   struct page *newhpage);
>   #else
>   static inline struct hugetlb_cgroup *hugetlb_cgroup_from_page(struct page *page)
>   {
> @@ -112,5 +114,11 @@ static inline int __init hugetlb_cgroup_file_init(int idx)
>   {
>   	return 0;
>   }
> +
> +static inline void hugetlb_cgroup_migrate(struct page *oldhpage,
> +					  struct page *newhpage)
> +{
> +	return;
> +}
>   #endif  /* CONFIG_MEM_RES_CTLR_HUGETLB */
>   #endif
> diff --git a/mm/hugetlb_cgroup.c b/mm/hugetlb_cgroup.c
> index c2b7b8e..2d384fe 100644
> --- a/mm/hugetlb_cgroup.c
> +++ b/mm/hugetlb_cgroup.c
> @@ -394,6 +394,27 @@ int __init hugetlb_cgroup_file_init(int idx)
>   	return 0;
>   }
> 
> +void hugetlb_cgroup_migrate(struct page *oldhpage, struct page *newhpage)
> +{
> +	struct hugetlb_cgroup *h_cg;
> +
> +	VM_BUG_ON(!PageHuge(oldhpage));
> +
> +	if (hugetlb_cgroup_disabled())
> +		return;
> +
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


Why do you need  cgroup_exclude/release rmdir here ? you holds hugetlb_lock()
and charges will not be empty, here.

Thanks,
-Kame
