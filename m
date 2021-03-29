From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 29 Mar 2021 13:31:47 -0300
Message-ID: <20210329163147.GG2356281@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-6-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a9aEK6B+3YyO5OqaUbIleKWQnFZ2YkAV6AxJ0q5vvnY=;
 b=ig2oCuU0YoeT8AMc4uQ3O8ZJsVtUGMboBU7t+iCo8mleLVT/mMEVGKU7UWwJg4UqUEOo5td/f7o+vQRgbQEzibO39txsYeYwDAWUwJSfJLtFESYZqtNONznjsTDuvt1pVCoP/8bcy1IMMkuYw2dbKtD9ZDlVVLtktSEDMT5rsXXQYSA4GslGqjXtE/DcgzkYQrVoXRFr8UGbUOP9Mur0qxRCrw9EJSyhA2DQuG15tql1sMwsagY3YGNKxyl2bH2sTA2/WkFYJ93IfazQExIKAvLi7YaH6kqXW98R4aaDKHE/8XBh3ZOZS7VPd6q5GAeetlwn2gWy0JMUj3eMjGUhdQ==
Content-Disposition: inline
In-Reply-To: <20210324120528.24d82dbd@jacob-builder>
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
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Mar 24, 2021 at 12:05:28PM -0700, Jacob Pan wrote:

> > IMHO a use created PASID is either bound to a mm (current) at creation
> > time, or it will never be bound to a mm and its page table is under
> > user control via /dev/ioasid.
> > 
> True for PASID used in native SVA bind. But for binding with a guest mm,
> PASID is allocated first (VT-d virtual cmd interface Spec 10.4.44), the
> bind with the host IOMMU when vIOMMU PASID cache is invalidated.
> 
> Our intention is to have two separate interfaces:
> 1. /dev/ioasid (allocation/free only)
> 2. /dev/sva (handles all SVA related activities including page tables)

I'm not sure I understand why you'd want to have two things. Doesn't
that just complicate everything?

Manipulating the ioasid, including filling it with page tables, seems
an integral inseperable part of the whole interface. Why have two ?

> > I thought the whole point of something like a /dev/ioasid was to get
> > away from each and every device creating its own PASID interface?
> > 
> yes, but only for the use cases that need to expose PASID to the
> userspace.

Why "but only"? This thing should reach for a higher generality, not
just be contained to solve some problem within qemu.

> > It maybe somewhat reasonable that some devices could have some easy
> > 'make a SVA PASID on current' interface built in,
> I agree, this is the case PASID is hidden from the userspace, right? e.g.
> uacce.

"hidden", I guess, but does it matter so much?

The PASID would still consume a cgroup credit

> > but anything more
> > complicated should use /dev/ioasid, and anything consuming PASID
> > should also have an API to import and attach a PASID from /dev/ioasid.
> > 
> Would the above two use cases constitute the "complicated" criteria? Or we
> should say anything that need the explicit PASID value has to through
> /dev/ioasid?

Anything that needs more that creating a hidden PASID link'd to
current should use the full interface.

> In terms of usage for guest SVA, an ioasid_set is mostly tied to a host mm,
> the use case is as the following:

From that doc:

  It is imperative to enforce
  VM-IOASID ownership such that a malicious guest cannot target DMA
  traffic outside its own IOASIDs, or free an active IOASID that belongs
  to another VM.

Huh?

Security in a PASID world comes from the IOMMU blocking access to the
PASID except from approved PCI-ID's. If a VF/PF is assigned to a guest
then that guest can cause the device to issue any PASID by having
complete control and the vIOMMU is supposed to tell the real IOMMU
what PASID's the device is alowed to access.

If a device is sharing a single PCI function with different security
contexts (eg vfio mdev) then the device itself is responsible to
ensure that only the secure interface can program a PASID and a less
secure context can never self-enroll. 

Here the mdev driver would have to consule with the vIOMMU to ensure
the mdev device is allowed to access the PASID - is that what this
set stuff is about? 

If yes, it is backwards. The MDEV is the thing doing the security, the
MDEV should have the list of allowed PASID's and a single PASID
created under /dev/ioasid should be loaded into MDEV with some 'Ok you
can use PASID xyz from FD abc' command.

Because you absolutely don't want to have a generic 'set' that all the
mdevs are sharing as that violates the basic security principle at the
start - each and every device must have a unique list of what PASID's
it can talk to.

> 1. Identify a pool of PASIDs for permission checking (below to the same VM),
> e.g. only allow SVA binding for PASIDs allocated from the same set.
> 
> 2. Allow different PASID-aware kernel subsystems to associate, e.g. KVM,
> device drivers, and IOMMU driver. i.e. each KVM instance only cares about
> the ioasid_set associated with the VM. Events notifications are also within
> the ioasid_set to synchronize PASID states.
> 
> 3. Guest-Host PASID look up (each set has its own XArray to store the
> mapping)
> 
> 4. Quota control (going away once we have cgroup)

It sounds worrysome things have gone this way.

I'd say you shoul have a single /dev/ioasid per VM and KVM should
attach to that - it should get all the global events/etc that are not
device specific.

permission checking *must* be done on a per-device level, either inside the
mdev driver, or inside the IOMMU at a per-PCI device level.

Not sure what guest-host PASID means, these have to be 1:1 for device
assignment to work - why would use something else for mdev?

Jason
