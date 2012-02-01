From: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 6/6] cls_cgroup: remove redundant rcu_read_lock/unlock
Date: Wed, 01 Feb 2012 08:07:19 +0100
Message-ID: <1328080039.22641.2.camel@edumazet-laptop>
References: <4F28E1D1.900@cn.fujitsu.com> <4F28E22A.703@cn.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:x-mailer:content-transfer-encoding:mime-version;
        bh=MuahedDzWijoscD2F1w9l9gaxZ8+8H7XJtSXD5/d9lE=;
        b=nI1IDNWF0O13U9jiI0irIppXCk8MzlCuwSLubE4cl+oAO2TkGBGSDXe4P0UUzoFfVD
         eVREm73B1QOr/gnjCOYgjPwWBEvxPxpE5tBwluFfUvdO7a19ucSBCi1dIspr9C9kU7cG
         wfzYN5/xO5ZNFSRmUziA/Ffew6ZOJ+ONxzznw=
In-Reply-To: <4F28E22A.703-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>

Le mercredi 01 f=C3=A9vrier 2012 =C3=A0 14:56 +0800, Li Zefan a =C3=A9c=
rit :
> We've already used rcu_read_lock/unlock inside task_classid(),
> so don't use the lock/unlock pair twice in this hot path.
>=20
> Signed-off-by: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> ---
>  net/core/sock.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>=20
> diff --git a/net/core/sock.c b/net/core/sock.c
> index 213c856..c0bab23 100644
> --- a/net/core/sock.c
> +++ b/net/core/sock.c
> @@ -1160,9 +1160,7 @@ void sock_update_classid(struct sock *sk)
>  {
>  	u32 classid;
> =20
> -	rcu_read_lock();  /* doing current task, which cannot vanish. */
>  	classid =3D task_cls_classid(current);
> -	rcu_read_unlock();
>  	if (classid && classid !=3D sk->sk_classid)
>  		sk->sk_classid =3D classid;

Yes, this seems fine.

Then, I wonder why we do the "if (classid && classid !=3D sk->sk_classi=
d)"

before the :

	sk->sk_classid =3D classid;

This seems unnecessary checks.

