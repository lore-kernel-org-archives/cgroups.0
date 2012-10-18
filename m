From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v5 07/14] mm: Allocate kernel pages to the right memcg
Date: Thu, 18 Oct 2012 13:24:47 +0400
Message-ID: <507FCADF.20109@parallels.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-8-git-send-email-glommer@parallels.com> <20121017151221.4c420e5a.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121017151221.4c420e5a.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, devel@openvz.org, linux-kernel@vger.kernel.org, Pekka Enberg <penberg@cs.helsinki.fi>, Suleiman Souhlal <suleiman@google.com>

On 10/18/2012 02:12 AM, Andrew Morton wrote:
> On Tue, 16 Oct 2012 14:16:44 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> When a process tries to allocate a page with the __GFP_KMEMCG flag, the
>> page allocator will call the corresponding memcg functions to validate
>> the allocation. Tasks in the root memcg can always proceed.
>>
>> To avoid adding markers to the page - and a kmem flag that would
>> necessarily follow, as much as doing page_cgroup lookups for no reason,
>> whoever is marking its allocations with __GFP_KMEMCG flag is responsible
>> for telling the page allocator that this is such an allocation at
>> free_pages() time.
> 
> Well, why?  Was that the correct decision?
> 

I don't fully understand your question. Is this the same question you
posed in patch 0, about marking some versus marking all? If so, I
believe I should have answered it there.

If not, please explain.

>> This is done by the invocation of
>> __free_accounted_pages() and free_accounted_pages().
> 
> These are very general-sounding names.  I'd expect the identifiers to
> contain "memcg" and/or "kmem", to identify what's going on.
> 

Changed.
