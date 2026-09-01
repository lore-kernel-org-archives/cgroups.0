Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44A46471D0B
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788253029; cv=none; b=S20Q+HaBfl5EC0StqJh7GHdB0Ojoz7orG6MzQW7qjvKgiVWAyGmQ0kEpZ8aeK2lrrfrzaInVG/dGdnlfwi76E9+UF9Z5te9FK7aICE1wIHHtYkZ5ZRRm9FGDPVl9SxUrJSLPq+f0KKXWi6/mdGRIq4cizSQj4cIaJ9yk/MWsnJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788253029; c=relaxed/simple;
	bh=qTcgY9EoeEHxVXgfiEWeuxCxjc4a584z0cwmku5Yd9g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VPVzsq+Jgn+0Gd0xBNOuSxbKnwHq5wBmllosSRubbSUIsylztfdtqQ8yF6rprNBgjMuSU6srX6F5TbkXZOzAy1sc4JEIHGjX7jmnE9+VMdQJ8rhCu4/1x8Q9ZT9+JaOIFWodshmzPslsIZ0asf/7lKRVTqI6wphomPCGXBPXTF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=UdDu2vPL; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="UdDu2vPL"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49557167508so47983245e9.1
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 01:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788253026; x=1788857826; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xrf2I5rwuZTtUj0/BgFzlW7VpIjkJf+F8+X2M3EKpgI=;
        b=UdDu2vPL8ptLlQXDjEu0QIyl1qM2qWV8g6iTYXLlSAurDvDYxMEICyQcgoiTs3bBa+
         Zpm6/ZVHsLl4IYeZpJE6fSCAx27965xo2PDKDW9Jp3JjzVCMYrVBa0kIPbg99RbZuAwV
         FpFYmo5BcHUNwrtLcnoubFnpqinQ6vCgvCVhVomSnpjeaqjxBNNuK3rd1Gbde8ObP7sf
         y/j6Ne8+4j7IqG4EiMsv1v/d+VuJXDDT8UGTic2AlVT+ZArXleYP/tG/8rQE10AU3K6e
         tqxqhE5vOeUu3ZSI71cXaifgZgPxPqFJUWVU140301WhpbgqIIMfY3w2r22YsQciTWQR
         p3sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788253026; x=1788857826;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xrf2I5rwuZTtUj0/BgFzlW7VpIjkJf+F8+X2M3EKpgI=;
        b=bkHRUIn5jCIVZsIGoeFoPxmyjj6nnKyGZtOO7FyBfPwsDdtWnMhBNwJtbxQ34w4uTK
         9LZVu9f7EJKE8lQD1dNOz+lBdpg87c59aAtUfd0y0uf2reeGBnVRg9an/f80rU7iqKsU
         786bbU+LvVqx45dZc8fnHfFQ00vmyZdgl4kaXFz2MZoxmLlsmedaApOnMSXRyzp+T7rL
         MpSWQf2DEm95nb7wZn543CsqtgsYj6AxDMqHIkHck9W4Sw5gMFTs1y0byapcZl4Zhkle
         b4cWtqdLhZ98OQiziReQXtPWD70MU4MH25CSxv4Uo9QtzhdiRQmt2vVy1XBXf0qB3Zyu
         vQzg==
X-Forwarded-Encrypted: i=1; AHgh+Rp5zQi/1bva/rr0jZhbcx/Tvwc4qczxntWlogCD7lv00DQRw57yHO+P2Ch0U/GZJAwCsooP9rK5@vger.kernel.org
X-Gm-Message-State: AFuF++nJLEBwc4EUSM795L2MOgxd/DpHr0PB3U9Y8YBdjp/5QL4xEoVe
	eqHBVZ5dQR3iBWR5Gzwr93pzBevNg4y8PPI59+zFUFWmB1u08rq+qLKWQPGpL9hGeKR0yX+Irl9
	AWm6908U=
X-Gm-Gg: AR+sD112u67UjgZhgFNdczBScBdiAXQKs5AYsKSQ//Eow4KxAJ651LnP/DsFk2iQNkk
	1xwRZh1+TEsGaEdwGhA43+00nvVhB1RyiN4WXG/T1aY19q1s/gV4wFUtbdHxfkmtn97mxH9ZVOW
	h8bma9XoB8nwpxfB4EEOeiA9mvBu6GBoJ0w2xB7glKhodF373Y45hxtO7dCvA1ts2PTm6O2Sjx6
	yYavo0meTVteLDVxB33RbRZhXMPMxsBmxAeXhgVEFVdIQCr7bdSndA71IJuPPLqc80eC2QqdH8Q
	u+WMR82sgpgmEWM+heYPMfBdXK2RTMYKHt5UlM/Aw7ARpEH+icXdWzGn7vTUIjQIe5oLV0IfLnX
	vkljuzBZaRCV8Ghi8KSeaR/EqXr3lbVsmOOP0YGKCL4e20FkgtrXisD9USbS3KkyCHDTWwyeF6t
	MoVY/ZgyoioG23J8Tvx5+JBZ2M4nU+US2QCUXpmII7ng/i38ZpbxrxoQJigFPQ25Y=
X-Received: by 2002:a05:600c:64c6:b0:495:52a5:8829 with SMTP id 5b1f17b1804b1-49cdc558470mr121172455e9.11.1788253026345;
        Tue, 01 Sep 2026 01:57:06 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48442c4259esm3313283f8f.7.2026.09.01.01.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 01:57:05 -0700 (PDT)
Date: Tue, 1 Sep 2026 10:57:03 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Wilson Felipe Pereira <wfelipe@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
Message-ID: <apaO1OHVQWJCuJDE@localhost.localdomain>
References: <20260901052250.154532-1-wfelipe@google.com>
 <20260901052250.154532-3-wfelipe@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nuwu7tagmytj5izv"
Content-Disposition: inline
In-Reply-To: <20260901052250.154532-3-wfelipe@google.com>


--nuwu7tagmytj5izv
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 2/2] selftests/cgroup: test_zswap: fix implicit
 unsigned promotion bug in test_no_kmem_bypass
MIME-Version: 1.0

On Tue, Sep 01, 2026 at 05:22:28AM +0000, Wilson Felipe Pereira <wfelipe@go=
ogle.com> wrote:
> In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
> checked against stored_pages * page_size / 4 to verify that the pages
> pushed to zswap belong to the test memory cgroup.
>=20
> Due to slight stat update timing differences, delta can evaluate to a sma=
ll
> negative number (e.g. -5MB out of 1GB). Because delta is declared as a
> signed int and stored_pages is an unsigned size_t, C's usual arithmetic
> conversions implicitly promote a negative delta to a large unsigned 64-bit
> integer, causing `delta < stored_pages * page_size / 4` to falsely evalua=
te
> to 0 and fail the test.
>=20
> Fix this by declaring zswapped and delta as signed long long and comparing
> against a signed threshold, ensuring negative deltas correctly evaluate
> to true.
>=20
> Fixes: a549f9f31561a ("selftests: cgroup: add test_zswap with no kmem byp=
ass test")
> Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
> Acked-by: Michal Koutn=FD <mkoutny@suse.com>

(The long long helper is a non-trivial change, so the ack should be
stripped on this version (unless you can convince me ;-).)

I'm afraid this bitness propagated too broadly.

The long vs long long difference is only relevant on 32b, right?
And the bit-width issue only appears because of the product, not the
values read from memory.stat [1].

I'd consider three ways forward:
a) Consolidate the helpers into one cg_read_key_s64() (same explicit size
   regardless of arch),
b) keep single arch-dependent helper and tackle product(s) only,
c) do not bother with 32b in these selftests (I have a hunch that
   they're not so relevant on such archs).

WDYT?

Michal


[1] At least the values derived from available memory, memory events
    could grow indefinitely. It's true that kernel uses explicit u64 for
    all of the entries.

--nuwu7tagmytj5izv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCapaTXBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ag6rAD9F+z0oXfuQAC+NJQ52/69
Wy9h9jBokjfFxG+tYku4HusA/A3LjZsf4+90ciLSyVy6BFPvXQx3uN958bN5VesH
mjUK
=8Zx/
-----END PGP SIGNATURE-----

--nuwu7tagmytj5izv--
