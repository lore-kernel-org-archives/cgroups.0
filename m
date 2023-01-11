From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [External] Re: [PATCH v3] blk-throtl: Introduce sync and async
 queues for blk-throtl
Date: Wed, 11 Jan 2023 13:35:32 +0100
Message-ID: <20230111123532.GB3673@blackbody.suse.cz>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
 <20230106153813.4ttyuikzaagkk2sc@quack3>
 <Y7hTHZQYsCX6EHIN@slm.duckdns.org>
 <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="L6iaP+gRLNZHKoI4"
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1673440534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=KUl6YA1IKQUKcScNMyJ415yLqRxEtI8kTOV2MucdUwI=;
        b=j8rDezHZBy0CHoXmut/N/eeDkVcSrSq7aWYb5DR4MRZOYPn0lF3k4OfsNWh/JMkukmXI5a
        jnVqayNAkJa2dXnAOZ2jAW7c3IzpBFryMclHuyPIidoCAeQy0Uz42dbyRCZp1Waf/ELEBW
        WMG/RLx2vU0i9sSpqAnw6cTTTox7xYM=
Content-Disposition: inline
In-Reply-To: <c839ba6c-80ac-6d92-af64-5c0e1956ae93@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
To: hanjinke <hanjinke.666@bytedance.com>, Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>, josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, yinxin.x@bytedance.com


--L6iaP+gRLNZHKoI4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello.

Thanks all for sharing ideas and more details (in time-previous messages).

On Sat, Jan 07, 2023 at 02:07:38AM +0800, hanjinke <hanjinke.666@bytedance.=
com> wrote:
> But for some specific scenarios with old kernel versions, blk-throtl
> is alose needed. The scenario described in my email is in the early stage=
 of
> research and extensive testing for it. During this period=EF=BC=8Csome pr=
iority
> inversion issues amoug cgroups or within one cgroup have been observed. S=
o I
> send this patch to try to fix or mitigate some of these issues.

Jinke, do you combine blk-throtl with memory limits? (As that could in theo=
ry
indirectly reduce async requests as dirtier would be slowed down.)

Thanks,
Michal

--L6iaP+gRLNZHKoI4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iHUEARYIAB0WIQTrXXag4J0QvXXBmkMkDQmsBEOquQUCY76tEgAKCRAkDQmsBEOq
uTntAQCFo6a3wu0l6VAEdVs14UXuwMrppoC19q2D3MXh03vohQEAjdb/QSHK87YF
XpY7Qj73w0N3r7QhlT9J4wOlGj1WVQ4=
=m0hK
-----END PGP SIGNATURE-----

--L6iaP+gRLNZHKoI4--
