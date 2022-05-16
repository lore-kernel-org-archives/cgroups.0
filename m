From: Wang Cheng <wanngchenng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mm/mempolicy: fix uninit-value in mpol_rebind_policy()
Date: Mon, 16 May 2022 17:47:26 +0800
Message-ID: <20220516094726.b5rrsjg7rvei2od5@ppc.localdomain>
References: <20220512123428.fq3wofedp6oiotd4@ppc.localdomain>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YHaY3VzzTKl05Ylig5G4revSeCBrE0n2SgEWey+VV4c=;
        b=kJYGrFZKUFrWk0ImWW0YnAKs8rcQzfSr2AwwcnEDXieIovOXoMXhPfHwkPrRr2ZH7o
         xG4giXUDJD8ISDP6iPnb9oDfLIB3221ksRJ3Rc9/Mv6j99u+uC7PEKZx6eC3T0wZU3sv
         2KcBpyQhdSwtSPFTH022wws+PNTjY8P5kf8QzLrDotBClqNmhO+tZpxCwC1K69P2bk1J
         DSR63mJwu57lsyUm8sjZv1CqSyMvJvMwNy6o9ELSPh2UdM2bVjfNA1+F4NUKYiXcrb3X
         8bUu7QGJbpkb8qHWeSzKsZ5qhXTxtmauGydQ60t8cWQX0N5KZyAnIisHArUfo2x8Qryy
         ORvA==
Content-Disposition: inline
In-Reply-To: <20220512123428.fq3wofedp6oiotd4-EN706goElQQmYvmMESoHnA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, syzkaller-bugs-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org

On 22/05/12 08:34PM, Wang Cheng wrote:
> mpol_set_nodemask()(mm/mempolicy.c) does not set up nodemask when
> pol->mode is MPOL_LOCAL. Check pol->mode before access
> pol->w.cpuset_mems_allowed in mpol_rebind_policy()(mm/mempolicy.c).
> 
> BUG: KMSAN: uninit-value in mpol_rebind_policy mm/mempolicy.c:352 [inline]
> BUG: KMSAN: uninit-value in mpol_rebind_task+0x2ac/0x2c0 mm/mempolicy.c:368
>  mpol_rebind_policy mm/mempolicy.c:352 [inline]
>  mpol_rebind_task+0x2ac/0x2c0 mm/mempolicy.c:368
>  cpuset_change_task_nodemask kernel/cgroup/cpuset.c:1711 [inline]
>  cpuset_attach+0x787/0x15e0 kernel/cgroup/cpuset.c:2278
>  cgroup_migrate_execute+0x1023/0x1d20 kernel/cgroup/cgroup.c:2515
>  cgroup_migrate kernel/cgroup/cgroup.c:2771 [inline]
>  cgroup_attach_task+0x540/0x8b0 kernel/cgroup/cgroup.c:2804
>  __cgroup1_procs_write+0x5cc/0x7a0 kernel/cgroup/cgroup-v1.c:520
>  cgroup1_tasks_write+0x94/0xb0 kernel/cgroup/cgroup-v1.c:539
>  cgroup_file_write+0x4c2/0x9e0 kernel/cgroup/cgroup.c:3852
>  kernfs_fop_write_iter+0x66a/0x9f0 fs/kernfs/file.c:296
>  call_write_iter include/linux/fs.h:2162 [inline]
>  new_sync_write fs/read_write.c:503 [inline]
>  vfs_write+0x1318/0x2030 fs/read_write.c:590
>  ksys_write+0x28b/0x510 fs/read_write.c:643
>  __do_sys_write fs/read_write.c:655 [inline]
>  __se_sys_write fs/read_write.c:652 [inline]
>  __x64_sys_write+0xdb/0x120 fs/read_write.c:652
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Uninit was created at:
>  slab_post_alloc_hook mm/slab.h:524 [inline]
>  slab_alloc_node mm/slub.c:3251 [inline]
>  slab_alloc mm/slub.c:3259 [inline]
>  kmem_cache_alloc+0x902/0x11c0 mm/slub.c:3264
>  mpol_new mm/mempolicy.c:293 [inline]
>  do_set_mempolicy+0x421/0xb70 mm/mempolicy.c:853
>  kernel_set_mempolicy mm/mempolicy.c:1504 [inline]
>  __do_sys_set_mempolicy mm/mempolicy.c:1510 [inline]
>  __se_sys_set_mempolicy+0x44c/0xb60 mm/mempolicy.c:1507
>  __x64_sys_set_mempolicy+0xd8/0x110 mm/mempolicy.c:1507
>  do_syscall_x64 arch/x86/entry/common.c:51 [inline]
>  do_syscall_64+0x54/0xd0 arch/x86/entry/common.c:82
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> KMSAN: uninit-value in mpol_rebind_task (2)
> https://syzkaller.appspot.com/bug?id=d6eb90f952c2a5de9ea718a1b873c55cb13b59dc
> 
> Reported-and-tested-by: syzbot+217f792c92599518a2ab-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
> Signed-off-by: Wang Cheng <wanngchenng-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
> The uninit-value is pol->w.cpuset_mems_allowed in
> mpol_rebind_policy().
> 
> While syzkaller reproducer runs, I notice pol->mode is 4(MPOL_LOCAL) in
>     mpol_set_nodemask()
>   do_set_mempolicy()(mm/mempolicy.c)
> that `nodemask` in `pol` is not initialized, which will be accessed in
> mpol_rebind_policy().
> 
>  mm/mempolicy.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 10e9c87260ed..18b74f02da71 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -347,7 +347,7 @@ static void mpol_rebind_preferred(struct mempolicy *pol,
>   */
>  static void mpol_rebind_policy(struct mempolicy *pol, const nodemask_t *newmask)
>  {
> -	if (!pol)
> +	if (!pol || pol->mode == MPOL_LOCAL)
>  		return;
>  	if (!mpol_store_user_nodemask(pol) &&
>  	    nodes_equal(pol->w.cpuset_mems_allowed, *newmask))
> -- 
> 2.30.2
>

Hi Andrew,

Thank you for fixing the commit message.

This patch seems to fix below bug too.
KMSAN: uninit-value in mpol_rebind_mm (2)
https://syzkaller.appspot.com/bug?id=f2fecd0d7013f54ec4162f60743a2b28df40926b

The uninit-value is pol->w.cpuset_mems_allowed in mpol_rebind_policy().
When syzkaller reproducer runs to the beginning of mpol_new(),

	    mpol_new() mm/mempolicy.c
	  do_mbind() mm/mempolicy.c
	kernel_mbind() mm/mempolicy.c

`mode` is 1(MPOL_PREFERRED), nodes_empty(*nodes) is `true` and `flags`
is 0. Then

	mode = MPOL_LOCAL;
	...
	policy->mode = mode;
	policy->flags = flags;

will be executed. So in mpol_set_nodemask(),

	    mpol_set_nodemask() mm/mempolicy.c
	  do_mbind()
	kernel_mbind()

pol->mode is 4(MPOL_LOCAL), that `nodemask` in `pol` is not initialized,
which will be accessed in mpol_rebind_policy().

IIUC, "#syz fix: mm/mempolicy: fix uninit-value in mpol_rebind_policy()"
could be sent to syzbot+ad1b8c404f0959c4bfcc-Pl5Pbv+GP7P466ipTTIvnc23WoclnBCfAL8bYrjMMd8@public.gmane.org
to attach the fixing commit to the bug. WDYT?

thanks,
- w

