From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 1 Apr 2021 10:15:33 -0300
Message-ID: <20210401131533.GD1463678@nvidia.com>
References: <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB188639EE54B48B0E1321C8198C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
 <20210330132830.GO2356281@nvidia.com>
 <BN6PR11MB40688F5AA2323AB8CC8E65E7C37C9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210331124038.GE1463678@nvidia.com>
 <BN6PR11MB406854CAE9D7CE86BEAB3E23C37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
 <20210401114648.GX1463678@nvidia.com>
 <BN6PR11MB406858FAC3821B84CCC4D30DC37B9@BN6PR11MB4068.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zTePrFjo+hnvFWhbhxOpSCw1Wyy/aCiDz8Wsh4y/Zfo=;
 b=qDLG9IShNI4x4anKv4nPoRYigkOuei1OsTIg3i0FH4ltnvmUEWmnpImwFSgoaY0AN2oHJpUvJTsqhyJn1eNAtNufJ9rW3ubNn94UkpeQXUVwVE9uyaZbd+AESba7MCk7EUaQmND94Yxokd/ua+mb4SseuBi4eBlikfrRvQEptWh9dgnrObf0/wxzScVSLjJ4OtzUQo27H30I1pu21iOhTFAgTfapjr5YGSVoRHHEqmi0SK8Jpj0jprSXJAlrorZEtp69LvqLjEFGSnEQmbYuewZtIYBCLoB6MjiDUuAqpjV3KXVUTt5w6JCWQIlneqmnDM9P6Wy9Ca92gja3F/E5CA==
Content-Disposition: inline
In-Reply-To: <BN6PR11MB406858FAC3821B84CCC4D30DC37B9-1gF2/dm/6VuPGwkGT4HjsJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
To: "Liu, Yi L" <yi.l.liu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "Tian,
 Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj, Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Thu, Apr 01, 2021 at 01:10:48PM +0000, Liu, Yi L wrote:
> > From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > Sent: Thursday, April 1, 2021 7:47 PM
> [...]
> > I'm worried Intel views the only use of PASID in a guest is with
> > ENQCMD, but that is not consistent with the industry. We need to see
> > normal nested PASID support with assigned PCI VFs.
> 
> I'm not quire flow here. Intel also allows PASID usage in guest without
> ENQCMD. e.g. Passthru a PF to guest, and use PASID on it without ENQCMD.

Then you need all the parts, the hypervisor calls from the vIOMMU, and
you can't really use a vPASID.

I'm not sure how Intel intends to resolve all of this.

> > > - this per-ioasid SVA operations is not aligned with the native SVA usage
> > >   model. Native SVA bind is per-device.
> > 
> > Seems like that is an error in native SVA.
> > 
> > SVA is a particular mode of the PASID's memory mapping table, it has
> > nothing to do with a device.
> 
> I think it still has relationship with device. This is determined by the
> DMA remapping hierarchy in hardware. e.g. Intel VT-d, the DMA isolation is
> enforced first in device granularity and then PASID granularity. SVA makes
> usage of both PASID and device granularity isolation.

When the device driver authorizes a PASID the VT-d stuff should setup
the isolation parameters for the give pci_device and PASID.

Do not leak implementation details like this as uAPI. Authorization
and memory map are distinct ideas with distinct interfaces. Do not mix
them.

Jason
