From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 17/28] x86/sgx: fix a NULL pointer
Date: Mon, 17 Jul 2023 18:52:13 +0000
Message-ID: <CU4OA1SYEUA9.1HXBD5E4PKRZ4@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
 <20230712230202.47929-18-haitao.huang@linux.intel.com>
 <CU4GJG1NRTUD.275UVHM8W2VED@seitikki>
 <ffe26e8b-9f2a-4f06-aadf-9dfb1421be76@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689619938;
        bh=P87FuhTc8IahWEgTuqdfWe67jrGdK6SDRTgOReZthFE=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=qlnofnqnii1cMegZYZVF2HqyH5omZ2b7OXOzmWHw5owzA1KLmpBqePrWEhzN9hyCR
         EgR9GGacPYBjYMMZQa98po56ewrU0hMXaaaBFhZemBR39eJ2uX89yeX+VEdPYKCpzh
         tUligDoFnNONCEqCbtyjpccJwznUBXbrwaULtWW8E2fMJTAEE2T54XqBqPX4dOooa8
         ANYFBYQ4kdLadlWlMLKbMr7bBU5dX3bjyEfnBkRBeBIXkYIl8lhjDERZycLmNwGERo
         /wm5YTgYyujAZtS4ESNh74V6tGcAXY2BCvK2/cxVYCl9Z5FM9PbeBdBS1Knz5Z+Bc2
         JmMSrfHkPFtvA==
In-Reply-To: <ffe26e8b-9f2a-4f06-aadf-9dfb1421be76-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org

On Mon Jul 17, 2023 at 3:49 PM UTC, Dave Hansen wrote:
> On 7/17/23 05:48, Jarkko Sakkinen wrote:
> > On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> >> Under heavy load, the SGX EPC reclaimers (ksgxd or future EPC cgroup
> >> worker) may reclaim SECS EPC page for an enclave and set
> >> encl->secs.epc_page to NULL. But the SECS EPC page is required for EAU=
G
> >> in #PF handler and is used without checking for NULL and reloading.
> >>
> >> Fix this by checking if SECS is loaded before EAUG and load it if it w=
as
> >> reclaimed.
> >>
> >> Signed-off-by: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > A bug fix should be 1/*.
>
> No, bug fixes should not even be _part_ of another series.  Send bug
> fixes separately, please.

Yes, that would be of course a better option.

BR, Jarkko
