From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v2 0/9] iocost bugfix
Date: Wed, 30 Nov 2022 10:26:32 -0700
Message-ID: <c8a2fc0f-0bd3-b276-646f-cab97ba5bc34@kernel.dk>
References: <20221130132156.2836184-1-linan122@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=04jXt74UY1VtpJun8zJvpOrg9ETd91QGiWVG7jWf27c=;
        b=WvC3pO7A3ARpOpPdif1K6HiRZlgxJ/CstMca+FL0z0mtnmuUqcKoo7VHwcnziQbl//
         jS+djIEAMLc6lTGvZY5l0345olBTCWEhjjBf2AwIsCgolZ6/oYAs4nRaDpNER5dVBDPX
         sMq55sqJV6jv7gUnQ9T9wCK5Ot9OmPWvJe6nVfnuDVVJ+yNpvB/rXR2CIqms+BoXDt/b
         cGMgh+Qnr74STBe8oISOcViGmkm95U61eut4IMPTZSmbN6vEEryfhATvELwBBA7mu2HZ
         M7HY7WxOOE05iMNJM1kZSIrGpPhFMAAZ6Ge2hcwHMejCi8rVAVCBXTEKfKbjqBx7pnTT
         MOGA==
Content-Language: en-US
In-Reply-To: <20221130132156.2836184-1-linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Li Nan <linan122-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 11/30/22 6:21=E2=80=AFAM, Li Nan wrote:
> Li Nan (4):
>   blk-iocost: fix divide by 0 error in calc_lcoefs()
>   blk-iocost: change div64_u64 to DIV64_U64_ROUND_UP in
>     ioc_refresh_params()
>   blk-iocost: fix UAF in ioc_pd_free
>   block: fix null-pointer dereference in ioc_pd_init
>=20
> Yu Kuai (5):
>   blk-iocost: cleanup ioc_qos_write() and ioc_cost_model_write()
>   blk-iocost: improve hanlder of match_u64()
>   blk-iocost: don't allow to configure bio based device
>   blk-iocost: read params inside lock in sysfs apis
>   blk-iocost: fix walk_list corruption
>=20
>  block/blk-iocost.c | 117 ++++++++++++++++++++++++++++-----------------
>  block/genhd.c      |   2 +-
>  2 files changed, 75 insertions(+), 44 deletions(-)

Please include a changelog when posting later versions of a patchset.

--=20
Jens Axboe


