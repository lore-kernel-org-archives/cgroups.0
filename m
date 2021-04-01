From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 10:46:41 -0300
Message-ID: <20210401134641.GG1463678@nvidia.com>
References: <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401114648.GX1463678@nvidia.com>
 <BN6PR11MB406858FAC3821B84CCC4D30DC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401131533.GD1463678@nvidia.com>
 <BN6PR11MB4068C1A040FF61B4A9ABBD9BC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UsmoWToKgEuO9q8+ezLJ1l1ZNZ7WRArJNMv+HLs4XY8=;
 b=d6F6d3zM6tSVvQhCQhG2PZxTAGJ49JvXYr4+36eB8HNI8ut52fXZybYS4+Axm16RrrQpNzeSJW9EcyvnvsjS+7WndNDKK7cRlyYU8uvZMrqovBqBC++wdWuiHgVtZkrCEsaJVzWhSLH8SXZf77ZbYzfsTaT4sNphBf3/wmurKOxcMZlwvTMxmy08sgATMwESg7M3ND0dRk2kKYRIZqDvB0sMc6P9RsmyVw08P/L2HTjdZSrI8q1RFVrJYCjEfmoaG/A/+Eu39HFHt5bJjB4OmcW1cp0791wi77/uOVElejZMzQWrpHezQaGI/Lq4UJ102HRHxfuDKM6XqAYWQcNVQw==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB4068C1A040FF61B4A9ABBD9BC37B9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
To: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 01:43:36PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Thursday, April 1, 2021 9:16 PM
> > 
> > On Thu, Apr 01, 2021 at 01:10:48PM +0000, Liu, Yi L wrote:
> > > > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > > > Sent: Thursday, April 1, 2021 7:47 PM
> > > [...]
> > > > I'm worried Intel views the only use of PASID in a guest is with
> > > > ENQCMD, but that is not consistent with the industry. We need to see
> > > > normal nested PASID support with assigned PCI VFs.
> > >
> > > I'm not quire flow here. Intel also allows PASID usage in guest without
> > > ENQCMD. e.g. Passthru a PF to guest, and use PASID on it without
> > ENQCMD.
> > 
> > Then you need all the parts, the hypervisor calls from the vIOMMU, and
> > you can't really use a vPASID.
> 
> This is a diagram shows the vSVA setup.

I'm not talking only about vSVA. Generic PASID support with arbitary
mappings.

And how do you deal with the vPASID vs pPASID issue if the system has
a mix of physical devices and mdevs?

Jason
