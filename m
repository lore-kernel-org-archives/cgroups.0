From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH v3] block/blk-iocost (gcc13): keep large values in a new
 enum
Date: Wed, 14 Dec 2022 09:56:48 -0700
Message-ID: <974973f8-c703-59aa-5afe-40b33429fdbb@kernel.dk>
References: <20221213120826.17446-1-jirislaby@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qQKY6n7m8NgblNOiTPoGQcWD1P9sRiAJmGKmfHIQaJI=;
        b=qDiKuv3fl7iPMbNQg9zsteNnbztHAVsD0qiatsZnMDeWRzSCENzuNxv7fKTpR+Aw+r
         ECz5GcXEvCuKQDcHXOMTehJ1L5S4PpdMcTf3ybKc3xVfHxgUG12zlkpPgbt2fzGVRC6f
         kUPYozQIOLOtXEUGvyVZSPyQFiS9fFd2SO6uuS5xj/GSFMWnpKviC2uBk0oaJKCm6zE+
         DsWWHeR3MKc7e8NNBk6Uyqp0DVkcJypwUYLBfpKRPRrjJ5WjnsyTpod1l/oQeYM1VKur
         Rm4ThNy1htZjuZnUjH2X/8HKwcDCdQRCIWa8WwnxmqFFMAWZlr0dsHlqBsENZZAQbuBw
         E3rg==
Content-Language: en-US
In-Reply-To: <20221213120826.17446-1-jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/13/22 5:08=E2=80=AFAM, Jiri Slaby (SUSE) wrote:
> Since gcc13, each member of an enum has the same type as the enum [1]. And
> that is inherited from its members. Provided:
>   VTIME_PER_SEC_SHIFT     =3D 37,
>   VTIME_PER_SEC           =3D 1LLU << VTIME_PER_SEC_SHIFT,
>   ...
>   AUTOP_CYCLE_NSEC        =3D 10LLU * NSEC_PER_SEC,
> the named type is unsigned long.
>=20
> This generates warnings with gcc-13:
>   block/blk-iocost.c: In function 'ioc_weight_prfill':
>   block/blk-iocost.c:3037:37: error: format '%u' expects argument of type=
 'unsigned int', but argument 4 has type 'long unsigned int'
>=20
>   block/blk-iocost.c: In function 'ioc_weight_show':
>   block/blk-iocost.c:3047:34: error: format '%u' expects argument of type=
 'unsigned int', but argument 3 has type 'long unsigned int'
>=20
> So split the anonumois enum with large values to a separate enum, so

anonymous?

--=20
Jens Axboe


