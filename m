From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Date: Mon, 25 Jun 2012 11:38:18 -0700
Message-ID: <20120625183818.GH3869@google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-12-git-send-email-glommer@parallels.com>
 <4FE89807.50708@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fjGspcfk4rxWUox+BvAv4VLU1Lez7GA2K241/n4yUt0=;
        b=hNd49usGy/Iu/pL5O0chWDV0xQzbL0Gpk9IERLLTnh0Tjbzmyf3wtIpDtpFVGNOG05
         3Lybk3nmBpUey6BFtN82mYrMBIK4A0br/7xnzyxU2NxVZMqMTBhwdpocQcqRHATK857u
         cmkAw2jZSGWang7XMg3tRZkVl7K02q9yONgrBX9nhHwQI7TvpI7raBPSc370ukLIpmL8
         gyIfeTxGHaMeIGZz87lZQrU0nUjcj9jPVA1te2KA7lkdHmAjWzuv3olHJzxKNG0K2Jkl
         finmB9fgxd7Iyma9CpGk4ctOibcnNDxR5975JblcV0hOsOtDWo/hDBShXiqifbMXy86m
         UetQ==
Content-Disposition: inline
In-Reply-To: <4FE89807.50708-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Jun 25, 2012 at 06:55:35PM +0200, Frederic Weisbecker wrote:
> On 06/25/2012 04:15 PM, Glauber Costa wrote:
> 
> > Because those architectures will draw their stacks directly from
> > the page allocator, rather than the slab cache, we can directly
> > pass __GFP_KMEMCG flag, and issue the corresponding free_pages.
> > 
> > This code path is taken when the architecture doesn't define
> > CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
> > THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the
> > remaining architectures fall in this category.
> > 
> > This will guarantee that every stack page is accounted to the memcg
> > the process currently lives on, and will have the allocations to fail
> > if they go over limit.
> > 
> > For the time being, I am defining a new variant of THREADINFO_GFP, not
> > to mess with the other path. Once the slab is also tracked by memcg,
> > we can get rid of that flag.
> > 
> > Tested to successfully protect against :(){ :|:& };:
> > 
> > Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> > CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> > CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> 
> 
> Acked-by: Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Frederic, does this (with proper slab accounting added later) achieve
what you wanted with the task counter?

Thanks.

-- 
tejun
