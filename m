From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2] percpu: improve percpu_alloc_percpu event trace
Date: Tue, 10 May 2022 19:33:17 -0700
Message-ID: <YnsgbXKiNNSF+1ZO@carbon>
References: <2b388d09-940e-990f-1f8a-2fdaa9210fa0@openvz.org>
 <a07be858-c8a3-7851-9086-e3262cbcf707@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652236405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=A/7S2Nfdl9mg+NTUlm8YRagGmVcuRP9spTCxvE0H5V8=;
        b=vBWdSRKNrRSnj63/2q34r3/NwsV2orkeonfypPwEqGznWLw2L0Fz8zfCr/hxvZ99MgLFvr
        WXMEKbGUubwgtQ2jbWiF1CSeAE8kxPdzTlzkXm3kZhuot9A3XTqfPMRehOC6DjskJh353p
        ILl2YaVkng/sfDDk+asuaFioScNzVjo=
Content-Disposition: inline
In-Reply-To: <a07be858-c8a3-7851-9086-e3262cbcf707-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, May 06, 2022 at 10:29:25PM +0300, Vasily Averin wrote:
> Added call_site, bytes_alloc and gfp_flags fields to the output
> of the percpu_alloc_percpu ftrace event:
> 
> mkdir-4393  [001]   169.334788: percpu_alloc_percpu:
>  call_site=mem_cgroup_css_alloc+0xa6 reserved=0 is_atomic=0 size=2408 align=8
>   base_addr=0xffffc7117fc00000 off=402176 ptr=0x3dc867a62300 bytes_alloc=14448
>    gfp_flags=GFP_KERNEL_ACCOUNT
> 
> This is required to track memcg-accounted percpu allocations.
> 
> Signed-off-by: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

LGTM, thanks Vasily!

One minor thing below.

> ---
> v2: added call_site, improved patch description
> ---
>  include/trace/events/percpu.h | 23 +++++++++++++++++------
>  mm/percpu-internal.h          |  8 ++++----
>  mm/percpu.c                   |  5 +++--
>  3 files changed, 24 insertions(+), 12 deletions(-)
> 
> diff --git a/include/trace/events/percpu.h b/include/trace/events/percpu.h
> index df112a64f6c9..e989cefc0def 100644
> --- a/include/trace/events/percpu.h
> +++ b/include/trace/events/percpu.h
> @@ -6,15 +6,20 @@
>  #define _TRACE_PERCPU_H
>  
>  #include <linux/tracepoint.h>
> +#include <trace/events/mmflags.h>
>  
>  TRACE_EVENT(percpu_alloc_percpu,
>  
> -	TP_PROTO(bool reserved, bool is_atomic, size_t size,
> -		 size_t align, void *base_addr, int off, void __percpu *ptr),
> +	TP_PROTO(unsigned long call_site,
> +		 bool reserved, bool is_atomic, size_t size,
> +		 size_t align, void *base_addr, int off,
> +		 void __percpu *ptr, size_t bytes_alloc, gfp_t gfp_flags),

Don't we want to preserve the order and add the call_site at the end?
Trace events are not ABI, but if we don't have a strong reason to break it,
I'd preserve the old order.

Thanks!
