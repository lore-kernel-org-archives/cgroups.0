From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/3] cgroup: make the default root invisible when it's
 umounted
Date: Wed, 4 Jun 2014 16:59:59 +0800
Message-ID: <538EE00F.10406@huawei.com>
References: <538D4956.5050205@huawei.com> <538D4982.10905@huawei.com> <20140603130144.GB26210@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140603130144.GB26210-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2014/6/3 21:01, Tejun Heo wrote:
> On Tue, Jun 03, 2014 at 12:05:22PM +0800, Li Zefan wrote:
>> Before this patch (in a fresh system):
>>
>>    # cat /proc/$$/cgroup
>>    # mount -t cgroup -o __DEVEL__sane_behavior xxx /cgroup
>>    # umount /cgroup
>>    # cat /proc/$$/cgroup
>>    0:cpuset,cpu,cpuacct,memory,devices,freezer,net_cls,blkio,perf_event,net_prio,hugetlb:/
>>
>> After this patch (in a fresh system):
>>
>>    # cat ...
>>    # mount ...
>>    # umount ...
>>    # cat /proc/$$/cgroup
>>    #
>>
>> You won't see the default root after it's umounted.
> 
> Hmmmm... I intentionally left it visible tho.  The only reason we gate
> its visibility is avoid disturbing userland which doesn't know about
> and won't use the unified hierarchy.  If the userland starts making
> use of it, there's no reason to hide it again especially as that's
> consistent with how other hierarchies behave too - they keep showing
> up if they have lingering refs.
> 

The example I gave is the same result if sane_behavior is not specified,
so this is a behavioural change for the old interface?

Do we need a fix like this?

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3f46165..6f10cff 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1789,6 +1789,9 @@ static void cgroup_kill_sb(struct super_block *sb)
 	else
 		percpu_ref_kill(&root->cgrp.self.refcnt);

+	if (root == &cgrp_dfl_root && !cgroup_sane_behavior(&root->cgrp))
+		cgrp_dfl_root_visible = false;
+
 	kernfs_kill_sb(sb);
 
