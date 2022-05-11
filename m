From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v2] percpu: improve percpu_alloc_percpu event trace
Date: Wed, 11 May 2022 10:30:37 -0700
Message-ID: <YnvyvaPWONjULpIa@carbon>
References: <2b388d09-940e-990f-1f8a-2fdaa9210fa0@openvz.org>
 <a07be858-c8a3-7851-9086-e3262cbcf707@openvz.org>
 <YnsgbXKiNNSF+1ZO@carbon>
 <30a47b4e-7c4b-cd2d-998d-cfaf8d12d342@openvz.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652290243;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hGt3BnCoU4kW+K89I9JK4z3L3KmFUi2s6F9PRzSqJy4=;
        b=je+mlCfAdY+4OyJgDBp5E3GBVuEBLdvt6J+eoOdJnIYkin2GEDUy3o1Xu4pmthPdnADjnW
        y1H2V1XbN5Q/fcQSXljhOoimbX3DNpiiDGnDR+z0zWakiPMO6Msv/BaB0DNLnlU7MSn595
        ruFFuRlABf7+uSqATZ77rTKjlERBqG0=
Content-Disposition: inline
In-Reply-To: <30a47b4e-7c4b-cd2d-998d-cfaf8d12d342-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, May 11, 2022 at 08:11:54AM +0300, Vasily Averin wrote:
> On 5/11/22 05:33, Roman Gushchin wrote:
> > On Fri, May 06, 2022 at 10:29:25PM +0300, Vasily Averin wrote:
> >>  TRACE_EVENT(percpu_alloc_percpu,
> >>  
> >> -	TP_PROTO(bool reserved, bool is_atomic, size_t size,
> >> -		 size_t align, void *base_addr, int off, void __percpu *ptr),
> >> +	TP_PROTO(unsigned long call_site,
> >> +		 bool reserved, bool is_atomic, size_t size,
> >> +		 size_t align, void *base_addr, int off,
> >> +		 void __percpu *ptr, size_t bytes_alloc, gfp_t gfp_flags),
> > 
> > Don't we want to preserve the order and add the call_site at the end?
> > Trace events are not ABI, but if we don't have a strong reason to break it,
> > I'd preserve the old order.
> 
> I checked recent trace patches and found that order changes is acceptable.
> 
> commit 8c39b8bc82aafcc8dd378bd79c76fac8e8a89c8d
> Author: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Date:   Fri Jan 14 11:44:54 2022 +0000
> 
>     cachefiles: Make some tracepoint adjustments
> 
> -           TP_printk("o=%08x i=%lx e=%d",
> -                     __entry->obj, __entry->ino, __entry->error)
> +           TP_printk("o=%08x dB=%lx B=%lx e=%d",
> +                     __entry->obj, __entry->dino, __entry->ino, __entry->error)
> 
> On the other hand I'm agree to keep old order by default.
> that's why I added bytes_alloc and gfp_flags to end of output.
> However I think call_site is an exception. In all cases found, 
> call_site is output first.
> For me personally it simplified output parsing.
> 
> So I would like to know Steven's position on this question.

Ok, not a strong opinion, I think both options are acceptable.

Thanks!
