From: Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 2/2] eventfd: simplify eventfd_signal_mask()
Date: Thu, 13 Jul 2023 16:52:34 +0200
Message-ID: <20230713-mahnen-drosseln-fa717117e827@brauner>
References: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org>
 <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b@kernel.org>
 <ZLAK+FA3qgbHW0YK@google.com>
Mime-Version: 1.0
Return-path: <io-uring-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689259971;
        bh=R4Hkl4iroQ+C4d3AaFA6aa52uzI7aPnAyTDDN/lwc78=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RS/6gRgqvF3ybwn8Ovqq43iLhI7Yv15SZZP2U5CNn6IhgXHQH9mo4nByA/g4W736R
         AkMi1WqcMsHhNrtO7dGPqCwKIYlgvLK+7FW5vJj2elL3FTubJgM81//BHDuM8QqyRP
         Csacjb3yQ3aRtIn7A1i9sInqtS8VRY/O0QwqwwSlh+wJ04gvPtGAbDZaSnmdfd209l
         vt3KpAe4HIE13hYrO1C7jusvVYug5pHUh1tQDDmm+XtqhW6CbXRqbqDYOCl1W9QxOQ
         VXNT8IMNIH9hLd1wzLndR4KoVQB79H/FYLq25P8lOlildm0R+bpsuSo9TwClPA0kLV
         csu2vX1i0ECSg==
Content-Disposition: inline
In-Reply-To: <ZLAK+FA3qgbHW0YK@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sean Christopherson <seanjc@google.com>
Cc: linux-fsdevel@vger.kernel.org, Vitaly Kuznetsov <vkuznets@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, David Woodhouse <dwmw2@infradead.org>, Paul Durrant <paul@xen.org>, Oded Gabbay <ogabbay@kernel.org>, Wu Hao <hao.wu@intel.com>, Tom Rix <trix@redhat.com>, Moritz Fischer <mdf@kernel.org>, Xu Yilun <yilun.xu@intel.com>, Zhenyu Wang <zhenyuw@linux.intel.com>, Zhi Wang <zhi.a.wang@intel.com>, Jani Nikula <jani.nikula@linux.intel.com>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>, David Airlie <airlied@gma>

On Thu, Jul 13, 2023 at 07:33:05AM -0700, Sean Christopherson wrote:
> On Thu, Jul 13, 2023, Christian Brauner wrote:
> > diff --git a/fs/eventfd.c b/fs/eventfd.c
> > index dc9e01053235..077be5da72bd 100644
> > --- a/fs/eventfd.c
> > +++ b/fs/eventfd.c
> > @@ -43,9 +43,10 @@ struct eventfd_ctx {
> >  	int id;
> >  };
> >  
> > -__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
> > +bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
> >  {
> >  	unsigned long flags;
> > +	__u64 n = 1;
> >  
> >  	/*
> >  	 * Deadlock or stack overflow issues can happen if we recurse here
> > @@ -68,7 +69,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
> >  	current->in_eventfd = 0;
> >  	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
> >  
> > -	return n;
> > +	return n == 1;
> >  }
> 
> ...
> 
> > @@ -58,13 +58,12 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
> >  	return ERR_PTR(-ENOSYS);
> >  }
> >  
> > -static inline int eventfd_signal(struct eventfd_ctx *ctx)
> > +static inline bool eventfd_signal(struct eventfd_ctx *ctx)
> >  {
> >  	return -ENOSYS;
> >  }
> >  
> > -static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
> > -				      unsigned mask)
> > +static inline bool eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
> >  {
> >  	return -ENOSYS;
> 
> This will morph to "true" for what should be an error case.  One option would be

Ewww, that means it did return -ENOSYS before any of this.

> to have eventfd_signal_mask() return 0/-errno instead of the count, but looking
> at all the callers, nothing ever actually consumes the result.
> 
> KVMGT morphs failure into -EFAULT
> 
> 	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger, 1) != 1)
> 		return -EFAULT;
> 
> but the only caller of that user ignores the return value.
> 
> 	if (vgpu_vreg(vgpu, i915_mmio_reg_offset(GEN8_MASTER_IRQ))
> 			& ~GEN8_MASTER_IRQ_CONTROL)
> 		inject_virtual_interrupt(vgpu);
> 
> The sample driver in samples/vfio-mdev/mtty.c uses a similar pattern: prints an
> error but otherwise ignores the result.
> 
> So why not return nothing?  That will simplify eventfd_signal_mask() a wee bit
> more, and eliminate that bizarre return value confusion for the ugly stubs, e.g.

Yeah, it used to return an int in the non-eventfd and a __u64 in the
eventfd case.

> 
> void eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
> {
> 	unsigned long flags;
> 
> 	/*
> 	 * Deadlock or stack overflow issues can happen if we recurse here
> 	 * through waitqueue wakeup handlers. If the caller users potentially
> 	 * nested waitqueues with custom wakeup handlers, then it should
> 	 * check eventfd_signal_allowed() before calling this function. If
> 	 * it returns false, the eventfd_signal() call should be deferred to a
> 	 * safe context.
> 	 */
> 	if (WARN_ON_ONCE(current->in_eventfd))
> 		return;
> 
> 	spin_lock_irqsave(&ctx->wqh.lock, flags);
> 	current->in_eventfd = 1;
> 	if (ctx->count < ULLONG_MAX)
> 		ctx->count++;
> 	if (waitqueue_active(&ctx->wqh))
> 		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
> 	current->in_eventfd = 0;
> 	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
> }
> 
> You could even go further and unify the real and stub versions of eventfd_signal().

The reason I didn't make eventfd_signal_mask() return void was that it
was called from eventfd_signal() which did, I didn't realize the caller
didn't actually consume the return value.

If we can let both return void it gets simpler.

Thanks for that.
