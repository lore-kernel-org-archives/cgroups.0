Received: from smtpout1.mo2.mail-out.ovh.net (smtpout1.mo2.mail-out.ovh.net [79.137.123.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218C04C6F09
	for <cgroups@vger.kernel.org>; Tue,  4 Aug 2026 20:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.137.123.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785875245; cv=none; b=hIXvMUhQVLHjd2+ZlGXQPjmDZ2kIRdoqh/PGL2eWNlcgCdGI7H8VYW7yaEd8zesIWf7f7IilzKQQznzfgQLxlzrzDB0idZanybM4qososybRrYw2OnXYQ+kgNMQhpEQCHaJEwTaggy4xcaMW0WbQVL9UgKrJSaE5eqpkP6vkLJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785875245; c=relaxed/simple;
	bh=VhG1QwXM+Aro5jI3Gs5H/CnGR48vKnhr+ZExnl4fWHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ccWqiliPuHCe0ubmdlAIM90U1JMAHW1WFgmplEVOe1x7uBrFH0vfYJy0pIOjs6s6CEcRqSYyPeGtiUQCC+C2TxsphlVaYOUT7Zjjcyfzat6FT+N/hSdaxIH8AbHmQ86f1NvVp4w8vhzgTugCRX+Eob7Dewc3cyWS5EWmc/bJl80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev; spf=pass smtp.mailfrom=pixelcluster.dev; dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b=e/H3tm6d; arc=none smtp.client-ip=79.137.123.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pixelcluster.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pixelcluster.dev header.i=@pixelcluster.dev header.b="e/H3tm6d"
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net [57.128.106.70])
	by mo2.mail-out.ovh.net (Postfix) with ESMTPS id 4hF4pD5D9Fz427D;
	Tue,  4 Aug 2026 20:27:00 +0000 (UTC)
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net. [127.0.0.1])
        by director5.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <christian.koenig@amd.com>; Tue,  4 Aug 2026 20:27:00 +0000 (UTC)
Received: from mta10.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.178.206])
	by director5.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4hF4pD2Q10z7tL2;
	Tue,  4 Aug 2026 20:27:00 +0000 (UTC)
Received: from pixelcluster.dev (unknown [10.1.6.8])
	(Authenticated sender: nat@pixelcluster.dev)
	by mta10.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id E96AA781A39;
	Tue,  4 Aug 2026 20:26:57 +0000 (UTC)
Authentication-Results:garm.ovh; auth=pass (GARM-112S00684a3ba6b-d2a0-4fc3-a5dc-50d53c9da3d9,
                    554F327AB99B0CF81BA34543D1D055DA486C6A81) smtp.auth=nat@pixelcluster.dev
X-OVh-ClientIp:88.133.252.134
Message-ID: <7b2887b1-ecb7-4d6e-ad34-068ab1d7d41e@pixelcluster.dev>
Date: Tue, 4 Aug 2026 22:26:56 +0200
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/6] cgroup,cgroup/dmem: Add
 (dmem_)cgroup_common_ancestor helper
To: Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>,
 Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Matthew Brost <matthew.brost@intel.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Tvrtko Ursulin <tursulin@ursulin.net>,
 Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
 =?UTF-8?Q?Timur_Krist=C3=B3f?= <timur.kristof@gmail.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20260804-dmemcg-aggressive-protect-v8-0-07af96681bf8@gmx.de>
 <20260804-dmemcg-aggressive-protect-v8-2-07af96681bf8@gmx.de>
 <b5b80acd-feea-408b-87eb-4264ffc7e2cd@lankhorst.se>
Content-Language: en-US
From: Natalie Vock <nat@pixelcluster.dev>
In-Reply-To: <b5b80acd-feea-408b-87eb-4264ffc7e2cd@lankhorst.se>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 5409949055335162134
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTEwfM3XXNsWe8F7B5ju/64XjbGDFzh52YUwkSrtdI55WXiADmmINK3ZApOBeFbHCVXU/nRvtkTjqGBFjF1FtbFUN5+dmwuOaMvt2SdPSwTQuvRuRuAYEjo1F4g9BzNIIZeSNhwV3YOei/JIQNdyApC+RrFUnvwvqKew084ZvfVc8CQXVCxenGMKbaYSTvuvoBqXpoYhomjm8lMDE6absgExhaTs70aV1hHk5KaK1AkUe006mxvbL4aHPsUUUArELUe294F+SniWrUJXz5C57egcxp+meXVeV+MGXIj7wgtSV/n2YxF1f8bDx3118PE9sl/lcyh9lzorWkH5KaJ9gPIKSUiNl4p0wV2rw9D7gHBFWFjq8lkN5YpoJbietFhFaa/7ZFZvKyUwO8fa49vLhTGbq2FtBqhPtom7MsdLwhWdgMXriObXJ1lgxMFaFiZZBpIV9BKKLrc2AOV3w9lAFroerzB6xfD+sH1F7ACRh8+fPrF5lS2PRG4UbLWJlTLsPrNILJMA8ddSdK6UG79dZwRFXybPbHqf6lETLTZ+CJ+hdYvCF0xh9rsXHnew5PNoJ40wueZU7Q/scSp9UZorXR76mrc9ddGmIPPie21iTy1Q+hhvM3t/TVIMSS0kcGZ//cx9pg6xA7ZYMN08cS40/RyrE57jtvLysHHE9AsiVM7qUw
DKIM-Signature: a=rsa-sha256; bh=OWsSjdzRQizS7ptUXy3slBRvYZe2bgiMkPIBo/KEgpo=;
 c=relaxed/relaxed; d=pixelcluster.dev; h=From; s=ovhmo-selector-1;
 t=1785875222; v=1;
 b=e/H3tm6d+BnZ/WSV84Z26odQcgIZndGtjo2t5agdGWXqEDQ1we2IaBu7SAyMqhV/I6x88wm9
 hOzZXtDqProvGuFCf6lZ/AFwm5N7p0KVHwQzdM5FUNJmrAVO0tKE2ku3dql+Yh6DWfY55bZcSEN
 WxnsXY4yIgYLp5lrwsIKVci3ePINPLrsqDRLixVaDMOCpxFxMozYrB4oa1ZSxxc6MJHveigCPUW
 Y2jAzCcakUbrMRf8vOLYbMO90UKBSH5DpZPTPcSyyT4cWQ3gmwJAbcb8x/gJUBhc+C1xH8H9P8D
 FV6TR9/EEVrEQrcfs2hXIxobIZ2X9A/J7/6J/lJj3bdGg==

On 8/4/26 22:18, Maarten Lankhorst wrote:
> 
> 
> On 8/4/26 10:25, Natalie Vock wrote:
>> This helps to find a common subtree of two resources, which is important
>> when determining whether it's helpful to evict one resource in favor of
>> another.
>>
>> To facilitate this, add a common helper to find the ancestor of two
>> cgroups using each cgroup's ancestor array.
>>
>> Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
>> ---
>>   include/linux/cgroup.h      | 21 +++++++++++++++++++++
>>   include/linux/cgroup_dmem.h |  9 +++++++++
>>   kernel/cgroup/dmem.c        | 41 +++++++++++++++++++++++++++++++++++++++++
>>   3 files changed, 71 insertions(+)
>>
>> diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
>> index f2aa46a4f871e..83a17ded1c516 100644
>> --- a/include/linux/cgroup.h
>> +++ b/include/linux/cgroup.h
>> @@ -623,6 +623,27 @@ static inline struct cgroup *cgroup_ancestor(struct cgroup *cgrp,
>>   	return cgrp->ancestors[ancestor_level];
>>   }
>>   
>> +/**
>> + * cgroup_common_ancestor - find common ancestor of two cgroups
>> + * @a: first cgroup to find common ancestor of
>> + * @b: second cgroup to find common ancestor of
>> + *
>> + * Find the first cgroup that is an ancestor of both @a and @b, if it exists
>> + * and return a pointer to it. If such a cgroup doesn't exist, return NULL.
>> + *
>> + * This function is safe to call as long as both @a and @b are accessible.
>> + */
>> +static inline struct cgroup *cgroup_common_ancestor(struct cgroup *a,
>> +						    struct cgroup *b)
>> +{
>> +	int level;
>> +
>> +	for (level = min(a->level, b->level); level >= 0; level--)
>> +		if (a->ancestors[level] == b->ancestors[level])
>> +			return a->ancestors[level];
>> +	return NULL;
>> +}
>> +
>>   /**
>>    * task_under_cgroup_hierarchy - test task's membership of cgroup ancestry
>>    * @task: the task to be tested
>> diff --git a/include/linux/cgroup_dmem.h b/include/linux/cgroup_dmem.h
>> index 1a88cd0c9eb00..9d72457c4cb9d 100644
>> --- a/include/linux/cgroup_dmem.h
>> +++ b/include/linux/cgroup_dmem.h
>> @@ -28,6 +28,8 @@ bool dmem_cgroup_below_min(struct dmem_cgroup_pool_state *root,
>>   			   struct dmem_cgroup_pool_state *test);
>>   bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>>   			   struct dmem_cgroup_pool_state *test);
>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
>> +							       struct dmem_cgroup_pool_state *b);
>>   
>>   void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool);
>>   #else
>> @@ -75,6 +77,13 @@ static inline bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>>   	return false;
>>   }
>>   
>> +static inline
>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
>> +							       struct dmem_cgroup_pool_state *b)
>> +{
>> +	return NULL;
>> +}
>> +
>>   static inline void dmem_cgroup_pool_state_put(struct dmem_cgroup_pool_state *pool)
>>   { }
>>   
>> diff --git a/kernel/cgroup/dmem.c b/kernel/cgroup/dmem.c
>> index 9df3b33c65046..a587611ca2235 100644
>> --- a/kernel/cgroup/dmem.c
>> +++ b/kernel/cgroup/dmem.c
>> @@ -762,6 +762,47 @@ bool dmem_cgroup_below_low(struct dmem_cgroup_pool_state *root,
>>   }
>>   EXPORT_SYMBOL_GPL(dmem_cgroup_below_low);
>>   
>> +/**
>> + * dmem_cgroup_get_common_ancestor(): Find the first common ancestor of two pools.
>> + * @a: First pool to find the common ancestor of.
>> + * @b: First pool to find the common ancestor of.
>> + *
>> + * Return: The first pool that is a parent of both @a and @b, or NULL if either @a or @b are NULL,
>> + * or if such a pool does not exist. A reference to the returned pool is grabbed and must be
>> + * released by the caller when it is done using the pool.
>> + */
>> +struct dmem_cgroup_pool_state *dmem_cgroup_get_common_ancestor(struct dmem_cgroup_pool_state *a,
>> +							       struct dmem_cgroup_pool_state *b)
>> +{
>> +	struct cgroup *ancestor_cgroup;
>> +	struct cgroup_subsys_state *ancestor_css;
>> +	struct dmemcg_state *ancestor_dmemcs = NULL;
>> +	struct dmem_cgroup_pool_state *pool = NULL;
>> +
>> +	if (!a || !b)
>> +		return NULL;
>> +
>> +	ancestor_cgroup = cgroup_common_ancestor(a->cs->css.cgroup, b->cs->css.cgroup);
>> +	if (!ancestor_cgroup)
>> +		return NULL;
>> +
>> +	rcu_read_lock();
>> +	ancestor_css = cgroup_e_css(ancestor_cgroup, &dmem_cgrp_subsys);
>> +	if (css_tryget(ancestor_css))
>> +		ancestor_dmemcs = css_to_dmemcs(ancestor_css);
>> +	rcu_read_unlock();
>> +
>> +	if (ancestor_dmemcs) {
>> +		pool = get_cg_pool_unlocked(css_to_dmemcs(ancestor_css),
>> +					    a->region);
>> +		if (IS_ERR(pool))
>> +			pool = NULL;
> This should probably be a warn_on as this can never happen, sashiko is wrong here.
> 
> If a and b are charged, all their ancestors are charged too. And when they share a
> common ancestor, then the common ancestor has to have an existing charged pool as
> well because there's a huge bug in the code otherwise.
> 
>> +		css_put(ancestor_css);
>> +	}
>> +	return pool;
>> +}
>> +EXPORT_SYMBOL_GPL(dmem_cgroup_get_common_ancestor);
>> +
>>   static int dmem_cgroup_region_capacity_show(struct seq_file *sf, void *v)
>>   {
>>   	struct dmem_cgroup_region *region;
>>
> 
> Otherwise looks good, so feel free to extend my r-b to this patch too, and with that minor fix up commit it.

Thanks a lot! Correct me if I'm wrong here as it's been a while, but I 
think sashiko's current comment about the css_put(ancestor_css) being 
wrong seems to have merit too? Since dmem_cgroup_pool_state_put() also 
puts a css reference but get_cg_pool_unlocked does not get another 
reference to the css on its own? (Kind of a footgun if you ask me, but 
not something for this series)

Mind if I also drop the css_put() line while I'm at it and *then* 
(finally :D) commit?

Natalie

> 
> Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
> 

