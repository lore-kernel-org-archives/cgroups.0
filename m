From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: [PATCH v2 4/6] slab: add SLAB_ACCOUNT flag
Date: Wed, 11 Nov 2015 19:07:19 +0300
Message-ID: <20151111160719.GX31308@esperanza>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <1ce23e932ea53f47a3376de90b21a9db8293bd6c.1447172835.git.vdavydov@virtuozzo.com>
 <20151110183808.GB13740@mtj.duckdns.org>
 <20151110185401.GW31308@esperanza>
 <20151111155450.GB6246@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151111155450.GB6246-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Nov 11, 2015 at 10:54:50AM -0500, Tejun Heo wrote:
> Hello,
> 
> On Tue, Nov 10, 2015 at 09:54:01PM +0300, Vladimir Davydov wrote:
> > > Am I correct in thinking that we should eventually be able to removed
> > > __GFP_ACCOUNT and that only caches explicitly marked with SLAB_ACCOUNT
> > > would need to be handled by kmemcg?
> > 
> > Don't think so, because sometimes we want to account kmalloc.
> 
> I'm kinda skeptical about that because if those allocations are
> occassional by nature, we don't care and if there can be a huge number
> of them, splitting them into a separate cache makes sense.  I think it
> makes sense to pin down exactly which caches are memcg managed.  That
> has the potential to simplify the involved code path and shave off a
> small bit of hot path overhead.

What about external_name allocation in __d_alloc? Is it occasional?
Depends on the workload I guess. Can we create a separate cache for it?
No, because its size is variable. There are other things like that, e.g.
pipe_buffer array.

Thanks,
Vladimir
