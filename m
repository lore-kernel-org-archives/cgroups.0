From: Sean Christopherson <seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] eventfd: simplify eventfd_signal_mask()
Date: Thu, 13 Jul 2023 07:33:05 -0700
Message-ID: <ZLAK+FA3qgbHW0YK@google.com>
References: <20230713-vfs-eventfd-signal-v1-0-7fda6c5d212b@kernel.org> <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1689258787; x=1691850787;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=fr2vYa/Ch6xYV487nmzxcm8iM/FlpnkWVHQ5jynQTbg=;
        b=jacaK9M2p8ae07DYtf3WTwW4sJ88AeR0PMoTM/K8Zom80G9CNsRED8/7OkNACpL4FI
         vSrK+poAQrpW9b9XXAEX3N+/eJqGG0fl2uSilp/V2zhMmynFGmkNp19rQMAPCUIgro+L
         8wZFnIyWuBTpd6inSk0jhwWPq/qOKDhiCmrdy2nICENUOLQPMx4zm5vkc1J+N+jf8F/9
         NWijWeXBKP6nhRWfAZooF9dECtwpwP1B06LROVi+ZRGQWEPDlF+8FcWtS7IpVg38LWBC
         sabPszkfHQCdZSa4qO28HKir4zE3m+cUi5LtAFjCZb9xEKl25slyjVF3CoaXZrvttifT
         RnQA==
In-Reply-To: <20230713-vfs-eventfd-signal-v1-2-7fda6c5d212b-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vitaly Kuznetsov <vkuznets-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Dave Hansen <dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Paul Durrant <paul-LM2mM/qkH7s@public.gmane.org>, Oded Gabbay <ogabbay-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Moritz Fischer <mdf-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Xu Yilun <yilun.xu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Zhenyu Wang <zhenyuw-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Zhi Wang <zhi.a.wang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jani Nikula <jani.nikula-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joonas Lahtinen <joonas.lahtinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Rodrigo Vivi <rodrigo.vivi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tvrtko Ursulin <tvrtko.ursulin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Airlie <airlied@gma>

On Thu, Jul 13, 2023, Christian Brauner wrote:
> diff --git a/fs/eventfd.c b/fs/eventfd.c
> index dc9e01053235..077be5da72bd 100644
> --- a/fs/eventfd.c
> +++ b/fs/eventfd.c
> @@ -43,9 +43,10 @@ struct eventfd_ctx {
>  	int id;
>  };
>  
> -__u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
> +bool eventfd_signal_mask(struct eventfd_ctx *ctx, __poll_t mask)
>  {
>  	unsigned long flags;
> +	__u64 n = 1;
>  
>  	/*
>  	 * Deadlock or stack overflow issues can happen if we recurse here
> @@ -68,7 +69,7 @@ __u64 eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n, __poll_t mask)
>  	current->in_eventfd = 0;
>  	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
>  
> -	return n;
> +	return n == 1;
>  }

...

> @@ -58,13 +58,12 @@ static inline struct eventfd_ctx *eventfd_ctx_fdget(int fd)
>  	return ERR_PTR(-ENOSYS);
>  }
>  
> -static inline int eventfd_signal(struct eventfd_ctx *ctx)
> +static inline bool eventfd_signal(struct eventfd_ctx *ctx)
>  {
>  	return -ENOSYS;
>  }
>  
> -static inline int eventfd_signal_mask(struct eventfd_ctx *ctx, __u64 n,
> -				      unsigned mask)
> +static inline bool eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
>  {
>  	return -ENOSYS;

This will morph to "true" for what should be an error case.  One option would be
to have eventfd_signal_mask() return 0/-errno instead of the count, but looking
at all the callers, nothing ever actually consumes the result.

KVMGT morphs failure into -EFAULT

	if (vgpu->msi_trigger && eventfd_signal(vgpu->msi_trigger, 1) != 1)
		return -EFAULT;

but the only caller of that user ignores the return value.

	if (vgpu_vreg(vgpu, i915_mmio_reg_offset(GEN8_MASTER_IRQ))
			& ~GEN8_MASTER_IRQ_CONTROL)
		inject_virtual_interrupt(vgpu);

The sample driver in samples/vfio-mdev/mtty.c uses a similar pattern: prints an
error but otherwise ignores the result.

So why not return nothing?  That will simplify eventfd_signal_mask() a wee bit
more, and eliminate that bizarre return value confusion for the ugly stubs, e.g.

void eventfd_signal_mask(struct eventfd_ctx *ctx, unsigned mask)
{
	unsigned long flags;

	/*
	 * Deadlock or stack overflow issues can happen if we recurse here
	 * through waitqueue wakeup handlers. If the caller users potentially
	 * nested waitqueues with custom wakeup handlers, then it should
	 * check eventfd_signal_allowed() before calling this function. If
	 * it returns false, the eventfd_signal() call should be deferred to a
	 * safe context.
	 */
	if (WARN_ON_ONCE(current->in_eventfd))
		return;

	spin_lock_irqsave(&ctx->wqh.lock, flags);
	current->in_eventfd = 1;
	if (ctx->count < ULLONG_MAX)
		ctx->count++;
	if (waitqueue_active(&ctx->wqh))
		wake_up_locked_poll(&ctx->wqh, EPOLLIN | mask);
	current->in_eventfd = 0;
	spin_unlock_irqrestore(&ctx->wqh.lock, flags);
}

You could even go further and unify the real and stub versions of eventfd_signal().
