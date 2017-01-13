From: "W. Trevor King" <wking@tremily.us>
Subject: Re: [PATCH] Documentation: cpuset: Fix 'cpuset.tasks' -> 'tasks'
Date: Fri, 13 Jan 2017 09:44:34 -0800
Message-ID: <20170113174434.GO10810@odin.tremily.us>
References: <9dd9adef5fe4ae283d0510204f556b4390e5a897.1484259596.git.wking@tremily.us>
 <20170113102742.686b785c@lwn.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="gh4H09KImyIEQ1se"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=tremily.us; s=odin;
        t=1484329474; bh=Qxc5OFqq76YyfVYA6Ivpg0ZHGCbkYGZ8AQ0cnXKr3NE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=BWx12Nu0m4BjiSNRsCxQ7PuReFZ24pMVFhSiY+0kS4eUF9Ajev64DinaV9PdZZa+m
         6fVR48l/fvAfiQ6I6g/sw+h7Eayr5f50P1UZfYmkznHsri9JJCPrw3OKZetxPbcWfa
         ajXX3PEvd7By/u43hTxt1pJTDdNst98bo9e+Fc8c=
Content-Disposition: inline
In-Reply-To: <20170113102742.686b785c@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org


--gh4H09KImyIEQ1se
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 13, 2017 at 10:27:42AM -0700, Jonathan Corbet wrote:
> > -if a task's pid is written to another cpusets 'cpuset.tasks' file, the=
n its
> > +if a task's pid is written to another cpuset's 'tasks' file, then its
>=20
> So I'll confess that I don't understand this change.  All of the
> control files are referred to as cpuset.whatever in this document;
> why should this one, in particular, be different?

'tasks' is part of the generic cgroup tooling, so it doesn't get the
cpuset prefix:

  $ ls /sys/fs/cgroup/cpuset/*tasks*
  /sys/fs/cgroup/cpuset/tasks

Cheers,
Trevor

--=20
This email may be signed or encrypted with GnuPG (http://www.gnupg.org).
For more information, see http://en.wikipedia.org/wiki/Pretty_Good_Privacy

--gh4H09KImyIEQ1se
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJYeRIAAAoJEBBpoQVgXJg1geQQAInxyHOxafDn0x2NoE8UVkmz
/lqVeTTKniRk+Vd4enNWvmg1s+mw8oB3OnrM4jOinct1Z4/XJ8Al6x/U69hivFIg
M1mUpZ0deXu8+Gjg1mB+Lj+xOChjbNZMNDiN70T3YQJ9sk6SlBWfg8OTKhQBwJ2J
54d/I5Sl6/1HRLR9wgc6sxgLAW+9fGceEZYOSjkRWbF6lu+ju7PYYfEIQUHz5hR+
g1SuDT9qESRFqhmekX5Rcd/505QHEYADEKLPzC6q/Yzh76KbZeBi1Hjd1r86uVlc
E4DtWtU8oEy9bwkhwP6JHwVZBJMQpY4szA48COWCylYRHjD9UvqQugX3RVVZFsx2
pokWUsSFqQsUMuE8NVQLwuyi1H3VMgEKh4sgwjvp0achDwGoncCzuKtpBgss9BCN
SGvwN3t01xJr8eQKMPRNXEmhaTkS73l7sawdKRzaUhtRq7fksuIb4MB7AWNKGXge
Lkn+PxLq8NUoaXTU5GeDEwD/Eihvg9NPDTxICmVEd+Td3H22M6FfmAImLyQIfFvN
BoatpxAFOWZZJ3Epd847v5h1YSmr26aJi1B+z0mjCzaM5F1ZtAs8WxAkzl9wPzO2
c+CYefY525THQzAZ0bqI/JD+Adv9S3YNhfXjxhAFeBRkJajrYpRn5qhseWMqCUIN
BjPa+mUWowXMru+6hmDU
=G6Ga
-----END PGP SIGNATURE-----

--gh4H09KImyIEQ1se--
