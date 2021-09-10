From: brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and
 misc_events.local
Date: Fri, 10 Sep 2021 13:20:37 +0800
Message-ID: <8259b666-f3a4-6788-880c-38d679414bcb@gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <20210909143702.GA13761@blackbody.suse.cz>
 <CAHVum0eGN=v1kLqHQg7HBESp8Kg4aGZFNd4XTpxfeyToXPmPVg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BLhN9TB7Ol57sQQenKldl3mBRnGfktBhdGML7tJA3Ww=;
        b=hktGUARwAQCs/rrNssjoUdMQwzYznSPdwPBEc22JFRemiMjqWDYzC+dzoeKKnhYkVR
         T1b9xEKSF9jGM3t4ejhzDcAaOuGihnjoM9wLUIwdzf6I5vcf9wB0X50i3Gb5YBshLTWc
         3sTMapg+S1zz4st1unMb/cCOtt9BhQZrX/Bf8xUH/lTpNzBqpRF9fbSgYBO27yA2QBRK
         yJUoMwX+D+ewzlDCf/az0x2t/2YAi4ZQlePOx7sTheh6r5kQs8nw9NK8aU1cNzQ0X6ub
         iXVl4yiUgKfBdndy432DD6n6kFiQjT+nsjoFj4Wfro0AVRddDjIAZl1OBvQTR6FZMYvC
         5HeQ==
In-Reply-To: <CAHVum0eGN=v1kLqHQg7HBESp8Kg4aGZFNd4XTpxfeyToXPmPVg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Vipin Sharma <vipinsh-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org



Vipin Sharma wrote on 2021/9/10 1:08 上午:
> On Thu, Sep 9, 2021 at 7:37 AM Michal Koutný <mkoutny-IBi9RG/b67k@public.gmane.org> wrote:
>>
>> Hello Chunguang.
>>
>> The new version looks like a good step generally.
>>
>> My main remark is that I wouldn't make a distinct v1 and v2 interface,
>> it's a new controller so I think the v2 could be exposed in both cases
>> (or in other words, don't create new v1-specific features).
> 
> I agree with Michal. We can have the same interface for v1 otherwise
> there will not be any form of feedback in v1 for failures.

Yeah, this is more reasonable. But there is still one question, whether we
need to be consistent with other cgroup subsystems, events and events.local
under v1 should not support hierarchy？

>>
>> On Wed, Sep 08, 2021 at 01:24:34PM +0800, brookxu <brookxu.cn-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>>> +static int misc_events_show(struct seq_file *sf, void *v)
>>> +{
>>> +     struct misc_cg *cg = css_misc(seq_css(sf));
>>> +     unsigned long count, i;
>>> +
>>> +     for (i = 0; i < MISC_CG_RES_TYPES; i++) {
>>> +             count = atomic_long_read(&cg->events[i]);
>>> +             if (READ_ONCE(misc_res_capacity[i]) || count)
>>> +                     seq_printf(sf, "%s %lu\n", misc_res_name[i], count);
>>
>> More future-proof key would be
>>                         seq_printf(sf, "%s.max %lu\n", misc_res_name[i], count);
>> or
>>                         seq_printf(sf, "max.%s %lu\n", misc_res_name[i], count);
>>
>> (Which one is a judgement call but I'd include the "name" of event type too.)
>>
> I am inclined more towards "%s.max", it looks nice to see the resource
> name before its corresponding events

I also think %s.max may be more intuitive.
