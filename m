From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Tue, 30 Mar 2021 15:42:24 +0200
Message-ID: <YGMqwPnYjSfV+Cbr@myrica>
References: <20210319112221.5123b984@jacob-builder> <YFhiMLR35WWMW/Hu@myrica>
 <20210324100246.4e6b8aa1@jacob-builder>
 <20210324170338.GM2356281@nvidia.com>
 <20210324151230.466fd47a@jacob-builder> <YFxkNEz3THJKzW0b@myrica>
 <20210325100236.17241a1c@jacob-builder>
 <20210325171645.GF2356281@nvidia.com> <YF2WEmfXsXKCkCDb@myrica>
 <20210330130755.GN2356281@nvidia.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=pnUANKY68LFCHKnXAlNl92vZ5QNwZhc3rycWb9aJ4U4=;
 b=cXrleCcTe2edFKE7JXHrs9Bj1XROOQncYe9/RXuKuyYfg1oiY9hkloCupeUygrymIP
 9ayZSOUA/kzg9omudYLIbfliaSwzsF8t2WjsUk7aasxaQAZ65kiYcqVsJssvwnbqXWaQ
 7tP999kzGqM64anG+FHHGrYwPo3CD/MmoJSW67AsljQ3h4bpd7h5J0oHBBrJFcYhNPQZ
 jSvprN5HGew9kx/NPjUMKVuGbUtOweyWIunsFY/SwCVoa+64VGBhAnUWkD+o4ORO7eF3
 KDrvwGNAF2EaQH0lzuiBF6N51eP9jHBLGYuCYZ1yO4oXRNlIuT6R6Tj2RPOAmd0YGpIB
 8yZw==
Content-Disposition: inline
In-Reply-To: <20210330130755.GN2356281-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
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
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Tue, Mar 30, 2021 at 10:07:55AM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 26, 2021 at 09:06:42AM +0100, Jean-Philippe Brucker wrote:
> 
> > It's not inconceivable to have a control queue doing DMA tagged with
> > PASID. The devices I know either use untagged DMA, or have a choice to use
> > a PASID.
> 
> I don't think we should encourage that. A PASID and all the related is
> so expensive compared to just doing normal untagged kernel DMA.

How is it expensive?  Low number of PASIDs, or slowing down DMA
transactions?  PASIDs aren't a scarce resource on Arm systems, they have
almost 1M unused PASIDs per VM.

Thanks,
Jean

> I assume HW has these features because virtualization use cases might
> use them, eg by using mdev to assign a command queue - then it would
> need be be contained by a PASID.
> 
> Jason
