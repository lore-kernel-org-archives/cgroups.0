From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 02/11] memcg: Reclaim when more than one page needed.
Date: Sat, 11 Aug 2012 02:56:20 +0900
Message-ID: <50254B44.7090107@jp.fujitsu.com>
References: <1344517279-30646-1-git-send-email-glommer@parallels.com> <1344517279-30646-3-git-send-email-glommer@parallels.com> <20120810154240.GG1425@dhcp22.suse.cz> <50253B95.7010905@jp.fujitsu.com> <20120810172824.GA14591@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20120810172824.GA14591@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>, Suleiman Souhlal <suleiman@google.com>

(2012/08/11 2:28), Michal Hocko wrote:
> On Sat 11-08-12 01:49:25, KAMEZAWA Hiroyuki wrote:
>> (2012/08/11 0:42), Michal Hocko wrote:
>>> On Thu 09-08-12 17:01:10, Glauber Costa wrote:
>>> [...]
>>>> @@ -2317,18 +2318,18 @@ static int mem_cgroup_do_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
>>>>   	} else
>>>>   		mem_over_limit = mem_cgroup_from_res_counter(fail_res, res);
>>>>   	/*
>>>> -	 * nr_pages can be either a huge page (HPAGE_PMD_NR), a batch
>>>> -	 * of regular pages (CHARGE_BATCH), or a single regular page (1).
>>>> -	 *
>>>>   	 * Never reclaim on behalf of optional batching, retry with a
>>>>   	 * single page instead.
>>>>   	 */
>>>> -	if (nr_pages == CHARGE_BATCH)
>>>> +	if (nr_pages > min_pages)
>>>>   		return CHARGE_RETRY;
>>>
>>> This is dangerous because THP charges will be retried now while they
>>> previously failed with CHARGE_NOMEM which means that we will keep
>>> attempting potentially endlessly.
>>
>> with THP, I thought nr_pages == min_pages, and no retry.
>
> right you are.
>
>>> Why cannot we simply do if (nr_pages < CHARGE_BATCH) and get rid of the
>>> min_pages altogether?
>>
>> Hm, I think a slab can be larger than CHARGE_BATCH.
>>
>>> Also the comment doesn't seem to be valid anymore.
>>>
>> I agree it's not clean. Because our assumption on nr_pages are changed,
>> I think this behavior should not depend on nr_pages value..
>> Shouldn't we have a flag to indicate "trial-for-batched charge" ?
>
> dunno, it would require a new parameter anyway (because abusing gfp
> doesn't seem great idea).
>
ok, agreed.

-Kame


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
