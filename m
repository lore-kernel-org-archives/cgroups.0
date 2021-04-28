From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] ipc: use kmalloc for msg_queue and shmid_kernel
Date: Wed, 28 Apr 2021 08:33:38 +0200
Message-ID: <YIkBwgrDXF2x0Dt+@dhcp22.suse.cz>
References: <e67f2a95-4b01-9db2-fe47-0b2210f0b138@virtuozzo.com>
 <b0845b85-f4fe-601d-3328-d707d7db27f5@virtuozzo.com>
 <YIaVKi+0VMrz5LGD@dhcp22.suse.cz>
 <70805e05-5e56-2ab9-2654-3d48e9fe5a0a@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1619591619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ZhVc13i/loE89OYYNbTCn+LJbpHgfesQUl3vFUzU4w=;
        b=hcsbUVWZOVa/VD7u1r+GmF/lDktHCL3s1g+57QapM1T1z/kS/fIVhq2dmbzUoQQ1SkD5P8
        jq0XFt5nGtr5WpT2823UcVhheb//TC4a0GNGLkTr+bmBbrLPca+VmxIZWE+D68CsXk/Ul8
        PtTpuvnPR6+vo9WXfNBwN9/fguwpXfs=
Content-Disposition: inline
In-Reply-To: <70805e05-5e56-2ab9-2654-3d48e9fe5a0a-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dmitry Safonov <0x7f454c46-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed 28-04-21 08:15:10, Vasily Averin wrote:
> On 4/26/21 1:25 PM, Michal Hocko wrote:
> > Using kvmalloc for sub page size objects is suboptimal because kmalloc
> > can easily fallback into vmalloc under memory pressure and smaller
> > objects would fragment memory. Therefore replace kvmalloc by a simple
> > kmalloc.
> 
> I think you're wrong here:
> kvmalloc can failback to vmalloc for size > PAGE_SIZE only

You are right. My bad. My memory failed on me. Sorry about the
confusion.
-- 
Michal Hocko
SUSE Labs
