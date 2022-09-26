From: Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [sparc64] fails to boot, (was: Re: [PATCH memcg v6] net: set
 proper memcg for net_init hooks allocations)
Date: Mon, 26 Sep 2022 16:06:08 +0300
Message-ID: <CADxRZqyAG5Co9hLEp6p8vPC9WyGERR6un-3Rqapyv14G4vPXJw@mail.gmail.com>
References: <6b362c6e-9c80-4344-9430-b831f9871a3c@openvz.org>
 <f9394752-e272-9bf9-645f-a18c56d1c4ec@openvz.org> <20220918092849.GA10314@u164.east.ru>
 <CADxRZqyyHAtzaaPjcKi8AichGew2yi-_vQcKoLoxPanLvXZL0g@mail.gmail.com> <20220921170259.GI8331@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=lHYmumLvyE4V6WpEgRdvIHKDaBX6pkuSXgTnGyOxhOQ=;
        b=IbCR66K42xKS/M7CztGQ/LQwHaP2woOeBjaIbh+fDq1UpLATW4PO90HWgwWtBykUjM
         0HFnd3Fvcq4RrR+0gAVoejrdv99y5kHVbenxc5NAbMGkf3N4Q6uM9TRajq85B4J8ZjSV
         V9XJrozFgaVtJ66AgOm/XY3g53aH44A0ATIQsMFfMwFsaPIFTE6EeXYZrIlDC2l48fAE
         KZHd8afOJREzG4jpDC7lYSeU43uR6LjGw2LPG7z95O1bkwfXoBdZ3PiLVcxGwPbEtwIn
         33/32wZQKrjC+cbzxJ37ne+EwCc+Kc0RpNFBDDOyHXuTSz5aY6q2E8thqzuOeyX4aNQ+
         aSrQ==
In-Reply-To: <20220921170259.GI8331-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Linux Kernel list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sparc kernel list <sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Sep 21, 2022 at 8:03 PM Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org> wrote=
:
> On Wed, Sep 21, 2022 at 05:44:56PM +0300, Anatoly Pugachev <matorola@gmai=
l.com> wrote:
> > On Sun, Sep 18, 2022 at 12:39 PM Anatoly Pugachev <matorola-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> > >
> > >
> > > I'm unable to boot my sparc64 VM anymore (5.19 still boots, 6.0-rc1 d=
oes not),
> > > bisected up to this patch,
> > >
> > > mator@ttip:~/linux-2.6$ git bisect bad
> > > 1d0403d20f6c281cb3d14c5f1db5317caeec48e9 is the first bad commit
> > > commit 1d0403d20f6c281cb3d14c5f1db5317caeec48e9
> >
> > reverting this patch makes my sparc64 box boot successfully.
>
> The failed address falls into vmmemmap region (per your boot log
> output). It looks like the respective page/folio (of init_net struct) is
> unbacked there (and likely folio_test_slab fails dereferencing ->flags).
>
> Would you mind sharing your kernel's config?
> (I'm most curious about CONFIG_SPARSMEM_VMEMMAP, I'm not familiar with
> your arch at all though.)

mator@ttip:~/dmesg$ zcat config-6.0.0-rc6-00010-gb7f0f527dc3c.gz | grep VME=
MMAP
CONFIG_SPARSEMEM_VMEMMAP_ENABLE=3Dy
CONFIG_SPARSEMEM_VMEMMAP=3Dy

I do upload config and boot logs to
https://github.com/mator/sparc64-dmesg

building a new kernel version/releases as 'make olddefconfig && make -j'
current version of booted 6.0.0-rc6 is available as
https://github.com/mator/sparc64-dmesg/blob/master/config-6.0.0-rc6-00010-g=
b7f0f527dc3c.gz
