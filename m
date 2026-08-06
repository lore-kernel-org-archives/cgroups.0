Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DED1B3590AE
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786008145; cv=none; b=PUmwGMNnsMbGoRPkp3PV3WwqmtPVEdR8ni41msCOeqvn/7HfYu7fm7Tv18RQlAV4lRze+ZqJFd/iNwKDEx5EJJcswzsBmGEizjQ7fiH0stP9VvmgrYj9ZFcBzOIwnGieAs+aXI8Ul+pCqoxgw9RJzakv112wsz6SG1EGXPHMCVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786008145; c=relaxed/simple;
	bh=eAkOXZtlwNYjPhDGjyZtRke2iyDCQ2QqdzoXZFHQk1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NJPCxsVfAbPLLt4r9Rkmrp+//lxDAIBl7NSl/TBwxXvDM/KgDZUjNESc0yIDUt24Si5MMh+ofu2u3Jlj5AqDGNHbkYK4mCJgxDag/VERlafMk+MV9P8G89e5uS6oGkvjf5vBXjrofpNeEJIqkmRNqn/8m6FOJl6HOpXSszv0XAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RcsuN2zt; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RcsuN2zt"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f703a9e5dso975636f8f.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 02:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786008141; x=1786612941; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
        b=RcsuN2zt9rzM+ME03G17KTRB0gerlXLycmUYbC2nStsbif2TYq9tqbRW3nIW/NI40M
         a1sTJmvwC/A/IwXwBV/ZQfL3R/Mcnrlr50PqQN3Z+GLK0TfRGldvBySRj5W5Fxz2SEco
         X/1ATUl+sBLcCFChSVyub8/h46kWMjNsvgfItQhTSdnKdfAnGTxlMYWcID0E7wpqEAej
         vk6Y7RIs5pfpjfzmGcSJhdu9ApsZEtSNUywAzFtm2Dgg0WGDW5imsmGgtjfuGzZ9oPqS
         HP6ieG0QBvWdAD+LsBA09gJdbMuFEeJ2J1ibbv+oBr7HIXfxYzVvm6mcKrP6E07mXtA/
         Rt6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786008141; x=1786612941;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Pcnhqt0EtUylxXGbjqsf+1Pc4DS5YZiCgI0VutNek2Q=;
        b=Cb9R43IbtQFwoEypxXlGdpR/oX1X0oXEEldz9MQ5xihriRuRlWbarguaWkMBOPcRdu
         7lT50V70HRqLDyS6tPNCPnaBwarG96/5J4Ko0wAhTe9wiAikEA+318IbU8Cx/HocmDhr
         EpN3cCJjYIg2SZZBle6WLHUtmZjCIeIgNKQAIKq6F0GSELNhfzM9XYq44HfZCB0r9vS+
         CO1n7KbN9nyxyhLW3h+skWUgqq5aEpO+M2sI3u1etrnK4aIgbS3IDXbeN224IG1EOg7z
         K8HywI56opRiTDWfBHm6POW8L8EP04dbw3gjBpc+hbOEUXeN2r2/2XcHvYcAP1v0gTQC
         hkBQ==
X-Forwarded-Encrypted: i=1; AHgh+RqLIBJURmNLejvKodbTKsb7X6wAysg0CLiwMjLzXGjhUT7XgYXGm4N6j9tkMo/z3MtZyYWqsjPc@vger.kernel.org
X-Gm-Message-State: AOJu0Yws4fc1EHcCNCkqdszSVPUm1t+XMKx41ndprHExzPL/lAn9YIaH
	hkfBtl/BaXSNFod8fb7frwXafT1vixtnyICT1FQJKyW9a4clIyTyGylYsMx6F5qnYk8=
X-Gm-Gg: AR+sD11Its8D2cTvP3/jA/VJnp3XHAobmZFLQpk40wFOyvCB6/wTDDr91GlVUfDW2m0
	F0/ZeH7ikKaB7fMUC9pcT/jiogNBNOQnlVDPqYVB3O5P83gvcGrLQs+VeFPcFuFI8DLovd2BclW
	GZU1eowkzmA2nt0m42MacfVI3CQ2TFz8kTAfwQNFYUz+FLiZ6ZOMn/AAoyVDRdmfVgr8PiVj4Ey
	2adQJZNoW9d+BgIPp1tj1mrurv3N1BPFCny/hz3w0Aslpq+2Utsa/KBGdBpvFyQ6VeRBpj5e5o9
	Rved+IH617cNVp2JG6mL3Sw1skfeOBja2P0PMEBupDbveEysmUoktv07t0R2pb03ol7l97XVxaw
	twKm21oiZRHI5390rF99HF+Ve6dFrAHHB0e41wFmaXwd7UCrhWFE9cm4uR3AOGXHnLqmSmZLPip
	AFUM9vwzuxgkQSuNzd0t/jno56BXIIyOivltg2uI8wTlzDpABm3qflNMlZT80hp08+
X-Received: by 2002:a5d:624a:0:b0:47f:9750:26cc with SMTP id ffacd0b85a97d-47fec630b5cmr16574414f8f.23.1786008139632;
        Thu, 06 Aug 2026 02:22:19 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47ff7b31975sm4112794f8f.33.2026.08.06.02.22.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:22:18 -0700 (PDT)
Date: Thu, 6 Aug 2026 11:22:16 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yu Kuai <yukuai@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Yu Kuai <yukuai@fygo.io>, 
	Josef Bacik <josef@toxicpanda.com>, Coly Li <colyli@fygo.io>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>, 
	Benjamin Marzinski <bmarzins@redhat.com>, Song Liu <song@kernel.org>, Dan Williams <djbw@kernel.org>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Alison Schofield <alison.schofield@intel.com>, Pankaj Gupta <pankaj.gupta.linux@gmail.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>, Tao Cui <cui.tao@linux.dev>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-raid@vger.kernel.org, nvdimm@lists.linux.dev, virtualization@lists.linux.dev, 
	gfs2@lists.linux.dev, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-ID: <anRPSKHWo59GPIA0@localhost.localdomain>
References: <20260804065313.2092022-1-yukuai@kernel.org>
 <20260804065313.2092022-3-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ltojthlavrpt3nkl"
Content-Disposition: inline
In-Reply-To: <20260804065313.2092022-3-yukuai@kernel.org>


--ltojthlavrpt3nkl
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH v1 2/3] blk-cgroup: store blkcg in bio instead of blkg
MIME-Version: 1.0

Hi Kuai.

On Tue, Aug 04, 2026 at 02:53:12PM +0800, Yu Kuai <yukuai@kernel.org> wrote:
> From: Yu Kuai <yukuai@fygo.io>
>=20
> A bio currently stores a queue-local blkg reference.  This forces bio
> association and remap paths to look up or create a blkg even when the bio
> will never enter a blkcg policy.
>=20
> Store the blkcg css association in the bio instead, and derive the blkg
> from the bio's blkcg and current bdev when a policy needs it.  The first
> successful policy lookup pins the blkg, records the pin with BIO_BLKG_REF,
> and drops it from bio_clear_blkcg() or when bio_set_dev() changes the
> lookup key.
>=20
> Keep lookup-only users from creating missing blkgs by using
> bio_blkg_lookup(), and rename the bio cgroup association helpers to match
> the stored blkcg state.

I assume this should be OK due to limited lifetime of bios -- this would
not lead no possibly indefinite accumulation of offlined blkcgs,
correct?

> -void bio_associate_blkg_from_css(struct bio *bio,
> +void bio_associate_blkcg_from_css(struct bio *bio,
>  				 struct cgroup_subsys_state *css)
>  {
> -	if (bio_blkg(bio))
> -		blkg_put(bio_blkg(bio));
> +	struct blkcg *blkcg;
> =20
> -	if (css && css->parent) {
> -		bio->bi_blkg =3D blkg_tryget_closest(bio, css);
> -	} else {
> -		blkg_get(bdev_get_queue(bio->bi_bdev)->root_blkg);
> -		bio->bi_blkg =3D bdev_get_queue(bio->bi_bdev)->root_blkg;
> -	}
> +	if (!css || !css->parent)
> +		css =3D &blkcg_root.css;
> +
> +	blkcg =3D css_to_blkcg(css);
> +	if (bio_blkcg(bio) =3D=3D blkcg)
> +		return;
> +
> +	css_get(css);	<---
> +	bio_clear_blkcg(bio);
> +	bio->bi_blkcg =3D blkcg;
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg_from_css);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg_from_css);

[skip to next comment below now]

And here yet another (any) reference to same css is taken 2nd time.

[skip after next comment below :)]


> =20
>  /**
> - * bio_associate_blkg - associate a bio with a blkg
> + * bio_associate_blkcg - associate a bio with a blkcg
>   * @bio: target bio
>   *
> - * Associate @bio with the blkg found from the bio's css and request_que=
ue.
> - * If one is not found, bio_lookup_blkg() creates the blkg.  If a blkg is
> - * already associated, the css is reused and association redone as the
> - * request_queue may have changed.
> + * Associate @bio with the blkcg found from the bio's css.  If a blkcg is
> + * already associated, keep it as blkcg association is not queue-local.
>   */
> -void bio_associate_blkg(struct bio *bio)


> +void bio_associate_blkcg(struct bio *bio)
>  {
>  	struct cgroup_subsys_state *css;
> =20
>  	if (blk_op_is_passthrough(bio->bi_opf))
>  		return;
> =20
> -	if (bio_blkg(bio)) {
> -		css =3D bio_blkcg_css(bio);
> -		bio_associate_blkg_from_css(bio, css);
> -	} else {
> -		rcu_read_lock();
> -		css =3D blkcg_css();
> -		if (!css_tryget_online(css))
> -			css =3D NULL;
> -		rcu_read_unlock();
> +	if (bio_blkcg(bio))
> +		return;
> =20
> -		bio_associate_blkg_from_css(bio, css);
> -		if (css)
> -			css_put(css);
> -	}
> +	rcu_read_lock();
> +	css =3D blkcg_css();
> +	if (!css_tryget_online(css))	<---
> +		css =3D NULL;
> +	rcu_read_unlock();
> +
> +	bio_associate_blkcg_from_css(bio, css);
> +	if (css)
> +		css_put(css);
>  }
> -EXPORT_SYMBOL_GPL(bio_associate_blkg);
> +EXPORT_SYMBOL_GPL(bio_associate_blkcg);

next:
Here you take (online) reference to the blkcg->css.

[return back to previous comment]


after:
Ideally, no tasks should be in offlined (blk)cgs, so the `current` would
not resolve to blkcg_css() returning an offlined blkcgs. OTOH, it's
generally good not to do _new_ associations to an offlined blkcg.
Which is why I think this logic would better fit to
bio_associate_blkcg_from_css()


0.02=E2=82=AC,
Michal


--ltojthlavrpt3nkl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanRSRBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ahf+gEA5FtU8iXyQA9tlhJdWJEf
nyf1IBDUt4tisH7UDE8KiSEBAP5BK6FXkSftml/wn918ol1iwizfBzFhephd2gZc
e3UL
=GgwG
-----END PGP SIGNATURE-----

--ltojthlavrpt3nkl--
