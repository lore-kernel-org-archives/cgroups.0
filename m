From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 14:26:04 -0300
Message-ID: <20210401172604.GK1463678@nvidia.com>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB18867EC048E3E3FA37F9C38F8C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132740.GB1403691@nvidia.com>
 <BN6PR11MB40688BB2693A657D411E33C8C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331123801.GD1463678@nvidia.com>
 <20210331164621.5f0b0d63@jacob-builder>
 <20210401003705.GS1463678@nvidia.com>
 <20210401102355.38b0b7d7@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ziwf1w5DA8l+3uM9hK6DzOugzV5jzyrNOz7y/RdgICY=;
 b=ODGfMh1+QBZDYa/FGBFHjgz5L8qh0H3bOxSDR5QUAA3YbCV9H+bfGlCK4+wr6CiNpEHzvF3y0LqDy0FgACGthypU2LGcNB/wFqHKT4VSE60R8Lr63OYmrlh435wMpJwCi+47ShEqutwZGISH297ecxN59g1yL3JrJ39XAJAbfVnQqe3WsJBjk0RzDP1pelWLr/nkPhZUnDrmJ0hYM6Si1K0XutEYjvhuWDhLbAHNXFR9itvetNrPpQoyg214XK3P5O7xL8pN+hV7z8mRj/IEFb/OMaj2sF2Nia0oq4sClV8BZ7wwEcjUNqNqg6R7VOkhKgcinqBPJ7mv0o76e+499A==
Content-Disposition: inline
In-Reply-To: <20210401102355.38b0b7d7@jacob-builder>
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 10:23:55AM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 31 Mar 2021 21:37:05 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, Mar 31, 2021 at 04:46:21PM -0700, Jacob Pan wrote:
> > > Hi Jason,
> > > 
> > > On Wed, 31 Mar 2021 09:38:01 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > wrote: 
> > > > > > Get rid of the ioasid set.
> > > > > >
> > > > > > Each driver has its own list of allowed ioasids.    
> > > >  [...]  
> > > > 
> > > > The /dev/ioasid FD replaces this security check. By becoming FD
> > > > centric you don't need additional kernel security objects.
> > > > 
> > > > Any process with access to the /dev/ioasid FD is allowed to control
> > > > those PASID. The seperation between VMs falls naturally from the
> > > > seperation of FDs without creating additional, complicated, security
> > > > infrastrucure in the kernel.
> > > > 
> > > > This is why all APIs must be FD focused, and you need to have a
> > > > logical layering of responsibility.
> > > > 
> > > >  Allocate a /dev/ioasid FD
> > > >  Allocate PASIDs inside the FD
> Just to be super clear. Do we allocate a FD for each PASID and return the
> FD to the user? Or return the plain PASID number back to the user space?

I would do multiple PASID's per /dev/ioasid FD because we expect alot
of PASIDs to be in use and we'd run into FDno limits.

> > > >  Assign memory to the PASIDS
> > > > 
> > > >  Open a device FD, eg from VFIO or VDP
> > > >  Instruct the device FD to authorize the device to access PASID A in
> > > >  an ioasid FD  
> > > How do we know user provided PASID A was allocated by the ioasid FD?  
> > 
> > You pass in the ioasid FD and use a 'get pasid from fdno' API to
> > extract the required kernel structure.
> > 
> Seems you are talking about two FDs:
> - /dev/ioasid FD

No, just this one.

> - per IOASID FD
> This API ioasid = get_pasid_from_fd(dev_ioasid_fd, ioasid_fd);
> dev_ioasid_fd will find the xarray for all the PASIDs allocated under it,
> ioasid_fd wil be the index into the xarray to retrieve the actual ioasid.
> Correct?

'ioasid_fd' is just the ioasid number in whatever numberspace the
/dev/ioasid FD's use.

> > Why only one?  Each interaction with the other FDs should include the
> > PASID/FD pair. There is no restriction to just one.

> OK, one per subsystem-VM. For example, if a VM has a VFIO and a VDPA
> device, it should only two /dev/ioasid FDs respectively. Correct?

No, only one.

For something like qemu's use case I mostly expect the vIOMMU driver
will open /dev/ioasid for each vIOMMU instance it creates (basically
only one)

> > The act of programming the page tables and the act of authorizing a
> > PCI BDF to use a PASID are distinct things with two different IOCTLs.
> > 
> Why separate? 

Because they have different owners and different layers in the
software.

It is not about use case, it is about putting the control points where
they naturally belong.

> For a complex stack like vSVA, I feel we have to reduce moving parts and do
> some divide and conquer.

uAPI should have all come together with a user and user application.

uAPI is hardest and most important part.

Jason
