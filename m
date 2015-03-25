From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] mm: Remove usages of ACCESS_ONCE
Date: Wed, 25 Mar 2015 08:51:23 +0100
Message-ID: <20150325075123.GA22386@dhcp22.suse.cz>
References: <1427150680.2515.36.camel@j-VirtualBox>
 <20150324103003.GC14241@dhcp22.suse.cz>
 <1427221835.2515.52.camel@j-VirtualBox>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1427221835.2515.52.camel@j-VirtualBox>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Aswin Chandramouleeswaran <aswin-VXdhtT5mjnY@public.gmane.org>, Christian Borntraeger <borntraeger-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Davidlohr Bueso <dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue 24-03-15 11:30:35, Jason Low wrote:
> On Tue, 2015-03-24 at 11:30 +0100, Michal Hocko wrote:
> > On Mon 23-03-15 15:44:40, Jason Low wrote:
> > > Commit 38c5ce936a08 converted ACCESS_ONCE usage in gup_pmd_range() to
> > > READ_ONCE, since ACCESS_ONCE doesn't work reliably on non-scalar types.
> > > 
> > > This patch removes the rest of the usages of ACCESS_ONCE, and use
> > > READ_ONCE for the read accesses. This also makes things cleaner,
> > > instead of using separate/multiple sets of APIs.
> > > 
> > > Signed-off-by: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
> > 
> > Makes sense to me. I would prefer a patch split into two parts. One which
> > changes potentially dangerous usage of ACCESS_ONCE and the cleanup. This
> > will make the life of those who backport patches into older kernels
> > easier a bit.
> 
> Okay, so have a patch 1 which fixes the following:
> 
>     pte_t pte = ACCESS_ONCE(*ptep);
>     pgd_t pgd = ACCESS_ONCE(*pgdp);
> 
> and the rest of the changes in the cleanup patch 2?

Thanks!

> 
> > I won't insist though.
> > 
> > Acked-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
> 
> Thanks,
> Jason
> 

-- 
Michal Hocko
SUSE Labs
