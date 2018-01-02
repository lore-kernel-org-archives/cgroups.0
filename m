From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] blktrace: output io cgroup name for cgroup v1
Date: Tue, 2 Jan 2018 08:32:54 -0800
Message-ID: <20180102163254.GE3668920@devbig577.frc2.facebook.com>
References: <20171228070400.26328-1-houtao1@huawei.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IHGiJFO+7bXXIUiz/+TAulGyKqzg6O+E/iWD+W10SS8=;
        b=GHtgqo15XDgFJtKgvXguWix4I4Bk6qA08dIVgVK+p9uHFpzfxQBS+k3M6XSkQI9qas
         dfEXuaU2aRCQXFYpLqEMsltMNqL6mcyUmLaGDV5FEpzZPFEuPWe4mqtQxjkde4juLehg
         da52k8OPt4JmvB2hncG2t8r1+IuugAjYkW5nGZzjtas6i6oaoEGXmMH/iPsWTAmmoPSj
         suAGctuf6oHwxBid0fU/O8lOGz/0gPx7OQY024ISuUu/Jf0QDpXG7tAeyj1rgPRn7Yjh
         kALWFGe/JIkSNNQ495GSKBnj7CBDOGihaGSlzRsLGWnFiePT8h0ERcn6Z9CjemlTwce/
         raDw==
Content-Disposition: inline
In-Reply-To: <20171228070400.26328-1-houtao1@huawei.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hou Tao <houtao1@huawei.com>
Cc: linux-block@vger.kernel.org, cgroups@vger.kernel.org, shli@kernel.org

Hello, Hou.

On Thu, Dec 28, 2017 at 03:04:00PM +0800, Hou Tao wrote:
> Now the output of io cgroup name in blktrace is controlled by
> blk_cgroup & blk_cgname options in trace_options files. When
> using cgroup v1 for io controller, there is no output of cgroup
> name in trace file, because cgroup_path_from_kernfs_id() uses
> cgrp_dfl_root.kf_root to find the cgroup file and cgrp_dfl_root
> is only valid for cgroup v2.
> 
> So fix cgroup_path_from_kernfs_id() to support both cgroup v1 and v2.
>
> Fixes: 69fd5c3 ("blktrace: add an option to allow displaying cgroup path")

This isn't a bug fix, so the above tag probably isn't necessary.

> +void cgroup_path_from_kernfs_id(int ssid, const union kernfs_node_id *id,
>  					char *buf, size_t buflen)
>  {
> +	struct kernfs_root *root;
>  	struct kernfs_node *kn;
> +	struct cgroup *root_cgrp = NULL;
>  
> +	if (ssid >= CGROUP_SUBSYS_COUNT)
>  		return;
> +
> +	if (likely(static_key_enabled(cgroup_subsys_on_dfl_key[ssid]))) {
> +		root = cgrp_dfl_root.kf_root;
> +	} else {
> +		struct cgroup_subsys *subsys = cgroup_subsys[ssid];
> +
> +		/*
> +		 * It seems we can not use rcu_read_lock() to protect
> +		 * the liveness check of subsys->root->cgrp. Although
> +		 * root->cgrp is freed by RCU, when we dereference the
> +		 * old root, the old root may been destroying by
> +		 * cgroup_destroy_root().
> +		 */
> +		mutex_lock(&cgroup_mutex);
> +		if (percpu_ref_tryget_live(&subsys->root->cgrp.self.refcnt)) {
> +			root_cgrp = &subsys->root->cgrp;
> +			root = subsys->root->kf_root;
> +		}
> +		mutex_unlock(&cgroup_mutex);

I don't know.  Controllers can be rebound dynamically and we may end
up applying ino+gen to the wrong root.  For tracing, it's not a big
problem, but I'd much prefer to keep the interface strict so that we
can always depend on the correctness of these lookups.  Given that
blkio in cgroup1 is severely deficient (buffered writes aren't
supported at all), I feel reluctant about adding new features to it at
cost and this has some possibility of becoming a long term headache.

Thanks.

-- 
tejun
