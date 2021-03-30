From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 30 Mar 2021 10:46:21 -0300
Message-ID: <20210330134621.GQ2356281@nvidia.com>
References: <YFhiMLR35WWMW/Hu@myrica> <20210324100246.4e6b8aa1@jacob-builder>
 <20210324170338.GM2356281@nvidia.com>
 <20210324151230.466fd47a@jacob-builder> <YFxkNEz3THJKzW0b@myrica>
 <20210325100236.17241a1c@jacob-builder>
 <20210325171645.GF2356281@nvidia.com> <YF2WEmfXsXKCkCDb@myrica>
 <20210330130755.GN2356281@nvidia.com> <YGMqwPnYjSfV+Cbr@myrica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GzICrweByfFjw+vWK2FIyaa44HA54eR0gh4sxM92Dz4=;
 b=bq1fFYPuF2Wy8rYG23wbY9SJxFsJKwYasqjmV9GaZOHInfhZOBWc0zUVXBMsdpjdEh9RGRuLknm8D4yBGs3XxF9+pO5hefkwzu6QNpWqcrn1wDIh+MIfM8M5nHdBKdt21lSLjMadKl0XSYieHb3M32w9B1la4drhBfHlD8QJ9KBUsD7fkmOjlq9LfEfxZzus3NmaAdLE8t+6M+tbZmGvqRhgVWgKNU9ueiZHJ2BXDwIiAQgcYwNKoFFeoPdaPBN3qgsdHURfBoeCbjLNgUmwfL3vrwBcDExCrz7NzkinasXupLsJgDOPbtam8QgJF/f8Z7XPbJ+VUrXEja0XZ9SQrw==
Content-Disposition: inline
In-Reply-To: <YGMqwPnYjSfV+Cbr@myrica>
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
To: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 30, 2021 at 03:42:24PM +0200, Jean-Philippe Brucker wrote:
> On Tue, Mar 30, 2021 at 10:07:55AM -0300, Jason Gunthorpe wrote:
> > On Fri, Mar 26, 2021 at 09:06:42AM +0100, Jean-Philippe Brucker wrote:
> > 
> > > It's not inconceivable to have a control queue doing DMA tagged with
> > > PASID. The devices I know either use untagged DMA, or have a choice to use
> > > a PASID.
> > 
> > I don't think we should encourage that. A PASID and all the related is
> > so expensive compared to just doing normal untagged kernel DMA.
> 
> How is it expensive?  Low number of PASIDs, or slowing down DMA
> transactions?  PASIDs aren't a scarce resource on Arm systems, they have
> almost 1M unused PASIDs per VM.

There may be lots of PASIDs, but they are not without cost. The page
table behind them costs memory and cache occupancy, doing the lookups
hurts DMA performance.

Compare to a physical addressed kernel DMA (like x86 often sets up)
the runtime overheads from unnecessary PASID use is quite big.

Jason
