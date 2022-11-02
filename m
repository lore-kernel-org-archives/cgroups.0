From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v4 1/5] block, bfq: remove set but not used variable
 in __bfq_entity_update_weight_prio
Date: Tue, 1 Nov 2022 20:09:44 -0600
Message-ID: <7f7e59cb-e0b8-0db5-7c46-11aea963bcfa@kernel.dk>
References: <20221102022542.3621219-1-yukuai1@huaweicloud.com>
 <20221102022542.3621219-2-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=B/9nbqKAy6prDAS3oMmtklZfg/ZbEspQaEJ48FmeAmc=;
        b=TrwwCrLqC7JAM1Uu/+yafOAtWgX5dY7pPM2NvZ69AMrgl3UEFM/DscGiTUUHN3pc+L
         uS7v2QJimbqhm1WnG9dnmFDRtAK7Yte8g4pmcY2GKK2Ytn0tZg9J9Dfz0LlYaXEDDxsx
         iiTD4UyqQ9/VzWkjBXBux22f7w4atH83ns9iux6Su51579Sjj45hARf3lqY0yH2OoybV
         v0M5WTlBw12gNGR7yEzNR+v5pJXL2RhLDZb6KkB4LTw9dVwWz1JNVzxYWwMm3Og/CFZy
         yEUtvs6A3IVvM93m1EbIcurAyJwCjGIC2c1FgMU708u88XVXA0b3UxJKLzPm463agT6c
         ZJiQ==
Content-Language: en-US
In-Reply-To: <20221102022542.3621219-2-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, jack-AlSwsSmVLrQ@public.gmane.org, paolo.valente-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 11/1/22 8:25 PM, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> After the patch "block, bfq: cleanup bfq_weights_tree add/remove apis"),
> the local variable 'bfqd' is not used anymore, thus remove it.

Please add a Fixes tag.

-- 
Jens Axboe


