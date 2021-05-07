From: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Fri, 7 May 2021 07:36:49 +0000
Message-ID: <MWHPR11MB1886E0A7897758AA7BE509058C579@MWHPR11MB1886.namprd11.prod.outlook.com>
References: <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>	<20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>	<20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210428090625.5a05dae8@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com; 
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zL/NA+Gue/OgPDL2Qphm0KKhLO3t/v9HHZCpdf36x3U=;
 b=xHxFMAEjMNm3LqCI6PwqDigzknSzOLAfbOe5/U2TsqsuPio57zYHWuMgrvm8imLqpH7TS8FngLtL/UefJD68xAQAUwmLzRFmLqauj7X7LhIFFSQ1tbW3UL/8hpAkFujHtzq6EX2Lbfe0T3pUAQMlzFZPQgY60DS2b0tdlfa15yw=
In-Reply-To: <20210428090625.5a05dae8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
 <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Sender: "iommu" <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Sent: Wednesday, April 28, 2021 11:06 PM
> 
> On Wed, 28 Apr 2021 06:34:11 +0000
> "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> 
> > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > Sent: Monday, April 26, 2021 8:38 PM
> > >
> > [...]
> > > > Want to hear your opinion for one open here. There is no doubt that
> > > > an ioasid represents a HW page table when the table is constructed by
> > > > userspace and then linked to the IOMMU through the bind/unbind
> > > > API. But I'm not very sure about whether an ioasid should represent
> > > > the exact pgtable or the mapping metadata when the underlying
> > > > pgtable is indirectly constructed through map/unmap API. VFIO does
> > > > the latter way, which is why it allows multiple incompatible domains
> > > > in a single container which all share the same mapping metadata.
> > >
> > > I think VFIO's map/unmap is way too complex and we know it has bad
> > > performance problems.
> >
> > Can you or Alex elaborate where the complexity and performance problem
> > locate in VFIO map/umap? We'd like to understand more detail and see
> how
> > to avoid it in the new interface.
> 
> 
> The map/unmap interface is really only good for long lived mappings,
> the overhead is too high for things like vIOMMU use cases or any case
> where the mapping is intended to be dynamic.  Userspace drivers must
> make use of a long lived buffer mapping in order to achieve performance.

This is not a limitation of VFIO map/unmap. It's the limitation of any
map/unmap semantics since the fact of long-lived vs. short-lived is 
imposed by userspace. Nested translation is the only viable optimization
allowing 2nd-level to be a long-lived mapping even w/ vIOMMU. From 
this angle I'm not sure how a new map/unmap implementation could 
address this perf limitation alone.

> 
> The mapping and unmapping granularity has been a problem as well,
> type1v1 allowed arbitrary unmaps to bisect the original mapping, with
> the massive caveat that the caller relies on the return value of the
> unmap to determine what was actually unmapped because the IOMMU use
> of
> superpages is transparent to the caller.  This led to type1v2 that
> simply restricts the user to avoid ever bisecting mappings.  That still
> leaves us with problems for things like virtio-mem support where we
> need to create initial mappings with a granularity that allows us to
> later remove entries, which can prevent effective use of IOMMU
> superpages.

We could start with a semantics similar to type1v2. 

btw why does virtio-mem require a smaller granularity? Can we split
superpages in-the-fly when removal actually happens (just similar
to page split in VM live migration for efficient dirty page tracking)?

and isn't it another problem imposed by userspace? How could a new
map/unmap implementation mitigate this problem if the userspace 
insists on a smaller granularity for initial mappings?

> 
> Locked page accounting has been another constant issue.  We perform
> locked page accounting at the container level, where each container
> accounts independently.  A user may require multiple containers, the
> containers may pin the same physical memory, but be accounted against
> the user once per container.

for /dev/ioasid there is still an open whether an process is allowed to
open /dev/ioasid once or multiple times. If there is only one ioasid_fd
per process, the accounting can be made accurately. otherwise the
same problem still exists as each ioasid_fd is akin to the container, then
we need find a better solution.

> 
> Those are the main ones I can think of.  It is nice to have a simple
> map/unmap interface, I'd hope that a new /dev/ioasid interface wouldn't
> raise the barrier to entry too high, but the user needs to have the
> ability to have more control of their mappings and locked page
> accounting should probably be offloaded somewhere.  Thanks,
> 

Based on your feedbacks I feel it's probably reasonable to start with
a type1v2 semantics for the new interface. Locked accounting could
also start with the same VFIO restriction and then improve it
incrementally, if a cleaner way is intrusive (if not affecting uAPI).
But I didn't get the suggestion on "more control of their mappings".
Can you elaborate?

Thanks
Kevin
