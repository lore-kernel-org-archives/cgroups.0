Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C2F29430
	for <cgroups@vger.kernel.org>; Tue,  9 Jun 2026 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781009886; cv=none; b=e4qtAHCPF9jHR8TE/ZSk1jPLw0xbK+MkZDZmI87IWb4PkgzV5rKlhUuuOrgyXZVYh/zPhjBxKcqXGtA9jnLrW8YLbOJGZ7jTYMdF/JSLO+/HSm/DtVE9Os26G8BXQhU+GIdoy9KaF1R3Ka9V1MIBDPcYTEIonPhQJR06M6OdpvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781009886; c=relaxed/simple;
	bh=gYpQhDPjIE70r6t1FCbngDxSnN6WqnNYJh7MaxFEamo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9R1vhMzbLcI40JPK8dbLp1oOjPNnLH+49eiZwocx9VcjzD46i206fMxKUS1acAIqusvOBq/n8mxcGPwsFgiHIzIgOILEeWK3C29K2ONHBWertaw9gwMuhsbdcriEwTaUmRSMv8FMoVtvAWPymLeHidrYEvpbmTHgxR3sKnqStA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=LgTse6Wc; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="LgTse6Wc"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso62358485e9.2
        for <cgroups@vger.kernel.org>; Tue, 09 Jun 2026 05:58:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781009884; x=1781614684; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gYpQhDPjIE70r6t1FCbngDxSnN6WqnNYJh7MaxFEamo=;
        b=LgTse6Wct17eJ8MXo/c/ZUC0zN6MsphJEVfJMYVvyNuGeR8NH06urVQjC2VeHXWnUm
         2qgsTlFUFAZV0aZXY0Sv/nZ+PGYiNpM2wVYc1kc1RZmJqC+hvStppAva8rvW22/nXqkU
         0ubtpCfu3WamUweF5NUIjA9TYBTmA+agypK6mF4EZmGieGLOqAVH58ISQsS3jDDS88Pe
         YRvJprHfbUCD0RulLtJ85SgY3XcF41jnPrBH1R2et3ia3w84CPfGs75YJ/9LJdr9xUpi
         KVi554D/NHua+qqMPFPLba7VQPLfS3oOPRCfPbyZrTmU0kpbcSIV1Qhu8GIJzpPZc+B/
         VSyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781009884; x=1781614684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gYpQhDPjIE70r6t1FCbngDxSnN6WqnNYJh7MaxFEamo=;
        b=paDF53nJLRz2XtJEHYkgQxVXcnNopkf2B99VToSKQiqrR3JshfU4I+cj7s0P5L951a
         WUFveI96vkcEXVz/XDdNeTvN8V70NhAWjSQr9vKCqCzaufV2sJHWXe954HOXuZEtovaC
         kBVVCU5VhaBS4sGD8TMDNPqjq7X3b73Q5g8FNUuMBG4BcuMrsDlthmM1hxzLVWeMr7UT
         JTS8YGGcg+0DDpefYvnLtM6jAeXIZsqIYy7CKnvzPjCN4xnyy7bK54GcS0UWfDxFjwGE
         FMVCaSXuA6GaWolll5MjyEkLw4v4Es5bdqxQenx4V1HsH7rAx39Ew11oa2ns8FrYkQb3
         MMdg==
X-Forwarded-Encrypted: i=1; AFNElJ9KYzg1PvgJLozwf4LOiG2HkvOy/WeUVS/NRiHX+S68Pz1jHsB7YFU1kXnhrzGZFljioLbUviVx@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9G00qySSn+rCcdhJLMYyLB6Cg+IhzTNlRyFRMgYwQZdqrJbeH
	lcD6tnlsTglMAf7DLLYtjCHNKLIkH8S4FxT4uJfQFOZU6Uhy7+hemqjeqgxE0I956wY=
X-Gm-Gg: Acq92OEI2/y2RDtwlCuFTd49ksbe9LObdOylHizSYOQw4Z/3MCgI8NUAtdYF2r4jSa0
	KE2mOmQtZpgCSVkhxD1XeV3/4u3m/T1kNvqjhxDkdr+dDXExc+23L4mYkYgy9/Obr+RD74EOzb6
	xDIqCH4PIy5UvXGH4KhS2fDLO2xdctZzEQX0Pl64btTMmft2cNGzeQo6u05b6HFABhjmBcOxCtf
	3pUynam7jvFF8pbQDtjE7YKvgTqMuck1VtzTUh36DwdEEn8vD57caiqvvFaHQd0ViUA/Sq1q5Ik
	esuZ1Oy8VP6sn6cAIrpPNhmJLgHZ59EC9Qw3LBYU/x7wETwliD35ueRtEfAB7w7y48fdoS0AjBH
	+jhDti2RyHnYLI5NWcfuJYCWuIG72T8OUqoJI+Fbaz6RljNAs6Fj13cVdsWBwxGbiLYpZUyoelM
	EJBeEzARz9azrCy5OPQgUVGstdANYw+o5vQG2i878=
X-Received: by 2002:a05:600c:4e09:b0:488:9bf8:7f17 with SMTP id 5b1f17b1804b1-490c25acd18mr365025535e9.14.1781009883789;
        Tue, 09 Jun 2026 05:58:03 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490bc3e4b5asm478588225e9.13.2026.06.09.05.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 05:58:03 -0700 (PDT)
Date: Tue, 9 Jun 2026 14:58:01 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Longxing Li <coregee2000@gmail.com>
Cc: syzkaller@googlegroups.com, tj@kernel.org, hannes@cmpxchg.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [Kernel Bug] INFO: task hung in cgroup_drain_dying
Message-ID: <aigMzVNsQpz_J0oQ@localhost.localdomain>
References: <CAHPqNmxGfjsKGEJJaSCrJqoU9WHY3q8CX1oTA7GV5BBHvDzgpg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ihxr3wswm62bdgvw"
Content-Disposition: inline
In-Reply-To: <CAHPqNmxGfjsKGEJJaSCrJqoU9WHY3q8CX1oTA7GV5BBHvDzgpg@mail.gmail.com>


--ihxr3wswm62bdgvw
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Subject: Re: [Kernel Bug] INFO: task hung in cgroup_drain_dying
MIME-Version: 1.0

Hello Longxing.

On Tue, Jun 09, 2026 at 07:42:06PM +0800, Longxing Li <coregee2000@gmail.com> wrote:
> We would like to report a new kernel bug found by our tool. INFO: task
> hung in cgroup_drain_dying. Details are as follows.

Thanks but I see no attachment.

(Greater if you could add description as plaintext [1])

> Kernel commit: v7.0.6
> Kernel config: see attachment

Do you have lockdep enabled (CONFIG_PROVE_LOCKING)? That may help
debugging here.

Thanks,
Michal

[1] https://docs.kernel.org/process/email-clients.html#general-preferences


--ihxr3wswm62bdgvw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaigN1RsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AhZrgD+P0VUps1OYR3GP4gMDF5s
kPqNeatXmFHPDVwijR/aI+QA/2gC+JVJFTUYWhVdYUVQtKLD09eFYxDYG/wVYz3L
zt8I
=/Xo2
-----END PGP SIGNATURE-----

--ihxr3wswm62bdgvw--
