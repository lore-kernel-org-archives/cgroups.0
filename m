From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/3] cgroup: fix mount failure in a corner case
Date: Mon, 30 Jun 2014 09:41:22 +0800
Message-ID: <53B0C042.9030206@huawei.com>
References: <53AD18D0.3090100@huawei.com> <53AD2852.2060304@huawei.com> <53AD35A8.7030908@huawei.com> <20140628115743.GB10829@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140628115743.GB10829-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/6/28 19:58, Tejun Heo wrote:
> Hello, Li.
> 
> On Fri, Jun 27, 2014 at 05:13:12PM +0800, Li Zefan wrote:
>> +	for_each_subsys(ss, i) {
>> +		if (!(opts.subsys_mask & (1 << i)) ||
>> +		    ss->root == &cgrp_dfl_root)
>> +			continue;
>> +
>> +		if (!percpu_ref_tryget_live(&ss->root->cgrp.self.refcnt)) {
>> +			mutex_unlock(&cgroup_mutex);
>> +			msleep(10);
>> +			ret = restart_syscall();
>> +			goto out_free;
>> +		}
> 
> Why not just put it immediately?  We know that it's not gonna be
> destroyed while holding cgroup_mutex.  It may look a bit weird but
> this is a pretty special case anyway and deferring put doesn't buy
> anything.
> 

Yeah, this is better. :)
