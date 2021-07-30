From: Miaohe Lin <linmiaohe@huawei.com>
Subject: Re: [PATCH 4/5] mm, memcg: avoid possible NULL pointer dereferencing
 in mem_cgroup_init()
Date: Fri, 30 Jul 2021 14:29:57 +0800
Message-ID: <2a9353e0-9ece-d8d5-1387-202b01b0fdad@huawei.com>
References: <20210729125755.16871-1-linmiaohe@huawei.com>
 <20210729125755.16871-5-linmiaohe@huawei.com> <YQNuK+jN7pZLJTvT@carbon.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <YQNuK+jN7pZLJTvT@carbon.lan>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Roman Gushchin <guro@fb.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, willy@infradead.org, alexs@kernel.org, richard.weiyang@gmail.com, songmuchun@bytedance.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On 2021/7/30 11:12, Roman Gushchin wrote:
> On Thu, Jul 29, 2021 at 08:57:54PM +0800, Miaohe Lin wrote:
>> rtpn might be NULL in very rare case. We have better to check it before
>> dereferencing it. Since memcg can live with NULL rb_tree_per_node in
>> soft_limit_tree, warn this case and continue.
>>
>> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
>> ---
>>  mm/memcontrol.c | 2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> index 5b4592d1e0f2..70a32174e7c4 100644
>> --- a/mm/memcontrol.c
>> +++ b/mm/memcontrol.c
>> @@ -7109,6 +7109,8 @@ static int __init mem_cgroup_init(void)
>>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL,
>>  				    node_online(node) ? node : NUMA_NO_NODE);
>>  
>> +		if (WARN_ON_ONCE(!rtpn))
>> +			continue;
> 
> I also really doubt that it makes any sense to continue in this case.
> If this allocations fails (at the very beginning of the system's life, it's an __init function),
> something is terribly wrong and panic'ing on a NULL-pointer dereference sounds like
> a perfect choice.
> 
> Is this a real world problem? Do I miss something?

No, this is a theoretical bug, a very race case but not impossible IMO.
Since we can't live with NULL rb_tree_per_node in soft_limit_tree, I thinks
simply continue or break here without panic is also acceptable. Or is it
more proper to choose panic here?

Thanks.

> .
> 

