From: "W. Trevor King" <wking-vJI2gpByivqcqzYg7KEe8g@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 10:33:53 -0700
Message-ID: <20160520173353.GB26350@odin.tremily.us>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de>
 <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
 <20160520160352.GC5632@htj.duckdns.org>
 <1463760550.8091.13.camel@HansenPartnership.com>
 <20160520161759.GD5632@htj.duckdns.org>
 <1463761509.8091.19.camel@HansenPartnership.com>
 <20160520165326.GE5632@htj.duckdns.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=comcast.net;
	s=q20140121; t=1463765636;
	bh=KygV6NYvY86uWthSp9JvUUe7IkqqSloX04XWRq0blJE=;
	h=Received:Received:Received:Date:From:To:Subject:Message-ID:
	 MIME-Version:Content-Type;
	b=Y7PJn/9BWmvpdrHsBI/jAObTN1PB6Yt/W0BJs4u29BxjemU9wOeTYgaPJpYh6xcb7
	 BQOVlhUDBBRWXJ+6v5oMM89idvai3gjruVSVo6eoB0FDws9JG4M0t/OLy4KoKwa4zX
	 J/XlX5vdnxAPy4Wiq/LaSQ9UBuRe1d8DQK0/Z01/+kOdth7KKC/8sEOd+WGDAqXMM/
	 P3HRLFg2lfDZDXXGB20rlmUvd6D1sScN8xb5acbsXdz3/8PLC8F6HR8i89GCPmduM0
	 eZAImCWx/xTN99Odopk6xGuMQn+ocIQJGmniOMSILdW2kpnpkDkwDY6UeFYYJcqffs
	 WllthLZOWaZ9g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tremily.us; s=odin;
	t=1463765634; bh=HlyWh23RQz4+hC7Cj/l8ShVsjUERhCmxgNW9+RPWdZo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jZBxXJNa73f19mRk9ctfONb3VK6/6Lvj9XbaUxsZKqkXUkKBD9zSb2me283Si7CZe
	 l60iqqAu1hirqQTGak/1lPZzHsp7VSA2x8F/7wXky6yN2Dzsg82zkpiT1ocbOBQQ5v
	 9JGL/6gcf4kuu40RJryt+Yz7CDyT5dWEnXesuB58=
Content-Disposition: inline
In-Reply-To: <20160520165326.GE5632-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I'm just chipping in from the peanut gallery, so sorry if this misses
some earlier discussion.

On Fri, May 20, 2016 at 12:53:26PM -0400, Tejun Heo wrote:
> Why does an unpriv NS need to have cgroup delegated to it without
> cooperation from cgroup manager?  If for resource control, I'm
> pretty sure we don't want to allow that without explicit cooperation
> from the enclosing scope.

A useful analogy is renice(1), which allows users to manage the way
their allocated resources are distributed among their processes.  A
system where a sysadmin has to explicitly grant users permission to
use renice seems overly restrictive, as does a system where a sysadmin
has to explicitly grant users permission to use cgroups to manage
their resources.  At that level, the only different is probably that
adjusting niceness doesn't consume additional system resources, while
creating a new cgroup does, and sysadmins might want to protect
themselves from having users create zillions of cgroups.

On the other hand, sysadmins who do want to grant this power can
automatically put users in their own cgroup with adjusted POSIX
permissions at login time (e.g. =E2=80=9CHi Alice, here's your own cgroup to
manage as you see fit.  Hi Bob, =E2=80=A6=E2=80=9D).  But having a way to s=
ay =E2=80=9CI'm
fine with users creating their own cgroup namespaces and sub-cgroups=E2=80=
=9D
is easier.  And making it opt-out (=E2=80=9CI'm *not* fine with users creat=
ing
their own=E2=80=A6=E2=80=9D) is even easier, and the choice between opt-in =
and opt-out
probably depends on how expensive cgroups are.

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJXP0p/AAoJEAPqygegUbGssLIQAIsBN238C1fyMpNQjb6nDTC4
YR1jj92lx9jWwbW4ZoMlEpZ+pD6q7nycIG7+Sbj8HFszjZGuFkDOe5Fl/sqQoDwL
oKV4MljZf9Wg8HSyzN2ihuBXoxeQ3dcCWei4hlkBHOE/vp9rP2Y8cAZo6k2gCN58
cy2o/EAiXJmMbQctmpKXEJPSJ6AbK+HA459wJ5yLsHgbMNzpFBZ01qicTLUK8SBg
nmfKSef8shsF40y/YZFiyixfMpLxtgXaYmtryaoJwFNh/9NAx5RzvMMRZGXtMcKF
/7SIzd59dT52yhWC1t3j7A+zaQRgJ5HgjF0ZgC99lDpPKnQYvHxcjPu6ugrgQOQd
voDN50t1jR2LO3fDan1mIFtKBzn1AO1P5wtULL+3Ai+sLX86bpQcFQmfuMb5u7JB
7FW6HWQkZgz92l29Jq8elMaPC2Vk2NPh9j+bdpRSS611Umtyrf5rob049rmuHzBR
m3OENipP7DOfnBKf94g6b5ZRGyfYCQBiKMgND4gNAY9z9daxpCv00kHuaw02EeAD
jyaQY2moQ5hwzsUtLzvP8W1h8n89qgfz4SoO1xHcVVM5NwEnyEMo6lZ8bt3KT2vj
fk27UtgW90/vWhrzwMkGGR1QvmiNW52c7izClJRAZ3gvhXfuedj6h7YZL7Tf1F3H
XLWZOYEOqGE4s/xMzR59
=/tO8
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
