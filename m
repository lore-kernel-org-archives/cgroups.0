From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: linux-next test error: BUG: using __this_cpu_read() in
 preemptible code in __mod_memcg_state
Date: Sat, 18 Apr 2020 18:13:58 +1000
Message-ID: <20200418181358.0a761486@canb.auug.org.au>
References: <00000000000022640205a04a20d8@google.com>
        <20200309092423.2ww3aw6yfyce7yty@box>
        <5b1196be-09ce-51f7-f5e7-63f2e597f91e@linux.alibaba.com>
        <d3fb0593-e483-3b69-bf2c-99ad6cd03567@linux.alibaba.com>
        <CACT4Y+Zfcs2MxD9-zR748UbkEpsV4BYjFgw1XgSqX4X8z=92CA@mail.gmail.com>
        <20200418174353.02295792@canb.auug.org.au>
        <20200418175059.7100ed7b@canb.auug.org.au>
        <CACT4Y+ZsAgq0M=xUzrXTOYaaJfr_BrD8_5R5bhzr9k29jDSC+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/FO+IgIlyK6wXn_YCvpKjvSp";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1587197642;
        bh=G8iMWCchG1teLmnVcfKg6CPEC0PAsZOhu4cHv56WVwE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uw0O9D1cGqHhSeRW4k7P7ETkAvMrg9aUTL/PWkY+SX9D/V8obRPCWQBAeiKCmK45w
         R6NzzWSC9yOvWwgIX83jGnNWfrDZF98IEX7K9B0bZrHptZPm8llL+/SPVbNy/GxEyF
         BO9eln5LihuGFiHyNxHL2XU2Szeoq9kZhbAjPUcj8lS0K1wTzAQiCokQ+aq51G9mII
         bzOPZF0SEcq4m1fkeMWOwgxLq9+KGCMSlVOtd09Mbzfo7JTkWhWdEzgOYLOPNUaAG9
         HZGlIi8OBSTukwDp9Iyt9EFINQw4A1wAMlS1jilXkn/sUhph4dhlju6KeEUZsKCs5g
         ncOJCYKPGT8TQ==
In-Reply-To: <CACT4Y+ZsAgq0M=xUzrXTOYaaJfr_BrD8_5R5bhzr9k29jDSC+w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, syzbot <syzbot+826543256ed3b8c37f62-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, syzkaller-bugs <syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--Sig_/FO+IgIlyK6wXn_YCvpKjvSp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

On Sat, 18 Apr 2020 10:02:36 +0200 Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > #syz invalid =20
>=20
> This is correct, thanks!
>=20
> You may now see "Status: closed as invalid on 2020/04/18 07:51" at:
> https://syzkaller.appspot.com/bug?extid=3D826543256ed3b8c37f62
>=20
> It does not show up as "open" and if this will happen again syzbot
> will report it (rather than assume it's still the old bug happening).

OK, good, thanks.

--=20
Cheers,
Stephen Rothwell

--Sig_/FO+IgIlyK6wXn_YCvpKjvSp
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl6atsYACgkQAVBC80lX
0GxKLgf7B1CaeOafVaZuCm00dKwG5hpfeoiZ90BssMjH+U91777VeGujRDCLsz82
sgYE8FV3sqY5xnFkZi8SIMXUiVQnEVDLZiwe/gmNvS0zu9Uh9kUDUvwMhOlf6faB
kSWu907utWkPrznsU36QctaVA5qwXpRDBUZX/NVBJkcBL6xAw1/ER1n/89kf2l7X
IzJLEw68AAbwPlKAdiARMg0aQXvWbeRzs+C0HiH668G2XHL/usBBFdZT/lZCg5Xl
tBe4s8bsxBHbv0lblZZNRFXUvCKB56TbpPCqAO+PQT+bKrKjA19xD8W74/EiMd9Y
165rBH3gTrzj24jJwyJdUFNSH93Gkg==
=ZnYC
-----END PGP SIGNATURE-----

--Sig_/FO+IgIlyK6wXn_YCvpKjvSp--
