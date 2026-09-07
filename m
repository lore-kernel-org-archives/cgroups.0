Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D8144CB8CD
	for <cgroups@vger.kernel.org>; Mon,  7 Sep 2026 14:06:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788789998; cv=none; b=tqPkTaEgIOSTXbUn3Sl9XZvjo1f9aOvMQg4kLauN2geNPwEN48zgHtM6zCsHX75CwvZps+xhISyPq9aSWHBHYwP5tY+vDsYvozmV+dZzkv2C0Ok26wSXymZIq+56j19S9LppIWEvcr4MRWGu7Smolpqkc6lpf6HI8AUqmBZbkWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788789998; c=relaxed/simple;
	bh=kAiALmTWnf8x9SsADiUwVb4eDhzSyPp2/E69JaKJyug=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gadOSfPrJL2NSD99fwdLP0RPG/rY7Ebjzrtyk0TFnI1zkpUnFfnTPK6g9O04IHradaagqSXCGTpHqBDimmo/jn5iON1p03YP4dbdjbxqujv/tDAiFE5AsxyiBFYCVh/KXdDqwHR4L81aN4WopVe8eFPT77AVuaLEsUnhuuQP5lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Fowv+iyf; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Fowv+iyf"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-4843f205a5bso2113285f8f.1
        for <cgroups@vger.kernel.org>; Mon, 07 Sep 2026 07:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788789994; x=1789394794; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hnVIlm2nSumk0PrCQmB9sy4lQ8aJwTihVNma9sBp9rQ=;
        b=Fowv+iyfr+KORHEl5atNl+7aAwsXvqtBTsM6zUgXJucKvDkMEVGUkhGuNvV6A0GKrq
         2TOLgDaQOOYq8Pa9yvJW9ela5KfpxlYYVdQ0iZSVr0+NFOSPzoMhyueP2IVRuHQAaC1L
         L71LrPhPKXdowjiGoPy8mVD08JcmohltxtUprlvQ+XuQNIPkK4IggtPxtjpCS1bEJkS+
         lyjAkHNM74Li+F/ScdA1u2GvyL/hPxMqyr4WDjLeHgK6nIRJOwuhavu+zxS7tC3aNDBh
         dnKffwS0AVynB5j/qhgiWaDINiq6K1munQ+tuO9cP+oUimRz37xhuVBbhyH31ufm7+bl
         zOtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788789994; x=1789394794;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hnVIlm2nSumk0PrCQmB9sy4lQ8aJwTihVNma9sBp9rQ=;
        b=E0pDHJ/m1p+VAl68/dZd1kRWKoMKW+xS+9a85KhK6CKgklVGq9ZKyueIw5pBTjZtPb
         gWsS1atY+46HfvMvrIYlweB+lgJC4h4Vq+9apECh1aDejr53NR21hVtGYdXCZcc9Oiai
         npJ7IVTCjXa+WHCZFUa6v18VIUnW1QYbctAFmIFG5YUEUC7dRjp+qBTK5OlShXT18blS
         3+rXyPBCVJVLolqGrj8fFrnvkhfOY2yJbtKP00AQqe0L59PUx50rwWEDitQNDXSWyi3w
         9fDDQVcAybMlsXfRK00LFW8+CBiUjAvzTyz8V5CvKjWmJFVGWIL59jCLqOReN+d+IkG0
         rGFw==
X-Forwarded-Encrypted: i=1; AKwUvBy8K8ILSUkWLZi3NZtAjSrHODNrxP1WXbusNumbfc5rSKjqM/ruDz52Ert9udlS+rp4AKpshdx0@vger.kernel.org
X-Gm-Message-State: AFuF++moyLhWhmXsB3q7A1lO46StfsQPAnyNpiO/3cRIjLEHkI3fEsfd
	8cVcUkKPhSexvoRJl1wwQtsZV6Q/UteWBTQPmZn0OY5dz3rzOHFujeTrB7beu30oH8k=
X-Gm-Gg: AYBFou1FpkTT1FrXgudIOYofHGFPCBOwsKNc8r3Wuw3xwlbHrcsWl/kXbd2MomCqWpJ
	g8VKJd4uTo6TgfLgASO2gEeT1cayUaOkCRp9tJOUf95iJFSi9llaPs8/3sI0d68+C6HcDcMVupf
	fjZxdEhxBucid9l8VBh2OrR+I0ZapmH+dqzWj8BgCK2vcuD2/NsyH2R4g2NExdnXwPUkkB0VW/D
	JnwIjSFfHb+Ga1uWDW5MViCyQjPTjp50C3Uu53pBu3Gz9j6ALquPbNOmAI+Q9OWMiQ0lE1Yl47v
	opvV1uwVqXxHAaSDNR+Pof7POs0xv9jhzJyqXL8nc2YJ6ur6p9C8UAGvOftyqzb3C//1ulAPpBT
	vT+tesFNVKv/18EduJHLWWuB8pV3PBfX/qJgFi0/Lh4WBlerl8dDrtFiQmE1BTqw5RiqKp26XEF
	0TBEfngoSOb8/nnEPm7TtHrUtpamfj7cxNgYdR4Lj6lj6jSJaXsZzHLRn6gDumoC4=
X-Received: by 2002:a05:6000:4014:b0:485:8a46:b3cf with SMTP id ffacd0b85a97d-4858a46b5fcmr20890181f8f.55.1788789994173;
        Mon, 07 Sep 2026 07:06:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48591eb3d3bsm16866649f8f.0.2026.09.07.07.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 07:06:33 -0700 (PDT)
Date: Mon, 7 Sep 2026 16:06:31 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Zhe Liu <liuzhe1@kylinos.cn>
Cc: bsegall@google.com, cgroups@vger.kernel.org, corbet@lwn.net, 
	dietmar.eggemann@arm.com, hannes@cmpxchg.org, juri.lelli@redhat.com, 
	kprateek.nayak@amd.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, mgorman@suse.de, mingo@redhat.com, peterz@infradead.org, 
	rostedt@goodmis.org, skhan@linuxfoundation.org, tj@kernel.org, 
	vincent.guittot@linaro.org, vschneid@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/3] sched/fair: Remove the write-order dependency
 between cpu.max and cpu.max.burst
Message-ID: <ap69-MoOmAJifgjG@localhost.localdomain>
References: <aobnZEh1hfIBhswD@localhost.localdomain>
 <20260904062013.504236-1-liuzhe1@kylinos.cn>
 <20260904062013.504236-2-liuzhe1@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5sahav5mzexczfrn"
Content-Disposition: inline
In-Reply-To: <20260904062013.504236-2-liuzhe1@kylinos.cn>


--5sahav5mzexczfrn
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/3] sched/fair: Remove the write-order dependency
 between cpu.max and cpu.max.burst
MIME-Version: 1.0

On Fri, Sep 04, 2026 at 02:20:11PM +0800, Zhe Liu <liuzhe1@kylinos.cn> wrot=
e:
> Keep the configured burst independent of the current quota and cap it
> when CFS refills runtime. This allows quota and burst updates in either
> order.
>=20
> Fixes: f4183717b370 ("sched/fair: Introduce the burstable CFS controller")
>=20
> Cc: stable@vger.kernel.org

The change makes sense to me and it should've been like that from the
beginning. OTOH, it may break someone's setup, so I'd take it but revert
it should regressions be reported. Hence, I wouldn't mark it for stable.=20


> Signed-off-by: Zhe Liu <liuzhe1@kylinos.cn>
> ---
>  kernel/sched/core.c | 3 +--
>  kernel/sched/fair.c | 3 ++-
>  2 files changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index f78275192036..5269b8cfcf7f 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -10159,8 +10159,7 @@ static int tg_set_bandwidth(struct task_group *tg,
>  	if (quota_us !=3D RUNTIME_INF && quota_us > max_bw_runtime_us)
>  		return -EINVAL;
> =20
> -	if (quota_us !=3D RUNTIME_INF && (burst_us > quota_us ||
> -					burst_us + quota_us > max_bw_runtime_us))
> +	if (burst_us > max_bw_runtime_us)
>  		return -EINVAL;

I notice this'd be relaxed rather like:

	if (burst_us > max_bw_runtime_us / 2)
		return -EINVAL;

I don't see in the current code that these BW_SHIFT'd calculations were
relevant for burst.
(Sashiko mentions overflows of the addition but I think it's confused
MAX_BW and UULONG_MAX or more precisely (UULONG_MAX / NSEC_PER_USEC),)
so even your version should still be safe.

(Without that stable annotation above.)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--5sahav5mzexczfrn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCap7E4hsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgafAEA/lDIyfoaL+fSg3OpnbzT
kKX5pkBVfO+FBzeCudKKlY0A/jVSRzj8PL3weJy/l9NmUY9jh/ilifk5nRv6Z0tK
K/cK
=kYvk
-----END PGP SIGNATURE-----

--5sahav5mzexczfrn--
