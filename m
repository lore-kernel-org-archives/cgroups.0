From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 19:45:14 +0400
Message-ID: <5127928A.20000@parallels.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com> <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com> <51278A12.4000504@parallels.com> <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <0000013d028eec8e-012456de-9b98-4bcb-9427-2fbee58ecc74-000000@email.amazonses.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christoph Lameter <cl@linux.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On 02/22/2013 07:39 PM, Christoph Lameter wrote:
> On Fri, 22 Feb 2013, Glauber Costa wrote:
> 
>> As I've mentioned in the description, the real bug is from partial slabs
>> being temporarily in the cpu_slab during a recent allocation and
>> therefore unreachable through the partial list.
> 
> The bootstrap code does not use cpu slabs but goes directly to the slab
> pages. See early_kmem_cache_node_alloc.
> 

That differs from what I am seeing here.
I can trace an early __slab_alloc allocation from
the kmem_cache_node cache, very likely coming from the kmem_cache boot
cache creation. It takes the page out of the partial list and moves it
to the cpu_slab. After that, that particular page becomes unreachable
for bootstrap.

At this point, we are already slab_state == PARTIAL, while
init_kmem_cache_nodes will only differentiate against slab_state == DOWN.



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
