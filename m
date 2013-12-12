From: Vladimir Davydov <vdavydov@parallels.com>
Subject: Re: Race in memcg kmem?
Date: Thu, 12 Dec 2013 17:39:29 +0400
Message-ID: <52A9BC91.5020105@parallels.com>
References: <52A71E43.9040200@parallels.com> <CAA6-i6oyraHQ7_1GBKxgupS12_QFx708Niu93nyNFLrbQBXE5A@mail.gmail.com> <52A8048E.4020806@parallels.com> <20131212132113.GG2630@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20131212132113.GG2630@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: Glauber Costa <glommer@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, devel@openvz.org, Balbir Singh <bsingharora@gmail.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

On 12/12/2013 05:21 PM, Michal Hocko wrote:
> On Wed 11-12-13 10:22:06, Vladimir Davydov wrote:
>> On 12/11/2013 03:13 AM, Glauber Costa wrote:
>>> On Tue, Dec 10, 2013 at 5:59 PM, Vladimir Davydov
> [...]
>>>> -- memcg_update_cache_size(s, num_groups) --
>>>> grows s->memcg_params to accomodate data for num_groups memcg's
>>>> @s is the root cache whose memcg_params we want to grow
>>>> @num_groups is the new number of kmem-active cgroups (defines the new
>>>> size of memcg_params array).
>>>>
>>>> The function:
>>>>
>>>> B1) allocates and assigns a new cache:
>>>>     cur_params = s->memcg_params;
>>>>     s->memcg_params = kzalloc(size, GFP_KERNEL);
>>>>
>>>> B2) copies per-memcg cache ptrs from the old memcg_params array to the
>>>> new one:
>>>>     for (i = 0; i < memcg_limited_groups_array_size; i++) {
>>>>         if (!cur_params->memcg_caches[i])
>>>>             continue;
>>>>         s->memcg_params->memcg_caches[i] =
>>>>                     cur_params->memcg_caches[i];
>>>>     }
>>>>
>>>> B3) frees the old array:
>>>>     kfree(cur_params);
>>>>
>>>>
>>>> Since these two functions do not share any mutexes, we can get the
>>> They do share a mutex, the slab mutex.
> Worth sticking in a lock_dep_assert?

AFAIU, lockdep_assert_held() is not applicable here:
memcg_create_kmem_cache() is called w/o the slab_mutex held, but it
calls kmem_cache_create_kmemcg(), which takes and releases this mutex,
working as a barrier. Placing lockdep_assert_held() into the latter
won't make things any clearer. IMO, we need a big good comment in
memcg_create_kmem_cache() proving its correctness.

Thanks.
