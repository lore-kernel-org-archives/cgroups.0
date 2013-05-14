From: Li Zefan <lizefan@huawei.com>
Subject: Re: cgroup dentry insufficiently initialized prior to calling d_instantiate.
Date: Tue, 14 May 2013 18:47:23 +0800
Message-ID: <5192163B.9010208@huawei.com>
References: <518D6E7C.9050204@schaufler-ca.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <518D6E7C.9050204@schaufler-ca.com>
Sender: linux-security-module-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: tj@kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org, lkml@vger.kernel.org, LSM <linux-security-module@vger.kernel.org>

On 2013/5/11 6:02, Casey Schaufler wrote:
> 
> In kernel/cgroup.c in cgroup_add_file() we have:
> 
> 
>         dentry = lookup_one_len(name, dir, strlen(name));
>         if (IS_ERR(dentry)) {
>                 error = PTR_ERR(dentry);
>                 goto out;
>         }
> 
>         mode = cgroup_file_mode(cft);
>         error = cgroup_create_file(dentry, mode | S_IFREG, cgrp->root->sb);
>         if (!error) {
>                 cfe->type = (void *)cft;
>                 cfe->dentry = dentry;
>                 dentry->d_fsdata = cfe;
>                 simple_xattrs_init(&cfe->xattrs);
>                 list_add_tail(&cfe->node, &parent->files);
>                 cfe = NULL;
>         }
>         dput(dentry);
> 
> cgroup_create_file() calls d_instantiate, which may
> decide to look at the xattrs on the file. Smack always
> does this and SELinux can be configured to do so, although
> no one seems to be using that option. Since the dentry
> has not been initialized panics in __d_xattr ensue. See
> bugzilla 57791.
> 

cgroup_add_file() should initialize xattrs before calling d_instantiate(),
just like cgroup_create() does.

I'll prepare a patch to fix it. Thanks for the report!

