From: =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat_200-wo4oW1Pw1HF3vZ0LZ0W7Rg@public.gmane.org>
Subject: control groups and /proc/meminfo, /proc/cpuinfo etc
Date: Thu, 5 Jan 2017 11:59:28 +0100
Message-ID: <4636e5b6-b769-c14a-75cb-909403803498@poczta.onet.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IWCgDuGJX2xBqTSfve0w22jeo53fqDnjf"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.onet.pl;
        s=2011; t=1483613973;
        bh=AR8N9oxCTTd4HcwQ+shvVi5hQvLX7bOXI37AS7RGg8g=;
        h=To:From:Subject:Date:From;
        b=hT/KogRPGlJgWzW68LzsLMqxt0B8brwXHWnLOxlpCbYfwh4I7Bq0sfuxzCzu7PT5o
         e12wgcUsumuSgrOPoivY1siEW7gQRsQ9v9tpNENFsHkHtPhmiwgHkaATXFhrKV6PaU
         AnYgYR/svXN7GbnFrfhv3QsT80Vouq1eICDOrukg=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IWCgDuGJX2xBqTSfve0w22jeo53fqDnjf
Content-Type: multipart/mixed; boundary="eaEP0ubvpLNNvkf64dLpBjmfo1GuXK6TA";
 protected-headers="v1"
From: =?UTF-8?Q?Micha=c5=82_Zegan?= <webczat_200-wo4oW1Pw1HF3vZ0LZ0W7Rg@public.gmane.org>
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <4636e5b6-b769-c14a-75cb-909403803498-wo4oW1Pw1HF3vZ0LZ0W7Rg@public.gmane.org>
Subject: control groups and /proc/meminfo, /proc/cpuinfo etc

--eaEP0ubvpLNNvkf64dLpBjmfo1GuXK6TA
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello.

Are there any plans to virtualize /proc/cpuinfo and /proc/meminfo and
all other things? Don't cgroup namespaces give an opportunity to do that?=



--eaEP0ubvpLNNvkf64dLpBjmfo1GuXK6TA--

--IWCgDuGJX2xBqTSfve0w22jeo53fqDnjf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFPBAEBCAA5FiEE8PeJXyv9t1Bfiq63mRxoPZnIFPkFAlhuJxAbHHdlYmN6YXRf
MjAwQHBvY3p0YS5vbmV0LnBsAAoJEJkcaD2ZyBT5TfYH/3rbbkzV5KEqTzedwDPS
02E0PMC1Q8qh0JTLuzaP+rqRrRjrNvEa7ZbKp5r4Xq+gQlKSzOteqgZouAocojHN
u1verOjBnuWapRnBfa2LA+RszHmImvT07KiKQ2u/TmfbHvjSLkySAQKJ5CQOrDFW
Lc9K5u1KntcDQBd3ETBLhSFm4NvcXlXNqmhzwUV5OF9M5/sIsS3Jyn51Evr2Y1HK
iT7GrP+zdiE/NMs/qfHi8ln0IUIn61XPQBdrqXpHGUQGJSER2khHedlgr/XkUKnI
JjpANlX+CKLPsqfNp3XSnnBArobA9QTZJ11BcxNE+E1lY5bzWUZQlLAfeGyw8/wK
8vw=
=QeGx
-----END PGP SIGNATURE-----

--IWCgDuGJX2xBqTSfve0w22jeo53fqDnjf--
