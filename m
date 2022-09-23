From: Mukesh Ojha <quic_mojha@quicinc.com>
Subject: Re: [PATCH] cgroup: fix cgroup_get_from_id
Date: Fri, 23 Sep 2022 21:13:15 +0530
Message-ID: <5b013fa2-4ad7-5995-ae6d-52770106272a@quicinc.com>
References: <20220923115119.2035603-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1663947926; x=1695483926;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=B0Z6lO/AYPTVpzI8xvjmvs6lklWmO2tJS2Pwo6sfTgo=;
  b=RqJVAeYb85F+7KjDbW7D4vMPDC41nP72lEwNmxBiBPeoYqsqfnC70U6b
   0ksqr5Z8MuD99PWjfAZdF5yL6IdPE7geodDu4FXng8ndemzltF2cnzEJJ
   sflMv6iE7AchuTHFv+NGUY+u3xw4dv8p89N8PMumBp7ewaCEa1NTTvTcO
   E=;
Content-Language: en-US
In-Reply-To: <20220923115119.2035603-1-ming.lei@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Ming Lei <ming.lei@redhat.com>, Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Marco Patalano <mpatalan@redhat.com>, Muneendra <muneendra.kumar@broadcom.com>

Hi,

On 9/23/2022 5:21 PM, Ming Lei wrote:
> cgroup has to be one kernfs dir, otherwise kernel panic is caused,
> especially cgroup id is provide from userspace.
> 
> Reported-by: Marco Patalano <mpatalan@redhat.com>
> Fixes: 6b658c4863c1 ("scsi: cgroup: Add cgroup_get_from_id()")
> Cc: Muneendra <muneendra.kumar@broadcom.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   kernel/cgroup/cgroup.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index e4bb5d57f4d1..5f2090d051ac 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6049,6 +6049,9 @@ struct cgroup *cgroup_get_from_id(u64 id)
>   	if (!kn)
>   		goto out;
>   
> +	if (kernfs_type(kn) != KERNFS_DIR)
> +		goto put;
> +
>   	rcu_read_lock();
>   
>   	cgrp = rcu_dereference(*(void __rcu __force **)&kn->priv);
> @@ -6056,7 +6059,7 @@ struct cgroup *cgroup_get_from_id(u64 id)
>   		cgrp = NULL;
>   
>   	rcu_read_unlock();
> -
> +put:
>   	kernfs_put(kn);
>   out:
>   	return cgrp;

Good catch.

Acked-by: Mukesh Ojha <quic_mojha@quicinc.com>

-Mukesh
