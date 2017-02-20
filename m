From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 06/19] kernel: convert perf_event_context.refcount from
 atomic_t to refcount_t
Date: Mon, 20 Feb 2017 11:28:25 +0100
Message-ID: <20170220102825.GL6500@twins.programming.kicks-ass.net>
References: <1487585948-6401-1-git-send-email-elena.reshetova@intel.com>
 <1487585948-6401-7-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=rUQUjBhHDwEfvm+hEQsRZIoi7bn47E+tHKQ+D0hkMwo=; b=I/1Ri3Gne/VNvKjNNvOw5O7Eo
        CjTfXPsa3nbi5PTXxvBQ1DKBr9ryHHJsW6TWdT8nintb9qBrJYNB7pwUSloWfYHwvrURcAfv/A+7o
        JkODnZp2PD536kQxB7YaBKUOhJxk1kmFz+F9e3zegkJIe2qrn4zY72/ghlJIbUK8YKqGsAJPudibQ
        RAA3eRxCYF1TTJBdh+p20/irfIfKZvGZ4y1iF2BQ5K0p5lAzs5mR2CMmibm8EQ53MWCMf8K12Ep3+
        N376bajoaPU1+6PprVpkUPzj+UWlx3uKHxQHaorolx4B4OX7PREbjB301UBOX4CtAe8mr7bNyja0F
      
Content-Disposition: inline
In-Reply-To: <1487585948-6401-7-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Mon, Feb 20, 2017 at 12:18:55PM +0200, Elena Reshetova wrote:
> +++ b/kernel/events/core.c
> @@ -1108,7 +1108,7 @@ static void perf_event_ctx_deactivate(struct perf_event_context *ctx)
>  
>  static void get_ctx(struct perf_event_context *ctx)
>  {
> -	WARN_ON(!atomic_inc_not_zero(&ctx->refcount));
> +	WARN_ON(!refcount_inc_not_zero(&ctx->refcount));
>  }

You can change that to refcount_inc(), as that has the exact same
semantics.
