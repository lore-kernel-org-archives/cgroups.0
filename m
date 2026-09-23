Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 661D6443311
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 15:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790178839; cv=none; b=sQTqPdL0aGU4dstlcIpSlgzh81tcwGRrGe7LKTNzoIfnQO7v3Y0Su4BV1F3xllom5YkxDX5TESq06FoCZlsNTpIMzhfUGFJXR4s/cPc9KXMzaopMpt9OH0h+eLlY/2KYb5HI2aRQ930lD4o7ZWdnx+VZh+MAfDUpR1fnT0X4+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790178839; c=relaxed/simple;
	bh=oH61LGa4P7Ygc8XH6M+e331r+6VnQYGoD9Ad6jAJVo8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ddnUOdfSmffJDT5NbVylG6WeeakhqXZEjiAa7CR+sm4bwMm3sz8b78AAvFErMVtepCTGtesqNFLsjwEe0L8hKFv3xC3WWCqoalV6+5vjoprFqG/qgIrvpB3sgC+Zde+uGHWpLdaSEvb43OmEjckojQz+nIe8Bimg0me/dQRUkFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OBs70j4r; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OBs70j4r"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4843c3ee4cfso712084f8f.2
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 08:53:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790178835; x=1790783635; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3bP9y62Oup4lvnhqrGRztmwfkpYx216ETMbJiizVEoA=;
        b=OBs70j4rXRyugbP/j+XlJtjbsDa/AOZhc1wWJXL+wrjI2B/ObQvrxtrzx7V7ZdgeoU
         HWcRpbmhSlvIu+8dRCz6iH4x0BWavxWTWk12IaOn4R/Xv1DkITE+zSknXzMkWbNgWTg2
         whw8YXeEsRD9+96kM5XmM/00UicL7IcVy2OhwWAwbgiQFNUlwZa9M/kaWUUkEkmp4LJn
         YkB2yZzWkw4sn1apCm3iehwpRRyWm0R7rUSlp1pjJGGOu0T+rIpUG4ghuzsmP0YquSm9
         ESVWRUZsolBJnG6m793GVruk0j48Mx7UHDLYZQKQeg/Ionm4BdAWkPTZZySr1k+G3dC0
         r9hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790178835; x=1790783635;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3bP9y62Oup4lvnhqrGRztmwfkpYx216ETMbJiizVEoA=;
        b=kJLtgzm3EmY9cBn6YV7KPCDJge3JyIPehwDZ9qU/AL9NVGV+CGnibspPXu0qZNOrhb
         ib5MunZAfVkU0B+sk3Q/x2IVbhHBxqdAM+nWSHX6Q0S+IJxCZKkzIKoyDdIGJaydRHiO
         4Tshs5B3XjJuUd0MtIydDgtBxR8G7onE0RZFzPhObtOJ3iitwfjItiwajtgsmJ9vrjUq
         h1j+cZ7vdzOtj7fCAOfmeTM2rxFz9EUD2k1m6GNoSabeBaRYqwOk7Uorrl2aDAhz+kb3
         8uLJ+HY0KSD3jccOwdiym/9116A7Bvmm3r/GJc9Ja/Tm3Nmgb3Jio5mF8Erhhoz/w21D
         WEkA==
X-Forwarded-Encrypted: i=1; AKwUvBxjizpZcbq88SYG6MBMl8tDDLvCMYNr4Y0K6VSQ9F3MUTZiXTh1nzJvPORauOOiaOZf18k0+/Yi@vger.kernel.org
X-Gm-Message-State: AFuF++naIW/ZY7Aq+SwojaJ4/9dXMmZPa7SKm4TqDBsvZqexxI0/0pIz
	fKmtCjF9+zoS2AmEm9M7NhOLRuwWJW29iggsd41iJZMlwFVAmZjnqmWXt5HghE6uxWg=
X-Gm-Gg: AYBFou00FqU0A+d6tf987DRt60XfaiEMhUcIM99yWAUMpRV5/17HUiNTPMfxHVN57iS
	17UdWELf/spw5NoqG9Ewg5daopF7tqbD/PeAHtV7fLsAmeLwVNCkq1robLvvBPuvgmaTAUeE2dd
	7sw3f1Y/3Bh98qaHsyyJhm7PdFbCw6S9An9YwuXzLsaX2egRaWEztpUmNPXQBubEzjInyJpt3Qs
	7qwId01e9wjlQVStuRcalb9v6gfXG+UiPH4O30wH6EaDtSmsf5ksnp9R2NuTtGvCmC0GptODaaF
	pPgVNVSoulb0tLJEy1JnRLsK1zdCLXCcvpF03TrsbSAUW6AViBU88JwN8dL/0h14P5ETnx4OIH/
	IAq3ewS3kPCZ+9IThi1Q5+Psqv2kfe2dWf9Hwu0+oBKe3DqIq7Cbw5U7BmrOq+hfAuVg9NccMbj
	mfDrj47xqqPfh2jJZfuDQcdaPxetc9Ai2i3A6BO7tnVOtTFz4dPBGX1HgFL1ej9HGpZ6l3denef
	UNvhFqWUaHd
X-Received: by 2002:a05:6000:490c:b0:487:a15:dbee with SMTP id ffacd0b85a97d-4886708e6f7mr4833638f8f.21.1790178835301;
        Wed, 23 Sep 2026 08:53:55 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488684864c8sm7826188f8f.13.2026.09.23.08.53.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 08:53:54 -0700 (PDT)
Date: Wed, 23 Sep 2026 17:53:53 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Peng Yu <yupeng0921@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, 
	Chaitanya Kulkarni <kch@nvidia.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, 
	Maurizio Lombardi <mlombard@arkamax.eu>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] nvmet: add cgroup_path to charge namespace I/O to a
 cgroup
Message-ID: <arP0TmdK3FnNfbwH@localhost.localdomain>
References: <20260923152653.40953-1-yupeng0921@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hzlqajg3mv3arfe4"
Content-Disposition: inline
In-Reply-To: <20260923152653.40953-1-yupeng0921@gmail.com>


--hzlqajg3mv3arfe4
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [PATCH v3] nvmet: add cgroup_path to charge namespace I/O to a
 cgroup
MIME-Version: 1.0

On Wed, Sep 23, 2026 at 08:26:53AM -0700, Peng Yu <yupeng0921@gmail.com> wrote:
> Scenario:
> * Create multiple nvmet subsystems/namespaces.
> * The namespaces are backed by different LVM logical volumes.
> * Some of the logical volumes share the same physical volumes.

Why are LVMs mentioned? (The test scenario doesn't seem to use those.
And the example is backed by RAM, so where would be any IO to control at
all? Note: I'm only giving this part of my attention span.)

> * The subsystems are exported to different users.
> * We should provide each user a specific iops/bps quota, thus a noisy
>   neighbor won't impact the performance of other logical volumes.

Why cannot you place users into respective cgroups and configure
appropriate per-device limits?

Thanks for providing more context about the scenario so that I can
understand what's the goal and obstacle.

Michal

--hzlqajg3mv3arfe4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarP2CxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgvggD/d9gzMHzRXPo0QW3GozuS
6+GKtlUqeoMNLRjR4PNAct4BAOxZLhmoLgG4njhrXd22B3KrqQFIKeHLGaLL0g3u
KzkJ
=e8GX
-----END PGP SIGNATURE-----

--hzlqajg3mv3arfe4--
