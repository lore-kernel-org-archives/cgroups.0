From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH -V3 4/8] memcg: track resource index in cftype private
Date: Tue, 13 Mar 2012 17:34:08 +0400
Message-ID: <4F5F4CD0.3080207@parallels.com>
References: <1331622432-24683-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1331622432-24683-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1331622432-24683-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 03/13/2012 11:07 AM, Aneesh Kumar K.V wrote:
>   		if (type == _MEM)
>   			ret = mem_cgroup_resize_limit(memcg, val);
> -		else
> +		else if (type == _MEMHUGETLB) {
> +			int idx = MEMFILE_IDX(cft->private);
> +			ret = res_counter_set_limit(&memcg->hugepage[idx], val);
> +		} else
>   			ret = mem_cgroup_resize_memsw_limit(memcg, val);
>   		break;
>   	case RES_SOFT_LIMIT:

What if a user try to set limit < usage ? Isn't there any reclaim that 
we could possibly do, like it is done by normal memcg ?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
