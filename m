From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 03/28] x86/sgx: Add 'struct sgx_epc_lru_lists' to
 encapsulate lru list(s)
Date: Mon, 17 Jul 2023 14:39:21 +0000
Message-ID: <CU4IWFX753SR.2X9WTBXIHJKBV@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-4-haitao.huang@linux.intel.com>
 <CU4GHCJTRKLZ.1RK23NWPHJGNI@seitikki>
 <op.17794m01wjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689604766;
        bh=jQupSR0cXaId81B1Mtbxu7kk9Li8dlHjg4WKD/ovjs0=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=A9NGmVEsJX3Q0g0VVdhcmbnI6LA5zdNI75Kr/PbREnqbsfYEgd3TMgoBSDx07rAPo
         claZfcAgKGqqjSbGrRHCRymlCCP7DI7Lri2tjqxlrN0h2sxw6kO+aknAg8oafQpH33
         cr49Eaae8sEDtjQFPCYxgLsqym2U5TfuHbqS0aNCZR9OebxfJGkozc1QyoDysBzq0U
         Xm5cHXOR7aV+dXTGTEF0mxUbKhzVrUK+EpPIlSoqClWYzGeQhxSen5xVxm9gDAZUXK
         6RLgAoZ50mZhSl16QJmWDzRaKcBBmPo4y5FhZIhOzK0FKqsOjnIUy9AG8vPXFVVsmG
         eA++hXcIFxnlQ==
In-Reply-To: <op.17794m01wjvjmi-yDQzE4XY+yVaPPhiJ6yCxLKMmGWinSIL2HeeBUIffwg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon Jul 17, 2023 at 1:23 PM UTC, Haitao Huang wrote:
> On Mon, 17 Jul 2023 07:45:36 -0500, Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> =
=20
> wrote:
>
> > On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> >> From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >>
> >> Introduce a data structure to wrap the existing reclaimable list
> >> and its spinlock in a struct to minimize the code changes needed
> >> to handle multiple LRUs as well as reclaimable and non-reclaimable
> >> lists. The new structure will be used in a following set of patches to
> >> implement SGX EPC cgroups.
> >>
> >> The changes to the structure needed for unreclaimable lists will be
> >> added in later patches.
> >>
> >> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> >> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>
> >> V3:
> >> Removed the helper functions and revised commit messages
> >> ---
> >>  arch/x86/kernel/cpu/sgx/sgx.h | 17 +++++++++++++++++
> >>  1 file changed, 17 insertions(+)
> >>
> >> diff --git a/arch/x86/kernel/cpu/sgx/sgx.h =20
> >> b/arch/x86/kernel/cpu/sgx/sgx.h
> >> index f6e3c5810eef..77fceba73a25 100644
> >> --- a/arch/x86/kernel/cpu/sgx/sgx.h
> >> +++ b/arch/x86/kernel/cpu/sgx/sgx.h
> >> @@ -92,6 +92,23 @@ static inline void *sgx_get_epc_virt_addr(struct =
=20
> >> sgx_epc_page *page)
> >>  	return section->virt_addr + index * PAGE_SIZE;
> >>  }
> >>
> >> +/*
> >> + * This data structure wraps a list of reclaimable EPC pages, and a =
=20
> >> list of
> >> + * non-reclaimable EPC pages and is used to implement a LRU policy =
=20
> >> during
> >> + * reclamation.
> >> + */
> >> +struct sgx_epc_lru_lists {
> >> +	/* Must acquire this lock to access */
> >> +	spinlock_t lock;
> >
> > Isn't this self-explanatory, why the inline comment?
>
> I got a warning from the checkpatch script complaining this lock needs =
=20
> comments.

OK, cool, not a big deal.

BR, Jarkko
