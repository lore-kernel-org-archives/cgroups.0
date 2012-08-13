From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v2 09/11] memcg: propagate kmem limiting information to
 children
Date: Mon, 13 Aug 2012 12:01:20 +0400
Message-ID: <5028B450.9080309@parallels.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-10-git-send-email-glommer@parallels.com> <50254A0A.3080805@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50254A0A.3080805-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On 08/10/2012 09:51 PM, Kamezawa Hiroyuki wrote:
>> +		/*
>> +		 * Once enabled, can't be disabled. We could in theory disable
>> +		 * it if we haven't yet created any caches, or if we can shrink
>> +		 * them all to death. But it is not worth the trouble
>> +		 */
>>   		static_key_slow_inc(&memcg_kmem_enabled_key);
>> -		memcg->kmem_accounted = true;
>> +
>> +		if (!memcg->use_hierarchy)
>> +			goto out;
>> +
>> +		for_each_mem_cgroup_tree(iter, memcg) {
>> +			if (iter == memcg)
>> +				continue;
>> +			memcg_kmem_account_parent(iter);
>> +		}
> 
> Could you add an explanation comment ?
> 

Of course, Kame.
Thanks
