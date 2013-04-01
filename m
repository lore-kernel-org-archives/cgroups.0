From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH] memcg: take reference before releasing rcu_read_lock
Date: Mon, 1 Apr 2013 11:24:13 +0400
Message-ID: <5159361D.40302@parallels.com>
References: <51556CE9.9060000@huawei.com> <5155718A.90108@parallels.com> <51563336.701@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <51563336.701@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>

On 03/30/2013 04:35 AM, Li Zefan wrote:
> On 2013/3/29 18:48, Glauber Costa wrote:
>> On 03/29/2013 02:28 PM, Li Zefan wrote:
>>> The memcg is not referenced, so it can be destroyed at anytime right
>>> after we exit rcu read section, so it's not safe to access it.
>>>
>>> To fix this, we call css_tryget() to get a reference while we're still
>>> in rcu read section.
>>>
>>> This also removes a bogus comment above __memcg_create_cache_enqueue().
>>>
>> Out of curiosity, did you see that happening ?
>>
> 
> Just by code inspection. This is not the only place you use RCU in this
> wrong way. Remember the last patch I sent? ;)
> 
Indeed, that is what happens with miscomprehensions: the mistake tends
to be repeated. Thanks for your diligence with this.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
