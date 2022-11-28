From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-block] blk-cgroup: Use css_tryget() in
 blkcg_destroy_blkgs()
Date: Mon, 28 Nov 2022 07:14:37 -0700
Message-ID: <427068db-6695-a1e2-4aa2-033220680eb9@kernel.dk>
References: <20221128033057.1279383-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YSAoMPL7GoXdvi2uqHoiRe+EA22FtKTEJJ1PVxlye2M=;
        b=jgvFSL7jpl9MqLgAG6fh4zKofcwxR+/eoEoZWF/ym/LrF4fLxXEQxRLZAstmlCbqpG
         nMpiwsjL1fRDSlJmD0MHKW9gTfTjZVdQBno5hAZlMaWaeACszvKP/wx8QZpvbzNUIV3H
         bcPYyTTrny+NDOoszf8U8N1sJwKg3ibV+Q6O7XF0xWAuNAl9ZFCDKPWBC53W22952bfD
         hx2wOQyXm8IkSwtBlDs8f08Chogp6iM40tAmOO3+l9bWfELea6Z1M3qeLPjSeGMLfDoP
         Ky+sdx4pCdqhXZRA0RVg9YQQds2CJJlEDyP6tTSqeqIS6Ut4fM3+w9JSx0/apa4WJJFI
         XjoQ==
Content-Language: en-US
In-Reply-To: <20221128033057.1279383-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, Hillf Danton <hdanton@sina.com>, Yi Zhang <yi.zhang@redhat.com>

On 11/27/22 8:30=E2=80=AFPM, Waiman Long wrote:
> Commit 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction
> path") incorrectly assumes that css_get() will always succeed. That may
> not be true if there is no blkg associated with the blkcg. If css_get()
> fails, the subsequent css_put() call may lead to data corruption as
> was illustrated in a test system that it crashed on bootup when that
> commit was included. Also blkcg may be freed at any time leading to
> use-after-free. Fix it by using css_tryget() instead and bail out if
> the tryget fails.
>=20
> Fixes: 951d1e94801f ("blk-cgroup: Flush stats at blkgs destruction path")
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  block/blk-cgroup.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
> index 57941d2a8ba3..74fefc8cbcdf 100644
> --- a/block/blk-cgroup.c
> +++ b/block/blk-cgroup.c
> @@ -1088,7 +1088,12 @@ static void blkcg_destroy_blkgs(struct blkcg *blkc=
g)
> =20
>  	might_sleep();
> =20
> -	css_get(&blkcg->css);
> +	/*
> +	 * If css_tryget() fails, there is no blkg to destroy.
> +	 */
> +	if (!css_tryget(&blkcg->css))
> +		return;
> +
>  	spin_lock_irq(&blkcg->lock);
>  	while (!hlist_empty(&blkcg->blkg_list)) {
>  		struct blkcg_gq *blkg =3D hlist_entry(blkcg->blkg_list.first,

This doesn't seem safe to me, but maybe I'm missing something. A tryget
operation can be fine if we're under RCU lock and the entity is freed
appropriately, but what makes it safe here? Could blkcg already be gone
at this point?

--=20
Jens Axboe


