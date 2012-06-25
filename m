From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Date: Mon, 25 Jun 2012 22:57:51 +0200
Message-ID: <20120625205747.GA8101@somewhere>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-12-git-send-email-glommer@parallels.com>
 <4FE89807.50708@redhat.com>
 <20120625183818.GH3869@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=eyshD+uMyAcKZQdxf62ztp+V5xMmI28ervG9DIYstvc=;
        b=ASA/7MFGIKs8Tmjcpet0FAH+EbqS41ueoWX2oZbMwa4WQr/AGzPaHaV/jZjUk7PGFX
         C2azr9XxIzi5TsXNAH6deaJnACcrxw0cio1PRQ0FbzeA1vnH9+7IHKeogAVAspHgnGxD
         PHvm6BrVNFg/5IpfH1liWHzYYxfUzfuo6KUh+quy308YnHtz10EpnJdQHSACxZejwL5s
         kon7iU0hReQvNofRmADxRFEEXt3wq6H7SpgoIx6aQp8jrJzsCeba3eh1ACj3zDGQoeqy
         zT9O+j/JiYD29r85uaTPKMi8Cl1bhWnnvI0MADpEl0maQ8Jh2spBWiGx4OzbJus6PpFW
         yNHw==
Content-Disposition: inline
In-Reply-To: <20120625183818.GH3869-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Mon, Jun 25, 2012 at 11:38:18AM -0700, Tejun Heo wrote:
> On Mon, Jun 25, 2012 at 06:55:35PM +0200, Frederic Weisbecker wrote:
> > On 06/25/2012 04:15 PM, Glauber Costa wrote:
> > 
> > > Because those architectures will draw their stacks directly from
> > > the page allocator, rather than the slab cache, we can directly
> > > pass __GFP_KMEMCG flag, and issue the corresponding free_pages.
> > > 
> > > This code path is taken when the architecture doesn't define
> > > CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
> > > THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the
> > > remaining architectures fall in this category.
> > > 
> > > This will guarantee that every stack page is accounted to the memcg
> > > the process currently lives on, and will have the allocations to fail
> > > if they go over limit.
> > > 
> > > For the time being, I am defining a new variant of THREADINFO_GFP, not
> > > to mess with the other path. Once the slab is also tracked by memcg,
> > > we can get rid of that flag.
> > > 
> > > Tested to successfully protect against :(){ :|:& };:
> > > 
> > > Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> > > CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> > > CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> > > CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> > > CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> > > CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Frederic, does this (with proper slab accounting added later) achieve
> what you wanted with the task counter?

I think so yeah. Relying on general kernel memory accounting should do
the trick for us. And if we need more finegrained limitation on kernel
stack accounting we can still add it incrementally. But I believe global
limitation can be enough.

Thanks.
