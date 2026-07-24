Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDBF041D4F4
	for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 09:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784886159; cv=none; b=fpmtQNjPgtzgZNzp3JF2WalKs/x1P+e0Uit4Tq2qVlVN+MnTbDMrLfqRsxWlV5b6Thz6kLleVmHQpOCpfAEcl2p+rqKCRnR1qdimulgpwK4LnVnPsOISgvKlItiPisJrKbyBHqGn3kpj3Rx8+pS1S+GkyUq9gW/OvJ7flvNsTJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784886159; c=relaxed/simple;
	bh=Fem4NKmPKh0GZYq+OrNCXgmFYs9WHmgaj0fgXfzXqwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LDjdU2ms5hfZd80QRtm3Yj0iSZ3ZutGsW2c6jpIpvEsKoI7EGX+Ag2lmlo8BQ+qE7JEhc9p+OXpQ/LpQqh8LlCyfe5Wp+vRGtNVbuLEbgkjbUduKqab8Hn9fDgdGTTyrNnSYis2nMvSfaV2GaKHKR5ljfEja0vYnEp8rKZ0kqW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bYwnFpMM; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bYwnFpMM"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49553515a8bso2842555e9.1
        for <cgroups@vger.kernel.org>; Fri, 24 Jul 2026 02:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784886156; x=1785490956; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GkHRoqsr9rnLagU9CdEmJtexYrHBEAG5U3QJpokuk3Q=;
        b=bYwnFpMMm9pf9SUFpF63yqaePveQgjaAz2alAwuCj5P59s/x4n7FP1KBVHW0GSJKPP
         R0kwtvs0jwVXt4HjEt1u9KNIIKbyhJuLBsJP3ytIaieyu8MYtR+gavhk5f2ZRMMtW3LT
         +pe68Lwrqzkwy1u/tI5n2+FfE+H4RyNBBgETRpKTxDg2k4ZrUq7PMSDfIxOg+mTGR0Nm
         vM1Nhe1O+f/8T1vpUTqdCWU5VKC9FMCK17E0v3zlMgm9jMNz7PCJaxryqif5G/7klbyX
         hsOewpC73ojbWaopPZ9iQYad5XueWTlnSTPfcin8NdJonl8eyr55X6QHHVkRlgnvM4Dt
         Nzaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784886156; x=1785490956;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GkHRoqsr9rnLagU9CdEmJtexYrHBEAG5U3QJpokuk3Q=;
        b=oLBmm50dzpXUwFd3NFErRPUl8uyMPoEqDbttAdwW/unsSefl28HlU88nfA7WyrfXnG
         gOSimpZeNjBvRxTzxNKvA9RNjyvpWUTWxZ4DnmCpFX5GU2ic1Kcr5asBb+6QNILWAeCo
         DfskWV1mDVOEBDqS5Yu/32I16bVi9NlbJEuPf970tTwTpZPhrGtn5/wMnPIOp5QoX2/x
         necCXB/kKmXFL6D3FIDIhjAhMNYoJtHFMZhY7Zgl7d4EjeSHpC5bWfp79zjHNzqs5XDJ
         m5GzahMskkbfJ6L0nbliJXR13p/N84cIQxRhfWVdRp7iayGzvCkWn8DZTEnumu+82brQ
         OAJQ==
X-Forwarded-Encrypted: i=1; AHgh+RotPvYE8Ikk8oAbiIm22YYc7LbQhEiJ2PabREhE61PK5custQLJ9n6FHutiheT1BeBNlJp9EGiQ@vger.kernel.org
X-Gm-Message-State: AOJu0YygjvUDHOzUUpG5pJ9Gl/Yx+KpduSDDKwEQuZnwezHf6vBzjY6t
	K/p3fA46DcUwnCPkCvBty0w/Ijs7AGS/UaFiakhAQaGVEPw5i+4Wmef8hn3pkGOHM30=
X-Gm-Gg: AR+sD11hAl042DXBF2tpMwgOl4VffxUeRF28bZVXs0Vb4mpZAa9+hjaLZs2l3C2PJxM
	L44KgaJM1rD7RJ05dIqfr0x2qLXk3CXQosTVoOiI4YiNwttQnx2N5mdsVTalANr6BPBBhiw3zEu
	rr5/kLOf7B8S7AAuZFOs0VHnwAQl0rSTp9AUaTzLzrl5ys9ACrWa/n/c3rqEDlUqzgyQldeeDyb
	HphMFNU/FSFkZLE+V5MlqPa2fRVh1BdmpWCEmGJoKrHn4Xr4NN3xVsF89KrzaBUsVAGLIyLSsTi
	HsDy8sZqVwj/uHOnM01jZXC+nyAxirCucfNQ3WIM906hWHxk9IL1nUFdRrcMdS6ChrlHuMyEdsH
	GIPX1snllX9VIDirtD85uA3SUxhBTiRJaXkcqievKs5jiRkshP63FJj0Nk+kQ3uelONyhC2eKZT
	D6Y98zdTbzSWSJLyOG
X-Received: by 2002:a05:600c:b99:b0:495:782e:8faf with SMTP id 5b1f17b1804b1-495782e8fbfmr50530555e9.30.1784886156140;
        Fri, 24 Jul 2026 02:42:36 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4957af910besm68475025e9.14.2026.07.24.02.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 02:42:35 -0700 (PDT)
Date: Fri, 24 Jul 2026 11:42:34 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] docs: cgroup-v2: mark memory.pressure and io.pressure as
 read-write
Message-ID: <amMzfahYd9Ua9tR1@localhost.localdomain>
References: <20260724020508.500893-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w6vmztswp5edcsiz"
Content-Disposition: inline
In-Reply-To: <20260724020508.500893-1-cui.tao@linux.dev>


--w6vmztswp5edcsiz
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] docs: cgroup-v2: mark memory.pressure and io.pressure as
 read-write
MIME-Version: 1.0

On Fri, Jul 24, 2026 at 10:05:08AM +0800, Tao Cui <cui.tao@linux.dev> wrote:
> From: Tao Cui <cuitao@kylinos.cn>
>=20
> The cgroup-v2 documentation describes memory.pressure and io.pressure as
> "read-only nested-keyed file", but both files accept trigger writes
> (cgroup_memory_pressure_write / cgroup_io_pressure_write) and are therefo=
re
> read-write. cpu.pressure and irq.pressure are already documented as
> read-write, so this also resolves an internal inconsistency.
>=20
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Reviewed-by: Michal Koutn=FD <mkoutny@suse.com>

--w6vmztswp5edcsiz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCamMzhhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhKwQD+Iy3pcOQIQWlRVtv/FGt3
cxKmOPUIXg1KfOr3pjnOC/0BAJJDDypJclDoElMGAiW1VrT0ly08e8wrpUmjLsr4
6kwL
=3hkW
-----END PGP SIGNATURE-----

--w6vmztswp5edcsiz--
