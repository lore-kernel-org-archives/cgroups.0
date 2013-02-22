From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] slub: correctly bootstrap boot caches
Date: Fri, 22 Feb 2013 15:00:19 +0000
Message-ID: <0000013d026b4e5f-1b3deecb-7e37-4476-a27b-3a7db8c1f0a8-000000@email.amazonses.com>
References: <1361529030-17462-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1361529030-17462-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Fri, 22 Feb 2013, Glauber Costa wrote:

> Although not verified in practice, I also point out that it is not safe to scan
> the full list only when debugging is on in this case. As unlikely as it is, it
> is theoretically possible for the pages to be full. If they are, they will
> become unreachable. Aside from scanning the full list, we also need to make
> sure that the pages indeed sit in there: the easiest way to do it is to make
> sure the boot caches have the SLAB_STORE_USER debug flag set.

SLAB_STORE_USER typically increases the size of the managed object. It is
not available when slab debugging is not compiled in. There is no list of
full slab objects that is maintained in the non debug case and if the
allocator is compiled without debug support also the code to manage full
lists will not be present.

Only one or two kmem_cache item is allocated in the bootstrap code and so
far the size of the objects was signficantly smaller than page size. So
the slab pages will be on the partial lists. Why are your slab management
structures so large that a page can no longer contain multiple objects?

If you have that issue then I would suggest to find another way to track
the early object (you could f.e. determine the page addresses from the
object and go through the slab pages like that).
