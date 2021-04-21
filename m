From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 21 Apr 2021 13:23:07 -0300
Message-ID: <20210421162307.GM1370958@nvidia.com>
References: <YGW27KFt9eQB9X2z@myrica>
 <BN6PR11MB4068171CD1D4B823515F7EFBC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401134236.GF1463678@nvidia.com>
 <BN6PR11MB4068C4DE7AF43D44DE70F4C1C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401160337.GJ1463678@nvidia.com>
 <4bea6eb9-08ad-4b6b-1e0f-c97ece58a078@redhat.com>
 <20210415230732.GG1370958@nvidia.com>
 <20210416061258.325e762e@jacob-builder>
 <20210416094547.1774e1a3@redhat.com>
 <BN6PR11MB406854F56D18E1187A2C98ACC3479@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tEGO5RBH2sUPVwBKyxNAKyTj+IAAzSfo5YCvm0bhJlw=;
 b=eorlwqlCxDaqTuZ0DJjUBD99utiknW2TLDUz5dND62Q8elQZ+quB5a/HgFG4el2Txn6567duLfRKwp9rxCQrla+mP2uSH3Rz0yZVy13LcDTvylejXwjrTGrYzsLEtGu++rBqXK9jfg+U2LA7Ac2NFIRulOIabcHRjJcOlnJkEkLxfmtOOyIXfCAHpcmAZoD9qG9PgOqAiwudCpXYRUkRfgXsxVwUoI6g1QgMvx86u6FELlbgASm/Lgzl3GaAMoPJqxRz2WHcosHelqtyd2qRuQk/VgNld5XX5jvbxrrSO/WkYy2BO/zBlBb/R1WwYYYZRmOD7OCcwEBLMsUZg1/Jyw==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB406854F56D18E1187A2C98ACC3479-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Auger Eric <eric.auger-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Joerg Roedel <joro-zLv9SwRftAIdnm+yROfE0A@public.gmane.org>, Lu Baolu <baolu.lu-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

On Wed, Apr 21, 2021 at 01:18:07PM +0000, Liu, Yi L wrote:
> > Ideally this new /dev/ioasid interface, and making use of it as a VFIO
> > IOMMU backend, should replace type1. 
> 
> yeah, just a double check, I think this also requires a new set of uAPIs
> (e.g. new MAP/UNMAP), which means the current VFIO IOMMU type1 related ioctls
> would be deprecated in future. right?

This is something to think about, it might make sense to run the
current ioctls in some "compat" mode under /dev/ioasid just to make
migration easier

In this sense /dev/ioasid would be a container that holds multiple
IOASIDs and every new format ioctl specifies the IOASID to operate
on. The legacy ioctls would use some default IOASID but otherwise act
the same.

I'm assuming here there is nothing especially wrong with the /dev/vfio
interface beyond being in the wrong place in the kernel and not
supporting multiple IOASIDs?

Then there may be a fairly simple approch to just make /dev/vfio ==
/dev/ioasid, at least for type 1.

By this I mean we could have the new /dev/ioasid code take over the
/dev/vfio char dev and present both interfaces, but with the same
fops.

The VFIO code would have to remain somehow to support PPC until
someone from ppc world migrates the SPAPR_TCE to use the kernel's new
common IOMMU framework instead of the arch specialty thing it does
now. But it can at least be compile disabled on everything except ppc.

Jason
