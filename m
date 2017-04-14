From: Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: Re: cgroup: avoid attaching a cgroup root to two different
 superblocks
Date: Fri, 14 Apr 2017 16:27:38 -0700
Message-ID: <20170414232737.GC20350@outlook.office365.com>
References: <58E7532B.4030505@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=9wJ51yKg39gYm8Q0lDbJidfw7h2sXsji2VtiRFnmuog=;
 b=dWwAyAc/9R1stCohlOKHS1oYGUFxerHz2Lptb5WFeSXJScbNOAd/v2TwrVKbaJim8RAOoS4/RFAXb7Kikwzp3ZCBvqLZv79Nto2I/XbvDKNEijpTfhyMgiO2b4eAvoTcihrA5CedJ984woEp4AIu2aVijRF2xIHNE2uO+wPVYjo=
Content-Disposition: inline
In-Reply-To: <58E7532B.4030505-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

One of our CRIU tests hangs with this patch.

Steps to reproduce:
curl -o cgroupns.c https://gist.githubusercontent.com/avagin/f87c8a8bd2a0de9afcc74976327786bc/raw/5843701ef3679f50dd2427cf57a80871082eb28c/gistfile1.txt
gcc cgroupns.c -o cgroupns
./cgroupns
./cgroupns

[root@fc24 ~]# strace -s 256 -fe clone,unshare,setns,mount ./cgroupns 
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = 0
unshare(CLONE_NEWCGROUP)                = 0
clone(child_stack=NULL, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x7fe5da0b89d0) = 529
strace: Process 529 attached
[pid   529] setns(3, CLONE_NEWCGROUP)   = 0
[pid   529] +++ exited with 0 +++
--- SIGCHLD {si_signo=SIGCHLD, si_code=CLD_EXITED, si_pid=529, si_uid=0, si_status=0, si_utime=0, si_stime=0} ---
+++ exited with 0 +++
[root@fc24 ~]# strace -s 256 -fe clone,unshare,setns,mount ./cgroupns 
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = ? ERESTARTNOINTR (To be restarted)
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = ? ERESTARTNOINTR (To be restarted)
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = ? ERESTARTNOINTR (To be restarted)
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = ? ERESTARTNOINTR (To be restarted)
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = ? ERESTARTNOINTR (To be restarted)
mount("none", "/tmp/cgroupns.test/zdtmtst", "cgroup", 0, "none,name=zdtmtst") = ? ERESTARTNOINTR (To be restarted)
....

Thanks,
Andrei

On Fri, Apr 07, 2017 at 04:51:55PM +0800, Li Zefan wrote:
> Run this:
> 
>     touch file0
>     for ((; ;))
>     {
>         mount -t cpuset xxx file0
>     }
> 
> And this concurrently:
> 
>     touch file1
>     for ((; ;))
>     {
>         mount -t cpuset xxx file1
>     }
> 
> We'll trigger a warning like this:
> 
>  ------------[ cut here ]------------
>  WARNING: CPU: 1 PID: 4675 at lib/percpu-refcount.c:317 percpu_ref_kill_and_confirm+0x92/0xb0
>  percpu_ref_kill_and_confirm called more than once on css_release!
>  CPU: 1 PID: 4675 Comm: mount Not tainted 4.11.0-rc5+ #5
>  Hardware name: Bochs Bochs, BIOS Bochs 01/01/2007
>  Call Trace:
>   dump_stack+0x63/0x84
>   __warn+0xd1/0xf0
>   warn_slowpath_fmt+0x5f/0x80
>   percpu_ref_kill_and_confirm+0x92/0xb0
>   cgroup_kill_sb+0x95/0xb0
>   deactivate_locked_super+0x43/0x70
>   deactivate_super+0x46/0x60
>  ...
>  ---[ end trace a79f61c2a2633700 ]---
> 
> Here's a race:
> 
>   Thread A				Thread B
> 
>   cgroup1_mount()
>     # alloc a new cgroup root
>     cgroup_setup_root()
> 					cgroup1_mount()
> 					  # no sb yet, returns NULL
> 					  kernfs_pin_sb()
> 
> 					  # but succeeds in getting the refcnt,
> 					  # so re-use cgroup root
> 					  percpu_ref_tryget_live()
>     # alloc sb with cgroup root
>     cgroup_do_mount()
> 
>   cgroup_kill_sb()
> 					  # alloc another sb with same root
> 					  cgroup_do_mount()
> 
> 					cgroup_kill_sb()
> 
> We end up using the same cgroup root for two different superblocks,
> so percpu_ref_kill() will be called twice on the same root when the
> two superblocks are destroyed.
> 
> We should fix to make sure the superblock pinning is really successful.
> 
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 3.16+
> Reported-by: Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cgroup-v1.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 1dc22f6..12e19f0 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -1146,7 +1146,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
>  		 * path is super cold.  Let's just sleep a bit and retry.
>  		 */
>  		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
> -		if (IS_ERR(pinned_sb) ||
> +		if (IS_ERR_OR_NULL(pinned_sb) ||
>  		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
>  			mutex_unlock(&cgroup_mutex);
>  			if (!IS_ERR_OR_NULL(pinned_sb))
