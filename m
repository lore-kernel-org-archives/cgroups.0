Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91227442399
	for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 12:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791809140; cv=none; b=gZ/ROW8jOS8IUTC7W8dAsb3u+VbDrDfQQ0gag3rNT/GqpsbiCzAaC+XM/lvRt2EA4KHG8XGocbqdORodn+sVnFVW5w8LXwU5nSwRZvk/yOa19pk15PX1J7Yx0dlq2wmUCv6FnJAZIwKV+WYGvtVNj+wrTvezrUH+DEs7zjRMAF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791809140; c=relaxed/simple;
	bh=Gz/v8fFmjlJ/nOXeGfucNPqVrqLu004q7AExsn89kQ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGjYgQhVmmPiTjqvzH8JsAG4miGTimfO0tiWXJcJIqrziIrvTLFIvoIaerZ9N/+E4PQRJd+4/hUxfJheEF5zz2CMCZcSbgetxUZYkdnFsKsDquqJiFvDjUqQ7qju72cXFi2vSqiZBSMtjzG9bhyAwL9oBxBO+hSWWyn7HWDkMs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Dmur+PDC; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Dmur+PDC"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-48b001cd92bso1045108f8f.2
        for <cgroups@vger.kernel.org>; Mon, 12 Oct 2026 05:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1791809138; x=1792413938; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=an/ERodSzuEqefgQ6URo9mMgAyarZVhVNb5a4ABoOvI=;
        b=Dmur+PDCAXMswbkxjMhtjFQm1aFi7pMxNACn3wDH2JT07Njj0pmsiLmnsuHYjF53UD
         zgqtitUtJu2v1DFYoFXqrhllVTcuApWCfXiBvcP++gdEdkqtxlgM1ytfb3+VP+VmNUy1
         afEd2XtqpXiKo1Q3Ak0E3n9uSi7qUYIsBkXH5TsGuHj/fL4zAzY801oicX1a370TOA11
         AeHezpmb4D9+Pe3vSDHf+X411dEAXXsNjXQ1A/vMsottUxY8VpqF7OpTfZ4XdJa9bg+b
         uM/vDsTe48k6inugRIaM3p6p1hNABm/TIjlsRyGCVWenVuLvgYCJuCHPaFf1L/d4bsiF
         r9Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791809138; x=1792413938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=an/ERodSzuEqefgQ6URo9mMgAyarZVhVNb5a4ABoOvI=;
        b=dW9RnXRFfjFNxzN6zCcmFWLbEzJBhDCGZRqblMda5uR4m0bO/DeRSpLBE0pKDKmuuu
         5LFyY+oOQet2Nm9MwGLol7UnMGuZp28w+q8EeP8xv5RzGtI5HTkGY+W9Z72llo8BAaqZ
         stJYwGnJKLdAfP8mhDE7+a+hSofJl6G7CEu4SN8MVVbbuMTZtsfCKdJ6bq5zqzlAatve
         E3zoEB8RMxkcQDMFy9r+gRE+F3ajJBzwRJ8Tbb15T7ArAr5IebBNqJcqIK7v6IsKuZVN
         CoLvaSIZnQc6AHi3QcHHDPDWR5DP1t8tdbc+4Q1drqAtvu8A1mP2wui6fjXDM7ESky/d
         b7jg==
X-Forwarded-Encrypted: i=1; AKwUvByk4G4mf6VEVT6gGjP10df7xMa8oMUTprJWZifwe6FKg7FC8lCugjZAsWHF7r7D87OSCgQjaMKG@vger.kernel.org
X-Gm-Message-State: AFq9FYIWzoo15xdmr7CJCSgWHNdnyLTPk9cqw0clUHvW7cDzxHzLxjGe
	CgUQiyQMydqK2U3E/CP1ZBv13XCdUsa+yUvaPacBRmtqM+HxHGZ6r92WXrBZWgRNiRw=
X-Gm-Gg: AYBFou1ZZumT4gXRHeBSEwxcKZF59vAw+sn63fsk5mTHm91CJHwxQym2FcxNS3DhMA4
	j8bjW+Xsal4ZpPl5uw81cOP0sqkfU5fYiTvPSalRi1dc9SFPNU0zUe6R/TkyxJA2XRYDCwcAeRX
	yFj56bXNDhrI9+xxFjbpJBNlAhwVCAjDe7Ufcr/7KKZUz1+iUgIa9RjvdHpyJj8HdrVF00yx92B
	KrWiuTklmsqZjWP870rrCOWrmZB0i6UuV4TvNu/m6n2bXKgZzJH9/Nz0low3SYjTOnIiEJQ921+
	XejbASCZ6Fw2sWvHqOD81NI8M9qSQs6M5hS3HGqultMtN/xsvODg7Ige+eLj4yzXhElzlSIOrtt
	U+gVb3uZ80QoB8aHfI/pMfulV0/i1pk7R4h50bDZH+nH97k3/GVoRiFIi+fzukD3PfZBh0OB2as
	34ewvOKE+Qtd1eF/yI25T4ugkGGNZL+ZLAENSHvwtvHe5/xBOzOl66CQjoTvy2JVgYP2dr+dqDF
	Q==
X-Received: by 2002:a05:6000:298d:20b0:48c:43a4:37f2 with SMTP id ffacd0b85a97d-48dbaadb3f7mr12969989f8f.17.1791809137549;
        Mon, 12 Oct 2026 05:45:37 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48db9aadf9bsm18884941f8f.29.2026.10.12.05.45.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Oct 2026 05:45:37 -0700 (PDT)
Date: Mon, 12 Oct 2026 14:45:35 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sasha Levin <sashal@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "T.J. Mercier" <tjmercier@google.com>, 
	Amir Goldstein <amir73il@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
Message-ID: <20261012-clumsily-chivalry-c652481fc90a@there>
References: <20261011223358.2327625-9-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gylt5nk4uhld73ur"
Content-Disposition: inline
In-Reply-To: <20261011223358.2327625-9-sashal@kernel.org>


--gylt5nk4uhld73ur
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] selftests: memcg: don't close an uninitialized fd
MIME-Version: 1.0

On Sun, Oct 11, 2026 at 06:33:37PM -0400, Sasha Levin <sashal@kernel.org> w=
rote:
> test_memcg_inotify_delete_file() and test_memcg_inotify_delete_dir()
> jump to cleanup before the inotify fd is created when cg_name() or
> cg_create() fails, and cleanup then closes whatever fd holds:
>=20
>   test_memcontrol.c:1685:6: warning: variable 'fd' is used uninitialized =
whenever 'if' condition is true [-Wsometimes-uninitialized]
>=20
> Initialize fd to -1.
>=20
> Fixes: 2de27980e1d46 ("selftests: memcg: Add tests for IN_DELETE_SELF and=
 IN_IGNORED")
> Assisted-by: LLM
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Thanks too,
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--gylt5nk4uhld73ur
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaszWahsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgD0wEAmh10oDQEWn7n0aEJYbBb
uaxG6lg1fY/9sjcEXSxbRKgA/Rt/e9OL/XTpEvxAx8DVCCsJgZnLdHG4SM+IuwrA
BLAB
=3bZl
-----END PGP SIGNATURE-----

--gylt5nk4uhld73ur--
