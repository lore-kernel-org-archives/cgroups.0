From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH-next v3] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Wed, 15 Dec 2021 11:58:45 -0500
Message-ID: <b50b7c01-c4fc-87bd-f5d9-80e6438cf670@redhat.com>
References: <20211214144412.447035-1-longman@redhat.com>
 <20211215043657.ngmxlk6rgc2ysbmz@offworld>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639587530;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=muCmOAWvr5CQnLclHX0MhSQxoOgFUPCsAa/pyphHI1Y=;
        b=G1nymf1uJak0Hd5rBW3+pLJ3dLeYpSbwji5DqdP3xuWFnZrAjzV3HV6YvgFWKGzJq2JDRb
        NbS/H8hSKyTYjlzH8aAfZ3jgf8bCIC3S3BhxmqG3NGRPpLLC037jhvUD2yFXmlhF1cOLEv
        fbtSl3ajrtLe4jThfcX0NspM072gXAw=
Content-Language: en-US
In-Reply-To: <20211215043657.ngmxlk6rgc2ysbmz@offworld>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>


On 12/14/21 23:36, Davidlohr Bueso wrote:
> On Tue, 14 Dec 2021, Waiman Long wrote:
>
>> @@ -2189,7 +2194,7 @@ static void drain_local_stock(struct 
>> work_struct *dummy)
>>      * drain_stock races is that we always operate on local CPU stock
>>      * here with IRQ disabled
>>      */
>> -    local_irq_save(flags);
>> +    local_lock_irqsave(&memcg_stock.lock, flags);
>>
>>     stock = this_cpu_ptr(&memcg_stock);
>>     drain_obj_stock(&stock->irq_obj);
>
> So here there is still the problem that you can end up taking sleeping 
> locks
> with irqs disabled via obj_cgroup_put() >> obj_cgroup_release() - ie: the
> percpu_ref_switch_lock and css_set_lock. It had occurred to me to promote
> the former to a raw spinlock, but doubt we can get away with the latter.

Yes, it is tricky to avoid all these. One possibility to to delay 
obj_cgroup_release() through RCU. However, this is outside the scope of 
this patch.

Cheers,
Longman

