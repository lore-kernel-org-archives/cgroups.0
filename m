From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v4 00/25] kmem limitation for memcg
Date: Mon, 18 Jun 2012 21:10:38 +0900
Message-ID: <4FDF1ABE.7070200@jp.fujitsu.com>
References: <1340015298-14133-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1340015298-14133-1-git-send-email-glommer@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>, Cristoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, cgroups@vger.kernel.org, devel@openvz.org, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, Suleiman Souhlal <suleiman@google.com>

(2012/06/18 19:27), Glauber Costa wrote:
> Hello All,
> 
> This is my new take for the memcg kmem accounting. This should merge
> all of the previous comments from you guys, specially concerning the big churn
> inside the allocators themselves.
> 
> My focus in this new round was to keep the changes in the cache internals to
> a minimum. To do that, I relied upon two main pillars:
> 
>   * Cristoph's unification series, that allowed me to put must of the changes
>     in a common file. Even then, the changes are not too many, since the overal
>     level of invasiveness was decreased.
>   * Accounting is done directly from the page allocator. This means some pages
>     can fail to be accounted, but that can only happen when the task calling
>     kmem_cache_alloc or kmalloc is not the same task allocating a new page.
>     This never happens in steady state operation if the tasks are kept in the
>     same memcg. Naturally, if the page ends up being accounted to a memcg that
>     is not limited (such as root memcg), that particular page will simply not
>     be accounted.
> 
> The dispatcher code stays (mem_cgroup_get_kmem_cache), being the mechanism who
> guarantees that, during steady state operation, all objects allocated in a page
> will belong to the same memcg. I consider this a good compromise point between
> strict and loose accounting here.
> 

2 questions.

  - Do you have performance numbers ?

  - Do you think user-memory memcg should be switched to page-allocator level accounting ?
    (it will require some study for modifying current bached-freeing and per-cpu-stock
     logics...)

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
