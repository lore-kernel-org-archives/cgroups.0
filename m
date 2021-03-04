From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [RFC PATCH 15/18] cgroup: Introduce ioasids controller
Date: Thu, 4 Mar 2021 13:28:09 -0800
Message-ID: <20210304132809.75b3fa55@jacob-builder>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-16-git-send-email-jacob.jun.pan@linux.intel.com>
 <YD+u3CXhwOi2LC+4@slm.duckdns.org>
 <20210303131726.7a8cb169@jacob-builder>
 <20210303160205.151d114e@jacob-builder> <YECtMZNqSgh7jkGP@myrica>
 <20210304094603.4ab6c1c4@jacob-builder>
 <20210304175402.GG4247@nvidia.com>
 <20210304110144.39ef0941@jacob-builder>
 <20210304190253.GL4247@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20210304190253.GL4247-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
To: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

On Thu, 4 Mar 2021 15:02:53 -0400, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> On Thu, Mar 04, 2021 at 11:01:44AM -0800, Jacob Pan wrote:
> 
> > > For something like qemu I'd expect to put the qemu process in a cgroup
> > > with 1 PASID. Who cares what qemu uses the PASID for, or how it was
> > > allocated?  
> > 
> > For vSVA, we will need one PASID per guest process. But that is up to
> > the admin based on whether or how many SVA capable devices are directly
> > assigned.  
> 
> I hope the virtual IOMMU driver can communicate the PASID limit and
> the cgroup machinery in the guest can know what the actual limit is.
> 
For VT-d, emulated vIOMMU can communicate with the guest IOMMU driver on how
many PASID bits are supported (extended cap reg PASID size fields). But it
cannot communicate how many PASIDs are in the pool(host cgroup capacity).

The QEMU process may not be the only one in a cgroup so it cannot give hard
guarantees. I don't see a good way to communicate accurately at runtime as
the process migrates or limit changes.

We were thinking to adopt the "Limits" model as defined in the cgroup-v2
doc.
"
Limits
------

A child can only consume upto the configured amount of the resource.
Limits can be over-committed - the sum of the limits of children can
exceed the amount of resource available to the parent.
"

So the guest cgroup would still think it has full 20 bits of PASID at its
disposal. But PASID allocation may fail before reaching the full 20 bits
(2M).
Similar on the host side, we only enforce the limit set by the cgroup but
not guarantee it.

> I was thinking of a case where qemu is using a single PASID to setup
> the guest kVA or similar
> 
got it.

> Jason


Thanks,

Jacob
