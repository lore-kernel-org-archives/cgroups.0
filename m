From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 1/4] cgroup: fix invalid rcu dereference
Date: Tue, 23 Oct 2012 14:50:48 +0200
Message-ID: <508692A8.6090706@suse.cz>
References: <20121022134536.172969567@napanee.usersys.redhat.com> <20121022134536.543579196@napanee.usersys.redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        bh=IqcyAVsNgkPfsx673LFiozKGo7f4g09ZQk7bgTTFcUU=;
        b=PTTNxYthl6IzeNZ4/6LIwlv/JlBQSOnvRnMTGS5aVl+b2ZooaD9aetIpZkGziYr5lB
         Qekr0qsUHGEfx70YOfMFuVQeLr3G38g85xdukTGLnDz43H/brMj2PWDLV3lBatSNDg3k
         fgHCcWzF24ufAleeKYw20TjvZgucDrPpKh1c0AjxsLAxHunqze4vtImNEmVh5HXwG5Ip
         6fmtol8o6MsuNhoCyopw2UkSNeZwD/Nl/BRz8eC6d1boEHuj9MtDZuw5ocXxITRi2iVH
         2i29dD94beJxU5toSqLQk1tHi9pdLo7+wMs4DaeMWkOha2jNimzldTDxPy32mPcVFWwY
         3vBg==
In-Reply-To: <20121022134536.543579196-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 10/22/2012 03:45 PM, Aristeu Rozanski wrote:
> From: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>

No, I'm *not* the author of the patch... Or at least I don't remember
:P. Where did you take it from?

> Commit "device_cgroup: convert device_cgroup internally to policy +
> exceptions" removed rcu locks which are needed in task_devcgroup
> called in this chain: devcgroup_inode_mknod OR
> __devcgroup_inode_permission -> __devcgroup_inode_permission ->
> task_devcgroup -> task_subsys_state -> task_subsys_state_check.
> 
> Change the code so that task_devcgroup is safely called with rcu read
> lock held.
> 
> ===============================
> [ INFO: suspicious RCU usage. ]
> 3.6.0-rc5-next-20120913+ #42 Not tainted
> -------------------------------
> include/linux/cgroup.h:553 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> rcu_scheduler_active = 1, debug_locks = 0
> 2 locks held by kdevtmpfs/23:
>  #0:  (sb_writers){.+.+.+}, at: [<ffffffff8116873f>]
> mnt_want_write+0x1f/0x50
>  #1:  (&sb->s_type->i_mutex_key#3/1){+.+.+.}, at: [<ffffffff811558af>]
> kern_path_create+0x7f/0x170
> 
> stack backtrace:
> Pid: 23, comm: kdevtmpfs Not tainted 3.6.0-rc5-next-20120913+ #42
> Call Trace:
>  [<ffffffff810c638d>] lockdep_rcu_suspicious+0xfd/0x130
>  [<ffffffff8121541d>] devcgroup_inode_mknod+0x19d/0x240
>  [<ffffffff8107bf54>] ? ns_capable+0x44/0x80
>  [<ffffffff81156b21>] vfs_mknod+0x71/0xf0
>  [<ffffffff813a8332>] handle_create.isra.2+0x72/0x200
>  [<ffffffff813a85d4>] devtmpfsd+0x114/0x140
>  [<ffffffff813a84c0>] ? handle_create.isra.2+0x200/0x200
>  [<ffffffff81093ad6>] kthread+0xd6/0xe0
>  [<ffffffff81654f24>] kernel_thread_helper+0x4/0x10
>  [<ffffffff8165369d>] ? retint_restore_args+0xe/0xe
>  [<ffffffff81093a00>] ? kthread_create_on_node+0x140/0x140
>  [<ffffffff81654f20>] ? gs_change+0xb/0xb
> 
> Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
> Cc: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> 
> ---
> 
> And this should fix it.
> 
>  security/device_cgroup.c |   15 +++++++--------
>  1 file changed, 7 insertions(+), 8 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2012-10-17 11:11:08.514793906 -0400
> +++ github/security/device_cgroup.c	2012-10-19 16:35:37.936804289 -0400
> @@ -533,10 +533,10 @@ struct cgroup_subsys devices_subsys = {
>   *
>   * returns 0 on success, -EPERM case the operation is not permitted
>   */
> -static int __devcgroup_check_permission(struct dev_cgroup *dev_cgroup,
> -					short type, u32 major, u32 minor,
> +static int __devcgroup_check_permission(short type, u32 major, u32 minor,
>  				        short access)
>  {
> +	struct dev_cgroup *dev_cgroup;
>  	struct dev_exception_item ex;
>  	int rc;
>  
> @@ -547,6 +547,7 @@ 	memset(&ex, 0, sizeof(ex));
>  	ex.access = access;
>  
>  	rcu_read_lock();
> +	dev_cgroup = task_devcgroup(current);
>  	rc = may_access(dev_cgroup, &ex);
>  	rcu_read_unlock();
>  
> @@ -558,7 +559,6 @@ 	return 0;
>  
>  int __devcgroup_inode_permission(struct inode *inode, int mask)
>  {
> -	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
>  	short type, access = 0;
>  
>  	if (S_ISBLK(inode->i_mode))
> @@ -570,13 +570,12 @@ 	short type, access = 0;
>  	if (mask & MAY_READ)
>  		access |= ACC_READ;
>  
> -	return __devcgroup_check_permission(dev_cgroup, type, imajor(inode),
> -					    iminor(inode), access);
> +	return __devcgroup_check_permission(type, imajor(inode), iminor(inode),
> +			access);
>  }
>  
>  int devcgroup_inode_mknod(int mode, dev_t dev)
>  {
> -	struct dev_cgroup *dev_cgroup = task_devcgroup(current);
>  	short type;
>  
>  	if (!S_ISBLK(mode) && !S_ISCHR(mode))
> @@ -587,7 +586,7 @@ 		return 0;
>  	else
>  		type = DEV_CHAR;
>  
> -	return __devcgroup_check_permission(dev_cgroup, type, MAJOR(dev),
> -					    MINOR(dev), ACC_MKNOD);
> +	return __devcgroup_check_permission(type, MAJOR(dev), MINOR(dev),
> +			ACC_MKNOD);
>  
>  }
> 


-- 
js
suse labs
