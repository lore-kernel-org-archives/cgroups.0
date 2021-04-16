From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 16 Apr 2021 10:23:32 -0700
Message-ID: <20210416102332.6f71e53e@jacob-builder>
References: <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
        <20210331124038.GE1463678@nvidia.com>
        <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
        <BN6PR11MB40687428F0D0F3B5F13EA3E0C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
        <YGW27KFt9eQB9X2z@myrica>
        <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
        <20210401134236.GF1463678@nvidia.com>
        <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
        <20210401160337.GJ1463678@nvidia.com>
        <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
        <20210415230732.GG1370958@nvidia.com>
        <20210416061258.325e762e@jacob-builder>
        <20210416094547.1774e1a3@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20210416094547.1774e1a3-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, jacob.jun.pan-VuQAYsv1561eoWH0uzbU5w@public.gmane.org

Hi Alex,

On Fri, 16 Apr 2021 09:45:47 -0600, Alex Williamson
<alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:

> On Fri, 16 Apr 2021 06:12:58 -0700
> Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
> 
> > Hi Jason,
> > 
> > On Thu, 15 Apr 2021 20:07:32 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > wrote: 
> > > On Thu, Apr 15, 2021 at 03:11:19PM +0200, Auger Eric wrote:    
> > > > Hi Jason,
> > > > 
> > > > On 4/1/21 6:03 PM, Jason Gunthorpe wrote:      
> > > > > On Thu, Apr 01, 2021 at 02:08:17PM +0000, Liu, Yi L wrote:
> > > > >       
> > > > >> DMA page faults are delivered to root-complex via page request
> > > > >> message and it is per-device according to PCIe spec. Page request
> > > > >> handling flow is:
> > > > >>
> > > > >> 1) iommu driver receives a page request from device
> > > > >> 2) iommu driver parses the page request message. Get the
> > > > >> RID,PASID, faulted page and requested permissions etc.
> > > > >> 3) iommu driver triggers fault handler registered by device
> > > > >> driver with iommu_report_device_fault()      
> > > > > 
> > > > > This seems confused.
> > > > > 
> > > > > The PASID should define how to handle the page fault, not the
> > > > > driver. 
> > > > 
> > > > In my series I don't use PASID at all. I am just enabling nested
> > > > stage and the guest uses a single context. I don't allocate any
> > > > user PASID at any point.
> > > > 
> > > > When there is a fault at physical level (a stage 1 fault that
> > > > concerns the guest), this latter needs to be reported and injected
> > > > into the guest. The vfio pci driver registers a fault handler to
> > > > the iommu layer and in that fault handler it fills a circ bugger
> > > > and triggers an eventfd that is listened to by the VFIO-PCI QEMU
> > > > device. this latter retrives the faault from the mmapped circ
> > > > buffer, it knowns which vIOMMU it is attached to, and passes the
> > > > fault to the vIOMMU. Then the vIOMMU triggers and IRQ in the guest.
> > > > 
> > > > We are reusing the existing concepts from VFIO, region, IRQ to do
> > > > that.
> > > > 
> > > > For that use case, would you also use /dev/ioasid?      
> > > 
> > > /dev/ioasid could do all the things you described vfio-pci as doing,
> > > it can even do them the same way you just described.
> > > 
> > > Stated another way, do you plan to duplicate all of this code someday
> > > for vfio-cxl? What about for vfio-platform? ARM SMMU can be hooked to
> > > platform devices, right?
> > > 
> > > I feel what you guys are struggling with is some choice in the iommu
> > > kernel APIs that cause the events to be delivered to the pci_device
> > > owner, not the PASID owner.
> > > 
> > > That feels solvable.
> > >     
> > Perhaps more of a philosophical question for you and Alex. There is no
> > doubt that the direction you guided for /dev/ioasid is a much cleaner
> > one, especially after VDPA emerged as another IOMMU backed framework.  
> 
> I think this statement answers all your remaining questions ;)
> 
> > The question is what do we do with the nested translation features that
> > have been targeting the existing VFIO-IOMMU for the last three years?
> > That predates VDPA. Shall we put a stop marker *after* nested support
> > and say no more extensions for VFIO-IOMMU, new features must be built
> > on this new interface?
> >
> > If we were to close a checkout line for some unforeseen reasons, should
> > we honor the customers already in line for a long time?
> > 
> > This is not a tactic or excuse for not working on the new /dev/ioasid
> > interface. In fact, I believe we can benefit from the lessons learned
> > while completing the existing. This will give confidence to the new
> > interface. Thoughts?  
> 
> I understand a big part of Jason's argument is that we shouldn't be in
> the habit of creating duplicate interfaces, we should create one, well
> designed interfaces to share among multiple subsystems.  As new users
> have emerged, our solution needs to change to a common one rather than
> a VFIO specific one.  The IOMMU uAPI provides an abstraction, but at
> the wrong level, requiring userspace interfaces for each subsystem.
> 
> Luckily the IOMMU uAPI is not really exposed as an actual uAPI, but
> that changes if we proceed to enable the interfaces to tunnel it
> through VFIO.
> 
> The logical answer would therefore be that we don't make that
> commitment to the IOMMU uAPI if we believe now that it's fundamentally
> flawed.
> 
I agree the uAPI data tunneling is definitely flawed in terms of
scalability.

I was just thinking it is still a small part of the overall
picture. Considering there are other parts such as fault reporting, user
space deployment, performance, and security. By completing the support on
the existing VFIO framework, it would at least offer a clear landscape where
the new /dev/ioasid can improve upon.

Perhaps similar to cgroup v1 vs v2, it took a long time and with known
limitations in v1.

Anyway, I am glad we have a clear direction now.

Thanks,

Jacob

> Ideally this new /dev/ioasid interface, and making use of it as a VFIO
> IOMMU backend, should replace type1.  Type1 will live on until that
> interface gets to parity, at which point we may deprecate type1, but it
> wouldn't make sense to continue to expand type1 in the same direction
> as we intend /dev/ioasid to take over in the meantime, especially if it
> means maintaining an otherwise dead uAPI.  Thanks,
> 

> Alex
> 


Thanks,

Jacob
