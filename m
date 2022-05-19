From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH -next v3 2/2] blk-throttle: fix io hung due to
 configuration updates
Date: Thu, 19 May 2022 18:10:26 +0200
Message-ID: <20220519161026.GG16096@blackbody.suse.cz>
References: <20220519085811.879097-1-yukuai3@huawei.com>
 <20220519085811.879097-3-yukuai3@huawei.com>
 <20220519095857.GE16096@blackbody.suse.cz>
 <a8953189-af42-0225-3031-daf61347524a@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1652976628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=x8EKRxmOXRG1OntBeojKu9rfDE0STl30IvsPB4f27xM=;
        b=FvquVMKKbnG9WotMztePck6/FwQq4FjESGMn7k+sPiYOrB61HTiUNSyKuQbM6KDVBd3L7E
        P1mqYgInGDeml0YiecNbihAYmJgyK+ad8ThsMlVr6+CN+SmssV2GibwMvxYYEzOZq4AMMW
        lTHEpZipYrA6FQSu2THAoTaRGuhf4kM=
Content-Disposition: inline
In-Reply-To: <a8953189-af42-0225-3031-daf61347524a-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, geert-Td1EMuHUCqxL1ZNQvxDV9g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Thu, May 19, 2022 at 08:14:28PM +0800, "yukuai (C)" <yukuai3-hv44wF8Li93=
QT0dZR+AlfA@public.gmane.org> wrote:
> tg_with_in_bps_limit:
>  jiffy_elapsed_rnd =3D jiffies - tg->slice_start[rw];
>  tmp =3D bps_limit * jiffy_elapsed_rnd;
>  do_div(tmp, HZ);
>  bytes_allowed =3D tmp; -> how many bytes are allowed in this slice,
> 		         incluing dispatched.
>  if (tg->bytes_disp[rw] + bio_size <=3D bytes_allowed)
>   *wait =3D 0 -> no need to wait if this bio is within limit
>=20
>  extra_bytes =3D tg->bytes_disp[rw] + bio_size - bytes_allowed;
>  -> extra_bytes is based on 'bytes_disp'
>=20
> For example:
>=20
> 1) bps_limit is 2k, we issue two io, (1k and 9k)
> 2) the first io(1k) will be dispatched, bytes_disp =3D 1k, slice_start =
=3D 0
>    the second io(9k) is waiting for (9 - (2 - 1)) / 2 =3D 4 s

The 2nd io arrived at 1s, the wait time is 4s, i.e. it can be dispatched
at 5s (i.e. 10k/*2kB/s =3D 5s).

> 3) after 3 s, we update bps_limit to 1k, then new waiting is caculated:
>=20
> without this patch:  bytes_disp =3D 0, slict_start =3D3:
> bytes_allowed =3D 1k	                            <--- why 1k and not 0?
> extra_bytes =3D 9k - 1k =3D 8k
> wait =3D 8s

This looks like it was calculated at time 4s (1s after new config was
set).

>=20
> whth this patch: bytes_disp =3D 0.5k, slice_start =3D  0,
> bytes_allowed =3D 1k * 3 + 1k =3D 4k
> extra_bytes =3D  0.5k + 9k - 4k =3D 5.5k
> wait =3D 5.5s

This looks like calculated at 4s, so the IO would be waiting till
4s+5.5s =3D 9.5s.

As I don't know why using time 4s, I'll shift this calculation to the
time 3s (when the config changes):

bytes_disp =3D 0.5k, slice_start =3D  0,
bytes_allowed =3D 1k * 3  =3D 3k
extra_bytes =3D  0.5k + 9k - 3k =3D 7.5k
wait =3D 7.5s

In absolute time, the IO would wait till 3s+7.5s =3D 10.5s

OK, either your 9.5s or my 10.5s looks weird (although earlier than
original 4s+8s=3D12s).
However, the IO should ideally only wait till

    3s + (9k -   (6k    -    1k)     ) / 1k/s =3D
         bio - (allowed - dispatched)  / new_limit

   =3D3s + 4k / 1k/s =3D 7s

   ('allowed' is based on old limit)

Or in another example, what if you change the config from 2k/s to =E2=88=9E=
k/s
(unlimited, let's neglect the arithmetic overflow that you handle
explicitly, imagine a big number but not so big to be greater than
division result).

In such a case, the wait time should be zero, i.e. IO should be
dispatched right at the time of config change.
(With your patch that still calculates >0 wait time (and the original
behavior gives >0 wait too.)

> I hope I can expliain it clearly...

Yes, thanks for pointing me to relevant parts.
I hope I grasped them correctly.

IOW, your patch and formula make the wait time shorter but still IO can
be delayed indefinitely if you pass a sequence of new configs. (AFAIU)

Regards,
Michal
