From: Jason Gunthorpe <jgg@nvidia.com>
Subject: Re: [RFC PATCH 00/19] mm: Introduce a cgroup to limit the amount of
 locked and pinned memory
Date: Tue, 31 Jan 2023 10:21:07 -0400
Message-ID: <Y9kj04z/jLcUesaL@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <Y9A7kDjm3ZFAttRR@nvidia.com>
 <6369225e-3522-341b-cd20-d95b1f11ea71@redhat.com>
 <Y9kfn4YX59PIxj7+@nvidia.com>
 <2e78d261-9ae9-d203-446e-eaa3c652ca6e@redhat.com>
 <Y9khYwunmC/xdXT9@nvidia.com>
 <1a2417bc-f3ac-3e63-a930-bdefaab2578e@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ci0s1FunZu7mXxKw9DuoTYbsCMkB0qkkoGkfq62lsoc=;
 b=q4qV0ry/odvW59GeefDHzSibRO/gEzD89jj6HfGblJuTLkb2mOUnbPohTGYBTfHVUsNZa8zuigydrJVe/WDyChA5Oul/ch1RNkb3SD89EkHZFRGDQpKlGzCPucZ7ZQZ3ja9/X+mav8LBnisYtVRSeUBpMl7YRjhEkATT28fhQ7FqYgOGusYXIrdKdMitSmXYXQZL1fjEd8ukxp9ZC4PtHhP0SilVN8FcseGxZpPm0AdqNIkJJBZ1jJu1vRnCVYduqO3seFnhPJVgmRM/X787wl5G6NC9gJLfBB543mUhV44/bs1g0Uwnr4q04kkgiuY2FxZq3c7eIyZ9rB5Y645X0g==
Content-Disposition: inline
In-Reply-To: <1a2417bc-f3ac-3e63-a930-bdefaab2578e@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Hildenbrand <david@redhat.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch

On Tue, Jan 31, 2023 at 03:15:49PM +0100, David Hildenbrand wrote:
> On 31.01.23 15:10, Jason Gunthorpe wrote:
> > On Tue, Jan 31, 2023 at 03:06:10PM +0100, David Hildenbrand wrote:
> > > On 31.01.23 15:03, Jason Gunthorpe wrote:
> > > > On Tue, Jan 31, 2023 at 02:57:20PM +0100, David Hildenbrand wrote:
> > > > 
> > > > > > I'm excited by this series, thanks for making it.
> > > > > > 
> > > > > > The pin accounting has been a long standing problem and cgroups will
> > > > > > really help!
> > > > > 
> > > > > Indeed. I'm curious how GUP-fast, pinning the same page multiple times, and
> > > > > pinning subpages of larger folios are handled :)
> > > > 
> > > > The same as today. The pinning is done based on the result from GUP,
> > > > and we charge every returned struct page.
> > > > 
> > > > So duplicates are counted multiple times, folios are ignored.
> > > > 
> > > > Removing duplicate charges would be costly, it would require storage
> > > > to keep track of how many times individual pages have been charged to
> > > > each cgroup (eg an xarray indexed by PFN of integers in each cgroup).
> > > > 
> > > > It doesn't seem worth the cost, IMHO.
> > > > 
> > > > We've made alot of investment now with iommufd to remove the most
> > > > annoying sources of duplicated pins so it is much less of a problem in
> > > > the qemu context at least.
> > > 
> > > Wasn't there the discussion regarding using vfio+io_uring+rdma+$whatever on
> > > a VM and requiring multiple times the VM size as memlock limit?
> > 
> > Yes, but iommufd gives us some more options to mitigate this.
> > 
> > eg it makes some of logical sense to point RDMA at the iommufd page
> > table that is already pinned when trying to DMA from guest memory, in
> > this case it could ride on the existing pin.
> 
> Right, I suspect some issue is that the address space layout for the RDMA
> device might be completely different. But I'm no expert on IOMMUs at all :)

Oh it doesn't matter, it is all virtualized so many times..

> I do understand that at least multiple VFIO containers could benefit by only
> pinning once (IIUC that mgiht have been an issue?).

iommufd has fixed this completely.

> It's all still a big improvement, because I also asked for TDX restrictedmem
> to be accounted somehow as unmovable.

Yeah, it is sort of reasonable to think of the CC "secret memory" as
memory that is no different from memory being DMA'd to. The DMA is
just some other vCPU.

I still don't have a clear idea how all this CC memory is going to
actually work. Eventually it has to get into iommufd as well, somehow.

Jason
