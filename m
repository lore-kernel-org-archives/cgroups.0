Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFE23E51F7
	for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 12:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789736346; cv=none; b=Dn4hC9N2I8bjjHVF6KPLVFScvwtVUrOk3s+3btFvjWpdUq+kTuGQcAt9V45OV2iUfM+XFRloZchCXPhthV4lVVtkKW4/qp/ryKX5jPIHvi3PzFhWzVUDUM2H/f4jrLZeh0odG8Q1P4iNg4niR5iY7ZQ9dk2MskLXlsh2KwN6zCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789736346; c=relaxed/simple;
	bh=GeGe1G7IqSHc7gRJJW5jBwTcx8OPDQooEPSShzO98Sw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QOgfkIUKOZ3o1frdd56WrLaFkMilUHxg7D6PZS+Yqvj8gwQbnqTJU4BuUrgr808skQglMnF2XtODU4kge2EVvYGfxzOcMemdlCiTX0bwDIgzykVy1IIdc7u/UR9kmuMBgM0TckuhhZhkkiMrGTCCwyO3JCH2TeniDeXLc8LwAsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ye47TcDw; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ye47TcDw"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso6811265e9.3
        for <cgroups@vger.kernel.org>; Fri, 18 Sep 2026 05:59:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1789736342; x=1790341142; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lQXJHC3pkovuXf5ldAtUgyIK3nhX0Z0HuIkj+p/dp+c=;
        b=Ye47TcDwl36hiIIY/V216Mjell+JTfC+lqa26KjtwlafaOi6ROVxjiiz6Rf5JEvz92
         4fGCWswLY8ewJqpjb4ElHqOZ+X6fHysp/DjgzdUqqp43tqxfTC0R2G/QcXInVSq36o2A
         pl70tzgCWZKTcd5C3/x2fm6EiFu9XLYq8QTI6bcoh0g0uYCVQUvPAQ70sdar761GoWVj
         HsDErRmLjbYrlNRx71onaLopvzKJEoFXSfFLedEdSEeCK7emHYLc67Xnlhzd0weg8qno
         RVZpXCQsaSmlLO4YEvGAKPqPEJI3Msr05+b8EvVme3u1pp5XGQ1RuHnM1JUkGlTo+Zmo
         FRjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789736342; x=1790341142;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQXJHC3pkovuXf5ldAtUgyIK3nhX0Z0HuIkj+p/dp+c=;
        b=eqt8e2oa5iGn3Xigpk3/VY2XHgpFiDUVHHckZ0pMqsZlsU31lL1X5vjVxjt1OMcJOq
         NcBmK+H3ZE5dQMOLOFlFk7hgPzeljLRs9OLDQlPFGrp9lvqow23P8g+o1YeGOqCr7jgk
         r+RheIiBdB4i1Qaoy/cQKptHVJg5tnoOEaZj7vEm/1MGw+vr4O5y+6FNqZkzCP2NAGyx
         wMsAf0HyKUzcJtCMa7rrA2x5jRcdUDv435zSEKJbuqfprlQhtEmV6HsdHWvigbbXftcY
         JE9GfUkaMFHOhyXV734E07JF6UC2EC1ucAD/i6jzJ+cxRgS8tKe3bjRLMzZidwpWmyab
         kIgQ==
X-Gm-Message-State: AFuF++kTe//zSMELXfby/Ev90GumopZg86AiUy9o0Hqt3WVQ+SCbDLHM
	NBTe8dLsxs3W0w6BrhMaOpo9VnCb0CILCYPIF4Xo9cGklPRaHG+wVZ08tD3bo5uOsoA=
X-Gm-Gg: AYBFou23cnPZ495nMBfZ9p6GXQTAStleLrlkjmZaSRdDXknPRKiIqxs+cv31/eZPFi3
	sgQGCuC5UaLDZ4gsG5NMNZWkqaqQFhzFjNdKaLG9XpS3n+z0ihga7pF+sK3hlrHNf65Of38rpMF
	gvtviEkaNiqIDBGgDOAUPRTEFyBNz0px8BFIdhsvd9j3QYKlOoPPwKibptgVv8JmmSeXDBsCxOa
	1oxri904rzk1/9gFH/FOrpJKOXgsHnCLSW4DYVYMVWgFgodPa6D0evJ7ZizmLW6IYvw7aOgLj99
	hAyrLaJRZwynh+vJ6iSuD0ifDVpfw5IzNLR/u8tH5p7EDCFr77IT5lNjBjfXG1cUTk6s07UvR95
	Y1xtp9NVYh6IXHJYPhe57p0TdFcstfouFEPsqcyIbfIwYb3J488c6gQu/8+/xWdRDSjglHpXvFo
	ftgpJqlvIVCiqPPFNIaVfXjRaBnyFpps+1/tf378ahFyjLZVya9Sec7dgyDMzC3l/In78i7LXjX
	A==
X-Received: by 2002:a05:600c:474c:b0:49e:817a:ca7 with SMTP id 5b1f17b1804b1-49fc56c3c34mr33478845e9.8.1789736342572;
        Fri, 18 Sep 2026 05:59:02 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fbd1d0d0bsm153252385e9.1.2026.09.18.05.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Sep 2026 05:59:02 -0700 (PDT)
Date: Fri, 18 Sep 2026 14:59:00 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] cgroup: Use %p for pointer formatting
Message-ID: <aq0z3hEYggA_TuUD@localhost.localdomain>
References: <20260918104852.1p2fz_-_@linutronix.de>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="hol7rf6ipdlfvwqx"
Content-Disposition: inline
In-Reply-To: <20260918104852.1p2fz_-_@linutronix.de>


--hol7rf6ipdlfvwqx
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup: Use %p for pointer formatting
MIME-Version: 1.0

On Fri, Sep 18, 2026 at 12:48:52PM +0200, Sebastian Andrzej Siewior <bigeas=
y@linutronix.de> wrote:
> Since commit ad67b74d2469d ("printk: hash addresses printed with
> %p") pointers are hashed by default and the behaviour can be controller
> by `hash_pointers' boot argument.
> The policy on %p is to not introduce new ones.
                %pK  should be here?

I assume it based on:

| This is because %pK checks are done at read() time rather than open()
| ...
| The correct long-term solution is to do the permission checks at
| open() time.

of Documentation/admin-guide/sysctl/kernel.rst-time


<snip>
> Removing %pK makes it possible to remove its handling from the library.

This is also a good sell.
But I see there are a few of them still here and there.

>=20
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  kernel/cgroup/debug.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>

Nevertheless,
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--hol7rf6ipdlfvwqx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaq01hxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AilwgD/Sk7Ba54CIc6wia7ML1h2
cW1PQW/MUJiO01WGOOqPxyIA/jZ7e3RV3k12q5svEhRo/llH6pXXBZdQBmlUqViv
s1sI
=zDX/
-----END PGP SIGNATURE-----

--hol7rf6ipdlfvwqx--
