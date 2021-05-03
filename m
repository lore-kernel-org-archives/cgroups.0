From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 3 May 2021 13:05:30 -0300
Message-ID: <20210503160530.GL1370958@nvidia.com>
References: <20210421105451.56d3670a@redhat.com>
 <20210421175203.GN1370958@nvidia.com>
 <20210421133312.15307c44@redhat.com>
 <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <YIeYJZOdgMN/orl0@yekko.fritz.box>
 <20210427172432.GE1370958@nvidia.com>
 <YIi5G4Wg/hpFqNdX@yekko.fritz.box>
 <20210429002149.GZ1370958@nvidia.com>
 <YIol9p3z8BTWFRh8@yekko>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5L2XLVuc7VtR24tCqFEn2YxELbEwg75eNiDbvo22F0M=;
 b=Wi7jP3Ea0sNIfYfuQeaSDrlS34K4gqZS5x4Pg+QEIud3Z02mZAWx5HZgjpuYWrkT7eJ3LdvBnAV5QuU0IQKDneOoiC4TYCpPHb2JT1YNbZBvHbeYBnbe0OxpWwEb8gNmFNrwenOz7vNtSiGqx6J4/mSyD21SINIpiTSKb3r3/sQmE/0BxURvtgEpHb/NEVmfRDJTdL+rP12eB+buOokStKYziHuBQ5Oi9fERdUTBZ76LbucCDPLn2wb/1dBL0K76QR5l5+ERx0INnJddj5Rj9oKPceVv3udORU0mQ2/zHvdxU35y1uFGS/bRXtvZoLWyMDzNYDLcGP0S4BlvpJH+Uw==
Content-Disposition: inline
In-Reply-To: <YIol9p3z8BTWFRh8@yekko>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Thu, Apr 29, 2021 at 01:20:22PM +1000, David Gibson wrote:
> > There is a certain appeal to having some
> > 'PPC_TCE_CREATE_SPECIAL_IOASID' entry point that has a wack of extra
> > information like windows that can be optionally called by the viommu
> > driver and it remains well defined and described.
> 
> Windows really aren't ppc specific.  They're absolutely there on x86
> and everything else as well - it's just that people are used to having
> a window at 0..<something largish> that you can often get away with
> treating it sloppily.

My point is this detailed control seems to go on to more than just
windows. As you say the vIOMMU is emulating specific HW that needs to
have kernel interfaces to match it exactly.

I'm remarking that trying to unify every HW IOMMU implementation that
ever has/will exist into a generic API complete enough to allow the
vIOMMU to be created is likely to result in an API too complicated to
understand..

Jason
