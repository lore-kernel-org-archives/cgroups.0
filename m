From: Jason Wang <jasowang-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 7 Apr 2021 10:06:30 +0800
Message-ID: <acbd03f2-5c7e-d38e-92b6-cedc02429889@redhat.com>
References: <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder> <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder> <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <MWHPR11MB1886CAD48AFC156BFC7C1D398C7A9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210405234230.GF7405@nvidia.com>
 <fa57bde5-472f-6e66-3521-bfac7d6e4f8d@redhat.com>
 <20210406124251.GO7405@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617761214;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eTZmJYI/IOE6eZrevZtsuKN2bM+b1mDhI0WPZSfz0LQ=;
        b=G3TZXjtlMrQ82v2jOE3+uJ4bYtpNVTECX0od4JC59dB8MJNy9wmOHeqZgyM6VNQpZzQN5g
        vd/A5ApgpUmc4wnoMHJfWU4afwjWOIzIDzHX474Mjo85xkk53yB32Q+teTB3UP2iq+rwrp
        cL/Tm7f3qjZ5JngN6gNFkJU1bRpCM50=
In-Reply-To: <20210406124251.GO7405-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"; format="flowed"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Eric Auger <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>


=D4=DA 2021/4/6 =CF=C2=CE=E78:42, Jason Gunthorpe =D0=B4=B5=C0:
> On Tue, Apr 06, 2021 at 09:35:17AM +0800, Jason Wang wrote:
>
>>> VFIO and VDPA has no buisness having map/unmap interfaces once we have
>>> /dev/ioasid. That all belongs in the iosaid side.
>>>
>>> I know they have those interfaces today, but that doesn't mean we have
>>> to keep using them for PASID use cases, they should be replaced with a
>>> 'do dma from this pasid on /dev/ioasid' interface certainly not a
>>> 'here is a pasid from /dev/ioasid, go ahead and configure it youself'
>>> interface
>>  =20
>> So it looks like the PASID was bound to SVA in this design. I think it's=
 not
>> necessairly the case:
> No, I wish people would stop talking about SVA.
>
> SVA and vSVA are a very special narrow configuration of a PASID. There
> are lots of other PASID configurations! That is the whole point, a
> PASID is complicated, there are many configuration scenarios, they
> need to be in one place with a very clearly defined uAPI


Right, that's my understanding as well.


>
>> 1) PASID can be implemented without SVA, in this case a map/unmap interf=
ace
>> is still required
> Any interface to manipulate a PASID should be under /dev/ioasid. We do
> not want to duplicate this into every subsystem.


Yes.


>
>> 2) For the case that hypervisor want to do some mediation in the middle =
for
>> a virtqueue. e.g in the case of control vq that is implemented in the
>> VF/ADI/SF itself, the hardware virtqueue needs to be controlled by Qemu,
>> Though binding qemu's page table to cvq can work but it looks like a
>> overkill, a small dedicated buffers that is mapped for this PASID seems =
more
>> suitalbe.
> /dev/ioasid should allow userspace to setup any PASID configuration it
> wants. There are many choices. That is the whole point, instead of
> copying&pasting all the PASID configuration option into every
> subsystem we have on place to configure it.
>
> If you want a PASID (or generic ioasid) that has the guest physical
> map, which is probably all that VDPA would ever want, then /dev/ioasid
> should be able to prepare that.
>
> If you just want to map a few buffers into a PASID then it should be
> able to do that too.
>
>> So do you mean the device should not expose the PASID confiugration API =
to
>> guest? I think it could happen if we assign the whole device and let gue=
st
>> to configure it for nested VMs.
> This always needs co-operating with the vIOMMU driver. We can't have
> nested PASID use without both parts working together.
>
> The vIOMMU driver configures the PASID and assigns the mappings
> (however complicated that turns out to be)
>
> The VDPA/mdev driver authorizes the HW to use the ioasid mapping, eg
> by authorizing a queue to issue PCIe TLPs with a specific PASID.
>
> The authorization is triggered by the guest telling the vIOMMU to
> allow a vRID to talk to a PASID, which qemu would have to translate to
> telling something like the VDPA driver under the vRID that it can use
> a PASID from /dev/ioasid
>
> For security a VDPA/mdev device MUST NOT issue PASIDs that the vIOMMU
> has not authorized its vRID to use. Otherwise the security model of
> something like VFIO in the guest becomes completely broken.


Yes, that's how it should work.

Thanks


>
> Jason
>

