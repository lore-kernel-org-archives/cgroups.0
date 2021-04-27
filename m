From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 27 Apr 2021 14:24:32 -0300
Message-ID: <20210427172432.GE1370958@nvidia.com>
References: <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com>
 <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SPaU/gpgmZzFAGpL9QsBTvaL85w1xdy8IEqqRSYM6j8=;
 b=LunouMo1pzQL2MTKE5ZycHEfdkmgY0GM8+259xkP/6k0J4m0FUnw3h+uJTpontZFwmGIQioCTlgMlj9pYUj57+bRsm5mqjZhUS1Kk2EoqkDQepcVUcogzD1cuRuxyIYvL3iCCLrfZrvsjCnXdDlBEv/lnS1BTNR0s0nZIXUhfgId/BvHP77dPvf7rojLs3RgDKqE/XaWdA3K/1Mn6RlwTHQ9GJOIkT21Yd5IFqyD2bvYETj8peyHjz6R5Q4XfG89EvzO0t3+UcPDKLsS8DPigBCz686H2mYOJ3T3neyysRpS+E4tEJIX4b2WDNvUDPm5PemzuBXZssNsepbdOpHoLw==
Content-Disposition: inline
In-Reply-To: <YIeYJZOdgMN/orl0-l+x2Y8Cxqc4e6aEkudXLsA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Apr 27, 2021 at 02:50:45PM +1000, David Gibson wrote:

> > > I say this because the SPAPR looks quite a lot like PASID when it has
> > > APIs for allocating multiple tables and other things. I would be
> > > interested to hear someone from IBM talk about what it is doing and
> > > how it doesn't fit into today's IOMMU API.
> 
> Hm.  I don't think it's really like PASID.  Just like Type1, the TCE
> backend represents a single DMA address space which all devices in the
> container will see at all times.  The difference is that there can be
> multiple (well, 2) "windows" of valid IOVAs within that address space.
> Each window can have a different TCE (page table) layout.  For kernel
> drivers, a smallish translated window at IOVA 0 is used for 32-bit
> devices, and a large direct mapped (no page table) window is created
> at a high IOVA for better performance with 64-bit DMA capable devices.
>
> With the VFIO backend we create (but don't populate) a similar
> smallish 32-bit window, userspace can create its own secondary window
> if it likes, though obvious for userspace use there will always be a
> page table.  Userspace can choose the total size (but not address),
> page size and to an extent the page table format of the created
> window.  Note that the TCE page table format is *not* the same as the
> POWER CPU core's page table format.  Userspace can also remove the
> default small window and create its own.

So what do you need from the generic API? I'd suggest if userspace
passes in the required IOVA range it would benefit all the IOMMU
drivers to setup properly sized page tables and PPC could use that to
drive a single window. I notice this is all DPDK did to support TCE.

> The second wrinkle is pre-registration.  That lets userspace register
> certain userspace VA ranges (*not* IOVA ranges) as being the only ones
> allowed to be mapped into the IOMMU.  This is a performance
> optimization, because on pre-registration we also pre-account memory
> that will be effectively locked by DMA mappings, rather than doing it
> at DMA map and unmap time.

This feels like nesting IOASIDs to me, much like a vPASID.

The pre-registered VA range would be the root of the tree and the
vIOMMU created ones would be children of the tree. This could allow
the map operations of the child to refer to already prepped physical
memory held in the root IOASID avoiding the GUP/etc cost.

Seems fairly genericish, though I'm not sure about the kvm linkage..

> I like the idea of a common DMA/IOMMU handling system across
> platforms.  However in order to be efficiently usable for POWER it
> will need to include multiple windows, allowing the user to change
> those windows and something like pre-registration to amortize
> accounting costs for heavy vIOMMU load.

I have a feeling /dev/ioasid is going to end up with some HW specific
escape hatch to create some HW specific IOASID types and operate on
them in a HW specific way.

However, what I would like to see is that something simple like DPDK
can have a single implementation - POWER should implement the standard
operations and map them to something that will work for it.

As an ideal, only things like the HW specific qemu vIOMMU driver
should be reaching for all the special stuff.

In this way the kernel IOMMU driver and the qemu user vIOMMU driver
would form something of a classical split user/kernel driver pattern.

Jason

