Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDEB847D950
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 09:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788255643; cv=none; b=Ju6Dfbfk4qWOaldBmVMUn1vsvAuMB/eyNNVBHHG0B398GcWD89KoPtTZGgxgAwNu/E75mnekEBP4ytic445x+luKWTmA8hWDjEYpmxh7CXnzKvBlURrN8Lwm+gCa+Pw8l1j87hvpAP0HSnh/wjrpLYH3BBtz1sp4RDoUqfYf9u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788255643; c=relaxed/simple;
	bh=S8lkRIWm+uNfv+3CZrx5vRCD9AZGpRpRYr/2FLp8tS4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FZwfVlzNO26k3/lz0kC8FWATlyZZ76r9ZXxljFYOjrf0agWg8ohohQu9sczryrSv4OmhvyYoqDMNU/IiKkPJ6Yob0/8fQrOGbnv/0EaHL2sXXVS8i1hja0avNeIkjV7zRfbtjUomN1XFse3SFOnAMNu4HGvU2JmpUG+7+APyeQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=eT2R1lU2; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="eT2R1lU2"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49cca4ffdcfso4708735e9.0
        for <cgroups@vger.kernel.org>; Tue, 01 Sep 2026 02:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788255634; x=1788860434; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5j9n+oKHaFzgx1DDinsR7OA0Nu8ZG/xJIjlL9o5nBTU=;
        b=eT2R1lU2XpYxHcgDGoPt8mrNUNvZxWR7WeZbWXXroZd2o5NInrISWInBvRnaPjprha
         8v6wmlb3L/lM7VFIvTzEAC1RfJ/vNywbFLAFGkb8kZgC6RgRc8VEtdNB5JT0FiPH43gX
         rWkbYqntOWaw4eVRKBt/nljC4xU9ix/rBIgV9aOzbBb04ZjDcq6lu1G0GCSoyWNcvWmN
         vVaMec/9bK80YJXV4Xx4LWD7G1LsS54JoBiay5gV7JxB7YdsWdAB5f+BxgyZ8yrh3XsX
         cvG6aUUxSIscFUc/c1QEws3z1AlMZR6n5Qfq3c23EPqlo8JXJ681ddbcan1dTJz6VHDA
         y+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788255634; x=1788860434;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5j9n+oKHaFzgx1DDinsR7OA0Nu8ZG/xJIjlL9o5nBTU=;
        b=X8Scimm6rBhNYA/VZanDyYvY09+d6O+tADqQRJzP1CNl7F/csGYocZJcYwqRXJ3Ryd
         t6oDQDWV+T6YGvWiNUEfDiaiC9NtwB2eK4cek7fYdTdjxUbkKpoV4xbeKjKP+tUwb4is
         1W2lAEi869SzrCtWJnHTlnMPmNrCV9b8sP9HhUPhcv/xwscHPHBuAUlIoEqvhiVevGAc
         MrIeMjcLTQ4M9fhwVfasbjjDMftzO+ZP/x18Igoq0YNMSyrmde5YFSTMN1fjoPvytKPp
         50Care0GUqIdr0W5Ph2NiNMjgh3m+9c+4kO+0Gm/NKqyHiEaf2ol9BOiXemJjbUE/VRR
         Jviw==
X-Forwarded-Encrypted: i=1; AHgh+RpxYB6u8d8YzmZBu6MZ6qFJJOPGSXwwY0XUkoCm9EUVJL9Kx1X2hAzVV1AizyRJ6QODKyteK1Mi@vger.kernel.org
X-Gm-Message-State: AFuF++mEWp4Kc3JQS6KJhiXL9y1aZCxXOhDdm45vuTVnX/P/HzebTXl9
	yggWK9iCf2MNUBDSAxPy9ei+IEil6VBbITKlik+qHn1JOFrVT/X/C/E2Tj36uCtxzhE=
X-Gm-Gg: AR+sD13PW0OpXXxu/tKvI/6hg0RkJQkA7I4D40vL8uFhCnkvd6TGJj87B/rTJu15qEx
	gDfdsyyNtZ4l/+oUiAxQlNOi6OcfJSHmFEoqAULP5AMlh9t1VPGTYZKCgh9atYhZciLCZhCU57p
	NFA3ki0kgJdCUAHJvbhYhx52Fo4LOxVtUjOANx02WMwmVhPEb5EtAWpfEREq69tYRxVb0z4K15R
	HxTYQIdOBikULME8t2ErZl8z0/ostrhgNc4GP5VPK8z2PdRXcjIr/hPTQ6JCfQlxs/EoTphJVgu
	TJ11xLeExrHYhX4wyrJeAJ79Fm2xask7mM0oEhyAknPSyRPtUeftxYDOis9ZlQ7xiepg0IOV6I/
	YuUL9VxYbrASFDwZUIS0O5lqq8cDaiCpCwSx9ROGGC2wo+1iHHnuulgsBG+kbOGMS3Jow/4ebd3
	E8a5V8krxxH38aInRNogVv4hFsbC1C6gHLmecepIcN0S9Mq2RD8Mf7dSw8a901zZ4=
X-Received: by 2002:a05:600c:1f91:b0:499:bf8c:cfd1 with SMTP id 5b1f17b1804b1-49b91c1c784mr475965405e9.2.1788255634423;
        Tue, 01 Sep 2026 02:40:34 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cdce1e3a9sm54689305e9.15.2026.09.01.02.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 02:40:33 -0700 (PDT)
Date: Tue, 1 Sep 2026 11:40:31 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, akpm@linux-foundation.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, dev@lankhorst.se, mripard@kernel.org, 
	nat@pixelcluster.dev, tj@kernel.org, osalvador@suse.de, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	kernel-team@meta.com
Subject: Re: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
Message-ID: <apaZdbM_l3kJIiyK@localhost.localdomain>
References: <20260831163752.2193337-1-joshua.hahnjy@gmail.com>
 <20260831163752.2193337-8-joshua.hahnjy@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="xo3yor5m4gjcubez"
Content-Disposition: inline
In-Reply-To: <20260831163752.2193337-8-joshua.hahnjy@gmail.com>


--xo3yor5m4gjcubez
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 7/7] mm/memcontrol: add stock to the memsw page_counter
MIME-Version: 1.0

Hello Joshua.

On Mon, Aug 31, 2026 at 09:37:51AM -0700, Joshua Hahn <joshua.hahnjy@gmail.=
com> wrote:
> Before this series, each memcg had one stock shared by all its
> page_counters (memory + memsw). Now that the memcg stock was folded
> into the page_counter level, give memsw its own page_counter_stock
> so that it can benefit from caching charges as well.
>=20
> Note that while the allocation is conditional on do_memsw_account(),
> the freeing is not; the freer will only free non-NULL stocks. This
> matters because do_memsw_account() could have changed in between the
> allocation and the free.

(Just a passerby comment, I have no remarks to the overhaul.)

The change of do_memsw_account() is because of re-attaching the memory
controller between v1 and v2 trees. That's not so common operation (but
not ruled out), pre-condition for that is that there's only a single
online memcg, namely the root memcg. So it needs treatment especially at
memcg offlining (which is what drain_all_stock() (also) does).

I don't know how expensive page_counter_drain_stock_async() is going to
be [1] but the v1 parts here could could be guarded with
!cgroup_on_dfl(memcg->css.cgroup).

Regards,
Michal

[1] Now, I see in 5/7 that there's the counter->stock check which should
    be quick bailout on v2 (maybe quicker than the cgroup_on_dfl()
    I=A0proposed above).

--xo3yor5m4gjcubez
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCapadjBsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiQnQEAn+3D5Q8gH9HbW/icWG8F
xGfgUIWouB8aOWqljr/HvZ8BANwLXDa9DIP7tkMWmP7WhMnwN1qjocussmXJE+Bl
QhQK
=VQ9y
-----END PGP SIGNATURE-----

--xo3yor5m4gjcubez--
