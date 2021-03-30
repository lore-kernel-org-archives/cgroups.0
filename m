From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 30 Mar 2021 10:27:40 -0300
Message-ID: <20210330132740.GB1403691@nvidia.com>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder>
 <20210322120300.GU2356281@nvidia.com>
 <20210324120528.24d82dbd@jacob-builder>
 <20210329163147.GG2356281@nvidia.com>
 <MWHPR11MB18867EC048E3E3FA37F9C38F8C7D9@MWHPR11MB1886.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l3G3sNaaTIF2ndmBFRetfRxBN8uTPCUmhpxZ/4yg7i4=;
 b=pyMitOg3Z6nVWFWVyCR0255dWUjhs18J7sxQLh9VxXOZO7rh+RpDJfQ+PkYTlUWA5kKviheCLbV37rL1t0DzM5lDzc5zJjqGoGeXdtnA6ESMCM6YynPJl6HQtFV2XLz35u65GnUWjLknhOnBOborDPUl/u3SL9/Bl61XLLTXNFOqXpxpJYZJnRz88IsznVT4rCNUUBR2gx9aVCplwpWtxcA7/HIssi+J1UYJbjMdXGvGhZaPVow3TlQuC3ipE0HtA00HIqyWJGdRe4118auD9PuAsAyYfQqIqwKjHmhXaN/Ejpu86ZaSgxDDz+X+6aK58GjAW66ogIRKw0lqXjznmQ==
Content-Disposition: inline
In-Reply-To: <MWHPR11MB18867EC048E3E3FA37F9C38F8C7D9-4Pk8um7sDhPjKiA5vsxACZPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
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
To: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Raj,
 Ashok" <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Jiang, Dave" <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org" <iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Wu, Hao" <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 30, 2021 at 04:14:58AM +0000, Tian, Kevin wrote:

> One correction. The mdev should still construct the list of allowed PASID's as
> you said (by listening to IOASID_BIND/UNBIND event), in addition to the ioasid 
> set maintained per VM (updated when a PASID is allocated/freed). The per-VM
> set is required for inter-VM isolation (verified when a pgtable is bound to the 
> mdev/PASID), while the mdev's own list is necessary for intra-VM isolation when 
> multiple mdevs are assigned to the same VM (verified before loading a PASID 
> to the mdev). This series just handles the general part i.e. per-VM ioasid set and 
> leaves the mdev's own list to be managed by specific mdev driver which listens
> to various IOASID events).

This is better, but I don't understand why we need such a convoluted
design.

Get rid of the ioasid set.

Each driver has its own list of allowed ioasids.

Register a ioasid in the driver's list by passing the fd and ioasid #

No listening to events. A simple understandable security model.

Look - it took you three emails to even correctly explain the security
model you are striving for here, it is *obviously* too complicated for
anyone to understand or successfully implement. simplify smiplify
simplify.

Jason
