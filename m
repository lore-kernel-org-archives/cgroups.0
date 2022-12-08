From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 08/18] x86/sgx: Allow reclaiming up to 32 pages, but
 scan 16 by default
Date: Thu, 8 Dec 2022 09:27:36 +0000
Message-ID: <Y5GuCAXhSBQMj2Oy@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-9-kristen@linux.intel.com>
 <Y5GtyM92jE5/UJT3@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670491660;
        bh=nYDQKYl6AfmksUUe3QUl1LuA/5DbK7++WISDhMXABeQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=evhG5/iAkrAQcfVfv+xgSTPcK0iGoj6oi9z71dSCl1yY45SFmuoX/sppTwbabYhCJ
         VegQd8R0eq/y953guEZOEyWVrdJwJFl/U9Gn0TCZMpJ2uAwsvCCRWvmAMn9UNChX2e
         YTdy9LTTUbAo0pgss5i5fCBeUwzWY56wGw1tAKPkpLbGFsIFbWfBE+sCGEp6Cgfwbp
         O38krwtNC4XT2wKkw2pOmKODbW9vWqbXya3KuxzG6PUxeeSFXGn+Y9Q3QudIxACFov
         Ibw5Orv2ro3YzvpzuJeNzn5PxhE1b1qzqRo/1yxnIfGFHcqzVK6hd3I15pejhD1wsV
         8+KIvc8SU8Pjg==
Content-Disposition: inline
In-Reply-To: <Y5GtyM92jE5/UJT3-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Thu, Dec 08, 2022 at 09:26:35AM +0000, Jarkko Sakkinen wrote:
> On Fri, Dec 02, 2022 at 10:36:44AM -0800, Kristen Carlson Accardi wrote:
> > From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > 
> > Modify sgx_reclaim_pages() to take a parameter that specifies the
> > number of pages to scan for reclaiming. Specify a max value of
> > 32, but scan 16 in the usual case. This allows the number of pages
> > sgx_reclaim_pages() scans to be specified by the caller, and adjusted
> > in future patches.
> > 
> > Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> > Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  arch/x86/kernel/cpu/sgx/main.c | 25 +++++++++++++++----------
> >  1 file changed, 15 insertions(+), 10 deletions(-)
> > 
> > diff --git a/arch/x86/kernel/cpu/sgx/main.c b/arch/x86/kernel/cpu/sgx/main.c
> > index 83aaf5cea7b9..f201ca85212f 100644
> > --- a/arch/x86/kernel/cpu/sgx/main.c
> > +++ b/arch/x86/kernel/cpu/sgx/main.c
> > @@ -18,6 +18,8 @@
> >  #include "encl.h"
> >  #include "encls.h"
> >  
> > +#define SGX_MAX_NR_TO_RECLAIM	32
> 
> SGX_NR_TO_SCAN_MAX

Would also deserve a descriptive comment.

BR, Jarkko
