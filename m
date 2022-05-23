From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Mon, 23 May 2022 06:36:58 -0600
Message-ID: <25f6703e-9e10-75d9-a893-6df1e6b75254@kernel.dk>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
 <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
 <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
 <20220523085902.wmxoebyq3crerecr@quack3.lan>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=L18DlrO1XtDATl5hYjR3u+d9RECswhbrU+Pb38Js3ks=;
        b=JPrsnrHfNbDWW8uJ6kKFgzO5szuJhqQJLtNpQJjh4Q321Oq3Dg2PJSwb344Snwl0aT
         6XvysX8RCg64WjCOz9hKQCekBRzdVnbvnWZBx2vl3DXsfMe6252Nh/8UA0xydXuCjfqP
         hqi4H3Vo0ZxSzk6qfBC+lAtshlsEebYPectaMGWkwKMpy2wxiHUF+F3GGuw9mtS5n/5C
         Om9NqySHY1pJx59ONDkraeOaSRduGCCNMnv/46+11kwCRSfHgKx7ht5oIBpJIa49jrqG
         bIPVZrHUwUVxzhPBrU+ujxfWluAP7f+yhsnBPpTNa2rq8GcRlJCw9MZ0qGRfGJ2nmu9C
         faUg==
Content-Language: en-US
In-Reply-To: <20220523085902.wmxoebyq3crerecr@quack3.lan>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jan Kara <jack@suse.cz>, "yukuai (C)" <yukuai3@huawei.com>
Cc: paolo.valente@linaro.org, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On 5/23/22 2:59 AM, Jan Kara wrote:
> On Mon 23-05-22 09:10:38, yukuai (C) wrote:
>> ? 2022/05/21 20:21, Jens Axboe ??:
>>> On 5/21/22 1:22 AM, yukuai (C) wrote:
>>>> ? 2022/05/14 17:29, yukuai (C) ??:
>>>>> ? 2022/05/05 9:00, yukuai (C) ??:
>>>>>> Hi, Paolo
>>>>>>
>>>>>> Can you take a look at this patchset? It has been quite a long time
>>>>>> since we spotted this problem...
>>>>>>
>>>>>
>>>>> friendly ping ...
>>>> friendly ping ...
>>>
>>> I can't speak for Paolo, but I've mentioned before that the majority
>>> of your messages end up in my spam. That's still the case, in fact
>>> I just marked maybe 10 of them as not spam.
>>>
>>> You really need to get this issued sorted out, or you will continue
>>> to have patches ignore because folks may simply not see them.
>>>
>> Hi,
>>
>> Thanks for your notice.
>>
>> Is it just me or do you see someone else's messages from *huawei.com
>> end up in spam? I tried to seek help from our IT support, however, they
>> didn't find anything unusual...
> 
> So actually I have noticed that a lot of (valid) email from huawei.com (not
> just you) ends up in the spam mailbox. For me direct messages usually pass
> (likely matching SPF records for originating mail server save the email
> from going to spam) but messages going through mailing lists are flagged as
> spam because the emails are missing valid DKIM signature but huawei.com
> DMARC config says there should be DKIM signature (even direct messages are
> missing DKIM so this does not seem as a mailing list configuration issue).
> So this seems as some misconfiguration of the mails on huawei.com side
> (likely missing DKIM signing of outgoing email).

SPF/DKIM was indeed a problem earlier for yukaui patches, but I don't
see that anymore. Maybe it's still an issue for some emails, from them
or Huawei in general?

-- 
Jens Axboe

