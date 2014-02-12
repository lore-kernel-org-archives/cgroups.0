From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: protect modifications to cgroup_idr with cgroup_mutex
Date: Wed, 12 Feb 2014 09:50:39 +0800
Message-ID: <52FAD36F.7000500@huawei.com>
References: <52F9D9DA.7040108@huawei.com> <20140211102032.GA11946@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140211102032.GA11946-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/11 18:20, Michal Hocko wrote:
> Hi Li,
> good work in reproducing the issue so quickly!
> I have tried to backport this patch to 3.12 kernel but the code has
> changed since then.
> The only two instances of idr_remove which are called outside of
> cgroup_mutex seem to be:
>  - cgroup_create calling it from err_free_id: path
>  - css_free_work_fn
>      mem_cgroup_css_free
>        __mem_cgroup_free
>          free_css_id
> 
> The second one takes ss->id_lock spinlock which should be sufficient
> to exclude get_new_cssid but cgroup_mount and cgroup_create don't use
> id_lock. They do hold cgroup_mutex though. So I guess I need something
> like the following (I will have it tested):

I don't think you need to do anything with ss->idr.

cgroup_create() calls alloc_css_id() -> get_new_cssid(), and get_new_cssid()
uses id_lock.

cgroup_mount() won't touch ss->idr, because the css_id for root cgroup is
always 0.
