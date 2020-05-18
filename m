From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH v2 3/4] mm/slub: Fix another circular locking dependency
 in slab_attr_store()
Date: Mon, 18 May 2020 18:05:00 -0400
Message-ID: <638f59c0-60f1-2279-fea6-28b2980720f4@redhat.com>
References: <20200427235621.7823-4-longman@redhat.com>
 <F1FA6654-C07C-42FD-B497-61EB635B264C@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589839511;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iZK8o0/YgEUO016TV6TQ7POrns9r3ptB7P38AZfbfLY=;
        b=NZSy1xktGmA8/pvmLb1i6powT+xv0TGvezpc0H74gC44w6M8NODwNdePpXz2dkxQ3CaMZf
        Gq21MUedJoQ+8jF2gGhCn43bTYX8V7g4FHvtaG7alTkY/GiIW9RosDXlRrR+D3/yAR7sbc
        ZsbodOYiyP+FVm24gXngS/PGuNYKML0=
In-Reply-To: <F1FA6654-C07C-42FD-B497-61EB635B264C@lca.pw>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Qian Cai <cai@lca.pw>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

On 5/16/20 10:19 PM, Qian Cai wrote:
>
>> On Apr 27, 2020, at 7:56 PM, Waiman Long <longman@redhat.com> wrote:
>>
>> It turns out that switching from slab_mutex to memcg_cache_ids_sem in
>> slab_attr_store() does not completely eliminate circular locking dependency
>> as shown by the following lockdep splat when the system is shut down:
>>
>> [ 2095.079697] Chain exists of:
>> [ 2095.079697]   kn->count#278 --> memcg_cache_ids_sem --> slab_mutex
>> [ 2095.079697]
>> [ 2095.090278]  Possible unsafe locking scenario:
>> [ 2095.090278]
>> [ 2095.096227]        CPU0                    CPU1
>> [ 2095.100779]        ----                    ----
>> [ 2095.105331]   lock(slab_mutex);
>> [ 2095.108486]                                lock(memcg_cache_ids_sem);
>> [ 2095.114961]                                lock(slab_mutex);
>> [ 2095.120649]   lock(kn->count#278);
>> [ 2095.124068]
>> [ 2095.124068]  *** DEADLOCK ***
> Can you show the full splat?
>
>> To eliminate this possibility, we have to use trylock to acquire
>> memcg_cache_ids_sem. Unlikely slab_mutex which can be acquired in
>> many places, the memcg_cache_ids_sem write lock is only acquired
>> in memcg_alloc_cache_id() to double the size of memcg_nr_cache_ids.
>> So the chance of successive calls to memcg_alloc_cache_id() within
>> a short time is pretty low. As a result, we can retry the read lock
>> acquisition a few times if the first attempt fails.
>>
>> Signed-off-by: Waiman Long <longman@redhat.com>
> The code looks a bit hacky and probably not that robust. Since it is the shutdown path which is not all that important without lockdep, maybe you could drop this single patch for now until there is a better solution?

That is true. Unlike using the slab_mutex, the chance of failing to 
acquire a read lock on memcg_cache_ids_sem is pretty low. Maybe just 
print_once a warning if that happen.

Thanks,
Longman

