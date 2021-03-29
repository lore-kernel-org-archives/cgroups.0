From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Mon, 29 Mar 2021 15:55:26 -0700
Message-ID: <20210329155526.2ad791a9@jacob-builder>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-6-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20210329163147.GG2356281-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jason,

On Mon, 29 Mar 2021 13:31:47 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:

> On Wed, Mar 24, 2021 at 12:05:28PM -0700, Jacob Pan wrote:
> 
> > > IMHO a use created PASID is either bound to a mm (current) at creation
> > > time, or it will never be bound to a mm and its page table is under
> > > user control via /dev/ioasid.
> > >   
> > True for PASID used in native SVA bind. But for binding with a guest mm,
> > PASID is allocated first (VT-d virtual cmd interface Spec 10.4.44), the
> > bind with the host IOMMU when vIOMMU PASID cache is invalidated.
> > 
> > Our intention is to have two separate interfaces:
> > 1. /dev/ioasid (allocation/free only)
> > 2. /dev/sva (handles all SVA related activities including page tables)  
> 
> I'm not sure I understand why you'd want to have two things. Doesn't
> that just complicate everything?
> 
> Manipulating the ioasid, including filling it with page tables, seems
> an integral inseperable part of the whole interface. Why have two ?
> 
In one of the earlier discussions, I was made aware of some use cases (by
AMD, iirc) where PASID can be used w/o IOMMU. That is why I tried to keep
ioasid a separate subsystem. Other than that, I don't see an issue
combining the two.

> > > I thought the whole point of something like a /dev/ioasid was to get
> > > away from each and every device creating its own PASID interface?
> > >   
> > yes, but only for the use cases that need to expose PASID to the
> > userspace.  
> 
> Why "but only"? This thing should reach for a higher generality, not
> just be contained to solve some problem within qemu.
> 
I totally agree in terms of generality. I was just trying to point out
existing framework or drivers such as uacce and idxd driver does not have a
need to use /dev/ioasid.

> > > It maybe somewhat reasonable that some devices could have some easy
> > > 'make a SVA PASID on current' interface built in,  
> > I agree, this is the case PASID is hidden from the userspace, right?
> > e.g. uacce.  
> 
> "hidden", I guess, but does it matter so much?
> 
it matters when it comes to which interface to choose. Use /dev/ioasid to
allocate if PASID value cannot be hidden. Use some other interface for bind
current and allocate if a PASID is not visible to the user.

> The PASID would still consume a cgroup credit
> 
yes, credit still consumed. Just the PASID value is hidden.

> > > but anything more
> > > complicated should use /dev/ioasid, and anything consuming PASID
> > > should also have an API to import and attach a PASID from /dev/ioasid.
> > >   
> > Would the above two use cases constitute the "complicated" criteria? Or
> > we should say anything that need the explicit PASID value has to through
> > /dev/ioasid?  
> 
> Anything that needs more that creating a hidden PASID link'd to
> current should use the full interface.
> 
Yes, I think we are on the same page. For example, today's uacce or idxd
driver creates a hidden PASID when user does open(), where a new WQ is
provisioned and bound to current mm. This is the case where /dev/ioasid is
not needed.

> > In terms of usage for guest SVA, an ioasid_set is mostly tied to a host
> > mm, the use case is as the following:  
> 
> From that doc:
> 
>   It is imperative to enforce
>   VM-IOASID ownership such that a malicious guest cannot target DMA
>   traffic outside its own IOASIDs, or free an active IOASID that belongs
>   to another VM.
> 
> Huh?
> 
Sorry, I am not following. In the doc, I have an example to show the
ioasid_set to VM/mm mapping. We use mm as the ioasid_set token to identify
who the owner of an IOASID is. i.e. who allocated the IOASID. Non-owner
cannot perform bind page table or free operations.

Section: IOASID Set Private ID (SPID)
 .------------------.    .------------------.
 |   VM 1           |    |   VM 2           |
 |                  |    |                  |
 |------------------|    |------------------|
 | GPASID/SPID 101  |    | GPASID/SPID 101  |
 '------------------'    -------------------'     Guest
 __________|______________________|____________________
           |                      |               Host
           v                      v
 .------------------.    .------------------.
 | Host IOASID 201  |    | Host IOASID 202  |
 '------------------'    '------------------'
 |   IOASID set 1   |    |   IOASID set 2   |
 '------------------'    '------------------'


> Security in a PASID world comes from the IOMMU blocking access to the
> PASID except from approved PCI-ID's. If a VF/PF is assigned to a guest
> then that guest can cause the device to issue any PASID by having
> complete control and the vIOMMU is supposed to tell the real IOMMU
> what PASID's the device is alowed to access.
> 
Yes, each PF/VF has its own PASID table. The device can do whatever
it wants as long as the PASID is present in the table. Programming of the
pIOMMU PASID table entry, however, is controlled by the host.

IMHO, there are two levels of security here:
1. A PASID can only be used by a secure context
2. A device can only use allowed PASIDs (PASID namespace is system-wide but
PASID table storage is per PF/VF)

IOASID set is designed for #1.

> If a device is sharing a single PCI function with different security
> contexts (eg vfio mdev) then the device itself is responsible to
> ensure that only the secure interface can program a PASID and a less
> secure context can never self-enroll. 
> 
If two mdevs from the same PF dev are assigned to two VMs, the PASID
table will be shared. IOASID set ensures one VM cannot program another VM's
PASIDs. I assume 'secure context' is per VM when it comes to host PASID.

> Here the mdev driver would have to consule with the vIOMMU to ensure
> the mdev device is allowed to access the PASID - is that what this
> set stuff is about? 
> 
No. the mdev driver consults with IOASID core When the guest programs a
guest PASID on to he mdev. VDCM driver does a lookup:
host_pasid = ioasid_find_by_spid(ioasid_set, guest_pasid);

If the guest_pasid does not exist in the ioasid_set, the mdev programming
fails; if the guest_pasid does exist but it maps to a wrong host PASID, the
damage is limited to the guest itself.

> If yes, it is backwards. The MDEV is the thing doing the security, the
> MDEV should have the list of allowed PASID's and a single PASID
> created under /dev/ioasid should be loaded into MDEV with some 'Ok you
> can use PASID xyz from FD abc' command.
> 
I guess that is not the case. For VT-d dedicated WQ, there is only one
PASID can be programmed onto the device. Programming the PASID with
/dev/sva FD abc command will be checked against its mm where /dev/ioasid is
used to do the allocation.

For a single shared WQ assigned to multiple VMs, there will be one mdev per
VM. Again, FD commands is limited to the PASIDs allocated for the VM.

For a single share WQ assigned to one VM, it can be bound to multiple guest
processes/PASIDs. Host IOMMU driver maintains a list of the PASIDs and
ensures that they are only programmed on to the per device PASID table.

> Because you absolutely don't want to have a generic 'set' that all the
> mdevs are sharing as that violates the basic security principle at the
> start - each and every device must have a unique list of what PASID's
> it can talk to.
> 
I agree, I don't think this is the case. The ioasid_set is some what
orthogonal to mdev collections.

> > 1. Identify a pool of PASIDs for permission checking (below to the same
> > VM), e.g. only allow SVA binding for PASIDs allocated from the same set.
> > 
> > 2. Allow different PASID-aware kernel subsystems to associate, e.g. KVM,
> > device drivers, and IOMMU driver. i.e. each KVM instance only cares
> > about the ioasid_set associated with the VM. Events notifications are
> > also within the ioasid_set to synchronize PASID states.
> > 
> > 3. Guest-Host PASID look up (each set has its own XArray to store the
> > mapping)
> > 
> > 4. Quota control (going away once we have cgroup)  
> 
> It sounds worrysome things have gone this way.
> 
Could you expand on that? Guaranteeing quota is very difficult. cgroup
limit model fits most scalar resources.

> I'd say you shoul have a single /dev/ioasid per VM and KVM should
> attach to that - it should get all the global events/etc that are not
> device specific.
> 
You mean a single /dev/ioasid FD per VM and KVM? I think that is what we
are doing in this set. A VM process can only open /dev/ioasid once, then
use the FD for allocation and pass the PASID for bind page table etc.

> permission checking *must* be done on a per-device level, either inside
> the mdev driver, or inside the IOMMU at a per-PCI device level.
> 
I think we are on the same page. For mdev, VDCM driver makes sure the guest
PASID programmed is allocated by the same VM that also performed the bind SVA.

For PF/VF which is not mediated, the permission is implied by the IOMMU
driver/HW since PASID table is per device.

> Not sure what guest-host PASID means, these have to be 1:1 for device
> assignment to work - why would use something else for mdev?
> 
We have G-H PASID translation. They don't have to be 1:1.
IOASID Set Private ID (SPID) is intended as a generic solution for guest PASID.
Could you review the secion Section: IOASID Set Private ID (SPID) in the
doc patch?

We also had some slides from last year. Slide 3s-6 mostly.
https://static.sched.com/hosted_files/kvmforum2020/9f/KVM_forum_2020_PASID_MGMT_Yi_Jacob_final.pdf

Really appreciated your time!


Jacob
