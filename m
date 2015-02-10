From: William Dauchy <william-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>
Subject: Re: ps stuck on cmdline reading
Date: Tue, 10 Feb 2015 16:10:50 +0100
Message-ID: <20150210151050.GB17444@gandi.net>
References: <20150121095808.GA18656@gandi.net>
 <20150203194036.GA2490@dhcp22.suse.cz>
 <20150205152233.GI3008@gandi.net>
 <20150205154558.GF19104@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4SFOXa2GPu3tIq4H"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150205154558.GF19104-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: William Dauchy <william-M8Sm6a3kpgNeoWH0uzbU5w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, Anna Schumaker <Anna.Schumaker-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org>


--4SFOXa2GPu3tIq4H
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Feb05 16:45, Michal Hocko wrote:
> OK, so the memcg reclaim gets down to nfs and it wants to evict its
> inode and that is waiting for the page to get unlocked. It would be
> interesting to find out who is keeping the page locked. What is the nfsd
> doing?

Trond points me the commit
9590544 NFS: avoid deadlocks with loop-back mounted NFS filesystems.

but it relies on sched commit as well, it seems hard to be backported in
3.14.x
--=20
William

--4SFOXa2GPu3tIq4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iEYEARECAAYFAlTaH3oACgkQ1I6eqOUidQEArQCgqjeO0jx7+R6AcKeBY3fHRaK0
x/UAoKDgcko3oO799L8cZNrFIdjmrHZp
=Y8i4
-----END PGP SIGNATURE-----

--4SFOXa2GPu3tIq4H--
