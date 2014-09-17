From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel crash in cgroup_pidlist_destroy_work_fn()
Date: Wed, 17 Sep 2014 13:29:37 +0800
Message-ID: <54191C41.3080003@huawei.com>
References: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAM_iQpVNzx1r8x-bP5CoiCX8PFk15JYHw_XfpYvJGgdkFHj8Gw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Cong Wang <xiyou.wangcong-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2014/9/17 7:56, Cong Wang wrote:
> Hi, Tejun
> 
> 
> We saw some kernel null pointer dereference in
> cgroup_pidlist_destroy_work_fn(), more precisely at
> __mutex_lock_slowpath(), on 3.14. I can show you the full stack trace
> on request.
> 

Yes, please.

> Looking at the code, it seems flush_workqueue() doesn't care about new
> incoming works, it only processes currently pending ones, if this is
> correct, then we could have the following race condition:
> 
> cgroup_pidlist_destroy_all():
>         //...
>         mutex_lock(&cgrp->pidlist_mutex);
>         list_for_each_entry_safe(l, tmp_l, &cgrp->pidlists, links)
>                 mod_delayed_work(cgroup_pidlist_destroy_wq,
> &l->destroy_dwork, 0);
>         mutex_unlock(&cgrp->pidlist_mutex);
> 
>         // <--- another process calls cgroup_pidlist_start() here
> since mutex is released
> 
>         flush_workqueue(cgroup_pidlist_destroy_wq); // <--- another
> process adds new pidlist and queue work in pararell
>         BUG_ON(!list_empty(&cgrp->pidlists)); // <--- This check is
> passed, list_add() could happen after this
> 

Did you confirm this is what happened when the bug was triggered?

I don't think the race condition you described exists. In 3.14 kernel,
cgroup_diput() won't be called if there is any thread running
cgroup_pidlist_start(). This is guaranteed by vfs.

But newer kernels are different. Looks like the bug exists in those
kernels.

> 
> Therefore, the newly added pidlist will point to a freed cgroup, and
> when it is freed in the delayed work we will crash.
> 
> The attached patch (compile test ONLY) could be a possible fix, since
> it will check and hold a refcount on this cgroup in
> cgroup_pidlist_start(). But I could very easily miss something here
> since there are many cgroup changes after 3.14 and I don't follow
> cgroup development.
> 
> What do you think?
> 
