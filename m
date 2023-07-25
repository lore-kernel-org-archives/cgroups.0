From: Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH 12/17] cgroup/drm: Introduce weight based drm cgroup
 control
Date: Tue, 25 Jul 2023 14:46:58 +0100
Message-ID: <9200b403-6376-96da-d84c-783a3371f73f@linux.intel.com>
References: <20230712114605.519432-1-tvrtko.ursulin@linux.intel.com>
 <20230712114605.519432-13-tvrtko.ursulin@linux.intel.com>
 <ZLsEEYDFlJZwrJiV@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1690292825; x=1721828825;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+OP3tS0a6vPFOecpYmL8uA5ooqpSQiEgNnaksnOSZtQ=;
  b=bb7HfaBzkEk+MyncxF9qHtjbHTowxedaHPFbP5Mrknsf7XEzcDAiGexr
   aqavvuV+SdEdYGkafyMHSDC5l7N2OarRg2WIhNAFYEtOWOOlFTiMsn3Td
   SNGwrCYWUJrzZMlOUvqFStHSLkNmOxiDbyW4QrY0q1nxHhmm5KLu8PQlb
   5jvMrp8BafVNri0m03OpvI5aQlt5yxz+QUX10Pq42WjOWT/rH/huZ06D8
   X4XJmb3SX3HhYA1j1hc5jaweHnFuFlDxJpURlmg7VKdLlZ8uLfh5VrWw6
   faFG/oyqH3jA/v8BXy9TTSIjxcngx1zjo/pR+EP/3p87tUqEd4Co32g14
   Q==;
Content-Language: en-US
In-Reply-To: <ZLsEEYDFlJZwrJiV-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Intel-gfx-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Dave Airlie <airlied-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Daniel Vetter <daniel.vetter-/w4YWyX8dFk@public.gmane.org>, Rob Clark <robdclark-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, =?UTF-8?Q?St=c3=a9phane_Marchesin?= <marcheu-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, "T . J . Mercier" <tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Kenny.Ho-5C7GfCeVMHo@public.gmane.org, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig-5C7GfCeVMHo@public.gmane.org>, Brian Welty <brian.welty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>


On 21/07/2023 23:17, Tejun Heo wrote:
> On Wed, Jul 12, 2023 at 12:46:00PM +0100, Tvrtko Ursulin wrote:
>> +DRM scheduling soft limits
>> +~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Please don't say soft limits for this. It means something different for
> memcg, so it gets really confusing. Call it "weight based CPU time control"
> and maybe call the triggering points as thresholds.

Yes sorry, you said that before and I forgot to reword it all when 
re-spinning. I have now marked it as TODO in my email client so 
hopefully next time round I don't forget.

Regards,

Tvrtko
