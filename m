From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [PATCH v2] slub: correctly bootstrap boot caches
Date: Mon, 25 Feb 2013 14:16:15 +0900
Message-ID: <20130225051615.GC12158@lge.com>
References: <1361550000-14173-1-git-send-email-glommer@parallels.com>
 <alpine.DEB.2.02.1302221034380.7600@gentwo.org>
 <alpine.DEB.2.02.1302221057430.7600@gentwo.org>
 <0000013d02d9ee83-9b41b446-ee42-4498-863e-33b3175c007c-000000@email.amazonses.com>
 <5127A607.3040603@parallels.com>
 <0000013d02ee5bf7-a2d47cfc-64fb-4faa-b92e-e567aeb6b587-000000@email.amazonses.com>
 <CAAmzW4OG6b+7t2S3PUY710CDHkbSb9BWxzxWULm5EzJP4BGEXA@mail.gmail.com>
 <0000013d09a01f03-376fad0e-700d-4a04-8da2-89e6b3a22408-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0000013d09a01f03-376fad0e-700d-4a04-8da2-89e6b3a22408-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Hello, Christoph.

On Sun, Feb 24, 2013 at 12:35:22AM +0000, Christoph Lameter wrote:
> On Sat, 23 Feb 2013, JoonSoo Kim wrote:
> 
> > With flushing, deactivate_slab() occur and it has some overhead to
> > deactivate objects.
> > If my patch properly fix this situation, it is better to use mine
> > which has no overhead.
> 
> Well this occurs during boot and its not that performance critical.

Hmm...
Yes, this is not performance critical place, but why do we use
a sub-optimal solution?

And flushing is abstration for complicated logic, so I think that
my raw implemntation is better for understanding.

But, I have no objection to merge Glauber's one
if you think that is better.

Thanks.

> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
