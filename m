Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5A1D306743
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 15:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784561212; cv=none; b=EjL3SbiXqsL/ptJjypDFzPF2Ysu2mZH0JgNXdSuITSLllQc2+3LvJ6OsA+7S9FW7a4sCzFVZUiqZgj3XyXdi0wByruJfnyG2CA6FR4iXQBmo1ahDCgQ2JLOSIKCmuks9J/Hb8bybeO7AWQrafTv674567+1mJMZQPjISjdhIpM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784561212; c=relaxed/simple;
	bh=ghK5za8aF1N6pu59Foh6V9T8x31sHIYSxEvCSet479c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EFOKILs2Tjfn+zQ4akaV90t5hyGk5nnfFFvb1GQbdF2GYIBjY5lbYmKmwGic2fC+gbaBChEsgRAIvczh0hlkriSqj4Oa1geODGbd7bjzpwoIwvHPSODezHMeeQrbYa+MJIJmc/ZXItrBDzwJb3hsVV4PcJUQi3OuP3+BFHvFFqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=EODW0rM2; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="EODW0rM2"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954afac04bso27573685e9.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 08:26:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784561209; x=1785166009; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ghK5za8aF1N6pu59Foh6V9T8x31sHIYSxEvCSet479c=;
        b=EODW0rM2HPV5v5jXus1d7KAZ9mo1j9TPtlIBiFreQgiElZjXszktq0p8r01pOxTADF
         9cOtOrjCoKSFFDvpX8/HHtu3BCLRxlHKe+uKE5ZKg5J4nPOxZXRYL1If6O4FlfZMSug0
         ftcJpm8AtbFt7FzxhQBY8+r/nEfcOMfuplJSnlCzkOOySkR1xTVqt0QwLIfoHqmjWveo
         nziJmkQLDps+s3dK10Na80TWebbQLimIPSIlBe/ljLucc6yj7vjBpLar39UeIplHugzf
         tk99l79OsRdIkxTA34txdLq/ipFyivs42MmbBiBAxToyPMm4fQ+q8bCyXB722ie8z7qH
         OV5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784561209; x=1785166009;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ghK5za8aF1N6pu59Foh6V9T8x31sHIYSxEvCSet479c=;
        b=Ji0gb9bLqeNPFM6otcXw2EnNi8sUgs5z9iobL5UBXtZOf6eaxrtw0i9oz8FexNXdOf
         MtXsgpL48oDWD3TP/IpzfUGAsOctPkYrVbT3QenhRLZLJBPByXKiLtiOQzPQxhqZwQIw
         9pvVNj0hX0bVOdwCJn9FyivgetShmefHD0Z8t6bNkdgKBv3olJ4PB31XBxFuY/50LrHo
         Ktcf+EW6D0iW13WTBwoxr3fAINbpLRP8yNo7qMW19CpgJM4dEIND6zXb90zdkcvKWVrF
         nhECUo5ohAYVccjwrk5MIUVFh9mkIMXdm/gEyPIQPclqRln6EEVdzkHv/DSzyLd+IMnN
         pHfQ==
X-Gm-Message-State: AOJu0Yz6Wvqkt0IbGYmAFF2YHLbi6EedG/Zg2SLMiRyfKDX/rtdq27Np
	wP5k5BZGlhGJUbv1R5EDK/x3zX/z26K/Z/jiXM8ThAUVuqmUXi9dQhj3fhSn1NFGxS4=
X-Gm-Gg: AfdE7ckLJIPtZ4MJeT/9ORUjIrI8fpcrZkWemCdv4raPk/dIIh/yva+PQSzmiDgwBNV
	YPJ8eK5SrfgyKxGSKGrhsiDH+0hYW4KCzD8+9NGVBfLpsQhRKt0i/14Chdab6dQ4jfPuAZYt4kV
	epT1DnUUFMVL25qq/ynaDO578I3cM1eYYSZ65qFC2RBcxctTm0zjp5qN2hxOWlPk1LbCGj5WevS
	pU7V3k/6HnKB6zacjUC1ypa9ljCLdwRK1/Yd3PzR8riP7lqeqPavXXKMCRFjalJREWrtYovNyst
	HbfIPC+ih432HT9v2qbrAUAvowJ9gHjiOJoVCwAQwHWdNYh6KEm595DoFiGN/Soyq38nXZEcinW
	h4aOAjqlDoa2a2YkKr8W1MQNRTJIyc2SUczJR82PfXm1jxkCdJYWJm30c1nOYMDIt2XJDSKHBhQ
	m+KX/4sg==
X-Received: by 2002:a05:600c:3512:b0:495:4572:21af with SMTP id 5b1f17b1804b1-4954a3ef7dbmr155802875e9.9.1784561209104;
        Mon, 20 Jul 2026 08:26:49 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4955de88951sm77982265e9.3.2026.07.20.08.26.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 08:26:48 -0700 (PDT)
Date: Mon, 20 Jul 2026 17:26:46 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and
 core_sched.force_idle_usec
Message-ID: <al46ipavC-KCaoHv@localhost.localdomain>
References: <20260718080100.2334415-1-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w2bwicfq2kh5elpa"
Content-Disposition: inline
In-Reply-To: <20260718080100.2334415-1-cui.tao@linux.dev>


--w2bwicfq2kh5elpa
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] cgroup/cpu: document cpu.stat nice_usec and
 core_sched.force_idle_usec
MIME-Version: 1.0

On Sat, Jul 18, 2026 at 04:01:00PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
> From: Tao Cui <cuitao@kylinos.cn>
>=20
> cgroup_base_stat_cputime_show() unconditionally prints a fourth base
> stat, nice_usec, in addition to usage_usec/user_usec/system_usec, and
> also prints core_sched.force_idle_usec when CONFIG_SCHED_CORE is enabled.
> Neither field is currently described in the cpu.stat section of
> cgroup-v2.rst, which still states it "always reports the following three
> stats".

Just to better sense popularity of the fields -- have you found this out
by:
a) reading cpu.stat and being confused about semantics of the fields or
b) scanning files/code vs docs looking for discrepancies?

Thanks,
Michal

--w2bwicfq2kh5elpa
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCal4+MhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ag3vwD9E1MC8njfG/ALqSIl0+J+
vDpXYoCVjiKaSM/c4p3+facBAM1HnJky1cQzDzCmTg5mmKUbPFXANmVUH42v2ac9
Y7MA
=/WHZ
-----END PGP SIGNATURE-----

--w2bwicfq2kh5elpa--
