From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 23 Apr 2021 19:28:03 -0300
Message-ID: <20210423222803.GK1370958@nvidia.com>
References: <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <20210423103851.41138791@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YbXGDqFwkQOJaUjES4Zo6AxYK7W93MS9wh4R5dAJACU=;
 b=Qil48oWo2JuziDVtV5Xfsy5m/xmSJnuoUiUDMJ7VUXfvRPSgVVEaKNCGhbepcvoNsPg0m04YbgBInXvL/+j44xbjAR5KENIEqUkEroedCq0aFIz/LGkimqZ8g8rietsH2kkUon7ppKs2KrkPsRh9U4pJx+BZA4n73i6KY7ollvWVGZQPaHzAYS6Oz+nbwVhSUM3Cjs6Wn4zHO8z6n/MdNpCliX5V0+/VdLk5W5iWiN2hDoh6eKBFnNp6gmm9443TUclVDYq1cjdcguhI1GLgGNsMk7/Amul0vXGNGEX6ZMA98ezPFFInsVQ/RnN5ftRgjMX6jXWg//xydhVpNYR4mA==
Content-Disposition: inline
In-Reply-To: <20210423103851.41138791-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David

On Fri, Apr 23, 2021 at 10:38:51AM -0600, Alex Williamson wrote:
> On Thu, 22 Apr 2021 20:39:50 -0300

> > /dev/ioasid should understand the group concept somehow, otherwise it
> > is incomplete and maybe even security broken.
> > 
> > So, how do I add groups to, say, VDPA in a way that makes sense? The
> > only answer I come to is broadly what I outlined here - make
> > /dev/ioasid do all the group operations, and do them when we enjoin
> > the VDPA device to the ioasid.
> > 
> > Once I have solved all the groups problems with the non-VFIO users,
> > then where does that leave VFIO? Why does VFIO need a group FD if
> > everyone else doesn't?
> 
> This assumes there's a solution for vDPA that doesn't just ignore the
> problem and hope for the best.  I can't speak to a vDPA solution.

I don't think we can just ignore the question and succeed with
/dev/ioasid.

Guess it should get answered as best it can for ioasid "in general"
then we can decide if it makes sense for VFIO to use the group FD or
not when working in ioasid mode.

Maybe a better idea will come up

> an implicit restriction.  You've listed a step in the description about
> a "list of devices in the group", but nothing in the pseudo code
> reflects that step.

I gave it below with the readdir() - it isn't in the pseudo code
because the applications I looked through didn't use it, and wouldn't
benefit from it. I tried to show what things were doing today.

> I expect it would be a subtly missed by any userspace driver
> developer unless they happen to work on a system where the grouping
> is not ideal.

I'm still unclear - what are be the consequence if the application
designer misses the group detail? 

Jason
