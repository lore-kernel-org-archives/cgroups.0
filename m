From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/3] mm, memcg: Don't put offlined memcg into local stock
Date: Mon, 31 Jan 2022 12:25:05 -0500
Message-ID: <9abc9cb8-8734-90b0-c495-8df89c7bb579@redhat.com>
References: <20211001190938.14050-1-longman@redhat.com>
 <20211001190938.14050-2-longman@redhat.com>
 <YVefHLo1+6lgw3aB@carbon.dhcp.thefacebook.com>
 <f7026256-4086-6632-569e-5b13594cb3fc@redhat.com>
 <YfgV2iiaVlR0hozD@carbon.dhcp.thefacebook.com>
 <95ba1931-e9c9-45c3-b080-d28f2ad368a7@redhat.com>
 <c950a93d-bb70-9a97-dabe-a1d58d755dad@redhat.com>
 <YfgaIcSJhqEOnh65@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643649913;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PaMPeaT7bqTywU/6EXOdBYInz5ZUKSgh51n5zqNu8us=;
        b=SdsQt7oSykSd+YU9Ahe1hqcwFqg61gHRjbsMh+/IXP8gHOrlrI9VQqc/CqW8CrLs0TXe9e
        /fpSeo155cS3r5tYPCbg2jT0dpf9DVpTU8FItiytL3dNNJ+R1WcJxHesGr2uTLIVqOvblL
        K9KLkSINzSBqcaV8d7J54rAd0DImFuc=
Content-Language: en-US
In-Reply-To: <YfgaIcSJhqEOnh65-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

On 1/31/22 12:19, Roman Gushchin wrote:
> On Mon, Jan 31, 2022 at 12:15:19PM -0500, Waiman Long wrote:
>> On 1/31/22 12:09, Waiman Long wrote:
>>> On 1/31/22 12:01, Roman Gushchin wrote:
>>>> On Sun, Jan 30, 2022 at 10:55:56PM -0500, Waiman Long wrote:
>>>>> On 10/1/21 19:51, Roman Gushchin wrote:
>>>>>> On Fri, Oct 01, 2021 at 03:09:36PM -0400, Waiman Long wrote:
>>>>>>> When freeing a page associated with an offlined memcg, refill_stock()
>>>>>>> will put it into local stock delaying its demise until another memcg
>>>>>>> comes in to take its place in the stock. To avoid that, we now check
>>>>>>> for offlined memcg and go directly in this case to the slowpath for
>>>>>>> the uncharge via the repurposed cancel_charge() function.
>>>>>> Hi Waiman!
>>>>>>
>>>>>> I'm afraid it can make a cleanup of a dying cgroup slower: for every
>>>>>> released page we'll potentially traverse the whole cgroup tree and
>>>>>> decrease atomic page counters.
>>>>>>
>>>>>> I'm not sure I understand the benefits we get from this change which
>>>>>> do justify the slowdown on the cleanup path.
>>>>>>
>>>>>> Thanks!
>>>>> I was notified of a lockdep splat that this patch may help to prevent.
>>>> Would you mind to test this patch:
>>>> https://www.spinics.net/lists/cgroups/msg31244.html  ?
>>>>
>>>> It should address this dependency.
>>> Thanks for the pointer. I believe that your patch should be able to
>>> address this circular locking dependency.
>>>
>>> Feel free to add my
>>>
>>> Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> BTW, have you posted it to lkml? If not, would you mind doing so?
> Not yet.
>
> I was waiting for Alexander to confirm that it resolves the originally reported
> issue. I just pinged him, will wait for tomorrow and post the patch in any case.
>
> Thanks!

I see. This is not a problem that is easily reproducible. You need to 
hit the right timing for the lockdep splat to appear.

Regards,
Longman

