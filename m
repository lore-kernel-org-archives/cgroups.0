From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v6 1/7] psi: introduce state_mask to represent stalled
 psi states
Date: Wed, 20 Mar 2019 11:02:49 +1100
Message-ID: <20190320110249.652ec153@canb.auug.org.au>
References: <20190319235619.260832-1-surenb@google.com>
        <20190319235619.260832-2-surenb@google.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/gcf3x9pNF4bWcL9pBwUmVyY"; protocol="application/pgp-signature"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1553040173;
        bh=jehP9+YT/rAivcVGOfJHVCT+k92Lsz+iBSFzJvUFN/Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JLB0DUS0XtDVE1T2hGU9fOTTCcPEXNuudOsbOY2P9sBGeACPjFJRvurNz1hv4BTSL
         Uj82m2Jd+FuuKJMmj+QHXF1gWDmATsDVYcAtzs+qR0XwLQ7PLGXIaxqNn1NGnLhGtU
         SWFMStDnDHgKbyDYvxMsk4xN9fvPXeGjjhHh/2qb6EX9OAlunS/yB0Gj0yKZNiS7eB
         Ji6GENiI1GQiY99aHr8fMba7nmuJJS69cm3KIQr06PwOXRP3jgZXXu/iizdctQzwjW
         CfvEvUzSKGAY8LL3tviwU3qjkIRgkE3bl942ktLdOx4jUYd1r5auLSOEIDwr1nWqfA
         yXNHtkm/V8GwA==
In-Reply-To: <20190319235619.260832-2-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

--Sig_/gcf3x9pNF4bWcL9pBwUmVyY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Suren,

On Tue, 19 Mar 2019 16:56:13 -0700 Suren Baghdasaryan <surenb@google.com> w=
rote:
>
> The psi monitoring patches will need to determine the same states as
> record_times().  To avoid calculating them twice, maintain a state mask
> that can be consulted cheaply.  Do this in a separate patch to keep the
> churn in the main feature patch at a minimum.
>=20
> This adds 4-byte state_mask member into psi_group_cpu struct which results
> in its first cacheline-aligned part becoming 52 bytes long.  Add explicit
> values to enumeration element counters that affect psi_group_cpu struct
> size.
>=20
> Link: http://lkml.kernel.org/r/20190124211518.244221-4-surenb@google.com
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>

This last SOB line should not be here ... it is only there on the
original patch because I import Andrew's quilt series into linux-next.

--=20
Cheers,
Stephen Rothwell

--Sig_/gcf3x9pNF4bWcL9pBwUmVyY
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAlyRgykACgkQAVBC80lX
0GzGdwgAkeERrC49NHtT6/Phx/CoT0fGnk18tNUFLom+rq3rOBQK2wx1PjucbibK
vXCE9EjVXmM1DNhVakECzW140fJtlo/sepGVTJhmSOUsMbOF1OI5PrAvszpgSjSU
5UF7ikasO20gSNsechnFvkJo4NA5zx/se85Mr62VKU8UgfAUcY3DQwATE6EJiQOY
vuaHEsGdYYpgctzrz9buJn2eXKSqatWwteCeyQj2UDsfXz63CCJxlQrO4p96B//c
wjfoSNMnOa25s418YxLiRmLA/9Upk9CMWPzQ7J6v3/TVGUNLvjZPRd1qBUE2za6g
xvo9LR9TcLA3X/p682Ykd4lk+ccBZA==
=KZbq
-----END PGP SIGNATURE-----

--Sig_/gcf3x9pNF4bWcL9pBwUmVyY--
