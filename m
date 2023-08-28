From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Mon, 28 Aug 2023 13:43:08 -0400
Message-ID: <820843a5-d7a5-91a9-b861-99e7132ddb98@redhat.com>
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
 <599b167c-deaf-4b92-aa8b-5767b8608483@redhat.com>
 <CAJD7tkZsGfYXkWM5aa67v3JytTO04LS7_x+ooMDK82cBZ-C8eQ@mail.gmail.com>
 <307cbcf6-dca2-0b5d-93e8-11368a931d2f@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693244598;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c86heriCzsgHv8Cr404S+ZS20rU8EPrOqgUpkTE5NMI=;
        b=LjpZVQxxDsbtFV37kMU3PTEe17Qpp8E6g1kZirQb/LFu9GgSXWPO2JI+N40ciwe5Iy3WQZ
        Hmnv6qtxnCPypzCDdjm1AOsid1LIO9tYWbHUuh/dF7yeIi0R1KWLiK6HTEmNkbE2nukQih
        xOsJJ5hhdfCzUkO8F0u/DL2gnpcsw/k=
Content-Language: en-US
In-Reply-To: <307cbcf6-dca2-0b5d-93e8-11368a931d2f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


On 8/28/23 13:35, Waiman Long wrote:
> On 8/28/23 13:28, Yosry Ahmed wrote:
>> On Mon, Aug 28, 2023 at 10:27=E2=80=AFAM Waiman Long <longman-H+wXaHxf7a=
LQT0dZR+AlfA@public.gmane.org> wrote:
>>>
>>> On 8/28/23 13:07, Yosry Ahmed wrote:
>>>>> Here I agree with you. Let's go with the approach which is easy to
>>>>> undo for now. Though I prefer the new explicit interface for=20
>>>>> flushing,
>>>>> that step would be very hard to undo. Let's reevaluate if the=20
>>>>> proposed
>>>>> approach shows negative impact on production traffic and I think
>>>>> Cloudflare folks can give us the results soon.
>>>> Do you prefer we also switch to using a mutex (with preemption
>>>> disabled) to avoid the scenario Michal described where flushers give
>>>> up the lock and sleep resulting in an unbounded wait time in the worst
>>>> case?
>>> Locking with mutex with preemption disabled is an oxymoron. Use=20
>>> spinlock
>>> if you want to have preemption disabled. The purpose of usiing mutex is
>>> to allow the lock owner to sleep, but you can't sleep with preemption
>>> disabled. You need to enable preemption first. You can disable
>>> preemption for a short time in a non-sleeping section of the lock
>>> critical section, but I would not recommend disabling preemption for=20
>>> the
>>> whole critical section.
>> I thought using a mutex with preemption disabled would at least allow
>> waiters to sleep rather than spin, is this not correct (or doesn't
>> matter) ?
>
> Because of optimistic spinning, a mutex lock waiter will only sleep if=20
> the lock holder sleep or when its time slice run out. So the waiters=20
> are likely to spin for quite a while before they go to sleep.

Perhaps you can add a mutex at the read side so that only 1 reader can=20
contend with the global rstat spinlock at any time if this is a concern.

Regards,
Longman

