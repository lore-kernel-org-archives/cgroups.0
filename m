From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix cgroup_path() vs rename() race
Date: Sat, 16 Feb 2013 15:59:39 +0800
Message-ID: <511F3C6B.30604@huawei.com>
References: <51022FC7.5020607@huawei.com> <511547EA.4090902@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <511547EA.4090902-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

(sorry for the late reply, just came back from holiday)

On 2013/2/9 2:46, Sasha Levin wrote:
> On 01/25/2013 02:09 AM, Li Zefan wrote:
>> rename() will change dentry->d_name. The result of this race can
>> be worse than seeing partially rewritten name, but we might access
>> a stale pointer because rename() will re-allocate memory to hold
>> a longer name.
>>
>> Use dentry_path_raw(), and this vfs API will take care of lockings.
>>
>> Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Hi Li,
> 
> I was fuzzing with trinity inside a KVM tools guest, and stumbled on
> a lockdep spew related to this patch.
> 
> Here's the spew (brace yourself):
> 

dentry_path_raw() will grab rename_lock and dentry->d_lock without disabling
irq, which means cgroup_path() can't be called if the caller has already held
a spinlock with irq disabled.

Both blkio cgroup and cpu cgroup have this lock issue...The only fix is to
make a copy of dentry->d_name and save it in cgrp->name.

Patch will be followed.

> [  313.262599] ======================================================
> [  313.271340] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> [  313.277542] 3.8.0-rc6-next-20130208-sasha-00028-ge4e162d #278 Tainted: G        W
> [  313.277542] ------------------------------------------------------
> [  313.277542] kworker/u:3/4490 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [  313.277542]  (rename_lock){+.+...}, at: [<ffffffff812a11f9>] dentry_path_raw+0x29/0x70
> [  313.277542]
> [  313.277542] and this task is already holding:
> [  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}, at: [<ffffffff819e78f3>] put_io_context_active+0x63/0x100
> [  313.277542] which would create a new lock dependency:
> [  313.277542]  (&(&q->__queue_lock)->rlock){-.-...} -> (rename_lock){+.+...}
> [  313.277542]
> [  313.277542] but this new dependency connects a HARDIRQ-irq-safe lock:
> [  313.277542]  (&(&q->__queue_lock)->rlock){-.-...}
> ... which became HARDIRQ-irq-safe at:
> 
...
