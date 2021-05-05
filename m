From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 5 May 2021 10:22:59 -0700
Message-ID: <20210505102259.044cafdf@jacob-builder>
References: <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <MWHPR11MB1886E688D2128C98A1F240B18C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210423114944.GF1370958@nvidia.com>
 <MWHPR11MB18861FE6982D73AFBF173E048C439@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210426123817.GQ1370958@nvidia.com>
 <MWHPR11MB188625137D5B7423822396C88C409@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210504084148.4f61d0b5@jacob-builder>
 <20210504180050.GB1370958@nvidia.com>
 <20210504151154.02908c63@jacob-builder>
 <20210504231530.GE1370958@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20210504231530.GE1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, 
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

On Tue, 4 May 2021 20:15:30 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, May 04, 2021 at 03:11:54PM -0700, Jacob Pan wrote:
> 
> > > It is a weird way to use xarray to have a structure which
> > > itself is just a wrapper around another RCU protected structure.
> > > 
> > > Make the caller supply the ioasid_data memory, embedded in its own
> > > element, get rid of the void * and rely on XA_ZERO_ENTRY to hold
> > > allocated but not active entries.
> > >   
> > Let me try to paraphrase to make sure I understand. Currently
> > struct ioasid_data is private to the iasid core, its memory is
> > allocated by the ioasid core.
> > 
> > You are suggesting the following:
> > 1. make struct ioasid_data public
> > 2. caller allocates memory for ioasid_data, initialize it then pass it
> > to ioasid_alloc to store in the xarray
> > 3. caller will be responsible for setting private data inside
> > ioasid_data and do call_rcu after update if needed.  
> 
> Basically, but you probably won't need a "private data" once the
> caller has this struct as it can just embed it in whatever larger
> struct makes sense for it and use container_of/etc
> 
that makes sense. thanks!

> I didn't look too closely at the whole thing though. Honestly I'm a
> bit puzzled why we need a pluggable global allocator framework.. The
> whole framework went to some trouble to isolate everything into iommu
> drivers then that whole design is disturbed by this global thing.
> 
Global and pluggable are for slightly separate reasons.
- We need global PASID on VT-d in that we need to support shared
workqueues (SWQ). E.g. One SWQ can be wrapped into two mdevs then assigned
to two VMs. Each VM uses its private guest PASID to submit work but
each guest PASID must be translated to a global (system-wide) host PASID to
avoid conflict. Also, since PASID table storage is per PF, if two mdevs of
the same PF are assigned to different VMs, the PASIDs must be unique.

- The pluggable allocator is to support the option where the guest PASIDs
are allocated by the hypervisor. Let it be the same as the host PASID or
some arbitrary number cooked up by the hypervisor but backed by a host HW
PASID. VT-d spec has this virtual command interface that requires the guest
to use it instead of allocating from the guest ioasid xarray. This is the
reason why it has to go down to iommu vendor driver. I guess that is what
you meant by "went to some trouble to isolate everything into iommu"?

For ARM, since the guest owns the per device PASID table. There is no need
to allocate PASIDs from the host nor the hypervisor. Without SWQ, there is
no need for global PASID/SSID either. So PASID being global for ARM is for
simplicity in case of host PASID/SSID.



> Jason


Thanks,

Jacob
