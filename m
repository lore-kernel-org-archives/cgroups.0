From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/1] block, bfq: remove bfq prefix from cgroups filenames
Date: Mon, 16 Sep 2019 10:01:40 -0600
Message-ID: <91deff5b-4a0d-a7ef-8bb2-7e7e5dad767b@kernel.dk>
References: <20190909073117.20625-1-paolo.valente@linaro.org>
 <80C56C11-DA21-4036-9006-2F459ACE9A8C@linaro.org>
 <c67c4d4b-ee56-85c1-5b94-7ae1704918b6@kernel.dk>
 <1F3898DA-C61F-4FA7-B586-F0FA0CAF5069@linaro.org>
 <20190916151643.GC3084169@devbig004.ftw2.facebook.com>
 <64329DDB-FFF4-4709-83B1-39D5E6BF6AB6@linaro.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BEJp88C2i8e+N1eeCwl/bIylkv3ygkyUoC1HYN2SV/k=;
        b=jhfxILuEU5LSCsXnCz+qhXGXW+5xTSEXtoXYBOnG0tgqgkC8QZkpPUuxQS62iaEG8G
         lT+fOZdcERuiq+rmr7NKKowWHPu1M3Nlu66ab6zYsjKUrb1NfoiBR4+pGdYnWyXPH9ia
         n72cJDV1heSbw50qfUMyU8NJuMBHfd7NNfFemrdfpdYGV14gqqhLmCvweCBP5OZh0Eid
         +tex2GW5MJvYVr4jZm8KmWW4oUqRExEUbwAwIJp6twGSL36gZnm0rNMmHBRrI4tzbdag
         NGG8To8FUUqrnZkyiDoHUAbv71m5kZ38+aZMFOph6Txy+3qAiacUbGFD9gw64AHhFR/A
         T/VA==
In-Reply-To: <64329DDB-FFF4-4709-83B1-39D5E6BF6AB6@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Paolo Valente <paolo.valente@linaro.org>, Tejun Heo <tj@kernel.org>
Cc: linux-block <linux-block@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Ulf Hansson <ulf.hansson@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, noreply-spamdigest via bfq-iosched <bfq-iosched@googlegroups.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, cgroups@vger.kernel.org

On 9/16/19 9:21 AM, Paolo Valente wrote:
> 
> 
>> Il giorno 16 set 2019, alle ore 17:16, Tejun Heo <tj@kernel.org> ha scritto:
>>
>> Hello, Paolo.
>>
>> On Mon, Sep 16, 2019 at 05:07:29PM +0200, Paolo Valente wrote:
>>> Tejun, could you put your switch-off-io-cost code into a standalone
>>> patch, so that I can put it together with this one in a complete
>>> series?
>>
>> It was more of a proof-of-concept / example, so the note in the email
>> that the code is free to be modified / used any way you see fit.  That
>> said, if you like it as it is, I can surely prep it as a standalone
>> patch.
>>
> 
> AFAICT your proposal contains no evident error.  Plus, no one seems to
> have complained about the idea (regardless from the exact
> implementation).  So I guess the best next step is to go for it.

Not filling me with a lot of confidence that you actually tested it?

-- 
Jens Axboe

