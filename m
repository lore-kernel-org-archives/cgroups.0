From: Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Fri, 19 Mar 2021 10:54:32 -0300
Message-ID: <20210319135432.GT2356281@nvidia.com>
References: <1614463286-97618-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1614463286-97618-6-git-send-email-jacob.jun.pan@linux.intel.com>
 <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M7ic/wgCgBjj+2SlGjLvj6N7uWWIpxlyndm1A+f5tMY=;
 b=emfT0d1/R6izUpprunoWVFojbrjhKKwsFt3ynJeD5bxS7DWtdpWxlSRFcT4CXW7uDBxtdGCPg3MTz0ZRhhzx2kBPbaM+otRcX0wi2t4L9UcMj+jzIabTlUmmfOlRCz+Aw+ZbChZl7dZ5goGoUULJaVDtvZywMnC9TwoVSB6aGxh8ueBdpBw64a3za0K/8+QrXTacEXfRhpl06+6hT+NBhnfCdUXSCecQkqDV6qQ/45hJ/9P+CbovepwE80+eXbvrBn48NIAOBAPd+ex1cCl3qAKAntOxJxfejxm7zWUPRqQhYTKek20Qt0PsWnx7+iXYpEyOxOV2aa7QOtrQPFAHFw==
Content-Disposition: inline
In-Reply-To: <YFSqDNJ5yagk4eO+@myrica>
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

On Fri, Mar 19, 2021 at 02:41:32PM +0100, Jean-Philippe Brucker wrote:
> On Fri, Mar 19, 2021 at 09:46:45AM -0300, Jason Gunthorpe wrote:
> > On Fri, Mar 19, 2021 at 10:58:41AM +0100, Jean-Philippe Brucker wrote:
> > 
> > > Although there is no use for it at the moment (only two upstream users and
> > > it looks like amdkfd always uses current too), I quite like the
> > > client-server model where the privileged process does bind() and programs
> > > the hardware queue on behalf of the client process.
> > 
> > This creates a lot complexity, how do does process A get a secure
> > reference to B? How does it access the memory in B to setup the HW?
> 
> mm_access() for example, and passing addresses via IPC

I'd rather the source process establish its own PASID and then pass
the rights to use it to some other process via FD passing than try to
go the other way. There are lots of security questions with something
like mm_access.

Jason
