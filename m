From: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH] mm: Remove usages of ACCESS_ONCE
Date: Tue, 24 Mar 2015 09:58:32 -0700
Message-ID: <1427216312.2515.46.camel@j-VirtualBox>
References: <1427150680.2515.36.camel@j-VirtualBox>
	 <551177F0.3070006@de.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <551177F0.3070006-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Aswin Chandramouleeswaran <aswin-VXdhtT5mjnY@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jason.low2-VXdhtT5mjnY@public.gmane.org

On Tue, 2015-03-24 at 15:42 +0100, Christian Borntraeger wrote:
> Am 23.03.2015 um 23:44 schrieb Jason Low:
> > Commit 38c5ce936a08 converted ACCESS_ONCE usage in gup_pmd_range() to
> > READ_ONCE, since ACCESS_ONCE doesn't work reliably on non-scalar types.
> > 
> > This patch removes the rest of the usages of ACCESS_ONCE, and use
> > READ_ONCE for the read accesses. This also makes things cleaner,
> > instead of using separate/multiple sets of APIs.
> > 
> > Signed-off-by: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
> 
> Reviewed-by: Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>

Thanks.

> one remark or question:
> 
> > -	anon_mapping = (unsigned long) ACCESS_ONCE(page->mapping);
> > +	anon_mapping = (unsigned long)READ_ONCE(page->mapping);
> 
> Were the white space changes intentional? IIRC checkpatch does prefer
> it your way and you have changed several places - so I assume yes.

Yeah, those changes were intentional.

I thought that this was more of the standard style to do casting, so I
made those changes as well.

> Either way, its probably fine to change that along.

Okay, I'll assume that this is fine for now unless something thinks this
shouldn't be part of the patch.
