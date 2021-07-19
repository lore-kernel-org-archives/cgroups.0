From: Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v5 02/16] memcg: enable accounting for IP address and
 routing-related objects
Date: Mon, 19 Jul 2021 15:24:43 +0100
Message-ID: <55811200-dfca-0cc6-9dd4-692066adf4c6@gmail.com>
References: <CALvZod66KF-8xKB1dyY2twizDE=svE8iXT_nqvsrfWg1a92f4A@mail.gmail.com>
 <cover.1626688654.git.vvs@virtuozzo.com>
 <9123bca3-23bb-1361-c48f-e468c81ad4f6@virtuozzo.com>
 <CAJwJo6ZgXDoXevNRte4G3Phei8WcgJ897JebWDkQDnPYrgTTQA@mail.gmail.com>
 <CALvZod7YhG1Ojp2Eyk=30OBzWr5_AyEW-c1AhQVDn7zpd6mpww@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=iJb8k19Y68cQ26kCOkNjiEf5YK8/nAR7Q1gJ3928CnI=;
        b=T0oK4JxzZ8pyuYqCEuhGFUWAm90vPZvpJ5FopJBMYTz5T9joodP1iNPyT5Ax6p0g74
         +By7csl0eik1QDfi+zDKjaQKIuXBH25O32x/7UkAwxQFMbqyFcPLfDla+dio31lZ+Fws
         Ui3gsGNqqBB5ou20NAOWzjtv3G0+ApgVzXdFFoxtg92nRejmXWt0nayD8jGGerDm7Vq9
         a68UeqZTbj6jRIO0HTy6Rwe2D9hCEqe4jlMD8Ijmg3v43e+RG9tampTKS6mmSQScfLmM
         pxaK8qVMzxglGQrCBofgSuRCATOMzTMpp3DainE2CPsKLMub59e+fb+Qn2+pjKnDeRqj
         LlQQ==
In-Reply-To: <CALvZod7YhG1Ojp2Eyk=30OBzWr5_AyEW-c1AhQVDn7zpd6mpww-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hideaki YOSHIFUJI <yoshfuji-VfPWfsRibaP+Ru+s062T9g@public.gmane.org>, David Ahern <dsahern-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Network Development <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 7/19/21 3:22 PM, Shakeel Butt wrote:
> On Mon, Jul 19, 2021 at 7:00 AM Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>
>> Hi Vasily,
>>
>> On Mon, 19 Jul 2021 at 11:45, Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:
>> [..]
>>> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>>> index ae1f5d0..1bbf239 100644
>>> --- a/mm/memcontrol.c
>>> +++ b/mm/memcontrol.c
>>> @@ -968,7 +968,7 @@ static __always_inline bool memcg_kmem_bypass(void)
>>>                 return false;
>>>
>>>         /* Memcg to charge can't be determined. */
>>> -       if (in_interrupt() || !current->mm || (current->flags & PF_KTHREAD))
>>> +       if (!in_task() || !current->mm || (current->flags & PF_KTHREAD))
>>>                 return true;
>>
>> This seems to do two separate things in one patch.
>> Probably, it's better to separate them.
>> (I may miss how route changes are related to more generic
>> __alloc_pages() change)
>>
> 
> It was requested to squash them together in some previous versions.
> https://lore.kernel.org/linux-mm/YEiUIf0old+AZssa-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/
> 

Ah, alright, never mind than.

Thanks,
           Dmitry
