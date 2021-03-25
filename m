From: Jacob Pan <jacob.jun.pan-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH V4 05/18] iommu/ioasid: Redefine IOASID set and
 allocation APIs
Date: Thu, 25 Mar 2021 10:02:36 -0700
Message-ID: <20210325100236.17241a1c@jacob-builder>
References: <20210318172234.3e8c34f7@jacob-builder> <YFR10eeDVf5ZHV5l@myrica>
 <20210319124645.GP2356281@nvidia.com> <YFSqDNJ5yagk4eO+@myrica>
 <20210319135432.GT2356281@nvidia.com>
 <20210319112221.5123b984@jacob-builder> <YFhiMLR35WWMW/Hu@myrica>
 <20210324100246.4e6b8aa1@jacob-builder>
 <20210324170338.GM2356281@nvidia.com>
 <20210324151230.466fd47a@jacob-builder> <YFxkNEz3THJKzW0b@myrica>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <YFxkNEz3THJKzW0b@myrica>
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
Cc: "Tian, Kevin" <kevin.tian-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Raj Ashok <ashok.raj-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Jean-Philippe Brucker <jean-philippe-68IGFXMjmZ7QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Dave Jiang <dave.jiang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wu Hao <hao.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Hi Jean-Philippe,

On Thu, 25 Mar 2021 11:21:40 +0100, Jean-Philippe Brucker
<jean-philippe-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:

> On Wed, Mar 24, 2021 at 03:12:30PM -0700, Jacob Pan wrote:
> > Hi Jason,
> > 
> > On Wed, 24 Mar 2021 14:03:38 -0300, Jason Gunthorpe <jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
> > wrote: 
> > > On Wed, Mar 24, 2021 at 10:02:46AM -0700, Jacob Pan wrote:  
> > > > > Also wondering about device driver allocating auxiliary domains
> > > > > for their private use, to do iommu_map/unmap on private PASIDs (a
> > > > > clean replacement to super SVA, for example). Would that go
> > > > > through the same path as /dev/ioasid and use the cgroup of
> > > > > current task?    
> > > >
> > > > For the in-kernel private use, I don't think we should restrict
> > > > based on cgroup, since there is no affinity to user processes. I
> > > > also think the PASID allocation should just use kernel API instead
> > > > of /dev/ioasid. Why would user space need to know the actual PASID
> > > > # for device private domains? Maybe I missed your idea?    
> > > 
> > > There is not much in the kernel that isn't triggered by a process, I
> > > would be careful about the idea that there is a class of users that
> > > can consume a cgroup controlled resource without being inside the
> > > cgroup.
> > > 
> > > We've got into trouble before overlooking this and with something
> > > greenfield like PASID it would be best built in to the API to prevent
> > > a mistake. eg accepting a cgroup or process input to the allocator.
> > >   
> > Make sense. But I think we only allow charging the current cgroup, how
> > about I add the following to ioasid_alloc():
> > 
> > 	misc_cg = get_current_misc_cg();
> > 	ret = misc_cg_try_charge(MISC_CG_RES_IOASID, misc_cg, 1);
> > 	if (ret) {
> > 		put_misc_cg(misc_cg);
> > 		return ret;
> > 	}  
> 
> Does that allow PASID allocation during driver probe, in kernel_init or
> modprobe context?
> 
Good point. Yes, you can get cgroup subsystem state in kernel_init for
charging/uncharging. I would think module_init should work also since it is
after kernel_init. I have tried the following:
static int __ref kernel_init(void *unused)
 {
        int ret;
+       struct cgroup_subsys_state *css;
+       css = task_get_css(current, pids_cgrp_id);

But that would imply:
1. IOASID has to be built-in, not as module
2. IOASIDs charged on PID1/init would not subject to cgroup limit since it
will be in the root cgroup and we don't support migration nor will migrate.

Then it comes back to the question of why do we try to limit in-kernel
users per cgroup if we can't enforce these cases.

> Thanks,
> Jean
> 


Thanks,

Jacob
