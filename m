From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 28 Apr 2021 11:56:22 -0300
Message-ID: <20210428145622.GU1370958@nvidia.com>
References: <20210421230301.GP1370958@nvidia.com>
 <20210422111337.6ac3624d@redhat.com>
 <20210422175715.GA1370958@nvidia.com>
 <20210422133747.23322269@redhat.com>
 <20210422200024.GC1370958@nvidia.com>
 <20210422163808.2d173225@redhat.com>
 <20210422233950.GD1370958@nvidia.com>
 <YIecXkaEGNgICePO@yekko.fritz.box>
 <20210427171212.GD1370958@nvidia.com>
 <YIizNdbA0+LYwQbI@yekko.fritz.box>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Atv8M8kVZhsk3nYMhAsMvAQazJTo6Tns2amFmaSapZ0=;
 b=A/0VpExIoyr+jBLACPdweT58nFKWc4oZYep2ATmF/NRkZa3xILBtxY8dHEOhRdt8LrFuI2FvaTFMr9MJdnCioAmYfmtyAdqJwq8zG4WtmStfsN5XaFsO20k7AMEEFBpXBbY/7Zx7cY7TkLIfjPEDtbDNG5B5YqfkO/87ng4xLkj1XcdXoqQcT8OB0UudahhyXxN4gSXPQnsasjbe13KCbqOSB2i8OXIgxkzv1P5Kcrg+Ze/Q3qg2pJJsN3e46TeyLoLpobE6nNyizbU+IRX84hAHUkn1eUrYLsNuhd1876Lxgpix9JHcy3L3GM3tMpjVcPyKm9zawKTwUK+dnDlreQ==
Content-Disposition: inline
In-Reply-To: <YIizNdbA0+LYwQbI-l+x2Y8Cxqc4e6aEkudXLsA@public.gmane.org>
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
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu,
 Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Apr 28, 2021 at 10:58:29AM +1000, David Gibson wrote:
> On Tue, Apr 27, 2021 at 02:12:12PM -0300, Jason Gunthorpe wrote:
> > On Tue, Apr 27, 2021 at 03:08:46PM +1000, David Gibson wrote:
> > > > Starting from a BDF the general pseudo code is:
> > > >  device_name = first_directory_of("/sys/bus/pci/devices/BDF/vfio/")
> > > >  device_fd = open("/dev/vfio/"+device_name)
> > > >  ioasidfd = open("/dev/ioasid")
> > > >  ioctl(device_fd, JOIN_IOASID_FD, ioasidfd)
> > > 
> > > This line is the problem.
> > > 
> > > [Historical aside: Alex's early drafts for the VFIO interface looked
> > > quite similar to this.  Ben Herrenschmidt and myself persuaded him it
> > > was a bad idea, and groups were developed instead.  I still think it's
> > > a bad idea, and not just for POWER]
> > 
> > Spawning the VFIO device FD from the group FD is incredibly gross from
> > a kernel design perspective. Since that was done the struct
> > vfio_device missed out on a sysfs presence and doesn't have the
> > typical 'struct device' member or dedicated char device you'd expect a
> > FD based subsystem to have.
> > 
> > This basically traded normal usage of the driver core for something
> > that doesn't serve a technical usage. Given we are now nearly 10 years
> > later and see that real widely deployed applications are not doing
> > anything special with the group FD it makes me question the wisdom of
> > this choice.
> 
> I'm really not sure what "anything special" would constitute here.

Well, really anything actually. All I see in, say, dpdk, is open the
group fd, get a device fd, do the container dance and never touch the
group fd again or care about groups in any way. It seems typical of
this class of application.

If dpdk is exposing other devices to a risk it certainly hasn't done
anything to make that obvious.

> > Okay, that is fair, but let's solve that problem directly. For
> > instance netlink has been going in the direction of adding a "extack"
> > from the kernel which is a descriptive error string. If the failing
> > ioctl returned the string:
> > 
> >   "cannot join this device to the IOASID because device XXX in the
> >    same group #10 is in use"
> 
> Um.. is there a sane way to return strings from an ioctl()?

Yes, it can be done, a string buffer pointer and length in the input
for instance.

> Getting the device fds from the group fd kind of follows, because it's
> unsafe to do basically anything on the device unless you already
> control the group (which in this case means attaching it to a
> container/ioasid).  I'm entirely open to ways of doing that that are
> less inelegant from a sysfs integration point of view, but the point
> is you must manage the group before you can do anything at all with
> individual devices.

I think most likely VFIO is going to be the only thing to manage a
multi-device group.

I see things like VDPA being primarily about PASID, and an IOASID that
is matched to a PASID is inherently a single device IOMMU group.

> I don't see why.  I mean, sure, you don't want explicitly the *vfio*
> group as such.  But IOMMU group is already a cross-subsystem concept
> and you can explicitly expose that in a different way.

Yes, and no, the kernel drivers in something like VDPA have decided
what device and group they are in before we get to IOASID. It is
illogical to try to retro-actively bolt in a group concept to their
APIs.
 
> Again, I realy think this is necessary complexity.  You're right that
> far too little of the userspace properly understands group
> restrictions.. but these come from real hardware limitations, and I
> don't feel like making it *less* obvious in the interface is going to
> help that.

The appeal of making it less obvious is we can have a single
simplified API flow so that an application that doesn't understand or
care about groups can have uniformity.

Jason
