From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH -next v5 4/8] blk-throttle: fix io hung due to config
 updates
Date: Wed, 22 Jun 2022 19:26:21 +0200
Message-ID: <20220622172621.GA28246@blackbody.suse.cz>
References: <20220528064330.3471000-1-yukuai3@huawei.com>
 <20220528064330.3471000-5-yukuai3@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ZPt4rx8FFjLCG7dd"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1655918782; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Jml0n4rcqjuj+OPSJZyRw7ItN6cmTrfRr6AuCXrU/lE=;
        b=vNbktpf1xKsoPuXRFhRhomPfTR6dR5KLyWvi9TFcnR+ZqXyNArdoJuXxTgbYme3q8UadJH
        XKlk6G10CYi/ZJCtdhvOwXdtgJDAVAV0aB+qpx8o39KbwaMH4vjcH/zIBlR0OxMdF2R3Il
        4x7uE3VXXiNbg7wXwktEv49H5kyWf0Q=
Content-Disposition: inline
In-Reply-To: <20220528064330.3471000-5-yukuai3@huawei.com>
List-ID: <cgroups.vger.kernel.org>
To: Yu Kuai <yukuai3@huawei.com>
Cc: tj@kernel.org, axboe@kernel.dk, ming.lei@redhat.com, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yi.zhang@huawei.com


--ZPt4rx8FFjLCG7dd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

(Apologies for taking so long before answering.)

On Sat, May 28, 2022 at 02:43:26PM +0800, Yu Kuai <yukuai3@huawei.com> wrot=
e:
> Some simple test:
> 1)
> cd /sys/fs/cgroup/blkio/
> echo $$ > cgroup.procs
> echo "8:0 2048" > blkio.throttle.write_bps_device
> {
>         sleep 2
>         echo "8:0 1024" > blkio.throttle.write_bps_device
> } &
> dd if=3D/dev/zero of=3D/dev/sda bs=3D8k count=3D1 oflag=3Ddirect
>=20
> 2)
> cd /sys/fs/cgroup/blkio/
> echo $$ > cgroup.procs
> echo "8:0 1024" > blkio.throttle.write_bps_device
> {
>         sleep 4
>         echo "8:0 2048" > blkio.throttle.write_bps_device
> } &
> dd if=3D/dev/zero of=3D/dev/sda bs=3D8k count=3D1 oflag=3Ddirect
>=20
> test results: io finish time
> 	before this patch	with this patch
> 1)	10s			6s
> 2)	8s			6s

I agree these are consistent and correct times.

And the new implementation won't make it worse (in terms of delaying a
bio) than configuring minimal limits from the beginning, AFACT.

> @@ -801,7 +836,8 @@ static bool tg_with_in_iops_limit(struct throtl_grp *=
tg, struct bio *bio,
> =20
>  	/* Round up to the next throttle slice, wait time must be nonzero */
>  	jiffy_elapsed_rnd =3D roundup(jiffy_elapsed + 1, tg->td->throtl_slice);
> -	io_allowed =3D calculate_io_allowed(iops_limit, jiffy_elapsed_rnd);
> +	io_allowed =3D calculate_io_allowed(iops_limit, jiffy_elapsed_rnd) +
> +		     tg->io_skipped[rw];
>  	if (tg->io_disp[rw] + 1 <=3D io_allowed) {
>  		if (wait)
>  			*wait =3D 0;
> @@ -838,7 +874,8 @@ static bool tg_with_in_bps_limit(struct throtl_grp *t=
g, struct bio *bio,
>  		jiffy_elapsed_rnd =3D tg->td->throtl_slice;
> =20
>  	jiffy_elapsed_rnd =3D roundup(jiffy_elapsed_rnd, tg->td->throtl_slice);
> -	bytes_allowed =3D calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd);
> +	bytes_allowed =3D calculate_bytes_allowed(bps_limit, jiffy_elapsed_rnd)=
 +
> +			tg->bytes_skipped[rw];
>  	if (tg->bytes_disp[rw] + bio_size <=3D bytes_allowed) {
>  		if (wait)
>  			*wait =3D 0;
>

Here we may allow to dispatch a bio above current slice's
calculate_bytes_allowed() if bytes_skipped is already >0.

bytes_disp + bio_size <=3D calculate_bytes_allowed() + bytes_skipped

Then on the next update

> [shuffle]
> +static void __tg_update_skipped(struct throtl_grp *tg, bool rw)
> +{
> +	unsigned long jiffy_elapsed =3D jiffies - tg->slice_start[rw];
> +	u64 bps_limit =3D tg_bps_limit(tg, rw);
> +	u32 iops_limit =3D tg_iops_limit(tg, rw);
> +
> +	if (bps_limit !=3D U64_MAX)
> +		tg->bytes_skipped[rw] +=3D
> +			calculate_bytes_allowed(bps_limit, jiffy_elapsed) -
> +			tg->bytes_disp[rw];
> +	if (iops_limit !=3D UINT_MAX)
> +		tg->io_skipped[rw] +=3D
> +			calculate_io_allowed(iops_limit, jiffy_elapsed) -
> +			tg->io_disp[rw];
> +}

the difference(s) here could be negative. bytes_skipped should be
reduced to account for the additionally dispatched bio.
This is all unsigned so negative numbers underflow, however, we add them
again to the unsigned, so thanks to modular arithmetics the result is
correctly updated bytes_skipped.

Maybe add a comment about this (unsigned) intention?

(But can this happen? The discussed bio would have to outrun another bio
(the one which defined the current slice_end) but since blk-throttle
uses queues (FIFO) everywhere this shouldn't really happen. But it's
good to know this works as intended.)

This patch can have
Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>


--ZPt4rx8FFjLCG7dd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCYrNQpAAKCRAkDQmsBEOq
uZ3BAQCL8oobgb+B0o8EQKGsxtLcjkKWGAXteGs1+CHNsFrUGAD/V+B+r/Bv3hQR
A5tMH+4VD4tzI0yNIrKNYH5LIKu2ZgU=
=HsKx
-----END PGP SIGNATURE-----

--ZPt4rx8FFjLCG7dd--
