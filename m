From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/7] res_counter: add a function
 res_counter_move_parent().
Date: Mon, 16 Apr 2012 15:31:57 -0700
Message-ID: <20120416223157.GE12421@google.com>
References: <4F86B9BE.8000105@jp.fujitsu.com>
 <4F86BA66.2010503@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=0Hxl/+zhLIMBEmAa82UdAsqafi7k/bQLU74Iay5n+kI=;
        b=JakGC2vxblskG/Hx7KSWvGZZYQpzIZVxTaarNGckwfJ3ai4l4zL10L7oe0PNvEzOSG
         gndCHCpEWOhX4wtSBvRS4czu/j4kEtkJ0LTdk4VAPp+8ZrwNZpSDHbFYS+3wqppGyXKH
         fxKfSWYqnIPavmMdwspJlJzXF0mMFQzdvm7KjSrljvUfDu0ELs5xz57F93taGaylWKUp
         fiC0VZQR+uHCStHOiecv7ik3U2AteorAFXcKqXkBzHvC/qpb7/9Dv0LbGn/bZsXTWwYs
         Y/g6wIO7RujyhxREyyY+YsxXus18fMBVKy/kaj/Fp9xmXUlvkxWWpsVbtsZXOh+VHaOw
         Zk3A==
Content-Disposition: inline
In-Reply-To: <4F86BA66.2010503@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, Glauber Costa <glommer@parallels.com>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Apr 12, 2012 at 08:20:06PM +0900, KAMEZAWA Hiroyuki wrote:
> +/*
> + * In hierarchical accounting, child's usage is accounted into ancestors.
> + * To move local usage to its parent, just forget current level usage.
> + */
> +void res_counter_move_parent(struct res_counter *counter, unsigned long val)
> +{
> +	unsigned long flags;
> +
> +	BUG_ON(!counter->parent);
> +	spin_lock_irqsave(&counter->lock, flags);
> +	res_counter_uncharge_locked(counter, val);
> +	spin_unlock_irqrestore(&counter->lock, flags);
> +}

On the second thought, do we need this at all?  It's as good as doing
nothing after all, no?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
