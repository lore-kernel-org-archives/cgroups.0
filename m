From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: WARNING: at kernel/cpuset.c:1139
Date: Thu, 24 Jul 2014 08:27:40 +0800
Message-ID: <53D052FC.3070409@huawei.com>
References: <53CF22F5.6000206@linux.vnet.ibm.com> <20140723151220.GD7103@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140723151220.GD7103-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mike Qiu <qiudayu-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/7/23 23:12, Tejun Heo wrote:
> On Wed, Jul 23, 2014 at 10:50:29AM +0800, Mike Qiu wrote:
>> commit 734d45130cb ("cpuset: update cs->effective_{cpus, mems} when config
>> changes") introduce the below warning in my server.
>>
>> [   35.652137] ------------[ cut here ]------------
>> [   35.652141] WARNING: at kernel/cpuset.c:1139
> 
> Hah, can you reproduce it?  If so, can you detail how?
> 

It's a typo.

WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
	nodes_equal(cp->mems_allowed, cp->effective_mems));

should be

WARN_ON(!cgroup_on_dfl(cp->css.cgroup) &&
	!nodes_equal(cp->mems_allowed, cp->effective_mems));
