From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH 15/18] cgroup: Introduce ioasids controller
Date: Wed, 3 Mar 2021 20:23:57 -0400
Message-ID: <20210304002357.GY4247@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
 <YD+u3CXhwOi2LC+4@slm.duckdns.org> <20210303131726.7a8cb169@jacob-builder>
 <20210303160205.151d114e@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210303160205.151d114e@jacob-builder>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
 t=1614817444; bh=aIwvvpE4wGoBAdK1+JiL6a3DRIITWKYkTYWOnUwBXbw=;
 h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
 From:To:CC:Subject:Message-ID:References:Content-Type:
 Content-Disposition:In-Reply-To:X-ClientProxiedBy:MIME-Version:
 X-MS-Exchange-MessageSentRepresentingType:X-Header;
 b=C3fjXaTiJBKO1GYRDJrCCxB7V2sCABjNAU8GwkVL7OgiP2eaQQhwz77qemjqv2HWG
 Ur0ALQQj7VoRWcK74JUXIAo6+w0CUQ2u7PuU9l8jvnXVeaxsaHVpuaPCrjjM4R1043
 QNxly8dOmrEdVq7/0RAaTXgjlA1cBCIqoiugq07vYKnuQ8YkPJZQtVFihRibWUvyQX
 sG7mW0uDkK3pgJouCW4jfadroRjQvwWwZr5oe10GAXxw63aopaVF0YCsKuumeLEyx3
 UmYjK/zIitVVODJ0TossHZvjZq3g3/chw/RpLRUQnVTSwaV6tqQdk5D1PTwhz6ezUN
 QRd1sctf32nvg==
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
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Mar 03, 2021 at 04:02:05PM -0800, Jacob Pan wrote:
> > The interface definitely can be reused. But IOASID has a different
> > behavior in terms of migration and ownership checking. I guess SEV key
> > IDs are not tied to a process whereas IOASIDs are. Perhaps this can be
> > solved by adding
> > +	.can_attach	= ioasids_can_attach,
> > +	.cancel_attach	= ioasids_cancel_attach,
> > Let me give it a try and come back.
> > 
> While I am trying to fit the IOASIDs cgroup in to the misc cgroup proposal.
> I'd like to have a direction check on whether this idea of using cgroup for
> IOASID/PASID resource management is viable.
> 
> Alex/Jason/Jean and everyone, your feedback is much appreciated.

IMHO I can't think of anything else to enforce some limit on a HW
scarce resource that unpriv userspace can consume.

Jason
