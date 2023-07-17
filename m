From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 02/28] x86/sgx: Add EPC page flags to identify owner
 type
Date: Mon, 17 Jul 2023 12:41:47 +0000
Message-ID: <CU4GEFJ8R4US.227AN2H482Q4G@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-3-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689597713;
        bh=m/DOGC6VOPi4p/KkmSKEwPEhmwK+Sh1kqIBGMvhMij8=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=Xt29kgKbOvs8kiul6RR8/AjHsVnpp2Vc9cPd3+e2BVZ69ih3Mh8Ry3SQx1pJ8I19y
         EFWrSVAMcHAsUcM6/8DHpDu/5JS/+ugvBS59Gb6oidoSHaSPrlQ83S1sGgq//QtvCw
         vYK/DHgSRdjO6eaweTtJarG1JY7DqbkfeJ/1REY1AoStCNHbhhX0/55egaxODMWZGT
         OYHRy3uYXfyle2IC4SxQ/W4zn3tzfXef3yzJWWUgYNmOuC/M7kDlKYmsIOkSA2xx6E
         gDjXmRA04k9xTnPeRhWv55jSj7XDPy8NtNnZTnoL08RUhozWl+0pUYqRp/EIUDJKXe
         bYmJmJc3NuiFQ==
In-Reply-To: <20230712230202.47929-3-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
> Two types of owners, 'sgx_encl' for VA pages and 'sgx_encl_page' for othe=
r,
> can be stored in the union field in sgx_epc_page struct introduced in the
> previous patch.

This would be easier to follow:

"Two types of owners of struct_epc_page, 'sgx_encl' for VA pages and
'sgx_encl_page' can be stored in the previously introduced union field."

> When cgroup OOM support is added in a later patch, the owning enclave of =
a
> page will need to be identified. Retrieving the sgx_encl struct from a
> sgx_epc_page will be different if the page is a VA page vs. other enclave
> pages.
>
> Add 2 flags which will identify the type of the owner and apply them
> accordingly to newly allocated pages.

This would be easier to follow:

"OOM support for cgroups requires that the owner needs to be identified
when selecting pages from the unreclaimable list. Address this by adding
flags for identifying the owner type."

It is better to carry the story a little bit forward than say that a
subsequent patch will require this :-) I.e. enough to get at least a
rough idea what is going on.

R, Jarkko
