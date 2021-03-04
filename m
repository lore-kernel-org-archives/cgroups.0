From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 15/18] cgroup: Introduce ioasids controller
Date: Thu, 4 Mar 2021 15:02:53 -0400
Message-ID: <20210304190253.GL4247@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
 <YD+u3CXhwOi2LC+4@slm.duckdns.org> <20210303131726.7a8cb169@jacob-builder>
 <20210303160205.151d114e@jacob-builder> <YECtMZNqSgh7jkGP@myrica>
 <20210304094603.4ab6c1c4@jacob-builder> <20210304175402.GG4247@nvidia.com>
 <20210304110144.39ef0941@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210304110144.39ef0941@jacob-builder>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1614884624; bh=KsoX4K4P4Z7v42HYxZh2fbbvzalzBIz6MU+YUWvMuh8=;
 h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
 From:To:CC:Subject:Message-ID:References:Content-Type:
 Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
 X-MS-Exchange-MessageSentRepresentingType:X-Header;
 b=Y/+tXoO5Rv7rqnPPVb03AWjy73eBvBv/FvNRCgbIDCXN7yKhA+No1pWHwflPq8mAx
 ctf7TOKCfllF6lXdt8+8tAkqCHqHlNrCJENCXatL5bK/cgGiZEsysjKJcDc0XGJou1
 dsfUs/WDt6irR+h8HZlKm7VTSOGkYGdb6G54n/TfdTP55oPL9KYIgC+FDVfq7HpLbq
 9mwPWlfwcBQsMrPi8WLRgeXR0AVDc8Xo/Zf7ta5xDj57rp7VX7WHlMZwAeaVnAiLwB
 M6VTBAEmhGfqM0aEXTWGxq0U7pOCOBcvP2IhsmGSycNcs+nm2CSD2yzzezItmtAhxg
 eTpbDFsDYSXZA==
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
To: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Mar 04, 2021 at 11:01:44AM -0800, Jacob Pan wrote:

> > For something like qemu I'd expect to put the qemu process in a cgroup
> > with 1 PASID. Who cares what qemu uses the PASID for, or how it was
> > allocated?
> 
> For vSVA, we will need one PASID per guest process. But that is up to the
> admin based on whether or how many SVA capable devices are directly
> assigned.

I hope the virtual IOMMU driver can communicate the PASID limit and
the cgroup machinery in the guest can know what the actual limit is.

I was thinking of a case where qemu is using a single PASID to setup
the guest kVA or similar

Jason
