Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9573640F73D
	for <cgroups@vger.kernel.org>; Thu,  6 Aug 2026 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786005202; cv=none; b=owcSn9anf8pZY74bcfZLvfn6cBrt0VSO+FLQcSi8vbFLFT8HJZzoEuIFDk+hAKJ3Mv2i67y6q9CCYwq8tgF3QFiPZQsTZUGS8dWPNg5nRi/FaX1A1M/dqpNXTRRAwUgVvG91yudDPmt02D0UVj7F9fgpTooYKc6Ay1UNnOAYAe4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786005202; c=relaxed/simple;
	bh=t9Gl+KvbLP+Re9xfzY/QhaWSjt8UCM1wwMDQL1wGKFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VEiaH8j1WlYBaAQ+Hp4JYhfusq3zKP4cR9pX+P9ndgu58qAU4nhXDU2zGWLkIhDvLX2vjgFMrrn3ati1Dydj/1zRRwcxi8J4PgD5dWJeGLjfjyQ8w19FfGB0oskioAOnRhSPcdxx5RSAfWbcGjmNwmu7anXLbTVldOKz9IHYEJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=OhPjyoWH; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="OhPjyoWH"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4921eed3fa2so14920955e9.0
        for <cgroups@vger.kernel.org>; Thu, 06 Aug 2026 01:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1786005194; x=1786609994; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kbwwwq24L3XnIIcYVbUsKDAVnxBveSW3by8s7kuBsxU=;
        b=OhPjyoWHS/0Wwb06Lc4goVLBj/42f39ti2gAJ0m0epf2OJOIVRKromw+YYRrjJH7y6
         7kyWeG5WpInyKusp7UuQecU9TvfAixM3JcQ5yXRAtzWkr0/rCaFy6V74NXmtroThjlsa
         Yy8+lns0FmXc1+TFX64kOEPAknFkL2NgbOd3CAdTWr7kdcHWGm7TQXEH/pzYbZc3FJjZ
         /mXYCEGCUF+tKgRJKL/cF6j9o6RbaPKwOME2FYw6d9Akfz9EAVMVPv1AY/Yr47037MVA
         hJnCLg8eaLdFJkF/zSjg0wUvaTweHRHN1aL2rOmUhChZR/Z5xHF43covoprYmizRrHfk
         V7eA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786005194; x=1786609994;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kbwwwq24L3XnIIcYVbUsKDAVnxBveSW3by8s7kuBsxU=;
        b=Ni4YIHP0IbVdQ5lpz3ghJNg0BJnJ1Y3mHUgezMI/QCrJ5u57SlJKRrz9oYVo3Kd7Hz
         e8Mx7zl0NTeNoVJ4FKnFaaf54Ef+ezjFbNsuLg6EXa4reOreSJDvhkA0tYgejdM+MO3Z
         AamVpFK+wIimTxszmajxF4IIfCE9AW9adDW3NTgwC8gRZ04I39zBHs5zM6ZwC4EdWToy
         qF4FKe+xkHd2BNrEcM05HrU230xXz3whO5j46skWPfN1MDiUcXWzj0Bs1cYagCu7zcUg
         jQonHfaBi525HJ1MrTlhGUrYxMvUfS5OBBNsmEG0IZmwxhUk/qCpBzBS6tlS0K2s/s4z
         /izQ==
X-Forwarded-Encrypted: i=1; AHgh+RrpIG+dLtHz9u8pjS2rBXVqn2Kxc0yJHdwP5czYRIalC8EBJ8hMAa0wFoNOeJCm2Bna2RorepqE@vger.kernel.org
X-Gm-Message-State: AOJu0YxkikS5h8vRzTUm25rChSCCgAnMy+ZqNklzWsKv33TmGjEyBmkm
	jmZu0LBaffgofmSjHhX8lWtmj0BRidWdqNM52ymrh0YeLU7Okip/vBVeOUVgf0qAV/Q=
X-Gm-Gg: AR+sD139hN9TJY/VVzmmMivtpAdSawgdpjqLTN//d3lCH7shkkyjHVisEtR4H/MNT/u
	Zs6dHp4FSIjymMNuFFxZ51SEEbfeS+qOCpkJJMU7XSscwN+PY3WLHL0cT8pR1kLAP2bhsBAjW3g
	5CL43W4aaduFoKlyZIBo2TJ9cXfxXF01r1DwgJNFh0+EWZCKyIuSmshrG2HXOBw0zYTCQPrrkSc
	lk2E42AsfA3qIO/hwy/JcSW57oQKwanZeJtFTsihlERMk5blAVl8UyhlRaWg1jKZIa2l+qX1oDG
	6GJzLBhRh/LyhqupbAhSXOtMmpmUf3TCBWJ9t1HaSQ5qiFd523/KzwV9kp2WQoY+GsaLo+4EFKG
	cZfrvRUyhPgu+i5+s6sh1BEViUAn0vddl+Kcoysx0UNHiR3QqoUF9D60HNCafyTx3SsKXxK5cbX
	hgRc8X3glFWW9ezg5lR8AZqQVPhfkazzCEyhR76ozCsajmi27SbOnIHNcEBaK3DzfZz2xwQ6ikr
	5k=
X-Received: by 2002:a05:600c:4688:b0:495:6bc9:62b0 with SMTP id 5b1f17b1804b1-4994e7d1487mr163017845e9.17.1786005194371;
        Thu, 06 Aug 2026 01:33:14 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-499542858b2sm48595955e9.14.2026.08.06.01.33.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 01:33:13 -0700 (PDT)
Date: Thu, 6 Aug 2026 10:33:12 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Wilson Felipe Pereira <wfelipe@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control
 write on EBUSY in test_zswap_writeback
Message-ID: <anRBETN6znndbjyr@localhost.localdomain>
References: <20260804042053.56940-1-wfelipe@google.com>
 <20260804042053.56940-2-wfelipe@google.com>
 <CAO9r8zM9H8iMOE2FE-H47CMUAExf3VcCf04anT=_Ja=m=sbr4g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nas2iww3rivojx2z"
Content-Disposition: inline
In-Reply-To: <CAO9r8zM9H8iMOE2FE-H47CMUAExf3VcCf04anT=_Ja=m=sbr4g@mail.gmail.com>


--nas2iww3rivojx2z
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 1/2] selftests/cgroup: test_zswap: retry subtree_control
 write on EBUSY in test_zswap_writeback
MIME-Version: 1.0

On Mon, Aug 03, 2026 at 11:39:14PM -0700, Yosry Ahmed <yosry@kernel.org> wr=
ote:
> > diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testin=
g/selftests/cgroup/test_zswap.c
> > index 49b36ee791606..312d51887a1d8 100644
> > --- a/tools/testing/selftests/cgroup/test_zswap.c
> > +++ b/tools/testing/selftests/cgroup/test_zswap.c
> > @@ -407,8 +407,11 @@ static int test_zswap_writeback(const char *root, =
bool wb)
> >          * Thus, the parent's setting shall be what's in effect. */
> >         if (cg_write(test_group, "memory.zswap.max", "max"))
> >                 goto out;
> > -       if (cg_write(test_group, "cgroup.subtree_control", "+memory"))
> > -               goto out;
> > +       while (cg_write(test_group, "cgroup.subtree_control", "+memory"=
)) {
> > +               if (errno !=3D EBUSY)
> > +                       goto out;
> > +               usleep(1000);
> > +       }
>=20
> I would honestly rather create a new cgroup here instead of reusing
> the leaf cgroup as a parent, to avoid any subtleties like this in the
> future, or even split test_zswap_writeback() into two test cases. I
> don't feel strongly though if others think the simple wait here is
> enough.

I somewhat agree, I'm not sure whether the recycling brings any signal
to the test.

In the case, the recycling and (re-)enablement is needed, I'd suggest an
explicit check for emptiness, the best of utils arsenal seems:
	cg_read_strcmp_wait(test_cgroup, "cgroup.events", "populated 0\n")

Thanks,
Michal

--nas2iww3rivojx2z
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCanRGxBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AgPAAEAnkONm5a6/QU81n89rmaO
gX8APeieENGJZExlGWvR9vIBAIX33lBPb1rWjVE6b1pdC7aLDpHTt2AoQfLJFbmA
yzkN
=sJQx
-----END PGP SIGNATURE-----

--nas2iww3rivojx2z--
