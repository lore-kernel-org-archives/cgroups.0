From: Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 1/1] doc, mempolicy: Fix wrong document in numa_memory_policy.txt
Date: Thu, 10 Apr 2014 16:23:55 -0700
Message-ID: <5347280B.3000303@infradead.org>
References: <1396410782-26208-1-git-send-email-tangchen@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1396410782-26208-1-git-send-email-tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tang Chen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, guz.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 04/01/2014 08:53 PM, Tang Chen wrote:
> In document numa_memory_policy.txt, the following examples for flag
> MPOL_F_RELATIVE_NODES are incorrect.
> 
> 	For example, consider a task that is attached to a cpuset with
> 	mems 2-5 that sets an Interleave policy over the same set with
> 	MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
> 	interleave now occurs over nodes 3,5-6.  If the cpuset's mems
> 	then change to 0,2-3,5, then the interleave occurs over nodes
> 	0,3,5.
> 
> According to the comment of the patch adding flag MPOL_F_RELATIVE_NODES,
> the nodemasks the user specifies should be considered relative to the
> current task's mems_allowed.
> (https://lkml.org/lkml/2008/2/29/428)
> 
> And according to numa_memory_policy.txt, if the user's nodemask includes
> nodes that are outside the range of the new set of allowed nodes, then
> the remap wraps around to the beginning of the nodemask and, if not already
> set, sets the node in the mempolicy nodemask.
> 
> So in the example, if the user specifies 2-5, for a task whose mems_allowed
> is 3-7, the nodemasks should be remapped the third, fourth, fifth, sixth
> node in mems_allowed.  like the following:
> 
> 	mems_allowed:       3  4  5  6  7
> 
> 	relative index:     0  1  2  3  4
> 	                    5
> 
> So the nodemasks should be remapped to 3,5-7, but not 3,5-6.
> 
> And for a task whose mems_allowed is 0,2-3,5, the nodemasks should be
> remapped to 0,2-3,5, but not 0,3,5.
> 
> 	mems_allowed:       0  2  3  5
> 
>         relative index:     0  1  2  3
>                             4  5
> 
> 
> Signed-off-by: Tang Chen <tangchen-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>

Wow.  This was not an April fools joke, right?

Have there been any acks of this?  I haven't seen any responses to it.

Andrew, do you want to merge it?


> ---
>  Documentation/vm/numa_memory_policy.txt | 5 ++---
>  1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
> index 4e7da65..badb050 100644
> --- a/Documentation/vm/numa_memory_policy.txt
> +++ b/Documentation/vm/numa_memory_policy.txt
> @@ -174,7 +174,6 @@ Components of Memory Policies
>  	allocation fails, the kernel will search other nodes, in order of
>  	increasing distance from the preferred node based on information
>  	provided by the platform firmware.
> -	containing the cpu where the allocation takes place.
>  
>  	    Internally, the Preferred policy uses a single node--the
>  	    preferred_node member of struct mempolicy.  When the internal
> @@ -275,9 +274,9 @@ Components of Memory Policies
>  	    For example, consider a task that is attached to a cpuset with
>  	    mems 2-5 that sets an Interleave policy over the same set with
>  	    MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
> -	    interleave now occurs over nodes 3,5-6.  If the cpuset's mems
> +	    interleave now occurs over nodes 3,5-7.  If the cpuset's mems
>  	    then change to 0,2-3,5, then the interleave occurs over nodes
> -	    0,3,5.
> +	    0,2-3,5.
>  
>  	    Thanks to the consistent remapping, applications preparing
>  	    nodemasks to specify memory policies using this flag should
> 


-- 
~Randy
