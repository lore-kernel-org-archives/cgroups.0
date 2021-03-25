From: Jean-Philippe Brucker <jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 25 Mar 2021 11:21:40 +0100
Message-ID: <YFxkNEz3THJKzW0b@myrica>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder> <YFhiMLR35WWMW/Hu@myrica>
 <20210324100246.4e6b8aa1@jacob-builder>
 <20210324170338.GM2356281@nvidia.com>
 <20210324151230.466fd47a@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linaro.org; s=google;
 h=date:from:to:cc:subject:message-id:references:mime-version
 :content-disposition:in-reply-to;
 bh=2bl+T//9tmIfvggnKu8W5/72RtiA3Lc/gNcBZ4TaNT0=;
 b=HDBMmQHjxhDfBDa8NUpbssXQOf02VdhzwNOvL6z/sjlS/ob6nTDjDFdk7Rx19nR1hs
 SQS1m7CNqJDQUJQrPvFOlRsKplOR4HvnzIgwuwJzay62ap35JEwN/qhpACoPzMAWxfWI
 XO4MYnlDxfTay5ZNPPLBaE8XvkwnoB0y15l1GoemjCgivvxfYqd4SqDye10bL/U1sDgq
 2q58EeYToO3fsZktwBu5V51IOdt2ibMB1IaBNKKSb4cr+C+as3JCUfzbgdL92Xba3w9V
 ql45gXFLeCm10iNBjvSTa/BEbpZQtQ6N4qHGai0lWRLpSVaztsL2TRhlDZbX05OJR9Pk
 EKxw==
Content-Disposition: inline
In-Reply-To: <20210324151230.466fd47a@jacob-builder>
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
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Wed, Mar 24, 2021 at 03:12:30PM -0700, Jacob Pan wrote:
> Hi Jason,
> 
> On Wed, 24 Mar 2021 14:03:38 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org> wrote:
> 
> > On Wed, Mar 24, 2021 at 10:02:46AM -0700, Jacob Pan wrote:
> > > > Also wondering about device driver allocating auxiliary domains for
> > > > their private use, to do iommu_map/unmap on private PASIDs (a clean
> > > > replacement to super SVA, for example). Would that go through the
> > > > same path as /dev/ioasid and use the cgroup of current task?  
> > >
> > > For the in-kernel private use, I don't think we should restrict based on
> > > cgroup, since there is no affinity to user processes. I also think the
> > > PASID allocation should just use kernel API instead of /dev/ioasid. Why
> > > would user space need to know the actual PASID # for device private
> > > domains? Maybe I missed your idea?  
> > 
> > There is not much in the kernel that isn't triggered by a process, I
> > would be careful about the idea that there is a class of users that
> > can consume a cgroup controlled resource without being inside the
> > cgroup.
> > 
> > We've got into trouble before overlooking this and with something
> > greenfield like PASID it would be best built in to the API to prevent
> > a mistake. eg accepting a cgroup or process input to the allocator.
> > 
> Make sense. But I think we only allow charging the current cgroup, how about
> I add the following to ioasid_alloc():
> 
> 	misc_cg = get_current_misc_cg();
> 	ret = misc_cg_try_charge(MISC_CG_RES_IOASID, misc_cg, 1);
> 	if (ret) {
> 		put_misc_cg(misc_cg);
> 		return ret;
> 	}

Does that allow PASID allocation during driver probe, in kernel_init or
modprobe context?

Thanks,
Jean
