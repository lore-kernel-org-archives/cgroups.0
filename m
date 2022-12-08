From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 11/18] x86/sgx: Prepare for multiple LRUs
Date: Thu, 8 Dec 2022 09:42:44 +0000
Message-ID: <Y5GxlPuH9b7B5AEy@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-12-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670492568;
        bh=ILluYFk8ruA2A/bk1cxa/lIB2gKjWFI9cFl4oDrdxrI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oebvmlOr+e8UZbD4fsAMJ+eaZsraR4ciDGHpSy7JExefAdCV+POEWLIEKVMSdLfkG
         886wTMRPp2KywfgGwFTS/T2cDT8iD23b3nmJ+aZ//9OnYcxuJd3K3E+oFvdBdtSALO
         tOpLq1OeKSqVey2U94ENeeielKU7B6SLfHycwu06uKRJEXFj84O8nnsgd0laEFImJ2
         ZRRFQz6EDUBAliCjYW2Rz8U1w8gjCFBgWGMFvuCy0iwS4GYJ+bV3ahwnYVVcw3ERdy
         UlK6BfFwQkSXjmZHvr8aWsVZa16Eoi1WZ6mC4AUdEDF4VUcSPI3vaRIPRFX3UkhmTA
         jaIF16GyY5FOQ==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-12-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:47AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Add sgx_can_reclaim() wrapper so that in a subsequent patch, multiple LRUs
> can be used cleanly.

Nit: Patch is the transient form of a change. Once a change has been
committed, it is a commit.

Further, you should instead explain why subsequent changes require
sgx_can_reclaim() wrapper, than just claim it without argument.

Alternatively, you can consider squashing this to the subsequent
patch, which makes use of the wrapper.

BR, Jarkko
