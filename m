Received: from mail-wm2-f2.google.com (mail-wm2-f2.google.com [74.125.225.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E431422E33
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 13:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784553394; cv=none; b=fdfLN0NNqihPl1iLWxBNtka31Vw/qUItTtwIuvyq7XWtvdA9pjk4eMO+z4WISayA46u8ZYbq8QXPieSQBYAHXfElsUUCay2tCPeCZtllh8tjls4sXhbPdHntl+LVnqyUM4JlHE+K2OCwzNK3FV6AKjazGPDo7d2mAze0G7Lv61E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784553394; c=relaxed/simple;
	bh=vax+aFL0WSjB4okz2i0tD/egGJ5gksI/+/yOw6Xy4rk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oz/F45xkxX+4y/d/WkaaN8nvh4ewMHrPIZp6+3ONS++lDJuja/5WvDUdRujmOUBj8XFJNkvemhcRPT2Wl46EExGDUvpSA8MEENWJw9i77YJzEW2+O8nv60s5VOOHg5H9swU6zLYOlGUJKXf0v072c6jap5Q1h8h2rp+MD6Nw7Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WQ8DjcgA; arc=none smtp.client-ip=74.125.225.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WQ8DjcgA"
Received: by mail-wm2-f2.google.com with SMTP id 5b1f17b1804b1-49242309566so19881815e9.0
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 06:16:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1784553390; x=1785158190; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vax+aFL0WSjB4okz2i0tD/egGJ5gksI/+/yOw6Xy4rk=;
        b=WQ8DjcgAO72Yy/2lCYwIQ4z6f544jdFh+8rvtl6NJYVO4LfiBQUdvEjwH4ouDBC6BP
         4NIa5TwQbj39zt9ddKGEWUzxUONrKHCifWcYuk50cND9lfcKbv+02UtBtrph0DPF9q03
         wWElJ90a/VEQgUxTVYno1L5wiJpEkhUaZRv7wrBtj4Fpt6QiXjFqxvUr/LN6oiUMcwZZ
         8MzoSsd8y3VaW7wEumErnTyjdQjraYWA8IYUyNkkvF4FRlhhD8BZUIWTtiyNbmOSNS+i
         ly0evGo4Auci5In2htZQKXOVdtE4TO2BZAn4W3DfUhiOwxQ94yarHAkNFkjnmm81Elbx
         22Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784553390; x=1785158190;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vax+aFL0WSjB4okz2i0tD/egGJ5gksI/+/yOw6Xy4rk=;
        b=sboHlFERA4Mt6wfvwy0CNqf1cUjDpSBqmtBQ7LunyomjdcqujjhN5hOkkBp/0wSudR
         fajTDwuTRd6djND37C0KeNL34ra1lshRh8er2jYqKfdn1g7t9y8VxhPaVHi9lVAvmXSG
         CGRXsukcAbJlsVPJT26I/K8/lqPFFr5XVpeKsgdbE7a4yMt+V4Jmd6sVbRZ1RR5Xg2js
         zdsxEJJw8JQvNF9XoOagyqQs3fTZGp911ibpGdVNuj+StE/KDWysVygWENwvXt1zpM5X
         j8FtIxcCBi6hC9O0SVVJHfxDIay1Fl/LELCAkAS8a217mim7GhQ+WqW8QI/X7zdUYSTI
         gVvA==
X-Forwarded-Encrypted: i=1; AHgh+Rr8ENs/xUQx7Fzk3c/wYe+1gXA3NcJ1LYjzo+IFu24AupYJT39l1j7Tbve47l+7VWOHX9pBadvt@vger.kernel.org
X-Gm-Message-State: AOJu0Ywqb/DjXKa6n23aySKGBX7hGSaVMHhvjoPZBMvRUns5yPmzeGAY
	/xEcEPeKTqRD5lIRIfF3WGYBMtlOEUDCWO8F+o7aRVElC2cKN6ay2H5urBuadUg0B3A=
X-Gm-Gg: AfdE7cm8BI0D1NIsXgJfI1yq26WLbOx1Q/mZCf7R2Nrv/jCqXantLDRZb/HjcHhVyI3
	kTLQ6AyW+nx2zSOovG95EzHXSKTsko0QFARp2sgOsnzg+l/+BKYUdIWuFhtELXmb9cINXW0S/6s
	Lwli44+oHfREbkcQpwSswbr5tj161P9jFr6ROBUf+FsS3DH3HGcAhY/ylj43zHm03PuR6N2atpX
	bEIuYiV8mj1kUXoUGI0cIoRXOR4ntHfS0SXfLEFtOMCKh4CPaitbgTyqLlatBQZ2htTxQcgr6GT
	rbE91Vhvhyw9iY23t52FmRgs/4Qkhs5C5tRmPAEMpfuSD8jTkq+f1CbZWOTachsBB9XLitDmKf/
	dq/35b9eUopUDF1z0uwWdF2udMiQ3A60p6tceapudiXXe/PO/sFV+Ma1BzSkE30yFWuZBhCzd/7
	Uus9Dx7g==
X-Received: by 2002:a05:600c:3ba5:b0:495:4b42:8677 with SMTP id 5b1f17b1804b1-4954b42873emr163787355e9.18.1784553390578;
        Mon, 20 Jul 2026 06:16:30 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49564011868sm11989295e9.3.2026.07.20.06.16.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 06:16:30 -0700 (PDT)
Date: Mon, 20 Jul 2026 15:16:28 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: tj@kernel.org, cgroups@vger.kernel.org, corbet@lwn.net, 
	cui.tao@linux.dev, hannes@cmpxchg.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org
Subject: Re: PING [PATCH v3] cgroup/cpu: document cpu.stat.local and clarify
 cpu.stat behavior
Message-ID: <al4fAmim8rdPCKlB@localhost.localdomain>
References: <20260629060636.200118-1-sunshaojie@kylinos.cn>
 <20260720100941.230825-1-sunshaojie@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ybx5ijmegvcly32d"
Content-Disposition: inline
In-Reply-To: <20260720100941.230825-1-sunshaojie@kylinos.cn>


--ybx5ijmegvcly32d
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: PING [PATCH v3] cgroup/cpu: document cpu.stat.local and clarify
 cpu.stat behavior
MIME-Version: 1.0

Hi.

On Mon, Jul 20, 2026 at 06:09:41PM +0800, Shaojie Sun <sunshaojie@kylinos.c=
n> wrote:
> Just a gentle ping on this documentation patch. It received an
> Acked-by from Michal about three weeks ago. Any chance this could be
> picked up for the next merge window, or is there anything else needed
> from my side?
>=20
> The commit in linux-next is: 171569f8ee6724a4113a0100fea6ff83d9b70c6a

That's how linux-next works [1]:

| The linux-next tree is, by design, a snapshot of what the mainline is
| expected to look like after the next merge window closes.

So that patch is currently heading for-7.3.

HTH,
Michal

[1] https://www.kernel.org/doc/html/latest/process/2.Process.html#next-trees

--ybx5ijmegvcly32d
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCal4fpxsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+Ag+OQEA7QVOo55uPncb1q3RxLA6
eZ0HKmyB8oJPcD/lvV3W6k8BAOZtkzovQVeFXHW5v1X+aKubte1+Wyok4BcrQUdH
M70G
=Rl3J
-----END PGP SIGNATURE-----

--ybx5ijmegvcly32d--
