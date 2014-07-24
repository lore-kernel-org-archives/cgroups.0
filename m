From: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
Date: Thu, 24 Jul 2014 10:46:20 +0800
Message-ID: <53D0737C.2030305@linux.vnet.ibm.com>
References: <53CF22F5.6000206@linux.vnet.ibm.com> <20140723151220.GD7103@htj.dyndns.org> <53D052FC.3070409@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53D052FC.3070409-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 07/24/2014 08:27 AM, Li Zefan wrote:
> On 2014/7/23 23:12, Tejun Heo wrote:
>> On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
>>> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
>>> changes") introduce the below warning in my server.
>>>
>>> [   35.652137] ------------[ cut here ]------------
>>> [   35.652141] WARNING: at kernel/cpuset.c:1139
>> Hah, can you reproduce it?  If so, can you detail how?
>>
> It's a typo.
>
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	nodes_equal(cp->mems_allowed, cp->effective_mems));
>
> should be
>
> WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
> 	!nodes_equal(cp->mems_allowed, cp->effective_mems));

Yes, it is. This warning disappeared after this patch.

Reported-and-Tested-by: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
>
