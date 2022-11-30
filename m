From: Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: protect the memory in cgroup from being
 oom killed
Date: Wed, 30 Nov 2022 19:43:39 +0700
Message-ID: <Y4dP+3VEYl/YUfK1@debian.me>
References: <20221130070158.44221-1-chengkaitao@didiglobal.com>
 <fd28321c-5f00-ba94-daed-2b8da2292c1f@gmail.com>
 <CAAWJmAYPUK+1GBS0R460pDvDKrLr9zs_X2LT2yQTP_85kND5Ew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="U2At7WgeybTkF08j"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0SYFP0szIO4uQWosjf/DBeQUEddgh/eJCRxGlHyoP1o=;
        b=lGFEahgyoDkFfO4MTJBxV+WDKKjYFLDSWD9cIm+boSkjj2uoMWRWiQcNtpl/TOm5rK
         sSHEv/glh5oOTksk41RVezXagw6jbuZ40TXl7NEnFNYManHa/w1R71xZZI36J4lX25UM
         cbcUfD4gneaUwM4QD+SBL6cBzhU+wznPmwiJK9DMF2KXg2dr+bRBElQibmy510sUXU9m
         PDGF6zV6GJt6ZojTKhrgyy9u/iQhayTWSqnd1UbNFjJ59iUnn8gey849SPnDD1NkqUem
         y+2zRdZvWk7CPIYegPztuRmyowZwiKIAvxOhInYXosz5F72MggNoCosSPckKf+1f0vF1
         S69A==
Content-Disposition: inline
In-Reply-To: <CAAWJmAYPUK+1GBS0R460pDvDKrLr9zs_X2LT2yQTP_85kND5Ew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Tao pilgrim <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, ran.xiaokai-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, zhengqi.arch-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, Liam.Howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chengzhihao1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haolee.swjtu-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sujiaxun-xX5NlYq76+e1Z/+hSey0Gg@public.gmane.org, feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, chengkaitao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org


--U2At7WgeybTkF08j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 30, 2022 at 07:33:01PM +0800, Tao pilgrim wrote:
> On Wed, Nov 30, 2022 at 4:41 PM Bagas Sanjaya <bagasdotme-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrot=
e:
> >
> > On 11/30/22 14:01, chengkaitao wrote:
> > > From: chengkaitao <pilgrimtao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> >
> > Yikes! Another patch from ZTE guys.
> >
> > I'm suspicious to patches sent from them due to bad reputation with
> > kernel development community. First, they sent all patches via
> > cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org (listed in Cc) but Greg can't sure these are really
> > sent from them ([1] & [2]). Then they tried to workaround by sending
> > from their personal Gmail accounts, again with same response from him
> > [3]. And finally they sent spoofed emails (as he pointed out in [4]) -
> > they pretend to send from ZTE domain but actually sent from their
> > different domain (see raw message and look for X-Google-Original-From:
> > header.
>=20
> Hi Bagas Sanjaya,
>=20
> I'm not an employee of ZTE, just an ordinary developer. I really don't kn=
ow
> all the details about community and ZTE, The reason why I cc cgel.zte@gma=
il.com
> is because the output of the script <get_maintainer.pl> has the
> address <cgel.zte-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>.
>=20
> If there is any error in the format of the email, I will try my best
> to correct it.
>=20

OK, thanks for clarification. At first I thought you were ZTE guys.
Sorry for inconvenience.

Now I ask: why do your email seem spoofed (sending from your gmail
account but there is extra gmail-specific header that makes you like
"sending" from your corporate email address? Wouldn't it be nice (and
appropriate) if you can send and receive email with the latter address
instead?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--U2At7WgeybTkF08j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY4dP9QAKCRD2uYlJVVFO
o2fFAP9CcwtLbXBJc0AgmMHIUvGNiyhA9iDVaDQGg5tezc3siAD+MdwAl/MqnXUT
o9/M5ZNbB5lgA8Gdug0py/N/VDy0TQc=
=RwhN
-----END PGP SIGNATURE-----

--U2At7WgeybTkF08j--
