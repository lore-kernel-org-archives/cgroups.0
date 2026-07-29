Received: from mail-yx1-f51.google.com (mail-yx1-f51.google.com [74.125.224.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F0D92F8BC3
	for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 20:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785356056; cv=none; b=qfUoeEAtSw1bdiiEkQvPDMufjj6CvfHMNXE66e4W5D+xJbEHrU1XEKg5reyHbdm4Yq9l8wvweVAmtXbHYZlhG1pqGXpkIAESxo/DWqac+Gx3dACBUTxmI6bm+kd7RwunGxzsJGNs9yxV93RrW8Ele8YBNL3si8NfPQMho8W4xl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785356056; c=relaxed/simple;
	bh=B98tp2z1tgkOYZvoJtX+L0gcyc3s0a5N3qq0sMGy6T4=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=LFGyXne8WM9XMTDUzUW9nS4R5AF4OOTfofpRIcGOlc5QG/7imDG2j35geThmFoRqo4q6N1SonynkFe3wKbcU8y20+NgNcVIUxMwoTPJRxLcR8TNFT5hhn6o4MJgFpvWqfGgLL8irDSVYA070BuVaU2kuM5HVTE9A0Wk2bZpFpbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ENCBGd6i; arc=none smtp.client-ip=74.125.224.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ENCBGd6i"
Received: by mail-yx1-f51.google.com with SMTP id 956f58d0204a3-66893db7bccso1966625d50.1
        for <cgroups@vger.kernel.org>; Wed, 29 Jul 2026 13:14:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785356054; x=1785960854; darn=vger.kernel.org;
        h=content-type:autocrypt:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kFwaVPM3TnySaGAq9ZVxi597lwQFvmxmYUSvRAQkyiI=;
        b=ENCBGd6iERC/kdDuaUcn541L7LOk7kAneg+SAX+6i6u8hWa3irqLFpxl+t8/S+DqO6
         rAJJlFAuAzhjDLeY6lgYxMelb523APWv+SITp7mHEIu4d49OxrzIUBFnJhkGEfFNcxtx
         0NsxPCf58XUzHizx1YK0jqrifzh1Fbq8d9i9OTa5rqUcxSrfLYHgz0l02HZAkKAw/wqY
         WdqLe8UjNWYI1kecQ1GAtR1rSISYi2+zprWNE4QO7E5KgwsuOtuki16VKK+mZw3x6O4f
         eXcNnUH+NkKEsAlTTp1OsepfB2g9SnLxV3tq/O6aGhZF37yAo8ytuMIMQxGBfd9Vhogj
         O25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785356054; x=1785960854;
        h=content-type:autocrypt:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kFwaVPM3TnySaGAq9ZVxi597lwQFvmxmYUSvRAQkyiI=;
        b=L5BF4IyZzB/Zg0lOZUFSVOwlj9Js22YWfP6KBdHK8Bj0R5YC0S3yQsKcRnm+P8EqGq
         Sbh32kURYIpsc/Fg+yQ7e5PUvK5esixncbheWI9juagcqSNJxo/l7cI6ZwvMCYfIqHgi
         9s10Y5v9wtWK8QRB1cvimPD672BEZE0aJSl2vLMB1R+Ezs6V6cdkNeF8TpfrhEE8jF1P
         kJMXKXvq9jmhrJGYUVvhc9H3gFaRRLi7BuM6p65r+DoT9NH/QvS1ViGgW3dh8MtMCw5p
         jDz+g1D23gV64dNSQXZy6HOa43ZzwA/Vnq8JIvzR1W3Nvt2hhaltSyaWoktviF0JnToa
         qC1A==
X-Forwarded-Encrypted: i=1; AHgh+Rpfwa1zzrc/kSSxpd737zGsdkvD5XRqbbEq9mZuukmXqNptPWoVhz+mVWK+ux6nWBTSLZn2L2p8@vger.kernel.org
X-Gm-Message-State: AOJu0YwfTYSej+j8wFt+F2u43kek2dOTkNLjFE2lDOPj1SsEPHjUlFey
	RIyb8Cnpg04PEN0jUGIXkkqXjy9mT0PuCTOalK5n9ag0y5K5CgCh8EH1/h7IAw==
X-Gm-Gg: AR+sD1247g0uCVGer6KC1s8pFo60yfY5YZHvrDoQnUjnSizHknAXQTjK3/NaQGnEI0x
	EUM2kln191Xtjt39mdMtr2rrHI66Ovrh5W7KKxyWaSVYFDxDCZTTkIXFpvyi5sUcs7BPtctHZ+q
	D0dFmbQ7Sley823wH4PzuV0k02zGIzwWyUgknTsIfSyj2jz45URLr7x13EOvOOUVbQOLLar2u2j
	2vljyNGDfiVGUV0hLFfWIuLsdckEPUf7LwAQM0dihvTNGtAxCK5FaDJ3E6V1Rt7zjAwYjNINEAw
	gM2noKWhE2BJIuiwrd3YE7NooXARXYHegWaxywRBaNhNzEkGvwgzdWGfzXhjiLz2xA8QUwXLCpc
	OTFm1+1ucMMwywVo8jx/OTORhJfmgfeisfxEYmIjLSyS4yML2bo2sXp7xsXBl6dU42htlze6HX/
	NQQJhs50NqtsbE7RXvX80Zeb2uoiKfUtPDq882cShWWN3m2kbXbmV3qUa7GtOkWw0=
X-Received: by 2002:a05:690e:440d:b0:667:8b90:2ee9 with SMTP id 956f58d0204a3-6692bb8d035mr20294d50.100.1785356054230;
        Wed, 29 Jul 2026 13:14:14 -0700 (PDT)
Received: from [10.138.10.6] ([185.98.168.14])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-669125fbbecsm2524477d50.12.2026.07.29.13.14.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jul 2026 13:14:13 -0700 (PDT)
Message-ID: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
Date: Wed, 29 Jul 2026 16:13:54 -0400
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: systemd development <systemd-devel@lists.freedesktop.org>,
 Linux cgroups development <cgroups@vger.kernel.org>
Cc: Alyssa Ross <hi@alyssa.is>
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: Purpose of init.scope
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------eBJTiibag0H0AMFV0hkfTWHo"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------eBJTiibag0H0AMFV0hkfTWHo
Content-Type: multipart/mixed; boundary="------------JcE1K58a6DowmL30ohHy5UIg";
 protected-headers="v1"; hp="clear"
Message-ID: <b6dd3b7a-18ba-4b0a-bc5f-9c92d8b2aa7f@gmail.com>
Date: Wed, 29 Jul 2026 16:13:54 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: systemd development <systemd-devel@lists.freedesktop.org>,
 Linux cgroups development <cgroups@vger.kernel.org>
Cc: Alyssa Ross <hi@alyssa.is>
From: Demi Marie Obenour <demiobenour@gmail.com>
Subject: Purpose of init.scope
Autocrypt: addr=demiobenour@gmail.com; keydata=
 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
 +MYSfkEjBz0E8CLOcAw7JIwAaeBT

--------------JcE1K58a6DowmL30ohHy5UIg
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

What is the purpose of having PID 1 in init.scope?  Is it functionally
necessary, or is it solely for consistency with when systemd is
running in a container or as a user service manager?
--=20
Sincerely,
Demi Marie Obenour (she/her/hers)


--------------JcE1K58a6DowmL30ohHy5UIg--

--------------eBJTiibag0H0AMFV0hkfTWHo
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEopQtqVJW1aeuo9/sszaHOrMp8lMFAmpqXw4ACgkQszaHOrMp
8lNOCBAAkFlIXV/QFDOPyv9WhvcG14J0C23vW4BH5ZLcnY3oVnNz/vOo7WQMLzML
2v3aPXxP8o9LEGIWwfurX5p8kYBhz0WiR/ESLy4V4JVbdnees29UzEefAWFxhBRM
spuuVD/3a/FAvWQ64W9P7araI0ujtgA4bY0DgralfN8DCpAbNRDv4ngAAQqmXYHh
ScxyfYOsJ8Q2IaS6ecIOE4Psd3FF/kWJoQrrqkbbYLqTpOTxHGs1zhEH/WiFVq9H
EqqJUZEhesdVekpNURlEX2pmxVhuHCqqGMk88WY27F/WFmnVay8aqPgyimX8IQQV
oJOHPWBfCHaCce7h2HwNP9AQuB/Wda7JC2bgXUNjc/sO0gNyxTpDV6q0VmSVjJW7
iXLSe99e6fosxidmvFNFcAAe0mMkEvxKwgs70WUHRxs1kOxYVgFUo9oZ3r+bJsgQ
o8aLWjQ0JeTDsBY4PIs0EJBWIWLTSydCWFAe3ClyLtM9VkKYLgOjbCQOYifeFI10
pwRgTGTBppHsXFbeSR9sCCDsOoVYhIBN1K4qwJ5ODnR/Y4aQy2rRx88e5XjDrxpz
ETsbbQgKQM2HMNKmUzFRqtAUcktmq5XmNl0qzcQ2YHe9yJpFpNjw/Zc8oNob23Tv
BnR7IfAviO83MsgNfoudi1/jHuWbCY1MlwozRu3yn0LmV+9vWWY=
=ewiF
-----END PGP SIGNATURE-----

--------------eBJTiibag0H0AMFV0hkfTWHo--
