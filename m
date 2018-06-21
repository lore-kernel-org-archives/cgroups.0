From: Andrei Vagin <avagin@virtuozzo.com>
Subject: Re: [16/32] kernfs, sysfs, cgroup, intel_rdt: Support fs_context
 [ver #8]
Date: Thu, 21 Jun 2018 11:47:55 -0700
Message-ID: <20180621184754.GB21326@outlook.office365.com>
References: <152720682792.9073.14747437198191460035.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JnMB7DzZD9TTO4EGJaihHqCsySCb76BtLdYQbXLF5ow=;
 b=bmTP0+Wnhe4QQiWnz3fQGlOe0GlLXhsKas2wYvL6RcUCIFjYpvZY9IJxJqqmpllK/7nUVqNbCqrpku6rAmG8fBxPVzcWUY9mFGVc+DxL5yEEVS2l9/3ytK+owpcILcaYPL464qNd1Vy88EKE9yqUdrCM6UTpikojc8qBSXm7nKQ=
Content-Disposition: inline
In-Reply-To: <152720682792.9073.14747437198191460035.stgit@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells@redhat.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org, linux-afs@lists.infradead.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

On Fri, May 25, 2018 at 01:07:08AM +0100, David Howells wrote:

...

> @@ -1972,57 +1957,51 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask, int ref_flags)
>  	return ret;
>  }
>  
> -struct dentry *cgroup_do_mount(struct file_system_type *fs_type, int flags,
> -			       struct cgroup_root *root, unsigned long magic,
> -			       struct cgroup_namespace *ns)
> +int cgroup_do_get_tree(struct fs_context *fc)
>  {
> -	struct dentry *dentry;
> -	bool new_sb;
> +	struct cgroup_fs_context *ctx = fc->fs_private;
> +	int ret;
> +
> +	ctx->kfc.root = ctx->root->kf_root;

[root@fc24 ~]# mount -t cgroup -o none,name=zdtmtst xxx /mnt/test
[root@fc24 ~]# mkdir /mnt/test/holder
[root@fc24 ~]# umount /mnt/test 
[root@fc24 ~]# mount -t cgroup -o none,name=zdtmtst xxx /mnt/test
Killed

ctx->root can be NULL here

[   93.719897] BUG: unable to handle kernel NULL pointer dereference at 0000000000000000
[   93.720097] PGD 80000002115f5067 P4D 80000002115f5067 PUD 1ef421067 PMD 0 
[   93.720179] Oops: 0000 [#1] SMP PTI
[   93.720257] CPU: 1 PID: 13843 Comm: cgroup04 Not tainted 4.18.0-rc1-next-20180621+ #1
[   93.720342] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
[   93.720432] RIP: 0010:cgroup_do_get_tree+0x1b/0xf0
[   93.720515] Code: 00 00 02 5b 5d c3 66 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 41 54 55 49 89 fc 53 48 83 ec 08 48 8b 9f 90 00 00 00 48 8b 43 20 <48> 8b 00 48 89 03 e8 8a cc 1e 00 85 c0 0f 88 97 00 00 00 48 81 7b 
[   93.720655] RSP: 0018:ffffb07941b03df8 EFLAGS: 00010292
[   93.720740] RAX: 0000000000000000 RBX: ffff9ba3527da300 RCX: 0000000000000000
[   93.720819] RDX: 0000000000000000 RSI: 0000000000000001 RDI: ffff9ba34d47b400
[   93.720897] RBP: ffffb07941b03e58 R08: 0000000000000000 R09: 0000000000000002
[   93.720975] R10: 0000000000000000 R11: 4aee8a3cb0beb9ec R12: ffff9ba34d47b400
[   93.721053] R13: ffff9ba351518000 R14: ffffffff961705d4 R15: ffff9ba35143f000
[   93.721131] FS:  000015418d893740(0000) GS:ffff9ba35fd00000(0000) knlGS:0000000000000000
[   93.721233] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   93.721336] CR2: 0000000000000000 CR3: 00000001c4658004 CR4: 00000000001606e0
[   93.721421] Call Trace:
[   93.721508]  cgroup1_get_tree+0x57c/0x640
[   93.721587]  vfs_get_tree+0x6e/0x180
[   93.721665]  do_mount+0x76b/0xa80
[   93.721753]  ksys_mount+0x80/0xd0
[   93.721831]  __x64_sys_mount+0x21/0x30
[   93.721908]  do_syscall_64+0x60/0x1b0
[   93.721987]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[   93.722065] RIP: 0033:0x15418d3bc85a

I think we need something like this:

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index e12c0a91b8a4..b1340bd5f5fc 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1192,6 +1192,7 @@ int cgroup1_get_tree(struct fs_context *fc)
                }
 
                ret = 0;
+               ctx->root = root;
                goto out_unlock;
        }
 
@@ -1241,6 +1242,7 @@ int cgroup1_get_tree(struct fs_context *fc)
                percpu_ref_reinit(&root->cgrp.self.refcnt);
                mutex_unlock(&cgroup_mutex);
        }
+       cgroup_get(&root->cgrp);
 
        /*
         * If @pinned_sb, we're reusing an existing root and holding an

https://travis-ci.org/avagin/linux/jobs/394887987

>  
> -	dentry = kernfs_mount(fs_type, flags, root->kf_root, magic, &new_sb);
> +	ret = kernfs_get_tree(fc);
> +	if (ret < 0)
> +		goto out_cgrp;
>  
>  	/*
>  	 * In non-init cgroup namespace, instead of root cgroup's dentry,
>  	 * we return the dentry corresponding to the cgroupns->root_cgrp.
>  	 */
> -	if (!IS_ERR(dentry) && ns != &init_cgroup_ns) {
