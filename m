From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 14/18] x86/sgx: Add EPC OOM path to forcefully reclaim
 EPC
Date: Thu, 8 Dec 2022 15:21:44 +0000
Message-ID: <Y5IBCOuF8X7jEK3+@kernel.org>
References: <20221202183655.3767674-1-kristen@linux.intel.com>
 <20221202183655.3767674-15-kristen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670512909;
        bh=tVhThTBTlto5XgoPkDUpcJfWLSIca0Vm8CQvc7flH4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BCxpw+coCm32MFSOsv6tLA547eDwyk4iQhTiUW/Ytxds1Zu2n21wyNNnkRPAo/Ldt
         A2P2emB8IohSGVOuAZDyQ3onEcJTxkkXJcOUswbVaOZuAxfoKxx65R9yLJgsopJBkZ
         EwvrLquzFwnulvZ2qde9ZHEHmvbnfUEyxE74AIclMW5UI7Du9BESExsk5brwHxJfbL
         8Y+SR98pX/6rtfEV3yck316uUZVBoJNwGRgB+XSuud9/61/BzRfGXC5Jq1NOT3RZVX
         yWMu2AF2a1wNGB3z5CI1Ho5arosZAu8/JM9KpaUyKdUMN81d+MfZzdj22UrUNsPqWI
         xoHky3O1Tw7uQ==
Content-Disposition: inline
In-Reply-To: <20221202183655.3767674-15-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Dec 02, 2022 at 10:36:50AM -0800, Kristen Carlson Accardi wrote:
> From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Introduce the OOM path for killing an enclave with the reclaimer
> is no longer able to reclaim enough EPC pages. Find a victim enclave,
> which will be an enclave with EPC pages remaining that are not
> accessible to the reclaimer ("unreclaimable"). Once a victim is
> identified, mark the enclave as OOM and zap the enclaves entire
> page range. Release all the enclaves resources except for the
> struct sgx_encl memory itself.
> 
> Signed-off-by: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
> Cc: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Why this patch is dependent of all 13 patches before it?

Looks like something that is orthogonal to cgroups and could be
live by its own. At least it probably does not require all of
those patches, or does it?

Even without cgroups it would make sense to killing enclaves if
reclaimer gets stuck.

BR, Jarkko
