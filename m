From: Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [LSF/MM TOPIC] cpuset vs mempolicy related issues
Date: Fri, 10 Feb 2017 12:52:25 +0100
Message-ID: <b137d135-124a-136c-65aa-95889cc62693@suse.cz>
References: <4c44a589-5fd8-08d0-892c-e893bb525b71@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4c44a589-5fd8-08d0-892c-e893bb525b71@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: lsf-pc@lists.linux-foundation.org, "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Anshuman Khandual <khandual@linux.vnet.ibm.com>, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, Mel Gorman <mgorman@techsingularity.net>

On 02/03/2017 10:17 AM, Vlastimil Babka wrote:
> Possible fix approach
>
> Cpuset updates will rebind nodemasks only of those mempolicies that need it wrt
> their relative nodes semantics (those are either created with the flag
> MPOL_F_RELATIVE_NODES, or with neither RELATIVE nor STATIC flag). The others
> (created with the STATIC flag) we can leave untouched. For mempolicies that we
> keep rebinding, adopt the approach of mbind() that swaps an updated copy
> instead of in-place changes. We can leave get_page_from_freelist() as it is and
> nodes will be filtered orthogonally with mempolicy nodemask and cpuset check.
>
> This will give us stable nodemask throughout the whole allocation without a
> need for an on-stack copy. The next question is what to do with
> current->mems_allowed. Do we keep the parallel modifications with seqlock
> protection or e.g. try to go back to the synchronous copy approach?
>
> Related to that is a remaining corner case with alloc_pages_vma() which has its
> own seqlock-protected scope. There it calls policy_nodemask() which might
> detect that there's no intersection between the mempolicy and cpuset and return
> NULL nodemask. However, __alloc_pages_slowpath() has own seqlock scope, so if a
> modification to mems_allowed (resulting in no intersection with mempolicy)
> happens between the check in policy_nodemask() and reaching
> __alloc_pages_slowpath(), the latter won't detect the modification and invoke
> OOM before it can return with a failed allocation to alloc_pages_vma() and let
> it detect a seqlock update and retry. One solution as shown in the RFC patch [3]
> is to add another check for the cpuset/nodemask intersection before OOM. That
> works, but it's a bit hacky and still produces an allocation failure warning.
>
> On the other hand, we might also want to make things more robust in general and
> prevent spurious OOMs due to no nodes being eligible for also any other reason,
> such as buggy driver passing a wrong nodemask (which doesn't necessarily come
> from a mempolicy).

It occured to me that it could be possible to convert cpuset handling from 
nodemask based to zonelist based, which means each cpuset would have its own set 
of zonelists where only the allowed nodes (for hardwall) would be present. For 
softwall we could have another set, where allowed nodes are prioritised, but all 
would be present... or we would just use the system zonelists.

This means some extra memory overhead for each cpuset, but I'd expect the amount 
of cpusets in the system should be relatively limited anyway. (Mempolicies used 
to be based on zonelists in the past, but there the overhead might have been 
more significant.)

We could then get rid of the task->mems_allowed and the related seqlock. Cpuset 
updates would allocate new set of zonelists and then swap it. This would need 
either refcounting or some rwsem to free the old version safely.

This together with reworked updating of mempolicies would provide the guarantee 
that once we obtain the cpuset's zonelist and mempolicy's nodemask, we can check 
it once for intersection, and then that result remains valid during the whole 
allocation.

Another advantage is that for_next_zone_zonelist_nodemask() then provides the 
complete filtering and we don't have to call __cpuset_zone_allowed().

Thoughts?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
