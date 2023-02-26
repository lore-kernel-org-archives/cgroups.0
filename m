From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] blk-iocost: initialize rqos before accessing it
Date: Sun, 26 Feb 2023 13:18:36 -0700
Message-ID: <99297e45-e5d7-e582-ed66-4080baf5c884@kernel.dk>
References: <20230224160714.172884-1-leitao@debian.org>
 <Y/uPFT7w+XQ9l0XE@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1677442718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WfnsNCyMqf3Mvd4sjmsuEBgREKEXaVYDac63SQuhJJw=;
        b=xeercA6ozu6jEy9thlUQk8vkH/YTR96f0IViO1Dd3uXuyyLB5NfTBmcFVhKTngRvRA
         2f49+/lo4TiAE5KvzX4q24Kev36C8ojQTFOy3X0UVnx5eQmylfgENGtw+ncKQkT0ZdyE
         6hZjQ446RbHXB1Hmyepo7E4f0NwGfkaEqriZeqSCXeU0TIvRyTeXRyUHyyccIRd8GmgE
         ji0ET9Rqclso4EgTnJTLDQbWOXCxCau7rIEHHSrvWAMjZYSZ1wMH12bhIn50gjdy4SLF
         hUV2keahta5WiQtrQ/UQbOi5RWdMIdZGA4HFHXeVYq1MtXOR8ZKdWS7X3UekCO5qKh3h
         cw7w==
Content-Language: en-US
In-Reply-To: <Y/uPFT7w+XQ9l0XE@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Tejun Heo <tj@kernel.org>, Breno Leitao <leitao@debian.org>
Cc: josef@toxicpanda.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, aherrmann@suse.de, linux-kernel@vger.kernel.org, hch@lst.de, leit@fb.com

On 2/26/23 9:55=E2=80=AFAM, Tejun Heo wrote:
> Hello, Breno.
>=20
> On Fri, Feb 24, 2023 at 08:07:14AM -0800, Breno Leitao wrote:
>> diff --git a/block/blk-iocost.c b/block/blk-iocost.c
>> index ff534e9d92dc..6cced8a76e9c 100644
>> --- a/block/blk-iocost.c
>> +++ b/block/blk-iocost.c
>> @@ -2878,11 +2878,6 @@ static int blk_iocost_init(struct gendisk *disk)
>>  	atomic64_set(&ioc->cur_period, 0);
>>  	atomic_set(&ioc->hweight_gen, 0);
>> =20
>> -	spin_lock_irq(&ioc->lock);
>> -	ioc->autop_idx =3D AUTOP_INVALID;
>> -	ioc_refresh_params(ioc, true);
>> -	spin_unlock_irq(&ioc->lock);
>> -
>>  	/*
>>  	 * rqos must be added before activation to allow ioc_pd_init() to
>>  	 * lookup the ioc from q. This means that the rqos methods may get
>> @@ -2893,6 +2888,11 @@ static int blk_iocost_init(struct gendisk *disk)
>>  	if (ret)
>>  		goto err_free_ioc;
>> =20
>> +	spin_lock_irq(&ioc->lock);
>> +	ioc->autop_idx =3D AUTOP_INVALID;
>> +	ioc_refresh_params(ioc, true);
>> +	spin_unlock_irq(&ioc->lock);
>> +
>=20
> I'm a bit worried about registering the rqos before ioc_refresh_params() =
as
> that initializes all the internal parameters and letting IOs flow through
> without initializing them can lead to subtle issues. Can you please inste=
ad
> explicitly pass @q into ioc_refresh_params() (and explain why we need it
> passed explicitly in the function comment)?

Sorry missed this, I'll drop it for now.

--=20
Jens Axboe


