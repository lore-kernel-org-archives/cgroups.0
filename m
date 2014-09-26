From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] Revert "cgroup: remove redundant variable in
 cgroup_mount()"
Date: Fri, 26 Sep 2014 01:04:57 -0400
Message-ID: <20140926050457.GB14426@htj.dyndns.org>
References: <1411704205-28995-1-git-send-email-lizefan@huawei.com>
 <20140926042617.GA14426@htj.dyndns.org>
 <20140926045352.GN7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=krfshgAo+x7N8J95nRhBncSzZs8jOQYZvwK1/4uaciQ=;
        b=wp8n0uwQHSvBFeqUdxq7rUNBqFs0aJWnTd/ylIBDx/sqQTQkAIMuTupgjwJUBqb8mg
         0XqTUqsuxM3Wwkji6zZcs10emEcx+3c9LBQoqlB45jC9Fp0hP9RNslUapy2Imkfbw8ST
         jQ9eRcfdzF8BT5fCqWxo4y30yKEwB5W6oQeoPRZ2zdtn+yCnlLMfQopRsGkZepacCicM
         yfR5/Nbe6o9gy6/lW7la2ji5pzipdJx6ACaL3pGOU+nqq7W+skdBhAvQBkCVkPaggHSW
         RYFzKmCYAcbtx/m19upZAZdrrZzxOI3W+MIRYLsa2maeWZ30MZs8f2CE8fyhOAB0WUqY
         nyvQ==
Content-Disposition: inline
In-Reply-To: <20140926045352.GN7996-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 26, 2014 at 05:53:52AM +0100, Al Viro wrote:
> On Fri, Sep 26, 2014 at 12:26:17AM -0400, Tejun Heo wrote:
> > On Fri, Sep 26, 2014 at 12:03:25PM +0800, Zefan Li wrote:
> > > This reverts commit 0c7bf3e8cab7900e17ce7f97104c39927d835469.
...
> > > Cc: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> > > Reported-by: Andrey Wagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > Signed-off-by: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Applied to cgroup/for-3.18.
> 
> Er?  It's a clear regression since 3.16; shouldn't it go into mainline
> before 3.17-final?  Another thing: AFAICS, if kernfs_fill_super() fails,

Hmmm?  This is reverting 0c7bf3e8cab7 which was committed six days ago
to cgroup/for-3.18.

> you get unbalanced kernfs_put() on the cleanup path - kernfs_kill_sb()
> will be called in those cases as well.  IOW, we'd better move that
>         kernfs_get(info->root->kn);
> in kernfs_fill_super() all way up to the point before kernfs_get_inode().
> Something like this:
> 
> Signed-off-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
> ---
> diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
> index f973ae9..e5e92e3 100644
> --- a/fs/kernfs/mount.c
> +++ b/fs/kernfs/mount.c
> @@ -74,6 +74,7 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
>  	sb->s_magic = magic;
>  	sb->s_op = &kernfs_sops;
>  	sb->s_time_gran = 1;
> +	kernfs_get(info->root->kn);
>  
>  	/* get root inode, initialize and unlock it */
>  	mutex_lock(&kernfs_mutex);
> @@ -90,7 +91,6 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
>  		pr_debug("%s: could not get root dentry!\n", __func__);
>  		return -ENOMEM;
>  	}
> -	kernfs_get(info->root->kn);

Ooh, right.  Will test & send the patch to Greg.

Thanks.

-- 
tejun
