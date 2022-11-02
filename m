From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v4 1/5] block, bfq: remove set but not used variable
 in __bfq_entity_update_weight_prio
Date: Tue, 1 Nov 2022 20:24:41 -0600
Message-ID: <0ddaf04b-84b5-8173-a67c-5dadce684108@kernel.dk>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
 <20221102022542.3621219-2-yukuai1@huaweicloud.com>
 <7f7e59cb-e0b8-0db5-7c46-11aea963bcfa@kernel.dk>
 <ee543096-ae21-99d3-f3a5-483deab03a5f@kernel.dk>
 <61725ff6-6da3-3d3c-4261-7f05c57ab9da@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S7UBdmk5MbBq8xf2xERnJFzAhfjmMFD1Ky4jz35lNF8=;
        b=Ov3ploiPrzbeq6flPiF5LhBY7nXtGzNgcCAIY30CnXl+B32v/IR7MR9/Rr7Y5yuWlK
         yzO9kkalrV7/xaphq3qK7InlXhNHnVNq0gvmWKqYQsr1S3A+U5F/XTl2w9rtiOy3zn72
         QhjChHTrUAzLJd39wvxVjEkG4pGXGaVaBK5U4flJlX+0boaeHtRZWOuZGTIWo+dBjlv0
         it64h/ou+b/y6xcAl7s8bSFN3dLtinvtt7Fo3iRcOSBVO1DSzdGijmNgbb4LafoQvvNq
         yw3BWEYKEKxP9N8XKSQox7JZixChmshToPYAbDvxd9BeL5DzUEr8Aa6lKQKQTfXr4Kvd
         EFlg==
Content-Language: en-US
In-Reply-To: <61725ff6-6da3-3d3c-4261-7f05c57ab9da-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On 11/1/22 8:18 PM, Yu Kuai wrote:
> Hi,
> 
> 在 2022/11/02 10:11, Jens Axboe 写道:
>> On 11/1/22 8:09 PM, Jens Axboe wrote:
>>> On 11/1/22 8:25 PM, Yu Kuai wrote:
>>>> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>>>>
>>>> After the patch "block, bfq: cleanup bfq_weights_tree add/remove apis"),
>>>> the local variable 'bfqd' is not used anymore, thus remove it.
>>>
>>> Please add a Fixes tag.
>>
>> Looks like the rest were good to go, so I added it myself.
> 
> Thanks for helping out. I'm not sure which commit id to use since the
> fixed patch is not in linux-next yet, does the commit id stay the same
> when the patch applied from for-6.2 to next ?

linux-next shas are not stable, but since you're sending this to the
linux-block list and against the block tree, that's obviously where
you'd find that commit.

-- 
Jens Axboe


