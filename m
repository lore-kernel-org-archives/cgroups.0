From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 09/12] blkcg: remove additional reference to the css
Date: Fri, 7 Sep 2018 10:54:46 -0700
Message-ID: <20180907175446.GC1100574@devbig004.ftw2.facebook.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
 <20180906211045.29055-10-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Sw6pbXe12wkIIY0DzSGDBgpk/O0ujeodMCZZAv1/1Sw=;
        b=ul74lg4S8XSunuW2s7t7cf5hyFrSzALM2HfiwHA82ivrRjJZOFJhBmq57+rIzygep8
         39PEdeWyjkEPTR2FPJVoLwYPYaXFEnhcQljCJQKHMu6MMALcv5+Gq5zRmKj75MtyJ/HY
         SacvqAEcstmSkYY7SGnRQEbOOPqQax4bgYYLmH2EXvDB1+MdkS68bMzAfY0uiLiFF89N
         tVzpfbwGZTWZa/aKrdKjn3ekedMpzZVaUXYexCKepHDgXMhS91Jlo3vM/lRvxd0DFsYl
         ibc06GgrMOjvXz1cD5SPaDGpQZeJxHgE7rqrep09c2RWPa6WV3wenCCKuidRbq8QqAMB
         QPTw==
Content-Disposition: inline
In-Reply-To: <20180906211045.29055-10-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello,

On Thu, Sep 06, 2018 at 05:10:42PM -0400, Dennis Zhou wrote:
> +struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
> +					 struct cgroup_subsys *ss)
> +{
> +	struct cgroup_subsys_state *css;
> +
> +	rcu_read_lock();
> +
> +	do {
> +		css = cgroup_css(cgrp, ss);
> +
> +		if (css)
> +			goto out_unlock;
> +		cgrp = cgroup_parent(cgrp);
> +	} while (cgrp);
> +
> +	css = init_css_set.subsys[ss->id];
> +out_unlock:
> +	rcu_read_unlock();

Nothing protects @css here tho.  It can be released before the caller
is done with it.  The caller must ensure that it's holding rcu read
lock to protect the lookup and the subsequent uses.  cgroup_css()
already checks for rcu locking, so if you just drop
rcu_read_lock/unlock(), everything should work fine.

Thanks.

-- 
tejun
