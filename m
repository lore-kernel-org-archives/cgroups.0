From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] mm, slab: Extend vm/drop_caches to shrink kmem slabs
Date: Thu, 27 Jun 2019 16:57:50 -0400
Message-ID: <063752b2-4f1a-d198-36e7-3e642d4fcf19@redhat.com>
References: <20190624174219.25513-1-longman@redhat.com>
 <20190624174219.25513-3-longman@redhat.com>
 <20190626201900.GC24698@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626201900.GC24698@tower.DHCP.thefacebook.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Jonathan Corbet <corbet@lwn.net>, Luis Chamberlain <mcgrof@kernel.org>, Kees Cook <keescook@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@goog>

On 6/26/19 4:19 PM, Roman Gushchin wrote:
>>  
>> +#ifdef CONFIG_MEMCG_KMEM
>> +static void kmem_cache_shrink_memcg(struct mem_cgroup *memcg,
>> +				    void __maybe_unused *arg)
>> +{
>> +	struct kmem_cache *s;
>> +
>> +	if (memcg == root_mem_cgroup)
>> +		return;
>> +	mutex_lock(&slab_mutex);
>> +	list_for_each_entry(s, &memcg->kmem_caches,
>> +			    memcg_params.kmem_caches_node) {
>> +		kmem_cache_shrink(s);
>> +	}
>> +	mutex_unlock(&slab_mutex);
>> +	cond_resched();
>> +}
> A couple of questions:
> 1) how about skipping already offlined kmem_caches? They are already shrunk,
>    so you probably won't get much out of them. Or isn't it true?

I have been thinking about that. This patch is based on the linux tree
and so don't have an easy to find out if the kmem caches have been
shrinked. Rebasing this on top of linux-next, I can use the
SLAB_DEACTIVATED flag as a marker for skipping the shrink.

With all the latest patches, I am still seeing 121 out of a total of 726
memcg kmem caches (1/6) that are deactivated caches after system bootup
one of the test systems. My system is still using cgroup v1 and so the
number may be different in a v2 setup. The next step is probably to
figure out why those deactivated caches are still there.

> 2) what's your long-term vision here? do you think that we need to shrink
>    kmem_caches periodically, depending on memory pressure? how a user
>    will use this new sysctl?
Shrinking the kmem caches under extreme memory pressure can be one way
to free up extra pages, but the effect will probably be temporary.
> What's the problem you're trying to solve in general?

At least for the slub allocator, shrinking the caches allow the number
of active objects reported in slabinfo to be more accurate. In addition,
this allow to know the real slab memory consumption. I have been working
on a BZ about continuous memory leaks with a container based workloads.
The ability to shrink caches allow us to get a more accurate memory
consumption picture. Another alternative is to turn on slub_debug which
will then disables all the per-cpu slabs.

Anyway, I think this can be useful to others that is why I posted the patch.

Cheers,
Longman

