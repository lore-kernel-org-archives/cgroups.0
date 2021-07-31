From: Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH 4/5] mm, memcg: avoid possible NULL pointer dereferencing
 in mem_cgroup_init()
Date: Sat, 31 Jul 2021 10:05:51 +0800
Message-ID: <f7a22702-cd08-6b15-48c7-68523c38060b@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-5-linmiaohe@huawei.com> <YQNuK+jN7pZLJTvT@carbon.lan>
 <YQOf0TKOXpGRQFHF@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YQOf0TKOXpGRQFHF@dhcp22.suse.cz>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, willy@infradead.org, alexs@kernel.org, richard.weiyang@gmail.com, songmuchun@bytedance.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 2021/7/30 14:44, Michal Hocko wrote:
> On Thu 29-07-21 20:12:43, Roman Gushchin wrote:
>> On Thu, Jul 29, 2021 at 08:57:54PM +0800, Miaohe Lin wrote:
>>> rtpn might be NULL in very rare case. We have better to check it before
>>> dereferencing it. Since memcg can live with NULL rb_tree_per_node in
>>> soft_limit_tree, warn this case and continue.
>>>
>>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>>> ---
>>>  mm/memcontrol.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index 5b4592d1e0f2..70a32174e7c4 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -7109,6 +7109,8 @@ static int __init mem_cgroup_init(void)
>>>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>>>  				    node_online(node) ? node : NUMA_NO_NODE);
>>>  
>>> +		if (WARN_ON_ONCE(!rtpn))
>>> +			continue;
>>
>> I also really doubt that it makes any sense to continue in this case.
>> If this allocations fails (at the very beginning of the system's life, it's an __init function),
>> something is terribly wrong and panic'ing on a NULL-pointer dereference sounds like
>> a perfect choice.
> 
> Moreover this is 24B allocation during early boot. Kernel will OOM and
> panic when not being able to find any victim. I do not think we need to

Agree with you. But IMO it may not be a good idea to leave the rtpn without NULL check. We should defend
it though it could hardly happen. But I'm not insist on this check. I will drop this patch if you insist.

Thanks both of you.

> do any special handling here.
> 

