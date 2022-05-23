From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH -next v5 0/3] support concurrent sync io for bfq on a
 specail occasion
Date: Mon, 23 May 2022 07:29:00 -0600
Message-ID: <f1a08877-e27f-6520-272d-a3e6598f97b9@kernel.dk>
References: <20220428120837.3737765-1-yukuai3@huawei.com>
 <d50df657-d859-79cf-c292-412eaa383d2c@huawei.com>
 <61b67d5e-829c-8130-7bda-81615d654829@huawei.com>
 <81411289-e13c-20f5-df63-c059babca57a@huawei.com>
 <d5a90a08-1ac6-587a-e900-0436bd45543a@kernel.dk>
 <55919e29-1f22-e8aa-f3d2-08c57d9e1c22@huawei.com>
 <b32ed748-a141-862c-ed35-debb474962ed@kernel.dk>
 <1172d00f-0843-1d7c-721f-fdb60a0945cb@huawei.com>
 <dfd2ac0b-74da-85f4-ff66-2eb307578d93@kernel.dk>
 <8f0b5115-6a96-d5eb-5243-0be832cf121b@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=C3bZbEaAq3Xu1O+OItJ+lvJSF2o3pyc0onzZAOeeJCk=;
        b=mIybBL1U6Elcn4NFipNHc5oYx+P5Xk/K0gsj85ZVi5o0E3KwuASAj4EvcTaDp/36nj
         jP1tJ4Jbnb4vasuwpfNDRsYJbfLxNA06dWhQ47QuAk/4RciDwvzHhvr4ZfEclYuY07jK
         fyswcaPhtbpzv+HtgMjrpL14+hJxbjhHfys+P4F2FtOj+8fSuy/Ge9UahGkhgN3nyn5G
         tcnNDsRQCe3AVMSUSp371ndlhVm2cueqcTjzWm4bmNxdo1wQse2nsxh9wEw/7THhxzz2
         fsLXjpoEBx0WzKoOA3XUajKrGaIzhE1D5ZQ3bAfiHNHr18QdHkYwLtje3LghS5hTLHY5
         8shw==
Content-Language: en-US
In-Reply-To: <8f0b5115-6a96-d5eb-5243-0be832cf121b@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai3@huawei.com>, paolo.valente@linaro.org
Cc: jack@suse.cz, tj@kernel.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On 5/23/22 6:58 AM, Yu Kuai wrote:
> ? 2022/05/23 20:36, Jens Axboe ??:
>> On 5/23/22 2:18 AM, Yu Kuai wrote:
>>> ? 2022/05/23 9:24, Jens Axboe ??:
>>>> On 5/22/22 7:10 PM, yukuai (C) wrote:
>>>>> ? 2022/05/21 20:21, Jens Axboe ??:
>>>>>> On 5/21/22 1:22 AM, yukuai (C) wrote:
>>>>>>> ? 2022/05/14 17:29, yukuai (C) ??:
>>>>>>>> ? 2022/05/05 9:00, yukuai (C) ??:
>>>>>>>>> Hi, Paolo
>>>>>>>>>
>>>>>>>>> Can you take a look at this patchset? It has been quite a long time
>>>>>>>>> since we spotted this problem...
>>>>>>>>>
>>>>>>>>
>>>>>>>> friendly ping ...
>>>>>>> friendly ping ...
>>>>>>
>>>>>> I can't speak for Paolo, but I've mentioned before that the majority
>>>>>> of your messages end up in my spam. That's still the case, in fact
>>>>>> I just marked maybe 10 of them as not spam.
>>>>>>
>>>>>> You really need to get this issued sorted out, or you will continue
>>>>>> to have patches ignore because folks may simply not see them.
>>>>>>
>>>>> Hi,
>>>>>
>>>>> Thanks for your notice.
>>>>>
>>>>> Is it just me or do you see someone else's messages from *huawei.com
>>>>> end up in spam? I tried to seek help from our IT support, however, they
>>>>> didn't find anything unusual...
>>>>
>>>> Not sure, I think it's just you. It may be the name as well "yukuai (C)"
>>> Hi, Jens
>>>
>>> I just change this default name "yukuai (C)" to "Yu Kuai", can you
>>> please have a check if following emails still go to spam?
>>>
>>> https://lore.kernel.org/all/20220523082633.2324980-1-yukuai3@huawei.com/
>>
>> These did not go into spam, were delivered just fine.
>>
> Cheers for solving this, I'll resend this patchset just in case they are
> in spam for Paolo...

Let's hope it's solved, you never know with gmail... But that series did
go through fine as well, fwiw.

-- 
Jens Axboe

