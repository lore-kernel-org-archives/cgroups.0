From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 27 Apr 2021 13:39:54 -0300
Message-ID: <20210427163954.GC1370958@nvidia.com>
References: <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <MWHPR11MB1886A98D9176B5571530EF1D8C459@MWHPR11MB1886.namprd11.prod.outlook.com>
 <YIec/Rt7OxvfFw7W@yekko.fritz.box>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nCBSDtTz9Mi9G/WR1q00RSBZ0mrGjOiilxBNVEhL9Dc=;
 b=Bxd7u7/6xqV8QR/QYST/eDZZKz3gjc0z4SYiGkg2i4CtpUfOqYzQSebbg+b1ov3hgo/qy618v9UK+V4KhUAjalvwjtCQwyLYGyc8ntUkY4g4UM2wd7hReZ6B/PIsQbyBtDcxBCnBw1r0vx9FZVWgLuo1yzmSADibQzCM7wjwmVhjBJ1WBAdegmRqbLORop4aQKBc2zF+TzX0Cia/OtV72kuI+76j4kBdXObW0q23OwkZ+o/TQaFmqF55sLu1HDo4kO6uIKfhflu4vgEdSQmupZIe2WnwJ4VQD1XQzSn8/EzrnsiNMYQ/17qX6XvtmKiIl5ugTe9bMylISpYNnnnH+g==
Content-Disposition: inline
In-Reply-To: <YIec/Rt7OxvfFw7W-l+x2Y8Cxqc4e6aEkudXLsA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Tue, Apr 27, 2021 at 03:11:25PM +1000, David Gibson wrote:

> > So your proposal sort of moves the entire container/group/domain 
> > managment into /dev/ioasid and then leaves vfio only provide device
> > specific uAPI. An ioasid represents a page table (address space), thus 
> > is equivalent to the scope of VFIO container.
> 
> Right.  I don't really know how /dev/iosasid is supposed to work, and
> so far I don't see how it conceptually differs from a container.  What
> is it adding?

There are three motivating topics:
 1) /dev/vfio/vfio is only usable by VFIO and we have many interesting
    use cases now where we need the same thing usable outside VFIO
 2) /dev/vfio/vfio does not support modern stuff like PASID and
    updating to support that is going to be a big change, like adding
    multiple IOASIDs so they can be modeled as as a tree inside a
    single FD
 3) I understand there is some desire to revise the uAPI here a bit,
    ie Alex mentioned the poor mapping performance.

I would say it is not conceptually different from what VFIO calls a
container, it is just a different uAPI with the goal to be cross
subsystem.

Jason
