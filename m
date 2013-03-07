From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup: INFO: suspicious RCU usage. in cgroup_name
Date: Thu, 7 Mar 2013 10:29:21 +0800
Message-ID: <5137FB81.7040304@huawei.com>
References: <5137687E.50701@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5137687E.50701-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sasha Levin <sasha.levin-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2013/3/7 0:02, Sasha Levin wrote:
> Hi all,
> 
> While fuzzing with trinity inside a KVM tools guest running latest -next kernel
> I've stumbled on the following:
> 
> [  450.180599] ===============================
> [  450.181392] [ INFO: suspicious RCU usage. ]
> [  450.182101] 3.9.0-rc1-next-20130305-sasha-00048-g35e9ec5-dirty #1032 Tainted: G        W
> [  450.183482] -------------------------------
> [  450.184343] include/linux/cgroup.h:429 suspicious rcu_dereference_check() usage!

My fault. I didn't trigger a OOM to test my patch. I thought the caller
of cpuset_print_task_mems_allowed() already acquired rcu_read_lock()...

Thanks for the report.
