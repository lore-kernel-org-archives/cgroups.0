Received: from smtpout2.mo540.mail-out.ovh.net (smtpout2.mo540.mail-out.ovh.net [51.210.91.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0C4432E6E
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=51.210.91.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785877709; cv=none; b=uGqng5CrREy8OBPRlth5TZr1+KkGj6TFEH44DhsTZuO03cdzZTlEXGMmijyEuU/RDGeajO74L4UMUiFe0C5/S6HNJdREgogZ8rCgtczJwrVis4+4T2jnReBjYdBgFMwDd27OltdRKjS+SdwkMaVsltSevOU4or//KESDX5Xfqxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785877709; c=relaxed/simple;
	bh=KydCBkPMtRmh00bEz6Rg7ocnXSwyMp/llgCc6GeLSCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=A8ignyP3UxdMMzaxfRBc+c8HccKreYpxZWLPm6jzLisy90ebFyyCscIFDvQ7U3SQ94xOWmWEDbYefkSA148ihPIZjhYdxFspehiZgaUwCfpCZpRkrexY4wgBW3rOrRXgjd2JkjzZAPps7A0dqCE4SEVFQ/a0RPN9UDW1fGD+2yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev; spf=pass smtp.mailfrom=pixelcluster.dev; dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b=YVE8B6D8; arc=none smtp.client-ip=51.210.91.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b="YVE8B6D8"
Received: from director2.derp.mail-out.ovh.net (director2.derp.mail-out.ovh.net [79.137.60.36])
	by mo540.mail-out.ovh.net (Postfix) with ESMTPS id 4hF5jq3vGcz4bfh;
	Tue,  4 Aug 2026 21:08:15 +0000 (UTC)
Received: from director2.derp.mail-out.ovh.net (director2.derp.mail-out.ovh.net. [127.0.0.1])
        by director2.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <christian.koenig@amd.com>; Tue,  4 Aug 2026 21:08:15 +0000 (UTC)
Received: from mta7.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.37.239])
	by director2.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4hF5jq2q1Lz1xnj;
	Tue,  4 Aug 2026 21:08:15 +0000 (UTC)
Received: from pixelcluster.dev (unknown [10.1.6.7])
	(Authenticated sender: nat@pixelcluster.dev)
	by mta7.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id 06A7EB81A5B;
	Tue,  4 Aug 2026 21:08:12 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-96R00137afb027-85af-476a-b1f1-66fecce69dc1,
                    554F327AB99B0CF81BA34543D1D055DA486C6A81) smtp.auth=nat@pixelcluster.dev
X-OVh-ClientIp:88.133.252.134
Message-ID: <c16ab0f4-20c7-4c3a-ad6a-93cd67069ac8@pixelcluster.dev>
Date: Tue, 4 Aug 2026 23:08:12 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 Maarten Lankhorst <dev@lankhorst.se>
Cc: Maxime Ripard <mripard@kernel.org>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Christian Koenig <christian.koenig@amd.com>,
 Huang Rui <ray.huang@amd.com>, Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>,
 =?UTF-8?Q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>,
 cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
 <20260804-dmemcg-aggressive-protect-v8-2-07af96681bf8@gmx.de>
 <b5b80acd-feea-408b-87eb-4264ffc7e2cd@lankhorst.se>
 <7b2887b1-ecb7-4d6e-ad34-068ab1d7d41e@pixelcluster.dev>
 <bd7c2432-a34b-400a-8351-ca4398b24981@lankhorst.se>
 <anJSBu2zbo8_lG7N@quatroqueijos.cascardo.eti.br>
Content-Language: en-US
From: Natalie Vock <nat@pixelcluster.dev>
In-Reply-To: <anJSBu2zbo8_lG7N@quatroqueijos.cascardo.eti.br>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
x-ovh-tracer-id: 6106599622343352598
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTEHF8gyUkvu9JTcDhcBknt8D9UWEteKkUw+BCwZvFs2o0q059BSERt0kMfIYIu1DBcENh0Mz3wM4CPIA5DaOD8woavFwVpcKWu9uUJuIHzjvY9xtfP9MmLyLyKJeeAEYNP6vJ2HWLOtN4izG6z9lEmZulCE5RlG5u7cXXCaFO8ZqrHVInH6l+srMJnoVSLvSpd/qrkUdrLFbPP7us16HsyNDrEkWGqMZioik6YA3hpptpVwpBKFzB1fs+YSEDSse+lly5wN41GPp5sfk1cFoXyTBI9vljXMySSXpk6F3uV3fa8bDrbSK6v7kBMiQR/MvwPbZjkixYwPW5AH9Gr3pTiIrsBJI0l51eDMeaV2HPCDDIp+RJdsv1AmXhxmuW6IcmDFuE7rOrTrx/v02Suz6a94afkE0mXB6hAqaCWx5IunsLzDP0Ob7NQO5gmn8pm0Q/6ZTJKA9XuLh2AEZmt3ihip86m39kE+k3ikMxa6VvxcXjxjtEhOxCj2MKP7qW3MtVlzBOTjfgKfBINeklYCEi6VGUQLuY+Z8exMjf4BAeKMSBQBrCOyc37TgT8QkKgxQU2CuBLKjLqSZh1EoYy8ncithysT70dPpjo+FK1VGIkcDqEKqaHlzQRy1umfUwND5WmAfOBTUaIi4mKeh3QmPFmW2cPVJmij8OkFpHcB0OGRig
DKIM-Signature: a=rsa-sha256; bh=ypU7R1oYn27Z8vPfykyh9rKLMeRMbWPSK3OpCSJOAYs=;
 c=relaxed/relaxed; d=pixelcluster.dev; h=From; s=ovhmo-selector-1;
 t=1785877696; v=1;
 b=YVE8B6D8tg50NAX+YDn6N2hVI+3SeuDz7VANKJdfqcUdQPyErG0cmDp+2NDHzlpqlaCYsfm8
 zbmDKntNG9pLxLR5JXgcb3+ZCMriluxF5oLp/WfCRZl7a+QRYgjbpUUFhi+19t9aq5AxRqcd9hQ
 vFEZ+GgU82zf2Jr9rTLxf4THw3YTzqPtqmtrHIYcH7V8Xikph/UNUB+6Pfnwy2GXHyTxcTq6QGU
 dsGSOn7Z+mbXGFgVLC8l07XVWvbDAed47dhN/pgKmO6ivfvaug7q26uxooUtFrDXkkgPj7bh6y5
 jOp9vH7H32wsGwPidHs4oQ1mggCFrPSBC8kRsr76pISFg==

On 8/4/26 22:56, Thadeu Lima de Souza Cascardo wrote:
> On Tue, Aug 04, 2026 at 10:41:25PM +0200, Maarten Lankhorst wrote:
>> Hey,
>>
>> On 8/4/26 22:26, Natalie Vock wrote:
>>> On 8/4/26 22:18, Maarten Lankhorst wrote:
>>>>
>>>>
>>>> On 8/4/26 10:25, Natalie Vock wrote:
>>>>> This helps to find a common subtree of two resources, which is important
>>>>> when determining whether it's helpful to evict one resource in favor of
>>>>> another.
>>>>>
>>>>> To facilitate this, add a common helper to find the ancestor of two
>>>>> cgroups using each cgroup's ancestor array.
>>>>>
>>>>> Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
>>>>> ---
>>>>>    include/linux/cgroup.h      | 21 +++++++++++++++++++++
>>>>>    include/linux/cgroup_dmem.h |  9 +++++++++
>>>>>    kernel/cgroup/dmem.c        | 41 +++++++++++++++++++++++++++++++++++++++++
>>>>>    3 files changed, 71 insertions(+)
>>>>>
>>>>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>>>>> index f2aa46a4f871e..83a17ded1c516 100644
>>>>> --- a/include/linux/cgroup.h
>>>>> +++ b/include/linux/cgroup.h
>>>>> @@ -623,6 +623,27 @@ static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
>>>>>        return cgrp->ancestors[ancestor_level];
>>>>>    }
>>>>>    +/**
>>>>> + * cgroup_common_ancestor - find common ancestor of two cgroups
>>>>> + * @a: first cgroup to find common ancestor of
>>>>> + * @b: second cgroup to find common ancestor of
>>>>> + *
>>>>> + * Find the first cgroup that is an ancestor of both @a and @b, if it exists
>>>>> + * and return a pointer to it. If such a cgroup doesn't exist, return NULL.
>>>>> + *
>>>>> + * This function is safe to call as long as both @a and @b are accessible.
>>>>> + */
>>>>> +static inline struct cgroup *cgroup_common_ancestor(struct cgroup *a,
>>>>> +                            struct cgroup *b)
>>>>> +{
>>>>> +    int level;
>>>>> +
>>>>> +    for (level = min(a->level, b->level); level >= 0; level--)
>>>>> +        if (a->ancestors[level] == b->ancestors[level])
>>>>> +            return a->ancestors[level];
>>>>> +    return NULL;
>>>>> +}
>>>>> +
>>>>>    /**
>>>>>     * task_under_cgroup_hierarchy - test task's membership of cgroup ancestry
>>>>>     * @task: the task to be tested
>>>>> diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
>>>>> index 1a88cd0c9eb00..9d72457c4cb9d 100644
>>>>> --- a/include/linux/cgroup_dmem.h
>>>>> +++ b/include/linux/cgroup_dmem.h
>>>>> @@ -28,6 +28,8 @@ bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
>>>>>                   struct dmem_cgroup_pool_state *test);
>>>>>    bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>>>>>                   struct dmem_cgroup_pool_state *test);
>>>>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
>>>>> +                                   struct dmem_cgroup_pool_state *b);
>>>>>      void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
>>>>>    #else
>>>>> @@ -75,6 +77,13 @@ static inline bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>>>>>        return false;
>>>>>    }
>>>>>    +static inline
>>>>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
>>>>> +                                   struct dmem_cgroup_pool_state *b)
>>>>> +{
>>>>> +    return NULL;
>>>>> +}
>>>>> +
>>>>>    static inline void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool)
>>>>>    { }
>>>>>    diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
>>>>> index 9df3b33c65046..a587611ca2235 100644
>>>>> --- a/kernel/cgroup/dmem.c
>>>>> +++ b/kernel/cgroup/dmem.c
>>>>> @@ -762,6 +762,47 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>>>>>    }
>>>>>    EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
>>>>>    +/**
>>>>> + * dmem_cgroup_get_common_ancestor(): Find the first common ancestor of two pools.
>>>>> + * @a: First pool to find the common ancestor of.
>>>>> + * @b: First pool to find the common ancestor of.
>>>>> + *
>>>>> + * Return: The first pool that is a parent of both @a and @b, or NULL if either @a or @b are NULL,
>>>>> + * or if such a pool does not exist. A reference to the returned pool is grabbed and must be
>>>>> + * released by the caller when it is done using the pool.
>>>>> + */
>>>>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
>>>>> +                                   struct dmem_cgroup_pool_state *b)
>>>>> +{
>>>>> +    struct cgroup *ancestor_cgroup;
>>>>> +    struct cgroup_subsys_state *ancestor_css;
>>>>> +    struct dmemcg_state *ancestor_dmemcs = NULL;
>>>>> +    struct dmem_cgroup_pool_state *pool = NULL;
>>>>> +
>>>>> +    if (!a || !b)
>>>>> +        return NULL;
>>>>> +
>>>>> +    ancestor_cgroup = cgroup_common_ancestor(a->cs->css.cgroup, b->cs->css.cgroup);
>>>>> +    if (!ancestor_cgroup)
>>>>> +        return NULL;
>>>>> +
>>>>> +    rcu_read_lock();
>>>>> +    ancestor_css = cgroup_e_css(ancestor_cgroup, &dmem_cgrp_subsys);
>>>>> +    if (css_tryget(ancestor_css))
>>>>> +        ancestor_dmemcs = css_to_dmemcs(ancestor_css);
>>>>> +    rcu_read_unlock();
>>>>> +
>>>>> +    if (ancestor_dmemcs) {
>>>>> +        pool = get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
>>>>> +                        a->region);
>>>>> +        if (IS_ERR(pool))
>>>>> +            pool = NULL;
>>>> This should probably be a warn_on as this can never happen, sashiko is wrong here.
>>>>
>>>> If a and b are charged, all their ancestors are charged too. And when they share a
>>>> common ancestor, then the common ancestor has to have an existing charged pool as
>>>> well because there's a huge bug in the code otherwise.
>>>>
>>>>> +        css_put(ancestor_css);
>>>>> +    }
>>>>> +    return pool;
>>>>> +}
>>>>> +EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
>>>>> +
>>>>>    static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
>>>>>    {
>>>>>        struct dmem_cgroup_region *region;
>>>>>
>>>>
>>>> Otherwise looks good, so feel free to extend my r-b to this patch too, and with that minor fix up commit it.
>>>
>>> Thanks a lot! Correct me if I'm wrong here as it's been a while, but I think sashiko's current comment about the css_put(ancestor_css) being wrong seems to have merit too? Since dmem_cgroup_pool_state_put() also puts a css reference but get_cg_pool_unlocked does not get another reference to the css on its own? (Kind of a footgun if you ask me, but not something for this series)
>>>
>>> Mind if I also drop the css_put() line while I'm at it and *then* (finally :D) commit?
>> I'd keep the css_put for the failure case then.
>>
>> Since the get_cg_pool_unlocked() is a local function, it's less of an issue that it doesn't
>> obtain a reference itself, as all callers outside dmemcg.c never notice.
>>
>> Maybe do a final round of testing too, in case it introduces new failures. :-)
>>
>> Especially device unload/reload might show double puts. But otherwise looks good to me.
>>
>> Kind regards,
>> ~Maarten
> 
> I wrote the fixup at [1] that included that css_put. I will look into the
> possibility of get_cg_pool_unlocked returning NULL or error. But I find
> that unconditionally calling css_put here is wrong. If pool is NULL, it
> needs to be called, because otherwise the css_tryget will be unbalanced.
> 
> The reason not to call it unconditionally is that it will be called when
> dmem_cgroup_pool_state_put is caled, hence, balancing the css_tryget.
> 
> I also need to consider whether doing it outside the RCU section is fine.

Why not? We acquire a reference within the RCU critical section, and if 
we have that reference we're obviously safe against concurrent frees, 
because the refcount is not zero (so it's invalid to free the object).

If css_tryget fails, the refcount was already zero and the css is about 
to be freed, in which case this does nothing. (Your initial fixup 
dropped another reference in that case, which is invalid as it pretty 
much guarantees a refcount underflow.)

> 
> I just looked here and one of the possibilities for pool to be NULL is that
> the region is unregistered in a race condition. region->unregistered is
> protected by dmemcg_lock, but that is taken by get_cg_pool_unlocked, so it
> seems possible.
> 
> By the way, while testing the whole series, I see many different issues
> here that I am still looking at as they may be otherwise hidden
> pre-existing bugs.

What's "many different" issues? I'm aware of your testing showing one 
potential issue, which is that dmem.min protection may evict own cgroups 
instead of others' cgroups. I didn't do anything about that in this 
series because I think it's a pre-existing issue that I'm fairly sure is 
at least theoretically triggerable without my patchset.

Are there any other issues I missed?

Regards,
Natalie

> 
> Regards.
> Cascardo.
> 
> [1] https://lore.kernel.org/cgroups/ahW8MY4XBox_nsmB@quatroqueijos.cascardo.eti.br/

