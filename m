From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH v5 02/31] vmscan: take at least one pass with shrinkers
Date: Thu, 9 May 2013 15:35:26 +0400
Message-ID: <518B89FE.9040100@parallels.com>
References: <1368079608-5611-1-git-send-email-glommer@openvz.org> <1368079608-5611-3-git-send-email-glommer@openvz.org> <20130509111226.GR11497@suse.de> <518B884C.9090704@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <518B884C.9090704-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

On 05/09/2013 03:28 PM, Glauber Costa wrote:
> On 05/09/2013 03:12 PM, Mel Gorman wrote:
>> On Thu, May 09, 2013 at 10:06:19AM +0400, Glauber Costa wrote:
>>> In very low free kernel memory situations, it may be the case that we
>>> have less objects to free than our initial batch size. If this is the
>>> case, it is better to shrink those, and open space for the new workload
>>> then to keep them and fail the new allocations. For the purpose of
>>> defining what "very low memory" means, we will purposefuly exclude
>>> kswapd runs.
>>>
>>> More specifically, this happens because we encode this in a loop with
>>> the condition: "while (total_scan >= batch_size)". So if we are in such
>>> a case, we'll not even enter the loop.
>>>
>>> This patch modifies turns it into a do () while {} loop, that will
>>> guarantee that we scan it at least once, while keeping the behaviour
>>> exactly the same for the cases in which total_scan > batch_size.
>>>
>>> [ v5: differentiate no-scan case, don't do this for kswapd ]
>>>
>>> Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
>>> Reviewed-by: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
>>> Reviewed-by: Carlos Maiolino <cmaiolino-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>> CC: "Theodore Ts'o" <tytso-3s7WtUTddSA@public.gmane.org>
>>> CC: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
>>> ---
>>>  mm/vmscan.c | 24 +++++++++++++++++++++---
>>>  1 file changed, 21 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>>> index fa6a853..49691da 100644
>>> --- a/mm/vmscan.c
>>> +++ b/mm/vmscan.c
>>> @@ -281,12 +281,30 @@ unsigned long shrink_slab(struct shrink_control *shrink,
>>>  					nr_pages_scanned, lru_pages,
>>>  					max_pass, delta, total_scan);
>>>  
>>> -		while (total_scan >= batch_size) {
>>> +		do {
>>>  			int nr_before;
>>>  
>>> +			/*
>>> +			 * When we are kswapd, there is no need for us to go
>>> +			 * desperate and try to reclaim any number of objects
>>> +			 * regardless of batch size. Direct reclaim, OTOH, may
>>> +			 * benefit from freeing objects in any quantities. If
>>> +			 * the workload is actually stressing those objects,
>>> +			 * this may be the difference between succeeding or
>>> +			 * failing an allocation.
>>> +			 */
>>> +			if ((total_scan < batch_size) && current_is_kswapd())
>>> +				break;
>>> +			/*
>>> +			 * Differentiate between "few objects" and "no objects"
>>> +			 * as returned by the count step.
>>> +			 */
>>> +			if (!total_scan)
>>> +				break;
>>> +
>>
>> To reduce the risk of slab reclaiming the world in the reasonable cases
>> I outlined after the leader mail, I would go further than this and either
>> limit it to memcg after shrinkers are memcg aware or only do the full scan
>> if direct reclaim and priority == 0.
>>
>> What do you think?
>>
> I of course understand your worries, but I myself believe makes things
> less memcg specific is a long term win. There is a reason for memcg
> needing this, and it might be helpful in other situations as well (maybe
> very low memory in small systems, or a small zone, etc). All that, if
> possible of course. As a last resort, I am obviously fine with
> making it memcg specific if needed.
> 
> From the options you outlined above, I personally would prefer to add
> the priority check test (since the direct reclaim part is implicit by
> the current_is_kswapd test)
> 
Ok. You also mentioned this as response to the opening e-mail, so:

I am fine with being conservative and making this memcg specific. This
is relatively minor, and as much as I can argue, it may not justify the
risks.



