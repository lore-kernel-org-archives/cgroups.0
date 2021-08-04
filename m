From: Waiman Long <llong-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Disable task obj_stock for PREEMPT_RT
Date: Wed, 4 Aug 2021 12:00:47 -0400
Message-ID: <ce048e8b-bd2d-7517-d8e0-f74be98b8dee@redhat.com>
References: <20210803175519.22298-1-longman@redhat.com> <87h7g62jxm.ffs@tglx>
 <8953e099-356e-ee09-a701-f4c7f4cda487@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628092852;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kEsjrzEf989GiFesEbeonJ3m9TGKEwxRikvJxw0JX+4=;
        b=cXMGZoc1XvE4W9cQAKBpJWkPubhcJ9qMGvNcV4EmEML4tyhcmO3kYmSqJCxJ1i8cR2CODz
        kA7+oRqHSjZeIxAe98IMGZ0rM6eeh5iSL+5/rvr3Ch1C0Hp8nj7E1Pv9/vrA03HhAxvyLG
        zFLS6nEb6d2Mvb1v806pb1wkn3ZTwz0=
In-Reply-To: <8953e099-356e-ee09-a701-f4c7f4cda487-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Luis Goncalves <lgoncalv-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On 8/3/21 9:40 PM, Waiman Long wrote:
> On 8/3/21 7:21 PM, Thomas Gleixner wrote:
>> To complete the analysis of drain_local_stock(). AFAICT that function
>> can only be called from task context. So what is the purpose of this
>> in_task() conditional there?
>>
>>     if (in_task())
>>            drain_obj_stock(&stock->task_obj);
> I haven't done a full analysis to see if it can be called from task 
> context only. Maybe in_task() check isn't needed, but having it there 
> provides the safety that it will still work in case it can be called 
> from interrupt context. 

After looking at possible call chains that can lead to 
drain_local_stock(), one call chain comes from the allocation of slab 
objects which I had previously determined to be callable from interrupt 
context. So it is prudent to add a in_task() check here.

Cheers,
Longman

