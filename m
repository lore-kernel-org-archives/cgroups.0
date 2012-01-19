From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] memcg: restore ss->id_lock to spinlock, using RCU for
 next
Date: Thu, 19 Jan 2012 08:33:21 +0100
Message-ID: <1326958401.1113.22.camel@edumazet-laptop>
References: <alpine.LSU.2.00.1201182155480.7862@eggly.anvils>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=JunrcHlH1c/Qf0NjB3FIwNpfrDdMSncwltI9fmUJCoo=;
        b=SQwhEahj9+WxFVrapvPvfq8RZgXYfvBVrOfMuedk/IsxctbJX/9p2h5SbcvNZ2wEnR
         a0hLBxsd29W8hHgDXS6lfLt6hBXmasulh7nMq9vIrNK3o2p9CKYE3KeaVg4iCi19rWJ0
         nssFmZQy2N1JlJAi6X4NzvfeZtBX+8bYQ3d/o=
In-Reply-To: <alpine.LSU.2.00.1201182155480.7862-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Manfred Spraul <manfred-nhLOkwUX5cPe2c5cEj3t2g@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Le mercredi 18 janvier 2012 =C3=A0 22:05 -0800, Hugh Dickins a =C3=A9cr=
it :

> 2. Make one small adjustment to idr_get_next(): take the height from
> the top layer (stable under RCU) instead of from the root (unprotecte=
d
> by RCU), as idr_find() does.
>=20

> --- 3.2.0+/lib/idr.c	2012-01-04 15:55:44.000000000 -0800
> +++ linux/lib/idr.c	2012-01-18 21:25:36.947963342 -0800
> @@ -605,11 +605,11 @@ void *idr_get_next(struct idr *idp, int
>  	int n, max;
> =20
>  	/* find first ent */
> -	n =3D idp->layers * IDR_BITS;
> -	max =3D 1 << n;
>  	p =3D rcu_dereference_raw(idp->top);
>  	if (!p)
>  		return NULL;
> +	n =3D (p->layer + 1) * IDR_BITS;
> +	max =3D 1 << n;
> =20
>  	while (id < max) {
>  		while (n > 0 && p) {

Interesting, but should be a patch on its own.

Maybe other idr users can benefit from your idea as well, if patch is
labeled  "idr: allow idr_get_next() from rcu_read_lock" or something...

I suggest introducing idr_get_next_rcu() helper to make the check about
rcu cleaner.

idr_get_next_rcu(...)
{
	WARN_ON_ONCE(!rcu_read_lock_held());
	return idr_get_next(...);
}


