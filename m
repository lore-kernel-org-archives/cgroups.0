From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 10 May 2021 13:39:56 -0300
Message-ID: <20210510163956.GD1002214@nvidia.com>
References: <20210505180023.GJ1370958@nvidia.com>
 <20210505130446.3ee2fccd@jacob-builder> <YJOZhPGheTSlHtQc@myrica>
 <20210506122730.GQ1370958@nvidia.com>
 <20210506163240.GA9058@otc-nc-03>
 <MWHPR11MB188698FBEE62AF1313E0F7AC8C569@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210510123729.GA1002214@nvidia.com>
 <20210510152502.GA90095@otc-nc-03>
 <20210510153111.GB1002214@nvidia.com>
 <20210510162212.GB90095@otc-nc-03>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aamh5W010c99pQ7W0CL0uGNQYPJkJSYQhWeISNlUlrs=;
 b=XxNzY7/9N5ELx34GFE8E+TpvXWkGDVvKYRwIkv/H0wEl32DxSZR2zPN+Hh3dv2w4sKal5p02VsUSTievXnIKp5bqfTU6EYQ/e3Zh4flVk8+syjdsiOyXUt/+s5OcJSj9rqQSWmhDO0LZuXsf7UA8SrwZTLCRyK/rVwBMK4d+Xht/kH7c0oxoJJZPpBpt+FA3oA/o118Kc2v9kkCLT23lPf3ZKAn+1wkE8DSs48mX/iOPewS6oLggHjMoOyCb9wWWSyqDtdH/BxwB3PJgg8+iknzazbZZusvSZau8YFxAqCY2djkYGo+2ceBzdVTvS35Q6enxL4BH9udSXgEOop4OtQ==
Content-Disposition: inline
In-Reply-To: <20210510162212.GB90095@otc-nc-03>
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
To: "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Mon, May 10, 2021 at 09:22:12AM -0700, Raj, Ashok wrote:

> Those vIOMMU's will have a capability that it supports PASID allocation
> interface. When you allocate you can say what type of PASID you need
> (shared vs local) and Qemu will obtain either within the local range, or in
> the shared range.

Isn't this what I've been saying? This all has to be explicit, and it
is all local to the iommu driver. At worst we'd have some single
global API 'get me a global PASID' which co-ordinates with all the
iommu drivers to actually implement it.

> > > When we have both SRIOV and shared WQ exposed to the same guest, we 
> > > do have an issue. The simplest way that I thought was to have a guest 
> > > and host PASID separation.  Where the guest has its own PASID  space 
> > > and host has its own carved out.  Guest can do what ever it wants within 
> > > that allocated space without fear of any collition with any other device. 
> > 
> > And how do you reliably migrate if the target kernel has a PASID
> > already allocated in that range?
> 
> For any shared range, remember there is a mapping table. And since those
> ranges are always reserved in the new host it isn't a problem.

It is a smaller problem - all the ranges still need to match between
hosts and so forth. It is tractable but this all needs to be API'd
properly and nothing can be implicit, including the global/local range
split.

Basically all this needs to come through in your /dev/ioasid API RFC
proposal that I hope is being worked on.

I still think it is smarter to push a group of RID's into a global
allocation group and accept there are potential downsides with that
than to try to force a global allocation group on every RID and then
try to fix the mess that makes for non-ENQCMD devices.

Jason
