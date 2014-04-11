From: Tang Chen <tangchen@cn.fujitsu.com>
Subject: Re: [PATCH 1/1] doc, mempolicy: Fix wrong document in numa_memory_policy.txt
Date: Fri, 11 Apr 2014 16:13:33 +0800
Message-ID: <5347A42D.9000503@cn.fujitsu.com>
References: <1396410782-26208-1-git-send-email-tangchen@cn.fujitsu.com> <5347280B.3000303@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <5347280B.3000303@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Randy Dunlap <rdunlap@infradead.org>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, guz.fnst@cn.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>


Hi Randy,

On 04/11/2014 07:23 AM, Randy Dunlap wrote:
> On 04/01/2014 08:53 PM, Tang Chen wrote:
>> In document numa_memory_policy.txt, the following examples for flag
>> MPOL_F_RELATIVE_NODES are incorrect.
>>
>> 	For example, consider a task that is attached to a cpuset with
>> 	mems 2-5 that sets an Interleave policy over the same set with
>> 	MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
>> 	interleave now occurs over nodes 3,5-6.  If the cpuset's mems
>> 	then change to 0,2-3,5, then the interleave occurs over nodes
>> 	0,3,5.
>>
>> According to the comment of the patch adding flag MPOL_F_RELATIVE_NODES,
>> the nodemasks the user specifies should be considered relative to the
>> current task's mems_allowed.
>> (https://lkml.org/lkml/2008/2/29/428)
>>
>> And according to numa_memory_policy.txt, if the user's nodemask includes
>> nodes that are outside the range of the new set of allowed nodes, then
>> the remap wraps around to the beginning of the nodemask and, if not already
>> set, sets the node in the mempolicy nodemask.
>>
>> So in the example, if the user specifies 2-5, for a task whose mems_allowed
>> is 3-7, the nodemasks should be remapped the third, fourth, fifth, sixth
>> node in mems_allowed.  like the following:
>>
>> 	mems_allowed:       3  4  5  6  7
>>
>> 	relative index:     0  1  2  3  4
>> 	                    5
>>
>> So the nodemasks should be remapped to 3,5-7, but not 3,5-6.
>>
>> And for a task whose mems_allowed is 0,2-3,5, the nodemasks should be
>> remapped to 0,2-3,5, but not 0,3,5.
>>
>> 	mems_allowed:       0  2  3  5
>>
>>          relative index:     0  1  2  3
>>                              4  5
>>
>>
>> Signed-off-by: Tang Chen<tangchen@cn.fujitsu.com>
>
> Wow.  This was not an April fools joke, right?
>
> Have there been any acks of this?  I haven't seen any responses to it.

Thanks for the reply. I found this problem when I was reading the doc.
I think it is wrong. And according to the original patch:

https://lkml.org/lkml/2008/2/29/428

I think it should be fixed in the above way. But if I was wrong, please
let me know, and I think we can at least improve the doc since it is
not that easy to understand.

Thanks. :)

>
> Andrew, do you want to merge it?
>
>
>> ---
>>   Documentation/vm/numa_memory_policy.txt | 5 ++---
>>   1 file changed, 2 insertions(+), 3 deletions(-)
>>
>> diff --git a/Documentation/vm/numa_memory_policy.txt b/Documentation/vm/numa_memory_policy.txt
>> index 4e7da65..badb050 100644
>> --- a/Documentation/vm/numa_memory_policy.txt
>> +++ b/Documentation/vm/numa_memory_policy.txt
>> @@ -174,7 +174,6 @@ Components of Memory Policies
>>   	allocation fails, the kernel will search other nodes, in order of
>>   	increasing distance from the preferred node based on information
>>   	provided by the platform firmware.
>> -	containing the cpu where the allocation takes place.
>>
>>   	    Internally, the Preferred policy uses a single node--the
>>   	    preferred_node member of struct mempolicy.  When the internal
>> @@ -275,9 +274,9 @@ Components of Memory Policies
>>   	    For example, consider a task that is attached to a cpuset with
>>   	    mems 2-5 that sets an Interleave policy over the same set with
>>   	    MPOL_F_RELATIVE_NODES.  If the cpuset's mems change to 3-7, the
>> -	    interleave now occurs over nodes 3,5-6.  If the cpuset's mems
>> +	    interleave now occurs over nodes 3,5-7.  If the cpuset's mems
>>   	    then change to 0,2-3,5, then the interleave occurs over nodes
>> -	    0,3,5.
>> +	    0,2-3,5.
>>
>>   	    Thanks to the consistent remapping, applications preparing
>>   	    nodemasks to specify memory policies using this flag should
>>
>
>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
