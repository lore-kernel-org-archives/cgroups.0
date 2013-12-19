From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: [PATCH 4/6] memcg, slab: check and init memcg_cahes under slab_mutex
Date: Thu, 19 Dec 2013 13:17:09 +0400
Message-ID: <52B2B995.2040801@parallels.com>
References: <6f02b2d079ffd0990ae335339c803337b13ecd8c.1387372122.git.vdavydov@parallels.com> <afc6d5e85d805c7313e928497b4ebcf1815703dd.1387372122.git.vdavydov@parallels.com> <20131218174105.GE31080@dhcp22.suse.cz> <52B29B2F.7050909@parallels.com> <CAA6-i6r=hW+Y2+kdKME=GTWN6sCbi37kh4sX5dT3AKkatpQzGg@mail.gmail.com> <20131219091215.GD9331@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20131219091215.GD9331@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, devel@openvz.org, Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On 12/19/2013 01:12 PM, Michal Hocko wrote:
> On Thu 19-12-13 12:00:58, Glauber Costa wrote:
>> On Thu, Dec 19, 2013 at 11:07 AM, Vladimir Davydov
>> <vdavydov@parallels.com> wrote:
>>> On 12/18/2013 09:41 PM, Michal Hocko wrote:
>>>> On Wed 18-12-13 17:16:55, Vladimir Davydov wrote:
>>>>> The memcg_params::memcg_caches array can be updated concurrently from
>>>>> memcg_update_cache_size() and memcg_create_kmem_cache(). Although both
>>>>> of these functions take the slab_mutex during their operation, the
>>>>> latter checks if memcg's cache has already been allocated w/o taking the
>>>>> mutex. This can result in a race as described below.
>>>>>
>>>>> Asume two threads schedule kmem_cache creation works for the same
>>>>> kmem_cache of the same memcg from __memcg_kmem_get_cache(). One of the
>>>>> works successfully creates it. Another work should fail then, but if it
>>>>> interleaves with memcg_update_cache_size() as follows, it does not:
>>>> I am not sure I understand the race. memcg_update_cache_size is called
>>>> when we start accounting a new memcg or a child is created and it
>>>> inherits accounting from the parent. memcg_create_kmem_cache is called
>>>> when a new cache is first allocated from, right?
>>> memcg_update_cache_size() is called when kmem accounting is activated
>>> for a memcg, no matter how.
>>>
>>> memcg_create_kmem_cache() is scheduled from __memcg_kmem_get_cache().
>>> It's OK to have a bunch of such methods trying to create the same memcg
>>> cache concurrently, but only one of them should succeed.
>>>
>>>> Why cannot we simply take slab_mutex inside memcg_create_kmem_cache?
>>>> it is running from the workqueue context so it should clash with other
>>>> locks.
>>> Hmm, Glauber's code never takes the slab_mutex inside memcontrol.c. I
>>> have always been wondering why, because it could simplify flow paths
>>> significantly (e.g. update_cache_sizes() -> update_all_caches() ->
>>> update_cache_size() - from memcontrol.c to slab_common.c and back again
>>> just to take the mutex).
>>>
>> Because that is a layering violation and exposes implementation
>> details of the slab to
>> the outside world. I agree this would make things a lot simpler, but
>> please check with Christoph
>> if this is acceptable before going forward.
> We do not have to expose the lock directly. We can hide it behind a
> helper function. Relying on the lock silently at many places is worse
> then expose it IMHO.

BTW, the lock is already exposed by mm/slab.h, which is included into
mm/memcontrol.c :-) So we have immediate access to the lock right now.

Thanks.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
