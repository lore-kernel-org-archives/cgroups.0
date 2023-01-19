From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH -next v3 0/3] blk-cgroup: make sure pd_free_fn() is called
 in order
Date: Thu, 19 Jan 2023 11:54:00 -0700
Message-ID: <bd1c347b-cbf8-3917-401a-ed85c6ccb956@kernel.dk>
References: <20230119110350.2287325-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sa8Oz+7EARYAtQ0WLnCqgtp/WsCMus/3I6/+CNJ1OPw=;
        b=sPzq1KJuKnyasXRpxYhl2vyV/bYi9yVZ56Vqego/VjuHdzz/5dWCi47UX2CUDpoDNC
         CcC5wYt/hUVVEpFkHtyZ89U3S4NTWky0LrDtrtiFDdFrjZELyHOpVBHxbNELtKnQ2iw4
         nr1fs0E0gGKpdnwRST07vzvNPYUzWsF4Vi012BPK68GyqhQejq7mymG62LbNctNk1H5z
         ANiECjUYn3uY98+hJ+kIU7gfPJH2vu/HOgNnNuH23TbDVW4pbv+weD5qebAzq+j5ja3T
         n2GpBO55V9L6Il8+jeulDNzuo2GKi68Gu59deOK6KEDsKNVjB9594cAWwGeunxMF6FhC
         vCiQ==
Content-Language: en-US
In-Reply-To: <20230119110350.2287325-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On 1/19/23 4:03=E2=80=AFAM, Yu Kuai wrote:
> From: Yu Kuai <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> Changes in v3:
>  - add ack tag from Tejun for patch 1,2
>  - as suggested by Tejun, update commit message and comments in patch 3
>=20
> The problem was found in iocost orignally([1]) that ioc can be freed in
> ioc_pd_free(). And later we found that there are more problem in
> iocost([2]).
>=20
> After some discussion, as suggested by Tejun([3]), we decide to fix the
> problem that parent pd can be freed before child pd in cgroup layer
> first. And the problem in [1] will be fixed later if this patchset is
> applied.

Doesn't apply against for-6.3/block (or linux-next or my for-next, for
that matter). Can you resend a tested one against for-6.3/block?

--=20
Jens Axboe


