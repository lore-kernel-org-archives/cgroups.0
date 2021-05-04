From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 4 May 2021 14:12:46 -0300
Message-ID: <20210504171246.GZ1370958@nvidia.com>
References: <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <MWHPR11MB1886F0818D30329172C420758C409@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mSN88xX3Q2gZJBWMT5TmWuPPEFp8pVrPLrRXRc5cYjY=;
 b=UQH54ZmBFbgVuE3S29LjyLeixlh1mOvD7ZoTE9uO0av480uA+fYkQ3X8Mb6a1WnjtmQd5XPjDrDJ10efDXbSRPonlJI62k+TxvSwUL4Vqka3hRki9uJ5T6rPnWCfTeCtpZJaHMdG9J7ZsjPYtqRDo2I5YVz9mnQ2gMhtzNLTzfQ5ASSQK3qeaV614a4tF8VMXxddp3MI0KzJcAnGIEPE0X4Qi9r+J2cJj9NIgq2hmWE6SBznbNKO6CoR5OdoUq9mMzcm1ZBb8noOWRa4d0vhboDTOH1YPlZMDPAMwPsEqxklLGIx/kbcz3E5YIdoaXJZbySUcHqceMC+uU9f27qUlA==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB1886F0818D30329172C420758C409-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Apr 28, 2021 at 06:58:19AM +0000, Tian, Kevin wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, April 28, 2021 1:12 AM
> > 
> [...] 
> > > As Alex says, if this line fails because of the group restrictions,
> > > that's not great because it's not very obvious what's gone wrong.
> > 
> > Okay, that is fair, but let's solve that problem directly. For
> > instance netlink has been going in the direction of adding a "extack"
> > from the kernel which is a descriptive error string. If the failing
> > ioctl returned the string:
> > 
> >   "cannot join this device to the IOASID because device XXX in the
> >    same group #10 is in use"
> > 
> > Would you agree it is now obvious what has gone wrong? In fact would
> > you agree this is a lot better user experience than what applications
> > do today even though they have the group FD?
> > 
> 
> Currently all the discussions are around implicit vs. explicit uAPI semantics
> on the group restriction. However if we look beyond group the implicit 
> semantics might be inevitable when dealing with incompatible iommu
> domains. An existing example of iommu incompatibility is IOMMU_
> CACHE. 

I still think we need to get rid of these incompatibilities
somehow. Having multiple HW incompatible IOASID in the same platform
is just bad all around.

When modeling in userspace IOMMU_CACHE sounds like it is a property of
each individual IOASID, not an attribute that requires a new domain.

People that want to create cache bypass IOASID's should just ask for
that that directly.

Jason
