From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: bug fix of cgroup_root object was not released
 after cgroup umounted
Date: Mon, 14 Dec 2015 14:51:39 -0500
Message-ID: <20151214195139.GB4026@mtj.duckdns.org>
References: <1450093554-24474-1-git-send-email-kyler.zhangkui@huawei.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4Jz5HTqi4OGvU6jCWOP98ww0XTYaXEXc9z4/hLoPWy0=;
        b=Wum6ZQ26UcC1XHqXxm3yo+691Ahio9mgjMoetwfWuKVp3brn0UqDYfhuE28oGItVvo
         2T5JITieExN1KfFBE/ETTkXPNMVDot9C9YV6IHYMSbGM6BbaTtxw3LXmCcRHzni3Kk7h
         xy8/xZ3/7fk4wj6R/IVJNbdWpGkYtyg/E7IenN6FYSAR9GCaEa+IrhHK/CjRMm2TUHBs
         BH8aPrbWj5GKD0e7LQR62xGZKKEg6kZ5LPCP/2kaI+lnTGqWeU7Gawb/6QCBxWY9WDce
         xpspDTyTElYSmPyPurKOy+0Uk9FiYlNAaVqASu7slBuMJwrCD/2DwW49zq9wwSGufkJy
         Fr2A==
Content-Disposition: inline
In-Reply-To: <1450093554-24474-1-git-send-email-kyler.zhangkui@huawei.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kyler.zhangkui@huawei.com
Cc: cgroups@vger.kernel.org, zhihui.gao@huawei.com, chenjie6@huawei.com, lizefan@huawei.com, stable@vger.kernel.org

Hello, Zhang.

On Mon, Dec 14, 2015 at 07:45:54PM +0800, kyler.zhangkui@huawei.com wrote:
> @@ -2147,6 +2147,13 @@ static void cgroup_kill_sb(struct super_block *sb)
>  {
>  	struct kernfs_root *kf_root = kernfs_root_from_sb(sb);
>  	struct cgroup_root *root = cgroup_root_from_kf(kf_root);
> +	struct cgroup *child;
> +	int live_child = 0;
> +
> +	mutex_lock(&cgroup_mutex);
> +	cgroup_for_each_live_child(child, &root->cgrp) {
> +		live_child++;
> +	}
>  
>  	/*
>  	 * If @root doesn't have any mounts or children, start killing it.
> @@ -2155,12 +2162,12 @@ static void cgroup_kill_sb(struct super_block *sb)
>  	 *
>  	 * And don't kill the default root.
>  	 */
> -	if (!list_empty(&root->cgrp.self.children) ||
> -	    root == &cgrp_dfl_root)
> -		cgroup_put(&root->cgrp);
> +	if (live_child || root == &cgrp_dfl_root)
> +	cgroup_put(&root->cgrp);
>  	else
>  		percpu_ref_kill(&root->cgrp.self.refcnt);
>  
> +	mutex_unlock(&cgroup_mutex);
>  	kernfs_kill_sb(sb);

I don't know.  With the above change, we might fail remounting with
the same option for some controllers which keep residual objects
around.  Changing controller associations has never been supported
correctly and I don't think it'll ever be.  I have no objection to
improving it but this has the potential to regress use cases which
would be more common.

Thanks.

-- 
tejun
