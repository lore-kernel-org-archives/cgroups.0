From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 6/7] memcg: remove pre_destroy()
Date: Mon, 16 Apr 2012 15:38:00 -0700
Message-ID: <20120416223800.GF12421@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
 <4F86BCCE.5050802@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=OYcHceiCZPeIUNSvQlbOzS0lhtIyRGH5URgS0tjye2k=;
        b=uhHWRnp67C2gu2f3WXtInLBnQRbYUj+p2Em1NjvX4GJHrEAJvRhp4uIUm/SNtnvOUq
         AmMTn4SxBYC8lXXjSlI5vRElxXninwr2xzc3ttXQjIIqxAV2RHL9o8vZXBJCQcw+0q4m
         xHTtUKApQHeVe+rGAhbPeM50UaacmNNBz4dYuWKZ4DTnXElMolDm5Ap99q/dU2aJlcy5
         EcPT0eB4Ue/xgwKcz6ipJ/oaChAE1vHqHSSJwCw72gYmIErq+mYcd9cyKsf/rksjPrRf
         DZq0wzsyFCIcSPzPjzA/cgJR6+90soMGMzTLBFEHiEZMuc+WgtlWFYk2fNgQeTAj8fyt
         FT0A==
Content-Disposition: inline
In-Reply-To: <4F86BCCE.5050802@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Glauber Costa <glommer@parallels.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

Hello,

On Thu, Apr 12, 2012 at 08:30:22PM +0900, KAMEZAWA Hiroyuki wrote:
> +/*
> + * This function is called after ->destroy(). So, we cannot access cgroup
> + * of this memcg.
> + */
> +static void mem_cgroup_recharge(struct work_struct *work)

So, ->pre_destroy per-se isn't gonna go away.  It's just gonna be this
callback which cgroup core uses to unilaterally notify that the cgroup
is going away, so no need to do this cleanup asynchronously from
->destroy().  It's okay to keep doing it synchronously from
->pre_destroy().  The only thing is that it can't fail.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
