From: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Subject: Re: [Resend PATCH 1/6] mm/memcg: warning on !memcg after readahead
 page charged
Date: Tue, 25 Aug 2020 09:00:54 +1000
Message-ID: <20200825090054.3c5dd68a@canb.auug.org.au>
References: <1597144232-11370-1-git-send-email-alex.shi@linux.alibaba.com>
        <20200820145850.GA4622@lca.pw>
        <20200824145201.GB4337@lca.pw>
        <20200824151045.GC3415@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/GBWE4=3K9zAUW5hSuk=F0/p";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1598310057;
        bh=eDDydcN+yRwqvCr58cy3ZtpIXf7l8cnkzFj+j1CqajM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bhHutHwcHIAL9ZElVcQQk25ly0t5DlWuVtHmK3kFpuxfYpgSIUxe3i7Dwf+HPRMWN
         D+F49Hy90V3rnGPOmwlB8FmTw4m5u0OVlESvELOTcUL/qquubwqnXGVzL9LD3aPMwc
         CGMiBfTl2CvWpU0XobpSYMeT3zf2EcuOYroHY3UZ7xd2COfY9DSIdNoq5Dk+iqdqVz
         TJbQ6AjtyUJzVlovsBKnXm93TnFjnvnUBsZilA2GoXAIUizRL1PNSLM/3rGX866oa6
         RDPFiyMo6NtWzdAszGH8k1rf76B8FW4FMDFQPvXYBSzPX2JpXzy/HkXEJr1+g+Xrdl
         LmHnzuTFbCojw==
In-Reply-To: <20200824151045.GC3415-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

--Sig_/GBWE4=3K9zAUW5hSuk=F0/p
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Mon, 24 Aug 2020 17:10:45 +0200 Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Mon 24-08-20 10:52:02, Qian Cai wrote:
> > On Thu, Aug 20, 2020 at 10:58:50AM -0400, Qian Cai wrote: =20
> > > On Tue, Aug 11, 2020 at 07:10:27PM +0800, Alex Shi wrote: =20
> > > > Since readahead page is charged on memcg too, in theory we don't ha=
ve to
> > > > check this exception now. Before safely remove them all, add a warn=
ing
> > > > for the unexpected !memcg.
> > > >=20
> > > > Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> > > > Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> =20
> > >=20
> > > This will trigger, =20
> >=20
> > Andrew, Stephen, can you drop this series for now? I did manage to trig=
ger this
> > warning on all arches, powerpc, x86 and arm64 (below). =20
>=20
> Yes, I do agree. See http://lkml.kernel.org/r/20200824151013.GB3415@dhcp2=
2.suse.cz

OK, I have removed the following from linux-next for today:

  c443db77c9f3 ("mm/thp: narrow lru locking")
  18bafefba73d ("mm/thp: remove code path which never got into")
  5fb6c0683017 ("mm/thp: clean up lru_add_page_tail")
  9d1d568727a8 ("mm/thp: move lru_add_page_tail func to huge_memory.c")
  47eb331560ff ("mm/memcg: bail out early from swap accounting when memcg i=
s disabled")
  4b0d99a64d78 ("mm/memcg: warning on !memcg after readahead page charged")

--=20
Cheers,
Stephen Rothwell

--Sig_/GBWE4=3K9zAUW5hSuk=F0/p
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl9ERqYACgkQAVBC80lX
0GwA5wf+MmH5x5QjwvI+81lnKYiqyUbfsEnlGMvy8JrOIX37/7lb9nUtabZtlOIx
RV6oA0amomiZDwc/c2X6GQh3oVsn69NpycxvuwZmofK7TSCz6U+YZFaUsFLxdJmd
RfQIvC55ORNcYXyjd67/OgCeXYDf//WyYMy82qd37YvLK3E7vtQQRRvdrskLBMNr
MpcRDAW4Lj3JBojpGVBspX2t0L0rmXzQY2OomgWQB29HFnJqNxPQ77aRLhm2zM6E
uRoOgMi2ca9F/cxXJKQwDrPceC7xWzaiUgCD8uOxFLwqtzcdiipnOOAeg6SJ1krt
7HQIE8bmAXf6XXAKncXy8nF4+VL0Pg==
=v0cS
-----END PGP SIGNATURE-----

--Sig_/GBWE4=3K9zAUW5hSuk=F0/p--
