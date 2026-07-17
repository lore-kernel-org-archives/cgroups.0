Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EDDD22ACEB
	for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 14:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784299726; cv=none; b=sdQS3JAMWPcs+vb7jqje3gIP/xa2k3gPJ3iHEmcItZpJjiNijDxy2PQxLNVJZ7/e91MoG/CmSGHqOZgTbzaPCbVlQoozfyJ2NYaX6MGaddu6IE/2EVcfaHL/rSdl6qzDdjTEkCjJg2hhRnd39MLi6sXkEA0sl0U8ybjZ5kvtzhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784299726; c=relaxed/simple;
	bh=mRjlo0h7XqajHkCi0tOJU+estaZg0reyf7n06FlL9no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VYAsbMVg9gC4BDx5YFsME866GTUMLDA22fUkPsPlQ9a+wAq0QYY0dXxzFho+8P6yULIWHKh/s4BL92EzWu+wNBMKlCY0IPfbBBa1EbuDS8Uqgxg1MezK1i+TCHOsh3k7LuCtWO4AbKlctAv8qn5LWBwLTuUAtZBIbdP9LFXa7EE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=QZV5B4fA; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="QZV5B4fA"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c160420289bso1103149566b.0
        for <cgroups@vger.kernel.org>; Fri, 17 Jul 2026 07:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784299723; x=1784904523; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xuE8UsHFqi/drBf67Pe9stpmyquoxdJrOltp395q5AQ=;
        b=QZV5B4fAuJ+EIhH+HVQldJVqNGZvlMXOeWPFJolvm7jmv/7T/Puhob0g1vQMlINS9K
         EYTja3uA4/abAn1g120m5JykLnYxJyyQtm1rz1T9rG7+UEDuTShrmbsOQdvHh+m9+L+O
         mmgblntVR670K35+XOQu4KIberAhhDwPWxfJnzEkwL/GAKACYmhhGHjo5ADLzXeaBAW6
         AUyFxpUtVynN1CcmVyHfQSg7Cwz9oWtpcrypxWszv/lD3IdQNmkyaGfjzY0o5U+l0yeE
         68xmqZWuQEEJPNRpXUn0T87DOvsPp46wYnAD87piXjm5XECX++N282LHQKdAusPxYsRF
         h7TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784299723; x=1784904523;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xuE8UsHFqi/drBf67Pe9stpmyquoxdJrOltp395q5AQ=;
        b=NakkxS0N3TkJancvPqBvcUyuI6yttzPmBVHCRmCd52wh+8Bi8Jlw1B55A76bz5SnUn
         4DpOAxMBr/OAHsD7h+O3tJLtpQSHFzVHiOEC4np7+ShLuaF4BDXnVLskEJVtIQfySjqk
         wMIqJ7QwC2rLeWaqnAXjWHg8cbwRCUHAGRqzVV2yR753CulSuOjGbiGTJV2EoUsniD/k
         WMUo8D6Bd3hFse77Ut86+zWhIj5wAfB6jypjcIUxMkxCkYH46qjIG0CLwx1iWnQeOchk
         mBWRxvvTMmzSJ53fSDFrNE9Z5S7vfgHiRYIK+rfKRM4rY/kgUX9EGfBvVCWrWN2XZJC7
         4V4A==
X-Forwarded-Encrypted: i=1; AHgh+RolnVlG3uVMTxe2Q9KWNtBr8xr5btFffKlr9W9rVfTbhJFgHcld+gtIPOOSCzpUXm9utaT17bpH@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7QDd0ghkqlv7tlessdJ37luBwyagNLFLe7C6598r6AQxoV2eq
	TKAkWEvuipbxhxaGPOyPWEZ1TST7qzi71s9pjUlcZZwTSvbz/NSMS3GmFYfNTaCWI9U=
X-Gm-Gg: AfdE7ckJNdwLYwbcNMCWH5pyWZql6du880Svo+ahXd9lXaln0T3TbggTyYpadfw9kK8
	7tBILKJxMHvFT0ttoalsP2BkU/EoVkLThGz/SZs2aXrpXrSFQVXuqx45oARDYRuGYqnWAi1JBqu
	ISgrU+dJSf7e5e4OQpw5YFNeJINTHfF8mpEjgYSudEc9uqYRYKXVhg0lUUBr46FY+PsH2ftgVl3
	zfirRzVy0kSlhsr+o60X6jIcxPf1tDY6lVPzlppIkwJcPPvoyFx9kii8CN5/8Wn6T4481wBUKr7
	JcSZFjpjQLUao6OpXf63C7EKHvBAYTj7vTyECme2Z35a1yXzV8JUmsjHwenRa/5o2CCzHuYvx8x
	9PTXtYJKJVvruXMXnOLLgPp/weXCcx9RKOR4aqlBv8ov7CPT6QncJ+NS4S6b/qPHEWQZI+xMNGI
	Hzut6EpA==
X-Received: by 2002:a17:906:fd82:b0:c15:e8c8:340 with SMTP id a640c23a62f3a-c16b46f5139mr134693366b.23.1784299723240;
        Fri, 17 Jul 2026 07:48:43 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1705a08476sm90682266b.17.2026.07.17.07.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 07:48:42 -0700 (PDT)
Date: Fri, 17 Jul 2026 16:48:40 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Tao Cui <cui.tao@linux.dev>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Jonathan Corbet <corbet@lwn.net>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, 
	cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cuitao@kylinos.cn
Subject: Re: [PATCH v2 1/2] Docs/admin-guide/cgroup-v2: document io.latency
 rotational vs non-rotational behavior
Message-ID: <alpADmJBLHpHAS_G@localhost.localdomain>
References: <20260717060225.2019764-1-cui.tao@linux.dev>
 <20260717060225.2019764-2-cui.tao@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ephr2qisqe6yuncj"
Content-Disposition: inline
In-Reply-To: <20260717060225.2019764-2-cui.tao@linux.dev>


--ephr2qisqe6yuncj
Content-Type: text/plain; protected-headers=v1; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 1/2] Docs/admin-guide/cgroup-v2: document io.latency
 rotational vs non-rotational behavior
MIME-Version: 1.0

Hi.

On Fri, Jul 17, 2026 at 02:02:24PM +0800, Tao Cui <cui.tao@linux.dev> wrote:
> -		The sampling window size in milliseconds.  This is the minimum
> -		duration of time between evaluation events.  Windows only elapse
> -		with IO activity.  Idle periods extend the most recent window.
> +		(Rotational devices only.)  The sampling window size in
> +		milliseconds.  This is the minimum duration of time between
> +		evaluation events.  Windows only elapse with IO activity.  Idle
> +		periods extend the most recent window.
> +
> +	  missed
> +		(Non-rotational devices only.)  The number of IOs in the
> +		current window whose latency exceeded the target.

		A group is considered to be missing its target once
		missed reaches certain ratio of total.

I would not bind to the exact value in the docs and put the explanation
to the "missed" stanza.

Thanks for documenting missed (pun intended) fields.

Besides that
Acked-by: Michal Koutn=FD <mkoutny@suse.com>

--ephr2qisqe6yuncj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCalpAwxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AiRZgD/bio1yk4KiA4j0+myiFeL
qPwIOp6V3p27lhF4qdBRVG4BAKC8MSZvi8+DOi/IuzdUE6EZRv3f7G9bIN6msiE4
JWQP
=tTpT
-----END PGP SIGNATURE-----

--ephr2qisqe6yuncj--
