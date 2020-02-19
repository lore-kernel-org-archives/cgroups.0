From: Mike Kravetz <mike.kravetz@oracle.com>
Subject: Re: [PATCH v12 7/9] hugetlb: support file_region coalescing again
Date: Tue, 18 Feb 2020 19:28:57 -0800
Message-ID: <cb402ae6-8424-c1f7-35ff-6acc68f9a23b@oracle.com>
References: <20200211213128.73302-1-almasrymina@google.com>
 <20200211213128.73302-7-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=GTH/p68KdhkiFJWtpDMSC/Ls9kAY8iH8V5hCViKDEQw=;
 b=iFcqO2NQC+0xUPGPzYCTKqu22A1wVsuAbiybcxrag0KuWmAV2RewPkL2l1A0kpsRdoDm
 IHF8wT6+MF+vL+IgE9NtOT/b6eX05UP9d5wofMjghyCzbSKQ2u6a3B7LoI1SZzg2z5hm
 pZo5lEmXP3zucjC+nsO3gcHOEXUAQIg7xFfxZel1emKzaCUPKf2jADyv2INDKdc4LSbQ
 juvEIa8OWSnXrfj40aUGX9+tulZ62kgyYVJedLdn/Sg+IB7cNC/3VUOQJ0sJjWHZUGMu
 ThRPJy0ix+7mjwiNWJuw3NGng62V4gn7gClzXfMlN1GEUmITbXxwqfldQBzxai4ngJCm KQ== 
In-Reply-To: <20200211213128.73302-7-almasrymina@google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>
Cc: shuah@kernel.org, rientjes@google.com, shakeelb@google.com, gthelen@google.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org

On 2/11/20 1:31 PM, Mina Almasry wrote:
> An earlier patch in this series disabled file_region coalescing in order
> to hang the hugetlb_cgroup uncharge info on the file_region entries.
> 
> This patch re-adds support for coalescing of file_region entries.
> Essentially everytime we add an entry, we call a recursive function that
> tries to coalesce the added region with the regions next to it. The
> worst case call depth for this function is 3: one to coalesce with the
> region next to it, one to coalesce to the region prev, and one to reach
> the base case.
> 
> This is an important performance optimization as private mappings add
> their entries page by page, and we could incur big performance costs for
> large mappings with lots of file_region entries in their resv_map.
> 
> Signed-off-by: Mina Almasry <almasrymina@google.com>
> 
> ---
> 
> Changes in v12:
> - Changed logic for coalescing. Instead of checking inline to coalesce
> with only the region on next or prev, we now have a recursive function
> that takes care of coalescing in both directions.
> - For testing this code I added a bunch of debug code that checks that
> the entries in the resv_map are coalesced appropriately. This passes
> with libhugetlbfs tests.
> 
> ---
>  mm/hugetlb.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 85 insertions(+)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 2d62dd35399db..45219cb58ac71 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -276,6 +276,86 @@ static void record_hugetlb_cgroup_uncharge_info(struct hugetlb_cgroup *h_cg,
>  #endif
>  }
> 
> +static bool has_same_uncharge_info(struct file_region *rg,
> +				   struct file_region *org)
> +{
> +#ifdef CONFIG_CGROUP_HUGETLB
> +	return rg && org &&
> +	       rg->reservation_counter == org->reservation_counter &&
> +	       rg->css == org->css;
> +
> +#else
> +	return true;
> +#endif
> +}
> +
> +#ifdef CONFIG_DEBUG_VM
> +static void dump_resv_map(struct resv_map *resv)
> +{
> +	struct list_head *head = &resv->regions;
> +	struct file_region *rg = NULL;
> +
> +	pr_err("--------- start print resv_map ---------\n");
> +	list_for_each_entry(rg, head, link) {
> +		pr_err("rg->from=%ld, rg->to=%ld, rg->reservation_counter=%px, rg->css=%px\n",
> +		       rg->from, rg->to, rg->reservation_counter, rg->css);
> +	}
> +	pr_err("--------- end print resv_map ---------\n");
> +}
> +
> +/* Debug function to loop over the resv_map and make sure that coalescing is
> + * working.
> + */
> +static void check_coalesce_bug(struct resv_map *resv)
> +{
> +	struct list_head *head = &resv->regions;
> +	struct file_region *rg = NULL, *nrg = NULL;
> +
> +	list_for_each_entry(rg, head, link) {
> +		nrg = list_next_entry(rg, link);
> +
> +		if (&nrg->link == head)
> +			break;
> +
> +		if (nrg->reservation_counter && nrg->from == rg->to &&
> +		    nrg->reservation_counter == rg->reservation_counter &&
> +		    nrg->css == rg->css) {
> +			dump_resv_map(resv);
> +			VM_BUG_ON(true);
> +		}
> +	}
> +}
> +#endif
> +
> +static void coalesce_file_region(struct resv_map *resv, struct file_region *rg)
> +{
> +	struct file_region *nrg = NULL, *prg = NULL;
> +
> +	prg = list_prev_entry(rg, link);
> +	if (&prg->link != &resv->regions && prg->to == rg->from &&
> +	    has_same_uncharge_info(prg, rg)) {
> +		prg->to = rg->to;
> +
> +		list_del(&rg->link);
> +		kfree(rg);
> +
> +		coalesce_file_region(resv, prg);
> +		return;
> +	}
> +
> +	nrg = list_next_entry(rg, link);
> +	if (&nrg->link != &resv->regions && nrg->from == rg->to &&
> +	    has_same_uncharge_info(nrg, rg)) {
> +		nrg->from = rg->from;
> +
> +		list_del(&rg->link);
> +		kfree(rg);
> +
> +		coalesce_file_region(resv, nrg);
> +		return;
> +	}
> +}
> +
>  /* Must be called with resv->lock held. Calling this with count_only == true
>   * will count the number of pages to be added but will not modify the linked
>   * list. If regions_needed != NULL and count_only == true, then regions_needed
> @@ -327,6 +407,7 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
>  				record_hugetlb_cgroup_uncharge_info(h_cg, h,
>  								    resv, nrg);
>  				list_add(&nrg->link, rg->link.prev);
> +				coalesce_file_region(resv, nrg);
>  			} else if (regions_needed)
>  				*regions_needed += 1;
>  		}
> @@ -344,11 +425,15 @@ static long add_reservation_in_range(struct resv_map *resv, long f, long t,
>  				resv, last_accounted_offset, t);
>  			record_hugetlb_cgroup_uncharge_info(h_cg, h, resv, nrg);
>  			list_add(&nrg->link, rg->link.prev);
> +			coalesce_file_region(resv, nrg);
>  		} else if (regions_needed)
>  			*regions_needed += 1;
>  	}
> 
>  	VM_BUG_ON(add < 0);
> +#ifdef CONFIG_DEBUG_VM
> +	check_coalesce_bug(resv);
> +#endif

Some distros have CONFIG_DEBUG_VM on in their default kernels.  Fedora comes
to mind.  Yes, this means 'VM_BUG_ON()' become 'BUG_ON()'.  That is somewhat
accepted.  I don't think we want this debug code behind CONFIG_DEBUG_VM and
called each time a file region is added.  It may be overkill to make it a
debug option via the config system.  Perhaps, just make it something like
CONFIG_DEBUG_HUGETLB_RSV_REGION and let hugetlb developers turn it on if
they would like?

Other than that, the code looks good.
-- 
Mike Kravetz

>  	return add;
>  }
> 
> --
> 2.25.0.225.g125e21ebc7-goog
> 
