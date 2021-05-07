From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 7 May 2021 11:06:14 -0600
Message-ID: <20210507110614.7b8e6998@redhat.com>
References: <20210421162307.GM1370958@nvidia.com>
        <20210421105451.56d3670a@redhat.com>
        <20210421175203.GN1370958@nvidia.com>
        <20210421133312.15307c44@redhat.com>
        <20210421230301.GP1370958@nvidia.com>
        <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210422121020.GT1370958@nvidia.com>
        <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210423114944.GF1370958@nvidia.com>
        <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210426123817.GQ1370958@nvidia.com>
        <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
        <20210428090625.5a05dae8@redhat.com>
        <MWHPR11MB1886E0A7897758AA7BE509058C579@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620407187;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aMtPDGFy4Ih0lIydf3qtNax2aFwdbLPaij5zXJDzDrA=;
        b=VJE7bQtDDy7i13TRikbgpNuqS7tdtE4u6tbM8xwZo+1pmHCDOghWAg57ppz7BbhlxSHubw
        UGNMPe/eYVlomULkKzP3jP/8mCabQydKccv7T+MFAo6pUML26FIuJtbH3TZFGwgZ81OPEe
        ZqM99uzM+VepjXJI1AXpSr9Awh62D0o=
In-Reply-To: <MWHPR11MB1886E0A7897758AA7BE509058C579-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Fri, 7 May 2021 07:36:49 +0000
"Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, April 28, 2021 11:06 PM
> > 
> > On Wed, 28 Apr 2021 06:34:11 +0000
> > "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> > >
> > > Can you or Alex elaborate where the complexity and performance problem
> > > locate in VFIO map/umap? We'd like to understand more detail and see  
> > how  
> > > to avoid it in the new interface.  
> > 
> > 
> > The map/unmap interface is really only good for long lived mappings,
> > the overhead is too high for things like vIOMMU use cases or any case
> > where the mapping is intended to be dynamic.  Userspace drivers must
> > make use of a long lived buffer mapping in order to achieve performance.  
> 
> This is not a limitation of VFIO map/unmap. It's the limitation of any
> map/unmap semantics since the fact of long-lived vs. short-lived is 
> imposed by userspace. Nested translation is the only viable optimization
> allowing 2nd-level to be a long-lived mapping even w/ vIOMMU. From 
> this angle I'm not sure how a new map/unmap implementation could 
> address this perf limitation alone.

Sure, we don't need to try to tackle every problem at once, a map/unmap
interface compatible with what we have is a good place to start and
nested translation may provide the high performance option.  That's not
to say that we couldn't, in the future, extend the map/unmap with memory
pre-registration like done in the spapr IOMMU to see how that could
reduce latency.

> > The mapping and unmapping granularity has been a problem as well,
> > type1v1 allowed arbitrary unmaps to bisect the original mapping, with
> > the massive caveat that the caller relies on the return value of the
> > unmap to determine what was actually unmapped because the IOMMU use
> > of
> > superpages is transparent to the caller.  This led to type1v2 that
> > simply restricts the user to avoid ever bisecting mappings.  That still
> > leaves us with problems for things like virtio-mem support where we
> > need to create initial mappings with a granularity that allows us to
> > later remove entries, which can prevent effective use of IOMMU
> > superpages.  
> 
> We could start with a semantics similar to type1v2. 
> 
> btw why does virtio-mem require a smaller granularity? Can we split
> superpages in-the-fly when removal actually happens (just similar
> to page split in VM live migration for efficient dirty page tracking)?

The IOMMU API doesn't currently support those semantics.  If the IOMMU
used a superpage, then a superpage gets unmapped, it doesn't get
atomically broken down into smaller pages.  Therefore virtio-mem
proposes a fixed mapping granularity to allow for that same unmapping
granularity.

> and isn't it another problem imposed by userspace? How could a new
> map/unmap implementation mitigate this problem if the userspace 
> insists on a smaller granularity for initial mappings?

Currently if userspace wants to guarantee unmap granularity, they need
to make the same restriction themselves on the mapping granularity.
For instance, userspace cannot currently map a 1GB IOVA range while
guaranteeing 2MB unmap granularity of that range with a single ioctl.
Instead userspace would need to make 512, 2MB mappings calls.

> > Locked page accounting has been another constant issue.  We perform
> > locked page accounting at the container level, where each container
> > accounts independently.  A user may require multiple containers, the
> > containers may pin the same physical memory, but be accounted against
> > the user once per container.  
> 
> for /dev/ioasid there is still an open whether an process is allowed to
> open /dev/ioasid once or multiple times. If there is only one ioasid_fd
> per process, the accounting can be made accurately. otherwise the
> same problem still exists as each ioasid_fd is akin to the container, then
> we need find a better solution.

We had tossed around an idea of a super-container with vfio, it's maybe
something we'd want to incorporate into this design.  For instance, if
memory could be pre-registered with a super container, which would
handle the locked memory accounting for that memory, then
sub-containers could all handle the IOMMU context of their sets of
devices relative to that common memory pool.
 
> > Those are the main ones I can think of.  It is nice to have a simple
> > map/unmap interface, I'd hope that a new /dev/ioasid interface wouldn't
> > raise the barrier to entry too high, but the user needs to have the
> > ability to have more control of their mappings and locked page
> > accounting should probably be offloaded somewhere.  Thanks,
> >   
> 
> Based on your feedbacks I feel it's probably reasonable to start with
> a type1v2 semantics for the new interface. Locked accounting could
> also start with the same VFIO restriction and then improve it
> incrementally, if a cleaner way is intrusive (if not affecting uAPI).
> But I didn't get the suggestion on "more control of their mappings".
> Can you elaborate?

Things like I note above, userspace cannot currently specify mapping
granularity nor has any visibility to the granularity they get from the
IOMMU.  What actually happens in the IOMMU is pretty opaque to the user
currently.  Thanks,

Alex

