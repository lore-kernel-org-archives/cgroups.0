From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 00/19] mm: Introduce a cgroup to limit the amount of
 locked and pinned memory
Date: Tue, 31 Jan 2023 10:10:43 -0400
Message-ID: <Y9khYwunmC/xdXT9@nvidia.com>
References: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
 <Y9A7kDjm3ZFAttRR@nvidia.com>
 <6369225e-3522-341b-cd20-d95b1f11ea71@redhat.com>
 <Y9kfn4YX59PIxj7+@nvidia.com>
 <2e78d261-9ae9-d203-446e-eaa3c652ca6e@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4dQjDouL0ik531YeVhjffr/FbCf56b4ymKwny6WKUE=;
 b=EEGWhNH/YhZhqUqbyJOvo73sPBIirkCiazU3p7h/V4IwmewGhJQwbyiVlMjSiB+7B9/vFX8QAnkkfd42AErGGLNVoK2bE1S4+RZ2CcuSY2Ku3l4Dz6EXJfXlun90LgzGkG36H8YJ5HAr9Rl4bkuxyUcvi70epUTk3Xqn32IO7qfANkIeITstqVIHSHZK325ma7TpEJamA9LyOSNPw63RUqgYe71kKH2Gk2VEv1oa8fzJqggfrufCvX92VCqoji4ShpwfcBxOyXzbeW5DPOUj3H8lP4pWNAdE5ZZDAGm9WA36ZTkfnTf/iSxn4ooFjpxX64TfFvI3YhaHBEcKN6/VIw==
Content-Disposition: inline
In-Reply-To: <2e78d261-9ae9-d203-446e-eaa3c652ca6e-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org

On Tue, Jan 31, 2023 at 03:06:10PM +0100, David Hildenbrand wrote:
> On 31.01.23 15:03, Jason Gunthorpe wrote:
> > On Tue, Jan 31, 2023 at 02:57:20PM +0100, David Hildenbrand wrote:
> > 
> > > > I'm excited by this series, thanks for making it.
> > > > 
> > > > The pin accounting has been a long standing problem and cgroups will
> > > > really help!
> > > 
> > > Indeed. I'm curious how GUP-fast, pinning the same page multiple times, and
> > > pinning subpages of larger folios are handled :)
> > 
> > The same as today. The pinning is done based on the result from GUP,
> > and we charge every returned struct page.
> > 
> > So duplicates are counted multiple times, folios are ignored.
> > 
> > Removing duplicate charges would be costly, it would require storage
> > to keep track of how many times individual pages have been charged to
> > each cgroup (eg an xarray indexed by PFN of integers in each cgroup).
> > 
> > It doesn't seem worth the cost, IMHO.
> > 
> > We've made alot of investment now with iommufd to remove the most
> > annoying sources of duplicated pins so it is much less of a problem in
> > the qemu context at least.
> 
> Wasn't there the discussion regarding using vfio+io_uring+rdma+$whatever on
> a VM and requiring multiple times the VM size as memlock limit?

Yes, but iommufd gives us some more options to mitigate this.

eg it makes some of logical sense to point RDMA at the iommufd page
table that is already pinned when trying to DMA from guest memory, in
this case it could ride on the existing pin.

> Would it be the same now, just that we need multiple times the pin
> limit?

Yes

Jason
