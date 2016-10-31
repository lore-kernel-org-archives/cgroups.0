From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Mon, 31 Oct 2016 08:54:41 +0200
Message-ID: <20161031065441.GY3617@leon.nu>
References: <20161013231413.GA32534@mtj.duckdns.org>
 <CAG53R5UciPpa5d8BWyR-tks3LBrBwRCN2NyBbbm1e3EE-OWSYQ@mail.gmail.com>
 <20161018215134.GB2761@htj.duckdns.org>
 <CAG53R5UEvkPBM0yFrR=fvEzyCrku2q=rLZyDVrSs9q+3hgbSmQ@mail.gmail.com>
 <20161019143345.GA18532@htj.duckdns.org>
 <CAG53R5WUyA7JBn=PeivUc5F5k210xf_HccPXFt3r7ZGYHOPaGA@mail.gmail.com>
 <20161019192006.GB3044@htj.duckdns.org>
 <CAG53R5X5dyo7J-UkeMxi_mSxgv=c54fV=anuCZtmf9kaYwDbPw@mail.gmail.com>
 <20161019200536.GC3044@htj.duckdns.org>
 <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="9Hhx61DPNOHVwUu9"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG53R5XkRKdo-SCaREZvov3AGp5MSd18RpQ+0HEu-htUzqwOOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>


--9Hhx61DPNOHVwUu9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 20, 2016 at 01:48:27AM +0530, Parav Pandit wrote:
> On Thu, Oct 20, 2016 at 1:35 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > Hello, Parav.
> >
> > On Thu, Oct 20, 2016 at 01:24:42AM +0530, Parav Pandit wrote:
> >> userland can get the max numbers using other framework which is used
> >> by control & data plane available in C library form or in form of
> >> system tools.
> >> I was preferring to get and set through same interface because,
> >> It simplifies user land software which is often not written in C so
> >> its likely that it needs to rely on system tools and parse the
> >> content, iterate through devices etc.
> >> Getting these info through rdma.max just makes it simple. There will
> >> be logic built to read/write rdma.max in userland anyway, which can be
> >> leveraged for percentage calculation instead of doing it from two
> >> places.
> >
> > Yeah, I get that this can be convenient in this case but it isn't a
> > generic approach.  I'd much prefer keeping it in line with other
> > resources.
> >
> Hmm. we don't have /proc/sys/kernel/pid_max type of simple interface
> to get the max values for rdma resources.
> rdma.max is close to that simplicity.

Sorry for my late response (very long weekends and piles of mails after it)=
 and
for not clarifying our requirements better, which are very simple.

1. We will have vendor specific vendors objects in the future (new ABI
support it and designed for that).
2. We don't want to fight for every addition of such objects to cgroup list.
3. We don't want to teach and/or rewrite scripts for "average" user after
addition of new objects.
4. Cgroup configuration should be as close as possible to "standard" if
such exists, so all infinite internet guides will work for RDMA too.

=46rom my understanding of current status.
My naive approach of introducing GLOBAL_HCA object is the way to go and the=
 real question
is to understand how to configure it, am I right?

>
>
>
>
> > Thanks.
> >
> > --
> > tejun

--9Hhx61DPNOHVwUu9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFuqxAAoJEORje4g2clinww4QAIg9kF8PdvmsOsYBS5Lc/lOy
mZ416Deyc+Jnwsqp6aqfTAphd6yJQ4bBnPszanzyQ2tYvM206HhsFGPHHOAgyu5M
FC+TePZrZhdcQJZV70l0K60PRJsGBMuZNma39Wt1P1Y5JBmBbBzb4zCfFND2gW7L
ZCZMVb5wbakp/gwL3BSAvPZIRqIdGEJKmBIX5NeqYGwO1pA8bPWEjPntsrjvy2I+
iywNHS/Ob49keVWUT+qfZqroETpvIzITJ63eaw+4i+CE7Inxb+z4b/6W85okWf3c
NGbSTbh4q9Hgp/ZNK+ellsbciu+f3dBrcH4TPdbUV20MvKMvauGSri6G//Upy7qX
FbiWfurOHBGT85jnd5BfQ34fJQcWV0ooqKEyJTFNabnTMQbA7ztGZufR0bOABn+2
efOQTh0AA/qH3Fb3Rst13kldmjRemgv9qiv3HEuOmlhUavcvlI/yjeVNIkGXTjmS
P+3z//ygDM4t2hwX4gdxWcL4d8zb0AB+0RnbbWMJchZCWQZgu2ywKJtT+60hjdre
hr1M23WnsAbTMMH8aFA3DYDW7lL2uIQT7MJb2GqtLJqIdLFjrdEtg+Pa61T+Vg0i
5m03w84qg/m8sIBqBidHZWlYeAYsMKGuzZiGLMRn2bSoy5/To7f0umLcR/nL5/U2
vtaRtOxxxHDjNau7WH8o
=m3fz
-----END PGP SIGNATURE-----

--9Hhx61DPNOHVwUu9--
