From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with
 cgroup_mutex
Date: Wed, 12 Feb 2014 10:38:32 +0100
Message-ID: <20140212093832.GD28085@dhcp22.suse.cz>
References: <52F9D9DA.7040108@huawei.com>
 <20140211102032.GA11946@dhcp22.suse.cz>
 <20140212091238.GC28085@dhcp22.suse.cz>
 <52FB3E50.8020809@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <52FB3E50.8020809-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed 12-02-14 17:26:40, Li Zefan wrote:
> On 2014/2/12 17:12, Michal Hocko wrote:
> > Li has pointed out that my previous backport was not correct because
> > err_unlock label releases a reference to supperblock which was not taken
> > before idr_alloc. I've also removed cgroup_mutex from free_css_id as per
> > Li.
> > Fixed in this version.
> > 
> 
> Looks good to me!

Thanks for double checking.

> Are you going to send it to stable mailing list after the fix hits mainline
> or use it internally?

I plan to have it tested internally and then send it later on when
stable FAILED to apply mail arrives. Unless you want to send it yourself
of course.

> It has small conflicts with this patch that will also be backported to 3.12:
> 
> https://git.kernel.org/cgit/linux/kernel/git/tj/cgroup.git/commit/kernel/cgroup.c?h=for-3.14-fixes&id=b58c89986a77a23658682a100eb15d8edb571ebb

Thanks for the heads up. Should be trivial to resolve.
-- 
Michal Hocko
SUSE Labs
