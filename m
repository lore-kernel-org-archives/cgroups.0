From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 08/10] blkcg: implement blk-iocost
Date: Thu, 29 Aug 2019 08:46:09 -0700
Message-ID: <20190829154609.GU2263813@devbig004.ftw2.facebook.com>
References: <20190828220600.2527417-1-tj@kernel.org>
 <20190829133928.16192-1-hdanton@sina.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aegqxwkNQfcl+Wg+uXNzhfA96N2TVnZEqWU/pVTp7O0=;
        b=SYTOMOQY9y4DHxazFL0VJ5Esl3I6kjkjeY0wH2mN1HPH/S+CJKwCkJ9ApmUWzpIltd
         7mJTwhspOUW+Xq1yyt6HsCav03dKy3i8mHcOeUt+mYUBpY0Scdy6du0IdP5UGhKYWKR4
         uO9gCZM6CksSTlpE/JECpZ/UtrIVw4ggrkWHKzVoykbTt3IfBI/zajFxcXk5E/VTWwHz
         RHQBykyBHBb/8qCtJR6BCiUAf21PHnWpn6uGQvPH2tRR/eEiZQhk+FPlqF/+32rRDSgD
         WwxUJYxcBZ4ZLQbdgQJDNQyHCJ1vtyy7JdkUZ9bxQdOZd2BI7CS43lRjQqsx224uAh4h
         F56w==
Content-Disposition: inline
In-Reply-To: <20190829133928.16192-1-hdanton@sina.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hillf Danton <hdanton@sina.com>
Cc: axboe@kernel.dk, newella@fb.com, clm@fb.com, josef@toxicpanda.com, dennisz@fb.com, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, Josef Bacik <jbacik@fb.com>, Rik van Riel <riel@surriel.com>

Hello,

On Thu, Aug 29, 2019 at 09:39:28PM +0800, Hillf Danton wrote:
> > +	on_q_ns = ktime_get_ns() - rq->alloc_time_ns;
> > +	rq_wait_ns = rq->start_time_ns - rq->alloc_time_ns;
> > +
> ehm... alloc_time makes no sense wrt start_time if this is their only
> use. What are you trying to measure with the two stamps if they are
> meaningfully apart?

Queue depth depletion.

> > +	rq_qos_add(q, rqos);
> > +	ret = blkcg_activate_policy(q, &blkcg_policy_iocost);
> > +	if (ret) {
> > +		rq_qos_del(q, rqos);
> 
> 		free_percpu(ioc->pcpu_stat);

Good catch.  Will send a follow up patch.

Thanks.

-- 
tejun
