From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 09/16] sl[au]b: always get the cache from its page
 in kfree
Date: Wed, 19 Sep 2012 11:42:54 +0400
Message-ID: <5059777E.8060906@parallels.com>
References: <1347977530-29755-1-git-send-email-glommer@parallels.com> <1347977530-29755-10-git-send-email-glommer@parallels.com> <00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <00000139d9fe8595-8905906d-18ed-4d41-afdb-f4c632c2d50a-000000@email.amazonses.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com, devel@openvz.org, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, Suleiman Souhlal <suleiman@google.com>, Frederic Weisbecker <fweisbec@gmail.com>, Mel Gorman <mgorman@suse.de>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@cs.helsinki.fi>

On 09/18/2012 07:28 PM, Christoph Lameter wrote:
> On Tue, 18 Sep 2012, Glauber Costa wrote:
> 
>> index f2d760c..18de3f6 100644
>> --- a/mm/slab.c
>> +++ b/mm/slab.c
>> @@ -3938,9 +3938,12 @@ EXPORT_SYMBOL(__kmalloc);
>>   * Free an object which was previously allocated from this
>>   * cache.
>>   */
>> -void kmem_cache_free(struct kmem_cache *cachep, void *objp)
>> +void kmem_cache_free(struct kmem_cache *s, void *objp)
>>  {
>>  	unsigned long flags;
>> +	struct kmem_cache *cachep = virt_to_cache(objp);
>> +
>> +	VM_BUG_ON(!slab_equal_or_parent(cachep, s));
>>
> 
> This is an extremely hot path of the kernel and you are adding significant
> processing. Check how the benchmarks are influenced by this change.
> virt_to_cache can be a bit expensive.
> 

Would it be enough for you to have a separate code path for
!CONFIG_MEMCG_KMEM?

I don't really see another way to do it, aside from deriving the cache
from the object in our case. I am open to suggestions if you do.

>> diff --git a/mm/slub.c b/mm/slub.c
>> index 4778548..a045dfc 100644
>> --- a/mm/slub.c
>> +++ b/mm/slub.c
>> @@ -2604,7 +2604,9 @@ void kmem_cache_free(struct kmem_cache *s, void *x)
>>
>>  	page = virt_to_head_page(x);
>>
>> -	slab_free(s, page, x, _RET_IP_);
>> +	VM_BUG_ON(!slab_equal_or_parent(page->slab, s));
>> +
>> +	slab_free(page->slab, page, x, _RET_IP_);
>>
> 
> Less of a problem here but you are eroding one advantage that slab has had
> in the past over slub in terms of freeing objects.
> 
likewise.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
