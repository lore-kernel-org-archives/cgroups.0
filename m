From: Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>
Subject: Re: [patch 2/2] fs: buffer: move allocation failure loop into the
 allocator
Date: Mon, 16 Dec 2013 17:22:48 +0900
Message-ID: <20131216082247.GA5334@lge.com>
References: <1381265890-11333-1-git-send-email-hannes@cmpxchg.org>
 <1381265890-11333-2-git-send-email-hannes@cmpxchg.org>
 <20131203165910.54d6b4724a1f3e329af52ac6@linux-foundation.org>
 <20131204015218.GA19709@lge.com>
 <20131213065805.GC8845@lge.com>
 <00000142ecd51cc6-b987e565-7b4f-4945-89ba-731f1d1376fb-000000@email.amazonses.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <00000142ecd51cc6-b987e565-7b4f-4945-89ba-731f1d1376fb-000000-p/GC64/jrecnJqMo6gzdpkEOCMrvLtNR@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, azurIt <azurit-Rm0zKEqwvD4@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Casteyde <casteyde.christian-GANU6spQydw@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Dec 13, 2013 at 04:40:58PM +0000, Christoph Lameter wrote:
> On Fri, 13 Dec 2013, Joonsoo Kim wrote:
> 
> > Could you review this patch?
> > I think that we should merge it to fix the problem reported by Christian.
> 
> I'd be fine with clearing __GFP_NOFAIL but not with using the same flags
> as for a higher order alloc. __GFP_NORETRY and __GFP_NOWARN should be left
> untouched for the minimal alloc.

Hello.

So you don't want to add __GFP_NORETRY and __GFP_NOWARN for kmemcheck?
I think that it isn't good idea, since users would meet *unexpected*
allocation failure if they enable kmemcheck and slub uses different flags
for kmemcheck. It makes users who want to debug their own problems embarrass.

Thanks.
