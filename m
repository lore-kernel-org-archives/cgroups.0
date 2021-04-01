From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 31 Mar 2021 21:37:05 -0300
Message-ID: <20210401003705.GS1463678@nvidia.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB18867EC048E3E3FA37F9C38F8C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132740.GB1403691@nvidia.com>
 <BN6PR11MB40688BB2693A657D411E33C8C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331123801.GD1463678@nvidia.com>
 <20210331164621.5f0b0d63@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AKdXEPLNEd+5l+BBdzRUMb69nRkfKn+b/iMCBHYXxjY=;
 b=Tr89xhSCZ3W77CkWKGiSolYOAGeRs5sKMowiQZmqG8J7J35NyijVFXmsH/ExtGY+TH9vJtDZNbXY3rJRZDNFi7K9ruPNy+YI8Vd8vT8vnHg1hiwIvwSY/rtBNE7Kv1L8QkWf05U3Jw/pjEXsOKS+kVqoOjiJ3I5aHWALRd/Sl0a/h9vikdh5Qw2VUg2lNig0fw/5n4bCUwZ582M4ahxtgeSlM24fka3CwvTSsGv5pgpTxlJ2QRG2LT56TmJLDS7lqgGwKLNnsLcijCGzoivrP05yZbgIfmLLZ1VUPm/EPH5cCagPKgAP3zuvuiPM3bBXSDiRauiolym/daIzgHKLug==
Content-Disposition: inline
In-Reply-To: <20210331164621.5f0b0d63@jacob-builder>
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Mar 31, 2021 at 04:46:21PM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 31 Mar 2021 09:38:01 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > > > Get rid of the ioasid set.
> > > >
> > > > Each driver has its own list of allowed ioasids.  
> >  [...]  
> > 
> > The /dev/ioasid FD replaces this security check. By becoming FD
> > centric you don't need additional kernel security objects.
> > 
> > Any process with access to the /dev/ioasid FD is allowed to control
> > those PASID. The seperation between VMs falls naturally from the
> > seperation of FDs without creating additional, complicated, security
> > infrastrucure in the kernel.
> > 
> > This is why all APIs must be FD focused, and you need to have a
> > logical layering of responsibility.
> > 
> >  Allocate a /dev/ioasid FD
> >  Allocate PASIDs inside the FD
> >  Assign memory to the PASIDS
> > 
> >  Open a device FD, eg from VFIO or VDP
> >  Instruct the device FD to authorize the device to access PASID A in
> >  an ioasid FD
> How do we know user provided PASID A was allocated by the ioasid FD?

You pass in the ioasid FD and use a 'get pasid from fdno' API to
extract the required kernel structure.

> Shouldn't we validate user input by tracking which PASIDs are
> allocated by which ioasid FD?

Yes, but it is integral to the ioasid FD, not something separated.

> > VFIO extracts some kernel representation of the ioasid from the ioasid
> > fd using an API
> > 
> This lookup API seems to be asking for per ioasid FD storage array. Today,
> the ioasid_set is per mm and contains a Xarray. 

Right, put the xarray per FD. A set per mm is fairly nonsensical, we
don't use the mm as that kind of security key.

> Since each VM, KVM can only open one ioasid FD, this per FD array
> would be equivalent to the per mm ioasid_set, right?

Why only one?  Each interaction with the other FDs should include the
PASID/FD pair. There is no restriction to just one.

> > VFIO does some kernel call to IOMMU/IOASID layer that says 'tell the
> > IOMMU that this PCI device is allowed to use this PASID'
>
> Would it be redundant to what iommu_uapi_sva_bind_gpasid() does? I thought
> the idea is to use ioasid FD IOCTL to issue IOMMU uAPI calls. Or we can
> skip this step for now and wait for the user to do SVA bind.

I'm not sure what you are asking.

Possibly some of the IOMMU API will need a bit adjusting to make
things split.

The act of programming the page tables and the act of authorizing a
PCI BDF to use a PASID are distinct things with two different IOCTLs.

iommu_uapi_sva_bind_gpasid() is never called by anything, and it's
uAPI is never implemented.

Joerg? Why did you merge dead uapi and dead code?

Jason
