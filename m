Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA5140F742
	for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 17:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790185118; cv=none; b=ZXcFhPB0IGXFviYaJ09t/3O//awYLPoUafvcWIj9sdpCRy7Q6HpEAxilSYsV1owruqniaeWtDHozEtLQKxioHimBxD7VBiUJKSE/oyeG4Mkxm6iHBekiBrq1JhCMehKhQkgbC0ej4t9z+50MR1i5EmQNPwWybcBrH60SDRYp0Sk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790185118; c=relaxed/simple;
	bh=XIYGGHxY9tI0JKsviu2UAjzT5cR+81bKArXmpsRjnmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TeFO7Gh0NQza0Wyj5ulP/4bu0OrHNaG8U5ii2Y/n9PxMUXoAvHMlCKJHTMVKud15YecEVUM0w0EnxhwoRQBWXAT1iTyFWbug3TamFnZHIcvQNXhZ32LgEmhtGHEW2Xl2f4Fim8/QzSufDTPqBkpLEVYr0huiEORnEpj/ufi6y9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=B0hKQKOn; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="B0hKQKOn"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b91369d18so8324305e9.0
        for <cgroups@vger.kernel.org>; Wed, 23 Sep 2026 10:38:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790185115; x=1790789915; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2E6jaqGmgCa1f3WKCO/PJDeZ3Cge2ODa7wmdYukhEmc=;
        b=B0hKQKOnllkoD2FT60WO4n98HLdL0d7fDAFN9JRzSbgRwPlZDN/RyC+vxhIY2ea37+
         MBdvYSromSs99u0IOVFvhzq15E/snr/X2fuAesUXUdAGu6hUEzkt+roVM/PGfmOKDgRr
         qFB34DMq2W0P8x/O/ugKZ5T0KXwcIgWLvIAXXndf+R4hfzLMrF+esZRSXG/P+qfd7kan
         2SCXYIqyNZcLxZ1UNEgxRsCabyXDTBFYNTTUPUp9l4bnhS0FwEEyX5gbByulo89VQgK+
         KmOmt1gRGRdqFTJu2evsex1u4Jb3x7JA4Y7DAxjiO1G9izFXWwBpVyH22bsBeOk8rg8X
         ea8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790185115; x=1790789915;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2E6jaqGmgCa1f3WKCO/PJDeZ3Cge2ODa7wmdYukhEmc=;
        b=fuvIClOZMwXTukqxXoh+MyevEyuCNIY11IeXTcXR+WKkOHkGUmFjx/BiVsGMUDGX22
         DD2fIswM/LISlM6jWU8lpuXr+aXSRA9UlpKKyvsOvRF3ChN0+F309atvGMFvR+JpUlaB
         pNsPy4QD8M8iYS1IgMnyTKBvasS06D+y/I5OwrLmKMh1ZpIg+1buB57O6TGdr4Pz7q3K
         oQA34/yjouvfmv4e4+8zzkRoNqCHdJG7FIDljtsp6PDcOgzO/3PRI98hLcsFJfE0cPHH
         WK+ODhOL8H12zdzzZFzH//64hyYzhq+DoUsapJykVrAqk2qiJV0rKsf9LHIqrs1jLCFX
         uoZg==
X-Forwarded-Encrypted: i=1; AKwUvBxKgWa5YFiMixUcoYb/+qWmbrVChs7OH5aRMjuQLqfAEEU/iCvM6xLJRCmznBt7oXMfnXnTYFVY@vger.kernel.org
X-Gm-Message-State: AFuF++kLrMNZbOjmLoOmcRwEw0AiiUMw2MExWrZd+I/F86JV5/+okiPZ
	hbwNF27ufjpzg5aeakigkRO9SJPYoDjzJ/KnKjHtm7gQxe8KBRzHd8eOBVgHZ7h8Jss=
X-Gm-Gg: AYBFou2/hd0f3xlxbeI6uhVlzFnkCzTzOOeeBDQEAXphaalWMDLxLuIj/Ep0mt3pGGp
	abSqp/5lbrSRzyhhimSyYF+0l5P9QGstgr+TNQjCI2lRGFiD1axDEWDjgpVw64CPkl3xKL8i0M9
	y7DkOki9qfTtlJ6P6gHjLI+pXpNWBnrDzyFzIVHDZytpd2+ld4+0xAdOerxsBRBRyj/FrkCjSkh
	iOzuWlv0ptS/8PS7Pf/Ag9utGIseCG5eX91O61TRq+YvesvVgxigNbFCNaGJ/qsF2kcyy6MHg9X
	2cmy7Gwhhez0q6+ciMpPVMNx6CTTJhRSPXyhramJBBxLMCwkDV7sU+EXQpJYpzR9MRqxV+j/Vd4
	yWmv/diCubu1neq0JSTftkQvIcC6SmO54ceLCuDcNHiF3OPxL5JZM9Gxq9+ZtquZ5eQBo4b56q0
	b+ldYryPivCzzStJZ1l7DhyG19Ktg600Yx9qMgOsylepodaKGLntXO7cs3W+1HyMULS5xC2+DlD
	Hen22X3jH6G
X-Received: by 2002:a05:600c:354e:b0:49c:fc6e:a3d8 with SMTP id 5b1f17b1804b1-49fdf13d72cmr52800525e9.23.1790185115110;
        Wed, 23 Sep 2026 10:38:35 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fe5cbd134sm2334655e9.9.2026.09.23.10.38.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 10:38:34 -0700 (PDT)
Date: Wed, 23 Sep 2026 19:38:32 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] selftests/cgroup: Add a test for the
 /proc/self/cgroup namespace view
Message-ID: <arP_HOr98HkTC-mK@localhost.localdomain>
References: <20260916111445.245788-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dlzzjlynwtbxxvfa"
Content-Disposition: inline
In-Reply-To: <20260916111445.245788-1-sunshaojie@kylinos.cn>


--dlzzjlynwtbxxvfa
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [RFC PATCH] selftests/cgroup: Add a test for the
 /proc/self/cgroup namespace view
MIME-Version: 1.0

Hello.

On Wed, Sep 16, 2026 at 07:14:45PM +0800, Shaojie Sun <sunshaojie@kylinos.c=
n> wrote:
> ---
> RFC.  This adds the missing selftest coverage for how /proc/$PID/cgroup is
> rendered for cgroup namespaces: the behavior is documented in
> Documentation/admin-guide/cgroup-v2.rst (section "Namespace"), but nothing
> in tools/testing/selftests exercises it.

What lead you to consider this as the missing coverage? (Are you using
some kcov reports or just the docs?)
What reasons do you see for this to break?

>=20
> Two points I would like feedback on before asking for a merge:
>=20
>   - The third case, a process moved into a sibling cgroup of its namespace
>     root, needs the parent and the child to synchronize, which is about a
>     third of the file.  Letting the child migrate itself after unsharing
>     would remove most of that code, but with the nsdelegate mount option
>     (which systemd sets by default) cgroup_procs_write_permission()
>     rejects the migration with -ENOENT, so the test could only skip on
>     exactly the setups where the behavior matters.  Keep the coverage and
>     the synchronization, prefer the smaller test, or split the file into a
>     basic-view patch and a boundary patch?

Looking at the sibling cgns is not so common, hence the test isn't
easily implementable. I prefer the smaller test w/out this case. (If the
child checked /proc/<other-pid>/cgroup, perhaps it could be simpler but
some synchronization is likely unavoidable.)

>=20
>   - I kept the ksft_* style with a tests[] table which the other tests in
>     this directory use.  If new tests should use kselftest_harness.h
>     instead, I can switch.

I'd like to gradually move to the harness, i.e. potential new code could
use that.

> This is an RFC, not a merge request yet.

Thank you

Michal

--dlzzjlynwtbxxvfa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCarQOlBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgDYQEAvYW9wgZArew5M47LpPCO
hGwpgUqD9Yn/cxh3OtaC6Z8A/ArHMN4Yvi0Oi242W6/1cKfKEGlxQTQd3csgfMMn
TJ8H
=+Zub
-----END PGP SIGNATURE-----

--dlzzjlynwtbxxvfa--
