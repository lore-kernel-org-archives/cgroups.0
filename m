From: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 22 Apr 2021 16:38:08 -0600
Message-ID: <20210422163808.2d173225@redhat.com>
References: <20210416094547.1774e1a3@redhat.com>
        <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
        <20210421162307.GM1370958@nvidia.com>
        <20210421105451.56d3670a@redhat.com>
        <20210421175203.GN1370958@nvidia.com>
        <20210421133312.15307c44@redhat.com>
        <20210421230301.GP1370958@nvidia.com>
        <20210422111337.6ac3624d@redhat.com>
        <20210422175715.GA1370958@nvidia.com>
        <20210422133747.23322269@redhat.com>
        <20210422200024.GC1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619131101;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5CPnCdS+3PHW7WBSNl+13JosLwiUy7b8OWDjwQeL9f4=;
        b=UvVtUoz6iTK73Xi6pmzNu7OsuSTlLjVhiCUxzt80uSnvu09HfvH9CVbfcdRfvryTmf6Mna
        x/PQArZQQw3eOt6JAo2JMHdQweTf2+uf3e9lEjQXIiiT1S5o21fQJEqTLmu8TLV115PdnT
        8DemSKpLt08LXWnIMzv4Zz7n5oi0xlA=
In-Reply-To: <20210422200024.GC1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David

On Thu, 22 Apr 2021 17:00:24 -0300
Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, Apr 22, 2021 at 01:37:47PM -0600, Alex Williamson wrote:
> 
> > If by "classic" you mean conventional PCI bus, then this is much worse
> > than simply "at risk".  The IOMMU cannot differentiate devices behind a
> > PCIe-to-PCI bridge, so the moment you turn on the IOMMU context for the
> > NIC, the address space for your HBA is pulled out from under it.    
> 
> Yes, I understand this, but this is fine and not really surprising if
> the HD device is just forced to remain "unusued"
> 
> To my mind the bigger issue is the NIC now has access to the HD and
> nobody really raised an alarm unless the HD happened to have a kernel
> driver bound.
> 
> > the vfio world, the NIC and HBA are grouped and managed together, the
> > user cannot change the IOMMU context of a group unless all of the
> > devices in the group are "viable", ie. they are released from any host
> > drivers.  
> 
> Yes, I don't propose to change any of that, I just suggest to make the
> 'change the IOMMU context" into "join a /dev/ioasid fd"
> 
> All devices in the group have to be joined to the same ioasid or, with
> the flag, left "unused" with no kernel driver. 
> 
> This is the same viability test VFIO is doing now, just moved slightly
> in the programming flow.
> 
> > vfio users are extremely aware of grouping, they understand the model,
> > if not always the reason for the grouping.  You only need to look at
> > r/VFIO to find various lsgroup scripts and kernel patches to manipulate
> > grouping.  The visibility to the user is valuable imo.  
> 
> I don't propose to remove visibility, sysfs and the lsgroup scripts
> should all still be there.
> 
> I'm just acknowledging reality that the user command line experiance
> we have is focused on single BDFs not on groups. The user only sees
> the group idea when things explode, so why do we have it as such an
> integral part of the programming model?

Because it's fundamental to the isolation of the device?  What you're
proposing doesn't get around the group issue, it just makes it implicit
rather than explicit in the uapi.  For what?  Some ideal notion that
every device should be isolated at the expense of userspace drivers
that then fail randomly because they didn't take into account groups
because it's not part of the uapi?

> > >    ioctl(vifo_device_fd, JOIN_IOASID_FD, ioasifd)
> > >    [..]
> > >    ioctl(vfio_device, ATTACH_IOASID, gpa_ioasid_id) == ENOPERM
> > > 
> > > I would feel comfortable if the ATTACH_IOASID fails by default if all
> > > devices in the group have not been joined to the same ioasidfd.  
> > 
> > And without a group representation to userspace, how would a user know
> > to resolve that?  
> 
> Userspace can continue to read sysfs files that show the group
> relation.
> 
> I'm only talking about the group char device and FD.
> 
> > So the group still exist in sysfs, they just don't have vfio
> > representations?  An implicit grouping does what, automatically unbind
> > the devices, so an admin gives a user access to the NIC but their HBA
> > device disappears because they were implicitly linked?    
> 
> It does exactly the same thing as opening the VFIO group FD and
> instantiating a single device FD does today.
> 
> Most software, like dpdk, automatically deduces the VFIO group from
> the commandline BDF, I'm mainly suggesting we move that deduction from
> userspace software to kernel software.
> 
> > basis ownership on the group, if a user owns the group but the group is
> > not viable because a device is still bound to another kernel driver,
> > the use can't do anything.  Implicitly snarfing up subtly affected
> > devices is bad.  
> 
> The user would get an /dev/ioasid join failure just like they get a
> failure from VFIO_GROUP_SET_CONTAINER (?) today that reflects the
> group is not viable.
> 
> Otherwise what is the alternative?
> 
> How do we model the VFIO group security concept to something like
> VDPA?

Is it really a "VFIO group security concept"?  We're reflecting the
reality of the hardware, not all devices are fully isolated.  An IOMMU
group is the smallest set of devices we believe are isolated from all
other sets of devices.  VFIO groups simply reflect that notion of an
IOMMU group.  This is the reality that any userspace driver needs to
play in, it doesn't magically go away because we drop the group file
descriptor.  It only makes the uapi more difficult to use correctly
because userspace drivers need to go outside of the uapi to have any
idea that this restriction exists.  Thanks,

Alex

