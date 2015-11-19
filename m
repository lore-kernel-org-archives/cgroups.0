From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/6] memcg: only account kmem allocations marked as
 __GFP_ACCOUNT
Date: Thu, 19 Nov 2015 14:00:15 -0500
Message-ID: <20151119190015.GC3941@cmpxchg.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <14d7a7f5e696d71793ddd835604de309af1963fd.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <14d7a7f5e696d71793ddd835604de309af1963fd.1447172835.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 10, 2015 at 09:34:04PM +0300, Vladimir Davydov wrote:
> Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
> fragile and difficult to maintain, because there seem to be many more
> allocations that should not be accounted than those that should be.
> Besides, false accounting an allocation might result in much worse
> consequences than not accounting at all, namely increased memory
> consumption due to pinned dead kmem caches.
> 
> So this patch switches kmem accounting to the white-policy: now only
> those kmem allocations that are marked as __GFP_ACCOUNT are accounted to
> memcg. Currently, no kmem allocations are marked like this. The
> following patches will mark several kmem allocations that are known to
> be easily triggered from userspace and therefore should be accounted to
> memcg.
> 
> Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
