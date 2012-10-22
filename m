From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 15/18] Aggregate memcg cache values in slabinfo
Date: Mon, 22 Oct 2012 19:11:24 +0400
Message-ID: <5085621C.3040904@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-16-git-send-email-glommer@parallels.com> <0000013a7a93cb72-588b2a69-ebb0-4b5f-9040-102800d3bef4-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <0000013a7a93cb72-588b2a69-ebb0-4b5f-9040-102800d3bef4-000000@email.amazonses.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On 10/19/2012 11:50 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> +
>> +/*
>> + * We use suffixes to the name in memcg because we can't have caches
>> + * created in the system with the same name. But when we print them
>> + * locally, better refer to them with the base name
>> + */
>> +static inline const char *cache_name(struct kmem_cache *s)
>> +{
>> +	if (!is_root_cache(s))
>> +		return s->memcg_params->root_cache->name;
>> +	return s->name;
>> +}
> 
> Could we avoid this uglyness? You can ID a slab cache by combining a memcg
> pointer and a slabname.
> 
But that is not what I want.

What I want is to show the cache by its root name in memcg-specific
slabinfo.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
