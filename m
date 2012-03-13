From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH -V3 3/8] hugetlb: add charge/uncharge calls for HugeTLB
 alloc/free
Date: Tue, 13 Mar 2012 17:31:52 +0400
Message-ID: <4F5F4C48.8050001@parallels.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1331622432-24683-4-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 8cac77b..f4aa11c 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -2901,6 +2901,11 @@ __mem_cgroup_uncharge_common(struct page *page, enum charge_type ctype)
>
>   	if (PageSwapCache(page))
>   		return NULL;
> +	/*
> +	 * HugeTLB page uncharge happen in the HugeTLB compound page destructor
> +	 */
> +	if (PageHuge(page))
> +		return NULL;

Maybe it is better to call uncharge_common from the compound destructor,
so we can have all the uncharge code in a single place.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
