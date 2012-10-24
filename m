From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 05/18] slab/slub: struct memcg_params
Date: Wed, 24 Oct 2012 12:42:31 +0400
Message-ID: <5087A9F7.7070804@parallels.com>
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-6-git-send-email-glommer@parallels.com> <CAAmzW4PVEb6WezFAjgNwYiAkNXE745ys6HejeNA4uRhUXqWe_g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <CAAmzW4PVEb6WezFAjgNwYiAkNXE745ys6HejeNA4uRhUXqWe_g@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: JoonSoo Kim <js1304@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, Suleiman Souhlal <suleiman@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On 10/23/2012 09:25 PM, JoonSoo Kim wrote:
> Hi, Glauber.
> 
> 2012/10/19 Glauber Costa <glommer@parallels.com>:
>> For the kmem slab controller, we need to record some extra
>> information in the kmem_cache structure.
>>
>> Signed-off-by: Glauber Costa <glommer@parallels.com>
>> Signed-off-by: Suleiman Souhlal <suleiman@google.com>
>> CC: Christoph Lameter <cl@linux.com>
>> CC: Pekka Enberg <penberg@cs.helsinki.fi>
>> CC: Michal Hocko <mhocko@suse.cz>
>> CC: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>> CC: Johannes Weiner <hannes@cmpxchg.org>
>> CC: Tejun Heo <tj@kernel.org>
>> ---
>>  include/linux/slab.h     | 25 +++++++++++++++++++++++++
>>  include/linux/slab_def.h |  3 +++
>>  include/linux/slub_def.h |  3 +++
>>  mm/slab.h                | 13 +++++++++++++
>>  4 files changed, 44 insertions(+)
>>
>> diff --git a/include/linux/slab.h b/include/linux/slab.h
>> index 0dd2dfa..e4ea48a 100644
>> --- a/include/linux/slab.h
>> +++ b/include/linux/slab.h
>> @@ -177,6 +177,31 @@ unsigned int kmem_cache_size(struct kmem_cache *);
>>  #define ARCH_SLAB_MINALIGN __alignof__(unsigned long long)
>>  #endif
>>
>> +#include <linux/workqueue.h>
> 
> Why workqueue.h is includede at this time?
> It may be future use, so is it better to add it later?
> Adding it at proper time makes git blame works better.
> 
It is for later, I missed this.

Thanks for spotting.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
