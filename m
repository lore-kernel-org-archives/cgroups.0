From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: protect modifications to cgroup->idr with
 cgroup_mutex
Date: Wed, 12 Feb 2014 15:02:10 +0800
Message-ID: <52FB1C72.60605@huawei.com>
References: <52FB14A5.9030307@huawei.com> <20140212063713.GA7984@mtj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140212063713.GA7984-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/2/12 14:37, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Feb 12, 2014 at 02:28:53PM +0800, Li Zefan wrote:
>> v2:
>> - Don't call deactivate_super() inside cgroup_mutex, as cgroup_kill_sb()
>> will be called if sb refcnt reaches 0. I don't think this can happen,
>> as cgroup_create() is called through vfs, so vfs should guarantee the
>> superblock won't disappear. Still better not depend on it even my guess
>> is probably correct.
> 
> If the deadlock can't actually happen, I don't really care either way
> as the code goes away after kernfs conversion anyway.  I've already
> applied v1, so if you think this change is important, can you send an
> incremental patch?
> 

I'm fine to stick with V1.

I'm pretty confident it's safe, as we can increment sb refcnt without
any checking or locking (even cgroup_mutex as the comment says) in
cgroup_create().
