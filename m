From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 8 Jun 2021 15:34:09 -0300
Message-ID: <20210608183409.GL1002214@nvidia.com>
References: <20210513135938.GG1002214@nvidia.com> <YKtbWo7PwIlXjFIV@yekko>
 <20210524233744.GT1002214@nvidia.com>
 <ce2fcf21-1803-047b-03f0-7a4108dea7af@nvidia.com>
 <20210525195257.GG1002214@nvidia.com> <YK8m9jNuvEzlXWlu@yekko>
 <20210527184847.GI1002214@nvidia.com> <YLWxlZC4AXJPOngB@yekko>
 <20210601125712.GA4157739@nvidia.com> <YL69b0UuDm72QbDO@yekko>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=q3usotIniC0C7CyC1ncqRPWaIZKf+w7Z7CRDIonHkg8=;
 b=Uj163r9/fXqFUVG7mH0af1V82npGHw87QLaudYqp5LVp2KHOkUn823pV16BfvbNO9chauG06/DN6M80lJZzaDNeSSJsa82NtlEVfJNliRLiTtOB23+MAY6Eun++Twt6fGfrISxJ3YOALl9qm4g4SIivqbCbaOLkGa1dxHsOjteAKx8AG/md6h6q6y50hTevCUioIYLATHrBZyLPkxTm+ec7ihzWrgc3Mgd/m1FekFG0jMNKOkgi/+4tmnUl1o+bpAda6/40v4r+Cki9WaXzmPGZZbaZDr8V2XTfkcy4BGtBL+D6ROTSHiDWwpJ/XfuCasBRzKf6hiyrm838v8qecsA==
Content-Disposition: inline
In-Reply-To: <YL69b0UuDm72QbDO@yekko>
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

On Tue, Jun 08, 2021 at 10:44:31AM +1000, David Gibson wrote:

> When you say "not using a drivers/iommu IOMMU interface" do you
> basically mean the device doesn't do DMA? 

No, I mean the device doesn't use iommu_map() to manage the DMA
mappings.

vfio_iommu_type1 has a special code path that mdev triggers that
doesn't allocate an IOMMU domain and doesn't call iommu_map() or
anything related to that.

Instead a mdev driver calls vfio_pin_pages() which "reads" a fake page
table and returns back the CPU pages for the mdev to DMA map however
it likes.

> Now, we could represent those different sorts of isolation separately,
> but at the time our thinking was that we should group together devices
> that can't be safely isolated for *any* reason, since the practical
> upshot is the same: you can't safely split those devices between
> different owners.

It is fine, but the direction is going the other way, devices have
perfect ioslation and rely on special interactions with the iommu to
get it.
 
> > What I don't like is forcing certain things depending on how the
> > vfio_device was created - for instance forcing a IOMMU group as part
> > and forcing an ugly "SW IOMMU" mode in the container only as part of
> > mdev_device.
> 
> I don't really see how this is depending on how the device is
> created.

static int vfio_iommu_type1_attach_group(void *iommu_data,
					 struct iommu_group
					 *iommu_group)
{
	if (vfio_bus_is_mdev(bus)) {

What the iommu code does depends on how the device was created. This
is really ugly.

This is happening becaus the three objects in the model:
driver/group/domain are not being linked together in a way that
reflects the modern world.

The group has no idea what the driver wants but is in charge of
creating the domain on behalf of the device.

And so people have been created complicated hackery to pass
information from the driver to the group, through the device, so that
the group can create the right domain.

I want to see the driver simply create the right domain directly. It
is much simpler and scales to more domain complexity.

Jason
