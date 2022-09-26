From: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Mon, 26 Sep 2022 10:28:12 -0700
Message-ID: <20220926102812.2b0696a7@kernel.org>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
        <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org>
        <20220918092849.GA10314@u164.east.ru>
        <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g@mail.gmail.com>
        <20220921170259.GI8331@blackbody.suse.cz>
        <CADxRZqyAG5Co9hLEp6p8vPC9WyGERR6un-3Rqapyv14G4vPXJw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664213294;
        bh=TpZUQWxRgvsRBZ9B6zo0p7FzXoiaePpQxMiDDnNBgKQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QPSqUe9Ur/PUiiTJBtm8l0/4UZdPjkeotTSVg1TDe0LQs09d6EE9xqiO02aHRQn4J
         k5g56tuXXwqJkmYMMxkoPGFcZYnkqPDRk/Am3nfAKi7Pi9wecOHnuNy3ZdMuQKfe5c
         nxol9cbQ0D6apJIbIRD6Xo13sHw0pZC5ZcwMeZJxEx/a8BwUrYJ90z7k3HlxiMtcUt
         YPt/8rML1+1qoqY6l2Iv/s7RFc61Z/vF/gfJd0yLhF2b8TWUbPEiTwr6oUbmdB2V4j
         ed+vAxHyJ8a5G0ETuggC63KgqvqsoIB4FDaepGxXzi6YUmNKGqafq886belqPc5Sj8
         yT0gbiHM+2kjg==
In-Reply-To: <CADxRZqyAG5Co9hLEp6p8vPC9WyGERR6un-3Rqapyv14G4vPXJw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal =?UTF-8?B?S291dG7DvQ==?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sparc kernel list <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Thorsten Leemhuis <linux-rCxcAJFjeRkk+I/owrrOrA@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, 26 Sep 2022 16:06:08 +0300 Anatoly Pugachev wrote:
> On Wed, Sep 21, 2022 at 8:03 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wro=
te:
> > On Wed, Sep 21, 2022 at 05:44:56PM +0300, Anatoly Pugachev <matorola@gm=
ail.com> wrote: =20
> > > reverting this patch makes my sparc64 box boot successfully. =20
> >
> > The failed address falls into vmmemmap region (per your boot log
> > output). It looks like the respective page/folio (of init_net struct) is
> > unbacked there (and likely folio_test_slab fails dereferencing ->flags).
> >
> > Would you mind sharing your kernel's config?
> > (I'm most curious about CONFIG_SPARSMEM_VMEMMAP, I'm not familiar with
> > your arch at all though.) =20
>=20
> mator@ttip:~/dmesg$ zcat config-6.0.0-rc6-00010-gb7f0f527dc3c.gz | grep V=
MEMMAP
> CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
> CONFIG_SPARSEMEM_VMEMMAP=3Dy
>=20
> I do upload config and boot logs to
> https://github.com/mator/sparc64-dmesg
>=20
> building a new kernel version/releases as 'make olddefconfig && make -j'
> current version of booted 6.0.0-rc6 is available as
> https://github.com/mator/sparc64-dmesg/blob/master/config-6.0.0-rc6-00010=
-gb7f0f527dc3c.gz

Forgive my uniformed chime-in but Linus seemed happy with the size of
-rc7 and now I'm worried there won't be an -rc8. AFAICT this is a 6.0
regression. Vasily, Shakeel, do we have a plan to fix this?
