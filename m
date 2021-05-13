From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 13 May 2021 10:50:30 -0300
Message-ID: <20210513135030.GF1002214@nvidia.com>
References: <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko>
 <20210503160530.GL1370958@nvidia.com>
 <YJDFj+sAv41JRIo4@yekko>
 <20210504181537.GC1370958@nvidia.com>
 <7e5c2276-ca1c-a8af-c15f-72a7c83c8bfa@ozlabs.ru>
 <20210505163902.GG1370958@nvidia.com>
 <YJzCC18cQDdKMR6p@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LV/70pglIClI+WWS32XYL5zD2ywvBpVyxovVe/GLPn4=;
 b=k5lszGhPf/48Y/1ZUK5IeebOukgDOr8jqBxi9VJ552O9rbAaDEjH6fz0QYD3qPRnx+YFiT6EszrrONRVj0cG7knGU8AxhhXDGv/UyZqiVHRI1xfq8+AcyUmjXtsUDXZDcmWM1BejOktuZoqqbdqeqPnZdcMS9axFs7Ha0JY02Xc0dEVEhK7icJICvZBqLgfJ9riXK6bbh9rVYJrYTqWaC/xnSSLdWmJVh4OICdvW9/7pIpDQGsUmbqsQhc2JPKD28ZJ4gOBWkI1JowUNWhnTky+upc+desOwphLIkUZ/px6WrtJDrSOonvFccSyjJrBH2Bu08Bj71dEMzfZPVNdI3A==
Content-Disposition: inline
In-Reply-To: <YJzCC18cQDdKMR6p@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alexey Kardashevskiy <aik-sLpHqDYs0B2HXe+LvDLADg@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj@in>

On Thu, May 13, 2021 at 04:07:07PM +1000, David Gibson wrote:
> On Wed, May 05, 2021 at 01:39:02PM -0300, Jason Gunthorpe wrote:
> > On Wed, May 05, 2021 at 02:28:53PM +1000, Alexey Kardashevskiy wrote:
> > 
> > > This is a good feature in general when let's say there is a linux supported
> > > device which has a proprietary device firmware update tool which only exists
> > > as an x86 binary and your hardware is not x86 - running qemu + vfio in full
> > > emulation would provide a way to run the tool to update a physical device.
> > 
> > That specific use case doesn't really need a vIOMMU though, does it?
> 
> Possibly not, but the mechanics needed to do vIOMMU on different host
> IOMMU aren't really different from what you need for a no-vIOMMU
> guest.  

For very simple vIOMMUs this might be true, but this new features of nesting
PASID, migration, etc, etc all make the vIOMMU complicated and
emuluating it completely alot harder.

Stuffing a vfio-pci into a guest and creating a physical map using a
single IOASID is comparably trivial.

Jason
