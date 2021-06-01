From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 1 Jun 2021 09:57:12 -0300
Message-ID: <20210601125712.GA4157739@nvidia.com>
References: <20210503161518.GM1370958@nvidia.com> <YJy9o8uEZs42/qDM@yekko>
 <20210513135938.GG1002214@nvidia.com> <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com> <YK8m9jNuvEzlXWlu@yekko>
 <20210527184847.GI1002214@nvidia.com> <YLWxlZC4AXJPOngB@yekko>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7gyZlwmlHYU/ZmUOvs3ehKHXbCDvmkOMT92IXgOjuI0=;
 b=EsSoLP4vmT+VbVjBbyAbsIPlGxQoQjktFVEadP3SD9bFG6jR/sdNZfPNmdr9bssK6kW1FYOfFBhDeQ+9ECvCjiNL5vNcM7aA0oelso6zG0Hkr2rkDYvn8vI0cpPjzTG4BGsZfbVqq+ijn4rZuzG6pLtldPzDvF0Jzb/P0XmKltmUqmZM1xNP+/lNseY+M9WIWDKdFuLBDdN5jul+hDbysqGEoH2lpgcr+HCwKViigqaF7nyaupKTIBIj1GUlrOFIWwAnIDgmDdvnGPt9wnOXVyoyh7pwKtaXQTTcTlU8x4J0JBgeY/w+WAvOKxRTdL7U9c0uwCtQg2YiZjwiqmryLA==
Content-Disposition: inline
In-Reply-To: <YLWxlZC4AXJPOngB@yekko>
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
To: David Gibson <david-xT8FGy+AXnRB3Ne2BGzF6laj5H9X9Tb+@public.gmane.org>
Cc: Kirti Wankhede <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Jiang,
 Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>

On Tue, Jun 01, 2021 at 02:03:33PM +1000, David Gibson wrote:
> On Thu, May 27, 2021 at 03:48:47PM -0300, Jason Gunthorpe wrote:
> > On Thu, May 27, 2021 at 02:58:30PM +1000, David Gibson wrote:
> > > On Tue, May 25, 2021 at 04:52:57PM -0300, Jason Gunthorpe wrote:
> > > > On Wed, May 26, 2021 at 12:56:30AM +0530, Kirti Wankhede wrote:
> > > > 
> > > > > 2. iommu backed mdev devices for SRIOV where mdev device is created per
> > > > > VF (mdev device == VF device) then that mdev device has same iommu
> > > > > protection scope as VF associated to it. 
> > > > 
> > > > This doesn't require, and certainly shouldn't create, a fake group.
> > > 
> > > It's only fake if you start with a narrow view of what a group is. 
> > 
> > A group is connected to drivers/iommu. A group object without *any*
> > relation to drivers/iommu is just a complete fiction, IMHO.
> 
> That might be where we differ.  As I've said, my group I'm primarily
> meaning the fundamental hardware unit of isolation.  *Usually* that's
> determined by the capabilities of an IOMMU, but in some cases it might
> not be.  In either case, the boundaries still matter.

As in my other email we absolutely need a group concept, it is just a
question of how the user API is designed around it.

> > The group mdev implicitly creates is just a fake proxy that comes
> > along with mdev API. It doesn't do anything and it doesn't mean
> > anything.
> 
> But.. the case of multiple mdevs managed by a single PCI device with
> an internal IOMMU also exists, and then the mdev groups are *not*
> proxies but true groups independent of the parent device.  Which means
> that the group structure of mdevs can vary, which is an argument *for*
> keeping it, not against.

If VFIO becomes more "vfio_device" centric then the vfio_device itself
has some properties. One of those can be "is it inside a drivers/iommu
group, or not?".

If the vfio_device is not using a drivers/iommu IOMMU interface then
it can just have no group at all - no reason to lie. This would mean
that the device has perfect isolation.

What I don't like is forcing certain things depending on how the
vfio_device was created - for instance forcing a IOMMU group as part
and forcing an ugly "SW IOMMU" mode in the container only as part of
mdev_device.

These should all be properties of the vfio_device itself.

Again this is all about the group fd - and how to fit in with the
/dev/ioasid proposal from Kevin:

https://lore.kernel.org/kvm/MWHPR11MB1886422D4839B372C6AB245F8C239-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org/

Focusing on vfio_device and skipping the group fd smooths out some
rough edges.

Code wise we are not quite there, but I have mapped out eliminating
the group from the vfio_device centric API and a few other places it
has crept in.

The group can exist in the background to enforce security without
being a cornerstone of the API design.

Jason
