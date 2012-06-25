From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 07/11] mm: Allocate kernel pages to the right memcg
Date: Tue, 26 Jun 2012 02:27:36 +0400
Message-ID: <4FE8E5D8.80808@parallels.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-8-git-send-email-glommer@parallels.com> <20120625180747.GE3869@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120625180747.GE3869@google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On 06/25/2012 10:07 PM, Tejun Heo wrote:
> On Mon, Jun 25, 2012 at 06:15:24PM +0400, Glauber Costa wrote:
>> When a process tries to allocate a page with the __GFP_KMEMCG flag,
>> the page allocator will call the corresponding memcg functions to
>> validate the allocation. Tasks in the root memcg can always proceed.
>>
>> To avoid adding markers to the page - and a kmem flag that would
>> necessarily follow, as much as doing page_cgroup lookups for no
>> reason, whoever is marking its allocations with __GFP_KMEMCG flag
>> is responsible for telling the page allocator that this is such an
>> allocation at free_pages() time. This is done by the invocation of
>> __free_accounted_pages() and free_accounted_pages().
>
> Shouldn't we be documenting that in the code somewhere, preferably in
> the function comments?
>
I can certainly do that.


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
