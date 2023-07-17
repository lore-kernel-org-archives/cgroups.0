From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 02/28] x86/sgx: Add EPC page flags to identify owner
 type
Date: Mon, 17 Jul 2023 12:43:31 +0000
Message-ID: <CU4GFR4WLMZP.3R9HJQFFG1JEK@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-3-haitao.huang@linux.intel.com>
 <CU4GEFJ8R4US.227AN2H482Q4G@seitikki>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689597816;
        bh=7B2Pjw6NKXemEOfCP4Ct4UyD922UxZCxaO6K3gVi/7E=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=OBushMGAKDmd4+oHNO5CKO8iknCBEDcvl5hf2of5KPj1BfEJCq7TVDaEvrMjoqLlq
         2TqfkuZvscTEC5Uee8X00ZQcbtClJ7+r6x6S3ZGVP0L0sIZ7PsfDCks/N6OKw3eqzm
         jA3MFXDNom5FJzY8hIRJWWVwNBei9J3GWe9AE98TJQjtsnJjnNI1O7EIqtWP4Tmx4O
         gXsWE61LX8N0YPg4XtrwcGpf+BH8Cvy6NCkspYxBMv9opPOug/Ti0SowGR2IRRL3zo
         XpF9cJO8Zo4voPbDGC7qeGog8ml7AaCbUnZ6qppr6+xrJytDTObPsoqyRu+kUMZxZV
         S+3i9iULCfdpg==
In-Reply-To: <CU4GEFJ8R4US.227AN2H482Q4G@seitikki>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon Jul 17, 2023 at 12:41 PM UTC, Jarkko Sakkinen wrote:
> On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> > From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> >
> > Two types of owners, 'sgx_encl' for VA pages and 'sgx_encl_page' for ot=
her,
> > can be stored in the union field in sgx_epc_page struct introduced in t=
he
> > previous patch.
>
> This would be easier to follow:
>
> "Two types of owners of struct_epc_page, 'sgx_encl' for VA pages and
> 'sgx_encl_page' can be stored in the previously introduced union field."
>
> > When cgroup OOM support is added in a later patch, the owning enclave o=
f a
> > page will need to be identified. Retrieving the sgx_encl struct from a
> > sgx_epc_page will be different if the page is a VA page vs. other encla=
ve
> > pages.
> >
> > Add 2 flags which will identify the type of the owner and apply them
> > accordingly to newly allocated pages.
>
> This would be easier to follow:
>
> "OOM support for cgroups requires that the owner needs to be identified
> when selecting pages from the unreclaimable list. Address this by adding
> flags for identifying the owner type."
>
> It is better to carry the story a little bit forward than say that a
> subsequent patch will require this :-) I.e. enough to get at least a
> rough idea what is going on.

Oops, sent by mistake. I was going to say that the flag would be better
named simply as SGX_EPC_OWNER_PAGE instead of SGX_EPC_OWNER_ENCL_PAGE.

BR, Jarkko
