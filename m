From: Travis Thompson <tthompson-mkn/cI4rzrdWk0Htik3J/w@public.gmane.org>
Subject: blkio write controls
Date: Thu, 5 Jun 2014 21:31:52 +0000
Message-ID: <B937BB93-F803-4DA1-AC31-F98DC3C52766@linkedin.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="Apple-Mail=_4AFE580D-AFBF-4BB0-BEB5-F11CA9629A8E";
	protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=linkedin.com; i=@linkedin.com; q=dns/txt;
  s=proddkim1024; t=1402004486; x=1433540486;
  h=from:to:subject:date:message-id:mime-version;
  bh=E6jOzadAa5SrMKUH79ndcWikW2hEUlmKnriZpshVFjM=;
  b=H/yiss5SPU5jmWKcHDznSGWznYK1pQrx6VXdzy64XpyTkT5BLkwsFVFS
   +jWLiWgcezF1mAIXfwx590mxEWQwNnXzH8DfgeqGREsaqi+HCtw4Goljb
   oDnyNDvgulCQMaSzQQ17ALP+fK/RELHg0zXMoKo+mfQJ8sZTeRVEr9OlA
   s=;
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

--Apple-Mail=_4AFE580D-AFBF-4BB0-BEB5-F11CA9629A8E
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=windows-1252

Hello,

I=92m currently working on blkio integration for Hadoop YARN and I was =
wondering what the status of write throttling is?  My understanding =
right now is it doesn=92t work because of buffered writes and so the =
kernel doesn=92t know where the io is coming from and doesn=92t throttle =
it.

Thanks,

Travis

--Apple-Mail=_4AFE580D-AFBF-4BB0-BEB5-F11CA9629A8E
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="signature.asc"
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.22 (Darwin)
Comment: GPGTools - http://gpgtools.org

iQEcBAEBCgAGBQJTkOHEAAoJEPFHXfuSos76IxEIAMsGtZbaL+0i/zdyBu2y0a0m
4e6wlJu/a0ZZdaE0Q5H3hOXA7DmGjTeHVT/uSvdtC2uGuCPl0jk3LfmKEt3RKA5F
7IyA5TgyyxE0hU21w/8I/YBAsis6JP4WIryedHahMMlGsPMzHZWu5SmrXRMG+GWZ
ACwvCLox8tZoY/9stPpV5I0TLDLOPF+eTJTUnPcHMTxurz1K1ovwHrXmKTe5rZqy
7y+rN1kqQyF8KX4POLoYJd25YZyO/Zmp/+rl6DVHJ/8om5DVVSRmUtR97HM5FuFD
XF+a75/trdXT3wJpbCt9HBGvuqEKtY9Iue41iaIdBFi/YXXaiyGyBdRAPF7soz4=
=tfj6
-----END PGP SIGNATURE-----

--Apple-Mail=_4AFE580D-AFBF-4BB0-BEB5-F11CA9629A8E--
