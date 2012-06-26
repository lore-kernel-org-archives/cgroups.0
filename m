From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 11/11] protect architectures where THREAD_SIZE >=
 PAGE_SIZE against fork bombs
Date: Tue, 26 Jun 2012 15:38:41 +0200
Message-ID: <20120626133838.GA11519@somewhere.redhat.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com>
 <1340633728-12785-12-git-send-email-glommer@parallels.com>
 <4FE89807.50708@redhat.com>
 <20120625183818.GH3869@google.com>
 <4FE9AF88.5070803@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=9glURVbtIVE2uWMecQuAs1MEt8gp0z7OVIzEzBo9SD0=;
        b=iRx+ymselpHrnrizbgW2RMPHMyxre2eXHN3BLpABNaPoXe3ikgZGIMRaHSBFlF563o
         +i6HuOTx997B9Mtge7qCUs6RzfVRg26+/IL5trW8+1ekmc5JExKCYtodsUnIbaQAK2rZ
         xMt804KHwXptuumgvVFaZ1KVeORvpRSUak5EG/64YnCc6HI3p6MJeBoFcJU5bR/VxTW8
         EhOI4FaSTjyd6bgjdYLppwTtWInuh6i8yBQJeh4i7cEUJZIJTrCRjHtDHxvgf6fOOhV0
         83nvrL6+nLQFJqlp4Vt/lICCN86pv13eWmchA49Tm9okVZWeBoK/GdNdUKmxjjS+8bf6
         eeEw==
Content-Disposition: inline
In-Reply-To: <4FE9AF88.5070803-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

On Tue, Jun 26, 2012 at 04:48:08PM +0400, Glauber Costa wrote:
> On 06/25/2012 10:38 PM, Tejun Heo wrote:
> >On Mon, Jun 25, 2012 at 06:55:35PM +0200, Frederic Weisbecker wrote:
> >>On 06/25/2012 04:15 PM, Glauber Costa wrote:
> >>
> >>>Because those architectures will draw their stacks directly from
> >>>the page allocator, rather than the slab cache, we can directly
> >>>pass __GFP_KMEMCG flag, and issue the corresponding free_pages.
> >>>
> >>>This code path is taken when the architecture doesn't define
> >>>CONFIG_ARCH_THREAD_INFO_ALLOCATOR (only ia64 seems to), and has
> >>>THREAD_SIZE >= PAGE_SIZE. Luckily, most - if not all - of the
> >>>remaining architectures fall in this category.
> >>>
> >>>This will guarantee that every stack page is accounted to the memcg
> >>>the process currently lives on, and will have the allocations to fail
> >>>if they go over limit.
> >>>
> >>>For the time being, I am defining a new variant of THREADINFO_GFP, not
> >>>to mess with the other path. Once the slab is also tracked by memcg,
> >>>we can get rid of that flag.
> >>>
> >>>Tested to successfully protect against :(){ :|:& };:
> >>>
> >>>Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> >>>CC: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
> >>>CC: Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>
> >>>CC: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> >>>CC: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> >>>CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >>>CC: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >>
> >>
> >>Acked-by: Frederic Weisbecker <fweisbec-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> >
> >Frederic, does this (with proper slab accounting added later) achieve
> >what you wanted with the task counter?
> >
> 
> A note: Frederic may confirm, but I think he doesn't even need
> the slab accounting to follow to achieve that goal.

Limiting is enough. But that requires internal accounting.
