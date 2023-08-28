From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 13:27:23 -0400
Message-ID: <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com>
References: <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
 <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
 <CAJD7tka34WjtwBWfkTu8ZCEUkLm7h-AyCXpw=h34n4RZ5qBVwA@mail.gmail.com>
 <ZOcDLD/1WaOwWis9@dhcp22.suse.cz>
 <CAJD7tkZby2enWa8_Js8joHqFx_tHB=aRqHOizaSiXMUjvEei4g@mail.gmail.com>
 <CAJD7tkadEtjK_NFwRe8yhUh_Mdx9LCLmCuj5Ty-pqp1rHTb-DA@mail.gmail.com>
 <ZOhSyvDxAyYUJ45i@dhcp22.suse.cz>
 <CAJD7tkYPyb+2zOKqctQw-vhuwYRg85e6v2Y44xWJofHZ+F+YQw@mail.gmail.com>
 <ZOzBgfzlGdrPD4gk@dhcp22.suse.cz>
 <CAJD7tkakMcaR_6NygEXCt6GF8TOuzYAUQe1im+vu2F3G4jtz=w@mail.gmail.com>
 <CALvZod7uxDd3Lrd3VwTTC-SDvqhdj2Ly-dYVswO=TBM=XTnkcg@mail.gmail.com>
 <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693243650;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mTV3kc++LcBibzlZRT0m+JhqLh8u4GMXYkeVqu8ur3w=;
        b=dAuTewKKarS5GexVgo9iPT5pnh54hhLPML/ogK8Ne6MMdCZ7bKP5IfEtgSfPpNLOt4v78n
        sFH9aTe4GGm0KnY6PYadO+/6ZiD67gigZ8FfmvSBPbIzAiPgT+ENaFUkCb3ylkzcJHvmxY
        3V/ncAlNWxsQ79P/TyZTRSBIAUpgEVU=
Content-Language: en-US
In-Reply-To: <CAJD7tkbnvMCNfQwY_dmVe2SWR5NeN+3RzFhsVyimM1ATaX0D5A@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org


On 8/28/23 13:07, Yosry Ahmed wrote:
>
>> Here I agree with you. Let's go with the approach which is easy to
>> undo for now. Though I prefer the new explicit interface for flushing,
>> that step would be very hard to undo. Let's reevaluate if the proposed
>> approach shows negative impact on production traffic and I think
>> Cloudflare folks can give us the results soon.
> Do you prefer we also switch to using a mutex (with preemption
> disabled) to avoid the scenario Michal described where flushers give
> up the lock and sleep resulting in an unbounded wait time in the worst
> case?

Locking with mutex with preemption disabled is an oxymoron. Use spinlock 
if you want to have preemption disabled. The purpose of usiing mutex is 
to allow the lock owner to sleep, but you can't sleep with preemption 
disabled. You need to enable preemption first. You can disable 
preemption for a short time in a non-sleeping section of the lock 
critical section, but I would not recommend disabling preemption for the 
whole critical section.

Cheers,
Longman

