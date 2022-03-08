From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/3] mm: vmalloc: introduce array allocation functions
Date: Tue, 8 Mar 2022 16:26:26 +0100
Message-ID: <Yid1orgE/Yf56WSV@dhcp22.suse.cz>
References: <20220308105918.615575-1-pbonzini@redhat.com>
 <20220308105918.615575-2-pbonzini@redhat.com>
 <Yidefp4G/Hk2Twfy@dhcp22.suse.cz>
 <77a34051-2672-88cf-99dd-60f5acfb905e@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1646753188; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=m2m+Ogcvgk7zAck8lJL9y5rOuyf0bq56RUWhNvKb8gE=;
        b=OFDOb0EX8vyJa+0LJDX7Xt+dj6BWiRqgtFSXsPFEiYkQ6sdEw/loo4IXxjnn4hrfyZx4nu
        xtvYdMNA0TmRGdgQCsrBvDWK+/YB3GNo5U1S690uSfCWm1EOUwu+z/F/Fl1e8LfoiK7zg1
        decbmKM6dxZOdt3C97MlG/yD3bCKPZY=
Content-Disposition: inline
In-Reply-To: <77a34051-2672-88cf-99dd-60f5acfb905e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dennis Zhou <dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 08-03-22 14:55:39, Paolo Bonzini wrote:
> On 3/8/22 14:47, Michal Hocko wrote:
> > Seems useful
> > Acked-by: Michal Hocko<mhocko-IBi9RG/b67k@public.gmane.org>
> > 
> > Is there any reason you haven't used __alloc_size(1, 2) annotation?
> 
> It's enough to have them in the header:
> 
> > > +extern void *__vmalloc_array(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
> > > +extern void *vmalloc_array(size_t n, size_t size) __alloc_size(1, 2);
> > > +extern void *__vcalloc(size_t n, size_t size, gfp_t flags) __alloc_size(1, 2);
> > > +extern void *vcalloc(size_t n, size_t size) __alloc_size(1, 2);

My bad, I have expected __alloc_size before the function name and simply
haven't noticed it at the end.
-- 
Michal Hocko
SUSE Labs
