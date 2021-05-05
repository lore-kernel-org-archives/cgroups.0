From: Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and allocation
 APIs
Date: Wed, 5 May 2021 11:10:29 +0200
Message-ID: <17ab53a6-c2d7-c085-6469-ae487b138526@redhat.com>
References: <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210421162307.GM1370958@nvidia.com> <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com> <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <MWHPR11MB1886188698A6E20338196F788C469@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210422121020.GT1370958@nvidia.com>
 <6e36797c-799e-074d-f66f-5686a4b37f38@redhat.com>
 <20210429200431.GA1370958@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1620205853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d0SQnCbBnNBGtZsOp6MO/Q/qxE8V3SBQW2J1qFEwtZU=;
        b=Wz1E4tSjMAcxNtyhjov/1s1KqQiWsWqQamzLmhHwPygkrFTtXrb52zMkpeanlCjYh6EZY1
        MSUFCc9aasUJbVyb9YUiJ5348tELeVZVW00pyA91+WW+iGEc1VpfGV6FVDFKWn9uIZMwD7
        T5HXHuZLzQtBrjw5cPV56QwWR59ISCo=
In-Reply-To: <20210429200431.GA1370958-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Hi Jason,

On 4/29/21 10:04 PM, Jason Gunthorpe wrote:
> On Thu, Apr 29, 2021 at 03:26:55PM +0200, Auger Eric wrote:
>> From the pseudo code,
>>
>>   gpa_ioasid_id = ioctl(ioasid_fd, CREATE_IOASID, ..)
>>   ioctl(ioasid_fd, SET_IOASID_PAGE_TABLES, ..)
>>
>> I fail to understand whether the SET_IOASID_PAGE_TABLES would apply to
>> the whole IOASIDs within /dev/ioasid or to a specific one.
> 
> Sorry, nearly every IOCTL would be scoped to a specific IOASID as one
> of the arguments.

OK thank you for the clarification.
> 
>> Also in subsequent emails when you talk about IOASID, is it the
>> ioasid_id, just to double check the terminology.
> 
> I am refering to IOASID as 'handle of the page table object inside the
> /dev/ioasid fd'. If that is equal to some HW value or not I think
> remains as decision point.
OK
> 
> Basically the fd has an xarray of 'struct [something] *' and the
> IOASID is index to that FD's private xarray. This is necessary to
> create proper security as even if we have global PASID numbers or
> something they still need to be isolated to only the FD that has
> been authorized access.
> 
>>>   nested_ioasid = ioctl(ioasid_fd, CREATE_NESTED_IOASID,  gpa_ioasid_id);
>>>   ioctl(ioasid_fd, SET_NESTED_IOASID_PAGE_TABLES, nested_ioasid, ..)
>> is the nested_ioasid the allocated PASID id or is it a complete
>> different object id.
> 
> It is the IOASID handle above.
ok as per the following emails and below comment IOASID and PASID are
different.The first would be a logic ID wgile the second the HW ID.

Thanks

Eric
> 
>>>
>>>    // IOMMU will match on the device RID, no PASID:
>>>   ioctl(vfio_device, ATTACH_IOASID, nested_ioasid);
>>>
>>>    // IOMMU will match on the device RID and PASID:
>>>   ioctl(vfio_device, ATTACH_IOASID_PASID, pasid, nested_ioasid);
>> here I see you pass a different pasid, so I guess they are different, in
>> which case you would need to have an allocator function for this pasid,
>> right?
> 
> Yes, the underlying HW ID (PASID or substream id or whatver) is
> something slightly different
> 
> Jason
> 

