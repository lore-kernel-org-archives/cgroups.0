From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Sun, 22 May 2022 19:24:37 -0600
Message-ID: <b32ed748-a141-862c-ed35-debb474962ed@kernel.dk>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
 <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
 <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oximGdL85AdyYM4EyrHBMR8JY42eOGAKAouksms98f0=;
        b=pxJ2UZmJRrY2NLXz4OLAZ67pT7PJyixhai/tBlwrwNUjBRr2Udq+056WLiclqUMvTB
         4wcC8pgS+GP0WO+CZHJMuYGwNxuusVHJFZiD7vp9f8RQ/myi6BbozzuhsWIBOopwlrL/
         kWN6Qlngaz8YJjX+3Qe5O1hpgPiR7WpgMJpewWQIplVVcjOxnX+QXsMGe3StX+4ZQpZF
         4s7aK6xqj7cPwtpRBin3N0DduqOlwrwLGhDAXaIblyfx5wSap5mPaGLJoMjrYt4qz3aU
         VkmLiY+dEYPkpbAFKIlrO5EhGWlNWrOC74rEqzgx3wQPO5mjKBV46fHwvHeL73yt89bu
         YLCw==
Content-Language: en-US
In-Reply-To: <55919e29-1f22-e8aa-f3d2-08c57d9e1c22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 5/22/22 7:10 PM, yukuai (C) wrote:
> ? 2022/05/21 20:21, Jens Axboe ??:
>> On 5/21/22 1:22 AM, yukuai (C) wrote:
>>> ? 2022/05/14 17:29, yukuai (C) ??:
>>>> ? 2022/05/05 9:00, yukuai (C) ??:
>>>>> Hi, Paolo
>>>>>
>>>>> Can you take a look at this patchset? It has been quite a long time
>>>>> since we spotted this problem...
>>>>>
>>>>
>>>> friendly ping ...
>>> friendly ping ...
>>
>> I can't speak for Paolo, but I've mentioned before that the majority
>> of your messages end up in my spam. That's still the case, in fact
>> I just marked maybe 10 of them as not spam.
>>
>> You really need to get this issued sorted out, or you will continue
>> to have patches ignore because folks may simply not see them.
>>
> Hi,
> 
> Thanks for your notice.
> 
> Is it just me or do you see someone else's messages from *huawei.com
> end up in spam? I tried to seek help from our IT support, however, they
> didn't find anything unusual...

Not sure, I think it's just you. It may be the name as well "yukuai (C)"
probably makes gmail think it's not a real name? Or maybe it's the
yukuai3 in the email? Pure speculation on my side.

-- 
Jens Axboe

