From: Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 02/27] mm, vmscan: Check if cpusets are enabled during
 direct reclaim
Date: Wed, 9 Mar 2016 13:30:17 +0100
Message-ID: <56E01759.5090203@suse.cz>
References: <1456239890-20737-1-git-send-email-mgorman@techsingularity.net>
 <1456239890-20737-3-git-send-email-mgorman@techsingularity.net>
 <56D8209C.5020103@suse.cz> <20160309115909.GA31585@techsingularity.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160309115909.GA31585-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
Cc: Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Rik van Riel <riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 03/09/2016 12:59 PM, Mel Gorman wrote:
> On Thu, Mar 03, 2016 at 12:31:40PM +0100, Vlastimil Babka wrote:
>> On 02/23/2016 04:04 PM, Mel Gorman wrote:
>>> Direct reclaim obeys cpusets but misses the cpusets_enabled() check.
>>> The overhead is unlikely to be measurable in the direct reclaim
>>> path which is expensive but there is no harm is doing it.
>>>
>>> Signed-off-by: Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>
>>> ---
>>>  mm/vmscan.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index 86eb21491867..de8d6226e026 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -2566,7 +2566,7 @@ static void shrink_zones(struct zonelist *zonelist, struct scan_control *sc)
>>>  		 * to global LRU.
>>>  		 */
>>>  		if (global_reclaim(sc)) {
>>> -			if (!cpuset_zone_allowed(zone,
>>> +			if (cpusets_enabled() && !cpuset_zone_allowed(zone,
>>>  						 GFP_KERNEL | __GFP_HARDWALL))
>>>  				continue;
>>
>> Hmm, wouldn't it be nicer if cpuset_zone_allowed() itself did the right
>> thing, and not each caller?
>>
>> How about the patch below? (+CC)
>>
> 
> The patch appears to be layer upon the entire series but that in itself

It could be also completely separate, witch your 02/27 dropped as it's
not tied to the rework anyway? Or did I miss something else cpuset
related in later patches?

> is ok. This part is a problem
> 
>> An important function for cpusets is cpuset_node_allowed(), which acknowledges
>> that if there's a single root CPU set, it must be trivially allowed. But the
>> check "nr_cpusets() <= 1" doesn't use the cpusets_enabled_key static key in a
>> proper way where static keys can reduce the overhead.
> 
> 
> There is one check for the static key and a second for the count to see
> if it's likely a valid cpuset that matters has been configured.

The point is that these should be equivalent, as the static key becomes
enabled only when there's more than one (root) cpuset. So checking
"nr_cpusets() <= 1" does the same as "!cpusets_enabled()", but without
taking advantage of the static key code patching.

> The
> point of that check was that it was lighter than __cpuset_zone_allowed
> in the case where no cpuset is configured.

But shrink_zones() (which you were patching) uses cpuset_zone_allowed(),
not __cpuset_zone_allowed(). The latter is provided only for
get_page_from_freelist(), which inserts extra fast check between
cpusets_enabled() and the slow cpuset allowed checking.

> The patches are not equivalent.
> 
