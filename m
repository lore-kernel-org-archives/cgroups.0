From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next v4 4/4] blk-throttle: fix io hung due to config
 updates
Date: Tue, 24 May 2022 11:59:36 +0200
Message-ID: <20220524095936.GB2434@blackbody.suse.cz>
References: <20220523082633.2324980-1-yukuai3@huawei.com>
 <20220523082633.2324980-5-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653386378; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JTKEB4NmoJkwSXk1U6EYZKEevt7IEvr3Nwq93kINHr0=;
        b=l4HC7B+JUhcVWwqVWAvAIxcfrLeo5n86Jld5BGNuZAJ8Ox9RFNXaio2R37Na4fcLy1/S8s
        UtqoZFBOj9zArT9tgp7woC06z+Y3Y3SCJjbk3nW9ljusVgVtr4rmV6nWuMmMrq4pRLw/P5
        aqBVkDC/8EejSzuqd3aC687vr7pcPWY=
Content-Disposition: inline
In-Reply-To: <20220523082633.2324980-5-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com

On Mon, May 23, 2022 at 04:26:33PM +0800, Yu Kuai <yukuai3@huawei.com> wrot=
e:
> Fix the problem by respecting the time that throttled bio aready waited.
> In order to do that, add new fields to record how many bytes/io already
> waited, and use it to calculate wait time for throttled bio under new
> configuration.

This new approach is correctly conserving the bandwidth upon changes.
(Looking and BPS paths.)

>=20
> Some simple test:
> 1)
> cd /sys/fs/cgroup/blkio/
> echo $$ > cgroup.procs
> echo "8:0 2048" > blkio.throttle.write_bps_device
> {
>         sleep 3
>         echo "8:0 1024" > blkio.throttle.write_bps_device
> } &
> sleep 1
> dd if=3D/dev/zero of=3D/dev/sda bs=3D8k count=3D1 oflag=3Ddirect
>=20
> 2)
> cd /sys/fs/cgroup/blkio/
> echo $$ > cgroup.procs
> echo "8:0 1024" > blkio.throttle.write_bps_device
> {
>         sleep 5
>         echo "8:0 2048" > blkio.throttle.write_bps_device
> } &
> sleep 1
> dd if=3D/dev/zero of=3D/dev/sda bs=3D8k count=3D1 oflag=3Ddirect
>=20

It's interesting that you're getting these numbers (w/patch)

> test results: io finish time
> 	before this patch	with this patch
> 1)	10s			6s
> 2)	8s			6s

wait :=3D (disp + bio - =CE=94t*l_old) / l_new

1)
wait =3D (0k + 8k - 3s*2k/s) / 1k/s =3D 2s -> i.e. 5s absolute

2)
wait =3D (0k + 8k - 5s*1k/s) / 2k/s =3D 2.5s -> i.e. 6.5s absolute

Are you numbers noisy+rounded or do I still mis anything?

(Also isn't it worth having this more permanent in tools/testing/selftest?)

> +static void tg_update_skipped(struct throtl_grp *tg)
> +{
> +	if (tg->service_queue.nr_queued[READ])
> +		__tg_update_skipped(tg, READ);
> +	if (tg->service_queue.nr_queued[WRITE])
> +		__tg_update_skipped(tg, WRITE);

On one hand, the callers of tg_update_skipped() know whether R/W limit
is changed, so only the respective variant could be called.
On the other hand, this conditions look implied by tg->flags &
THROTL_TG_PENDING.
(Just noting, it's likely still not possibly to pass the skipped value
only via stack.)


> @@ -115,6 +115,10 @@ struct throtl_grp {
>  	uint64_t bytes_disp[2];
>  	/* Number of bio's dispatched in current slice */
>  	unsigned int io_disp[2];
> +	/* Number of bytes will be skipped in current slice */
> +	uint64_t bytes_skipped[2];
> +	/* Number of bio's will be skipped in current slice */
> +	unsigned int io_skipped[2];

Please add a comment these fields exists to facilitate config updates
(the bytes to be skipped is sort of obvious from the name :-).

Thanks,
Michal

