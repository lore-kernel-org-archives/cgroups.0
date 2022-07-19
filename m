From: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v3] block: don't allow the same type rq_qos
 add more than once
Date: Wed, 20 Jul 2022 01:12:06 +0800
Message-ID: <17df93c3-5d12-aea9-95df-a46437ea798a@bytedance.com>
References: <20220719165313.51887-1-hanjinke.666@bytedance.com>
 <036e5ae0-4908-d4ab-c2e5-56e9ca85e26d@kernel.dk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:to:cc:references
         :from:in-reply-to:content-transfer-encoding;
        bh=xlsTXlXgkqcwZmlKCHkSKeWcBmUe/4Yks4XD/IOGgJ8=;
        b=ZQIQV7tJormcdXT5Y2BwVjedCW7zwEhbrZ4sYHPgObfAxoVc9msrDpayMhUw1YxOTY
         exrX/3rKOc3Y+Y+EQoIWutn6Ux8jV3GscFW7NzxCst8uCmuR+mBF/8YEvnsazGauTHUg
         waETftJEUk8j37dqhW//H5FRO/6EPxAjugJ0Xt8dA6E3eptOkt58/c7lM6dUKoI9jDrq
         oOezV0oj2E4VKjOhr2VyajXXmjh7b+QTrRFYQYp9/at1Z+19ei4Gx7VsEe90rb3xK9f4
         H8BltzEcTBBfoViuLK/am//c4djPNcVznBEgRxiRnJRH4QM5GL4LyGifiPIcInmUis3B
         KyPw==
In-Reply-To: <036e5ae0-4908-d4ab-c2e5-56e9ca85e26d-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

okay, I will do it.

在 2022/7/20 上午12:56, Jens Axboe 写道:
> On 7/19/22 10:53 AM, Jinke Han wrote:
>> From: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>>
>> In our test of iocost, we encounttered some list add/del corrutions of
>> inner_walk list in ioc_timer_fn.
> 
> This still fails for 5.20 and you didn't correct any of the spelling
> mistakes I identified.
> 
> Please take your time to get this right rather than attempt to rush it
> and needing to send new versions all of the time.
> 
