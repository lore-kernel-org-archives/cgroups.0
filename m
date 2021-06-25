From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: Short process stall after assigning it to a cgroup
Date: Fri, 25 Jun 2021 10:52:43 +0200
Message-ID: <YNWZW/WhdP50F4xy@blackbook>
References: <CAMJ=MEegYBi_G=_nk1jaJh-dtJj59EFs6ehCwP5qSBqEKseQ-Q@mail.gmail.com>
 <YNNvK0koEdkuD/z3@blackbook>
 <CAMJ=MEfMSX06-mcKuv54T7_VCCrv8uZsN-e-QiHe8-sx-sXVoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="XKHtlNgGHYTuc56p"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624611164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZMmoA41VC0zJ2L7yVVFYP5vkEgxoLw5HFmrgFw5BSc=;
        b=uebnGotChiEZ7PcTW2XnEcODhZSeP0O4eZS/q61OQgYD8biMzVBvyR97w+c9fnniDvXYPp
        7UHxF6fpQbWgA5t60Zp6wf3uEwaAJA7Rj97zf3qWiQoAy963S99nVE7aoCl+y5EMno45X5
        7Gbl2YelSm0ZKSUBoBqmnn5Kt3FfEqE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1624611164; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GZMmoA41VC0zJ2L7yVVFYP5vkEgxoLw5HFmrgFw5BSc=;
        b=uebnGotChiEZ7PcTW2XnEcODhZSeP0O4eZS/q61OQgYD8biMzVBvyR97w+c9fnniDvXYPp
        7UHxF6fpQbWgA5t60Zp6wf3uEwaAJA7Rj97zf3qWiQoAy963S99nVE7aoCl+y5EMno45X5
        7Gbl2YelSm0ZKSUBoBqmnn5Kt3FfEqE=
Content-Disposition: inline
In-Reply-To: <CAMJ=MEfMSX06-mcKuv54T7_VCCrv8uZsN-e-QiHe8-sx-sXVoA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Ronny Meeus <ronny.meeus-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org


--XKHtlNgGHYTuc56p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 25, 2021 at 09:32:59AM +0200, Ronny Meeus <ronny.meeus-Re5JQEeQqe8@public.gmane.org=
m> wrote:
> The application does not have strict RT requirements.

Can you even use the normal non-RT scheduling policy? ...

> We were working with fixed croups initially but this has the big
> disadvantage that the unused budget configured in one group cannot be
> used by another group and as such the processing power is basically
> lost.

=2E..then your problem may be solvable with mere weights to adjust prioriti=
es
of competitors. (Or if you need to stick with RT policies you can assign
different priorities on task basis, I wouldn't use RT groups for that.)

> About the stack: it is difficult to know from the SW when the issue
> happens so dumping the stack is not easy I think but it is a good
> idea.
> I will certainly think about it.

You may sample it periodically or start prior a migration to get more
insights what's causing the delay.=20

Regards,
Michal


--XKHtlNgGHYTuc56p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEEoQaUCWq8F2Id1tNia1+riC5qSgFAmDVmVcACgkQia1+riC5
qSj4NQ/9GVs17yCzEg2MYsOf/nr3/Ye5kDUy3JQ7tEeF05wLhEaeXikKa04y5Uxi
jUrDkmqSoZX/KbDJqv5u+1JLy5m76h8POHjc0fSG6bEhfZuttGWEZ0cQoEAqyJ74
69u3wTYcfuUeaE3uUSGwvGbWbvUMGTmYKykjrCp7oimZCQI9yaZ7XidDFVDysPCA
iEDX27yyC1RnheZsspMGkW429HgikPGg6nHsEtTTuywWxQvKfxY4c7r1LGRuk4ow
k2tZ9R20xgUCdLED/OCVB1DbVZ4Jv5X1wEgp0Ftz4QnYtsEd6TjXsG343CROBV4X
i9eSuUO+z8hWeB5noeIQSzavb8cH9yU+9+J9vWP6mjxBVb2wen9QQrQS2YWW658f
Y9NJ7acqSzNuGsW9oqW4fMTCXLzit9D87kZ7RXmldn1KgiBFuTGhdvY7lxgV/Eb6
YH5fyL/aqzvWGxPvLLjmUXkh92pyE2eREFdKefixG0B83flM5QyyJ6SvrR0nlQ2Z
08WLjrCRAcyIvCpnMO1jhJEFesVlClmwSRAQsRXOdmu0xw18y4tTSIgidN4maY3d
W6Kw+lin5+GBtDw4mXcaPiV7TUy15LAgekP4LVAG0+Mh3fC7pncdHFfDMkbE4fIw
L0K2LgKqYxXQ0bIe6bBYr9WZ32Jt1a6IQDytTflGuB8wjZbT1nk=
=GaAf
-----END PGP SIGNATURE-----

--XKHtlNgGHYTuc56p--
