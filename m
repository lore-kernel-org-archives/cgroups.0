From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 14:33:46 +0000
Message-ID: <CU4IS5XRH3PK.M9DAVXJ7PSSE@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
 <CU4GJG1NRTUD.275UVHM8W2VED@seitikki> <CU4GKARPLGU5.1CVBNY9N4K28F@seitikki>
 <op.1779qgkdwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689604431;
        bh=I21ZDliWD7GOdnTUiUm/tPH/YR8Nmd8AOMXf8/BsAhQ=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=IHUkmxqZ8XZmpa+aN5HU8DZORxXMoMRWO+WWbx47YVDPP8qvPcVzhLHh1XeIU1nv8
         QzuwK0t9DPm/8gU/fnssor4Fkmq/bB8XGYkbHHr7y4nEmeUstm1rRH2EwPj95Ker1K
         ndQjU7fQqZIg6zCAfCxTzu03K585baZEwR6GK48cFRJRo8r8l0MRQ4w+PA1hZNqEk2
         rosP4lYUR6++AlrfPC7kpK3RXNhNpJEOgiJy4QIqZNBgQEvsDCtykn/s6ikPHmljVM
         iwMAYqHp7lpN2ENeBAvgFFQ5uBO42xfrgNcJzvgxERPEFLRFCZbhD5sy8yNFfJ9l7k
         qM+Ktsgp12Txw==
In-Reply-To: <op.1779qgkdwjvjmi-yDQzE4XY+yVaPPhiJ6yCxLKMmGWinSIL2HeeBUIffwg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon Jul 17, 2023 at 1:14 PM UTC, Haitao Huang wrote:
> On Mon, 17 Jul 2023 07:49:27 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =
=20
> wrote:
>
> > On Mon Jul 17, 2023 at 12:48 PM UTC, Jarkko Sakkinen wrote:
> >> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> >> > Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
> >> > worker) may reclaim SECS EPC page for an enclave and set
> >> > encl->secs.epc_page to NULL. But the SECS EPC page is required for =
=20
> >> EAUG
> >> > in #PF handler and is used without checking for NULL and reloading.
> >> >
> >> > Fix this by checking if SECS is loaded before EAUG and load it if it=
 =20
> >> was
> >> > reclaimed.
> >> >
> >> > Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >>
> >> A bug fix should be 1/*.
> >
> > And a fixes tag.
> >
> > Or is there a bug that is momentized by the earlier patches? This patch
> > feels confusing to say the least.
> >
>
> It happens in heavy reclaiming cases, just extremely rare when EPC =20
> accounting is not partitioned into cgroups. Will add fix tag with the =20
> related EDMM patch. And move this as the first patch.

I understand, it is just a good practice to follow, i.e. have prelude
and then the "real" changes :-)

BR, Jarkko
