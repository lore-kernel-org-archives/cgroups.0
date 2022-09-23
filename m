From: Jarkko Sakkinen <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 01/20] x86/sgx: Call cond_resched() at the end of
 sgx_reclaim_pages()
Date: Fri, 23 Sep 2022 15:37:14 +0300
Message-ID: <Yy2oeiafoe1Cxz9C@kernel.org>
References: <20220922171057.1236139-1-kristen@linux.intel.com>
 <20220922171057.1236139-2-kristen@linux.intel.com>
 <Yy2naAZfiAyP5H/a@kernel.org>
 <Yy2oCRfLrePCWjx7@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663936638;
        bh=6ufS71cwq8f+QgKYS3c0Olp77739jrQ+6Uk+8KSx2gI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rBQix+E3G0MhqACZVF5fEWLWcnppHWANoio3N57g52jL6ckZ77Hhr+C6psPtJHo1y
         imZIMItciRJPvS/iOW8pHOv9/rzRuF7c2amXKeYG5Dn/ci+rjZGsA1iydRTlB2iYwc
         fU0gjLwN6c9Hz3FlQSJK+qLpMS/WuvDTlLt03WN+Kv40Em+ptYZ5fRWzvg4Qc+bOMy
         8fZfXkye4snjBqfgzlSS8FJG9FdsYc3C3OcZvwbsJCv+hNNfVPYCCuusKdzr9TVyYf
         lQL+eFXlRX44FM/KTVciYro2A0QBgJwDaX/Cg7Xpz4e7cn3b/yhFv63RK6Mc+t856s
         wcunbZjsiuHzQ==
Content-Disposition: inline
In-Reply-To: <Yy2oCRfLrePCWjx7-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Fri, Sep 23, 2022 at 03:35:25PM +0300, Jarkko Sakkinen wrote:
> On Fri, Sep 23, 2022 at 03:32:43PM +0300, Jarkko Sakkinen wrote:
> > On Thu, Sep 22, 2022 at 10:10:38AM -0700, Kristen Carlson Accardi wrote:
> > > From: Sean Christopherson <sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > 
> > > Move the invocation of post-reclaim cond_resched() from the callers of
> > > sgx_reclaim_pages() into the reclaim path itself.   sgx_reclaim_pages()
> > > is always called in a loop and is always followed by a call to
> > > cond_resched().  This will hold true for the EPC cgroup as well, which
> > > adds even more calls to sgx_reclaim_pages() and thus cond_resched().
> > 
> > This would be in my opinion better:
> > 
> > "
> > In order to avoid repetion of cond_sched() in ksgxd() and
> > sgx_alloc_epc_page(), move the call inside sgx_reclaim_pages().
> > 
> > This will hold true for the EPC cgroup as well, which adds more
> > call sites sgx_reclaim_pages().
> > "
> > 
> > This way it is dead obvious and is better description because
> > it enumerates the consequences (i.e. call sites).
> 
> Forgot 3rd call site: sgx_reclaim_direct(), which is used by
> SGX2 ioctls. The call sites of sgx_reclaim_direct() do not
> call cond_resched(). You should address why adding this call
> to those flows is fine.

Ofc adding a parameter to sgx_reclaim_pages() for cond_resched() call is
other option (not emphasising either option).

BR, Jarkko
