From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 28 Apr 2021 15:41:23 -0300
Message-ID: <20210428184123.GW1370958@nvidia.com>
References: <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <MWHPR11MB1886C9199AA3F00FF72ACB508C409@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gMfmm1azbuIlsXCXTeGTugB3LpP6zMt1PjDKaXST7PA=;
 b=fMLBMOkBCvSgDFRgfCWPqAajG2U53d/nIUY6+cMmNLyrlDufyCB/TY07W6ymzNif6+wi7IylHN3zujuMF2gpAqdI9eILAmQroCQY3mRz37R0oHhymyy4JKNN5DFkyAmkwMg+95G+SGe2bZNV6oTdidK3sbagmyNWAwSK0s91q303Evnl7SRyBbvyGvCxBQtXJlRCMgJ7Nn75npWsst5eirZhlIxzGXiNGu466W1s7s+BFueb7165gvf42/gNnrPBwN86lEHrp56Cf4IBhJWgNivxH7Jmvtys+VGhuIzz606WstV8I/IO9oSp7+wQbNjSX8IFiM6S8dQO0/WK8/vo8w==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886C9199AA3F00FF72ACB508C409-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Apr 28, 2021 at 07:47:56AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, April 28, 2021 1:12 AM
> > 
> [...]
> > One option is VFIO can keep its group FD but nothing else will have
> > anthing like it. However I don't much like the idea that VFIO will
> > have a special and unique programming model to do that same things
> > other subsystem will do. That will make it harder for userspace to
> > implement.
> 
> Hi, Jason,
> 
> I have a question here. Based on discussions so far, it's clearly that the
> new ioasid uAPI will differ from existing VFIO uAPI a lot, e.g. ioasid-
> centric operations, no group fd, no incompatible domains, etc. Then 
> I wonder how we plan to support legacy VFIO applications in this 
> transition phase. 

I suspect the VFIO group fd will have to be registered with
/dev/ioasid in addition to each device if we are to retain the same
model.

> Earlier you ever mentioned the desire of directly replacing
> /dev/vfio/vfio with /dev/ioasid and having ioasid to present both
> VFIO and new uAPI. Doesn't it imply that we have to copy the VFIO
> container/group semantics into /dev/ioasid although it's a special
> programming model only for VFIO?

I gave that as a something to think about, if it doesn't work out then
it is just a bad idea to discard.

> Alternatively we could keep all the container/group legacy within VFIO
> and having /dev/ioasid support only the new uAPI semantics. In this case
> VFIO will include a shim iommu backend to connect its legacy uAPI into 
> drivers/ioasid backend functions for backward compatibility. Then VFIO
> will also support a new model which only uses its device uAPI to bind
> to new ioasid fd w/o using any legacy container/group/iommu uAPI.
> Does this sound a plan? 

It may be where we end up.. Though I fear it will make it overly
complex inside VFIO to access the new stuff. It would be very nice if
we could see a path where VFIO insides could only deal with the
in-kernel ioasid handles, whatever they are.

Jason
