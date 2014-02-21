From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] sysfs: fix namespace refcnt leak
Date: Fri, 21 Feb 2014 05:12:48 -0500
Message-ID: <20140221101248.GB14653@mtj.dyndns.org>
References: <5306C03B.4060808@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/48qfj87pHzqAnqdpY/RVJvBcs1ZShtjzLp0BBQrRxk=;
        b=guiWngSQgi++iA6fuvjDv0K3H9TD5Y51skA3+7FiJn2JlRqlwIxUM3ThiEby6FQpFt
         yz/t+nJUnzohBnY35bx750qwkzpQuDhD3PyA8OkiaNgBX6pmtkaJxaFLsDJ2AKZzAwC5
         kLI05Nhnl4Y29/FP+t6eBGY6Cj7+gGsrj5bxO9LXt0eCdwq5Xcu17UJpo/PtKPcMBgoq
         q4CkJTZBqMMZeDdQ73KGtea+faVtUeKRL3p9CLT9MPcHv4nt+OTU2rVYzkYgk0jfrXTY
         hsaKsLd6VrDoGzp3FhQKw4hIK8IpCTkvdWO7V9C9RdmCbREcBbQG1FDm3ZEVmH7glKFs
         zvEg==
Content-Disposition: inline
In-Reply-To: <5306C03B.4060808@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Fri, Feb 21, 2014 at 10:55:55AM +0800, Li Zefan wrote:
> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
> ns refcnt unconditionally in sysfs_mount(), and instead we should
> get the refcnt only when kernfs_mount() allocated a new superblock.
> 
> v2:
> - Changed the name of the new argument, suggested by Tejun.
> - Made the argument optional, suggested by Tejun.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
...
> @@ -132,6 +132,7 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * @flags: mount flags specified for the mount
>   * @root: kernfs_root of the hierarchy being mounted
>   * @ns: optional namespace tag of the mount
> + * @new_sb_created: tell the caller if we allocated a new superblock
>   *
>   * This is to be called from each kernfs user's file_system_type->mount()
>   * implementation, which should pass through the specified @fs_type and
> @@ -141,7 +142,8 @@ const void *kernfs_super_ns(struct super_block *sb)
>   * The return value can be passed to the vfs layer verbatim.
>   */
>  struct dentry *kernfs_mount_ns(struct file_system_type *fs_type, int flags,
> -			       struct kernfs_root *root, const void *ns)
> +			       struct kernfs_root *root, const void *ns,
> +			       bool *new_sb_created)

Oops, just one more thing.  Let's please put @new_sb_created before
@ns; otherwise, kernfs_mount_ns() and kernfs_mount() become really
confusing as we end up omitting the second-to-last param for the
latter instead of the last.

Other than that,

 Reviewed-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
