From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Thu, 3 Nov 2016 20:00:06 +0200
Message-ID: <20161103180006.GL3617@leon.nu>
References: <20161018215134.GB2761@htj.duckdns.org>
 <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
 <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org>
 <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org>
 <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
 <20161031065441.GY3617@leon.nu>
 <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Xsbw7+pkldUUnFG3"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5VKwntDHX101+5aaGoyKMKQuiKQWam575iFAxhmKxhE1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--Xsbw7+pkldUUnFG3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 01, 2016 at 04:33:23PM +0530, Parav Pandit wrote:
> So my opinion is:
> (a) Let cgroup define the current standard objects and new reasonable
> set of vendor specific objects in future.
> (b) Add new rdma.percentage parameter so that any new standard object
> or vendor specific object can be abstracted from average end user and
> applications which are yet to catch up.
> I believe this takes care of your point (1), (3), (4)?

We (Tejun, Christoph, Matan and me) had a face-to-face talk during
KS/LPC and decided that the best way to move forward is to export to
user one object (global HCA like) only and don't export anything else.

All internal calculations will be based on this percentage.

Once the cgroups users will come with reasonable justification why they
need to configure different unexposed objects, we will expose them.

--Xsbw7+pkldUUnFG3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYG3slAAoJEORje4g2clinsF8QAK2K6TSU8wpObeLJ0M0BSQ3d
BGu9r7PyK3HQiQMy0qjoT2/uQRFGh28xXKsRcci8y8EkQaiI/xsEXU8Nw27Ihe32
9yMH5t6GjG00XjxCLQOQGpGjKyS4aSQGj1lsYUmhfeMThKj69uW2h6Ihzst3a9ST
WVqr1P+XLstQI/8BlO7PhzD+ulJoTPUN5Dl92pUgmIF9Qsmz32V/DSb1zuw1ymuq
M9DbJ/uU7WilsvTrxFFLmvlR3/Rpzon8YrL6p1xsEVh4LsO4iIzlpS5Jmrl1UYlc
7zeuVVmI8udUuTmYBQF4jZ5K+PZ36KC3DaI/341S0VfEYZ7/3NUyywWnz4Urv3qz
c3h+b0l0LgEpnaH0ahg+hhjPN12WHMAp9Nddyci1rRUu+zoLbs5GIMz7rwN4H6WY
XFIpnNSUzXIE2hJqBXAJziUKjrmwv8Rod2Ua6icEC90Ty0CSA/lI6Hw5cPmKEj23
TmSPKFEiKlR9GnBJ0O9GTbhOoNQGUIl64yvnSB2oCE4XcQLVnjv+JZZHRkYPa6i9
eqr90dsn7pPTKFKvC4rg1EmoXZSVA3Arp3GUlc/4YmBuAVxQSiuQL8nl5mxCTVRh
qrtYjYE/6Yd+MVzI/S/sFkGZ2h1JjjmZnMe1DeCgU3KhNeg59Joav+bdf6P6vCX3
2IOHk54mfPC4RC4rMXgm
=FK5S
-----END PGP SIGNATURE-----

--Xsbw7+pkldUUnFG3--
