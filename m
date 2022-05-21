From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Sat, 21 May 2022 06:21:28 -0600
Message-ID: <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gfHmtlCQtYvyaOp3BTWx/NwfcevCZ/dQvENt+OCB6OU=;
        b=i1Z7sKvKg/r7Fu90Re3JGKGo4OH8g8Rh6cF/OLtxysHA/ntRqQvqKVSVq2oF1hT6L4
         cNnY4wBcAg9kqs771D/Xc0PAxFm6ZZUDIHEvQjJlLqiY3ZTF1MkvntDJylyJoP3yjEBy
         aEgkl0OIh0MepffoSk4c1rEgxTlrxXHO0w8y7AoWrX0RPPOstSM83S7ponJCoxe2/3Fk
         cwTavtZmoY0/bOt2sJHHNhlb66apetZalZEVahMDSTFRMRHJpK3IFC3Iowh6/6VEjb2O
         U9kKXX8EL0eVtbcvNrYJg2Z3WKlp5dK6tZVXG5aOLhqu829Yw3YQXHKun68AuCwVTcgC
         vCTw==
Content-Language: en-US
In-Reply-To: <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "yukuai (C)" <yukuai3@huawei.com>, paolo.valente@linaro.org
Cc: jack@suse.cz, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On 5/21/22 1:22 AM, yukuai (C) wrote:
> 在 2022/05/14 17:29, yukuai (C) 写道:
>> 在 2022/05/05 9:00, yukuai (C) 写道:
>>> Hi, Paolo
>>>
>>> Can you take a look at this patchset? It has been quite a long time
>>> since we spotted this problem...
>>>
>>
>> friendly ping ...
> friendly ping ...

I can't speak for Paolo, but I've mentioned before that the majority
of your messages end up in my spam. That's still the case, in fact
I just marked maybe 10 of them as not spam.

You really need to get this issued sorted out, or you will continue
to have patches ignore because folks may simply not see them.

-- 
Jens Axboe

