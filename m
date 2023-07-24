From: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: fix obsolete function name in
 mem_cgroup_protection()
Date: Mon, 24 Jul 2023 09:52:43 +0800
Message-ID: <e3924d13-410c-21e5-b3df-21fea0f45574@huawei.com>
References: <20230723032538.3190239-1-linmiaohe@huawei.com>
 <ZL2Ph5g05Ud5vAdT@casper.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ZL2Ph5g05Ud5vAdT-FZi0V3Vbi30CUdFEqe4BF2D2FQJk+8+b@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2023/7/24 4:37, Matthew Wilcox wrote:
> On Sun, Jul 23, 2023 at 11:25:38AM +0800, Miaohe Lin wrote:
>> @@ -582,9 +582,9 @@ static inline void mem_cgroup_protection(struct mem_cgroup *root,
>>  	/*
>>  	 * There is no reclaim protection applied to a targeted reclaim.
>>  	 * We are special casing this specific case here because
>> -	 * mem_cgroup_protected calculation is not robust enough to keep
>> -	 * the protection invariant for calculated effective values for
>> -	 * parallel reclaimers with different reclaim target. This is
>> +	 * mem_cgroup_calculate_protection calculation is not robust enough
>> +	 * to keep the protection invariant for calculated effective values
>> +	 * for parallel reclaimers with different reclaim target. This is
>>  	 * especially a problem for tail memcgs (as they have pages on LRU)
>>  	 * which would want to have effective values 0 for targeted reclaim
>>  	 * but a different value for external reclaim.
> 
> This reads a little awkwardly now.  How about:
> 
>  	 * We are special casing this specific case here because
> -	 * mem_cgroup_protected calculation is not robust enough to keep
> +	 * mem_cgroup_calculate_protection is not robust enough to keep

Sounds better. Will do it in v2.

Thanks.
