From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Wed, 24 Mar 2021 14:03:38 -0300
Message-ID: <20210324170338.GM2356281@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-6-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder> <YFhiMLR35WWMW/Hu@myrica>
 <20210324100246.4e6b8aa1@jacob-builder>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uzr+K3BRDxSN1riRVVfJ2WL/Ho0CU52QiKj0ERMcv9w=;
 b=sDdOckxwkgSHEz6mRMpkT1XRJw4UZByb2yMGmmn4/mUdLEWzt6FfXd/XnRtMqUtkaTLKPdUxTlqu6yB2a/aYctAamkuBn6JUwz9E9YTzmKN2go+YJ/0aZ+qNjPn1rI79l+w3U4BMQlnyK4SmTj8991e0N/PdYMNS0eofgfhUlyGlqOc+2D6fvTZDl2rm2HhjPkLFrLteNnUAakll6PnhqQxKbVNViHJW8rybDLjmcFSSrcoSOt83o74J5iHWrYM2kwYprSKLW73S3bkkatns53VHK3X2JkoiYknLpFQ7oT0SNYkDCFq6XzfuFBge9O0FxhxN7TaZWHVMEf3xaHtT0g==
Content-Disposition: inline
In-Reply-To: <20210324100246.4e6b8aa1@jacob-builder>
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

On Wed, Mar 24, 2021 at 10:02:46AM -0700, Jacob Pan wrote:
> > Also wondering about device driver allocating auxiliary domains for their
> > private use, to do iommu_map/unmap on private PASIDs (a clean replacement
> > to super SVA, for example). Would that go through the same path as
> > /dev/ioasid and use the cgroup of current task?
>
> For the in-kernel private use, I don't think we should restrict based on
> cgroup, since there is no affinity to user processes. I also think the
> PASID allocation should just use kernel API instead of /dev/ioasid. Why
> would user space need to know the actual PASID # for device private domains?
> Maybe I missed your idea?

There is not much in the kernel that isn't triggered by a process, I
would be careful about the idea that there is a class of users that
can consume a cgroup controlled resource without being inside the
cgroup.

We've got into trouble before overlooking this and with something
greenfield like PASID it would be best built in to the API to prevent
a mistake. eg accepting a cgroup or process input to the allocator.

Jason
