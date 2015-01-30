From: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [RFC][PATCH] cpuset, sched: Fix cpuset sched_relax_domain_level
Date: Fri, 30 Jan 2015 10:35:21 -0800
Message-ID: <1422642921.3365.1.camel@j-VirtualBox>
References: <1422478025.4111.31.camel@j-VirtualBox>
	 <54CB04DC.3090405@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54CB04DC.3090405-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, aswin-VXdhtT5mjnY@public.gmane.org, scott.norton-VXdhtT5mjnY@public.gmane.org, chegu_vinod-VXdhtT5mjnY@public.gmane.org, jason.low2-VXdhtT5mjnY@public.gmane.org

On Fri, 2015-01-30 at 12:13 +0800, Zefan Li wrote:
> On 2015/1/29 4:47, Jason Low wrote:
> > The cpuset.sched_relax_domain_level can control how far we do
> > immediate load balancing on a system. However, it was found on recent
> > kernels that echo'ing a value into cpuset.sched_relax_domain_level
> > did not reduce any immediate load balancing.
> > 
> > The reason this occurred was because the update_domain_attr_tree() traversal
> > did not update for the "top_cpuset". This resulted in nothing being changed
> > when modifying the sched_relax_domain_level parameter.
> > 
> > This patch was able to address that problem by having update_domain_attr_tree()
> > allowing updates for the root (top_cpuset) in the cpuset traversal.
> > 
> > Signed-off-by: Jason Low <jason.low2-VXdhtT5mjnY@public.gmane.org>
> 
> Thanks for finding this bug!
> 
> Please Add:
> 
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+
> Fixes: fc560a26acce ("cpuset: replace cpuset->stack_list with cpuset_for_each_descendant_pre()")

Okay, I will send out a new version.

Thanks,
Jason
