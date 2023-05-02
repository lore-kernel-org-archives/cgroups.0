From: Waiman Long <longman@redhat.com>
Subject: Re: [RFC PATCH 1/3] cgroup: Drop unused function for cgroup_path
Date: Tue, 2 May 2023 15:58:00 -0400
Message-ID: <3005132d-7d05-0b7f-09f4-1956e42b6e2a@redhat.com>
References: <20230502133847.14570-1-mkoutny@suse.com>
 <20230502133847.14570-2-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683057485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aKHeKqZ6mdgIeuKnPtdj2k6l6vY7S9mG2MmFei8RXi4=;
        b=Z315wsyMyOkmDSjKFMGSwUrlxAuP0RUw8y4ckDHTcnTO7W1A6FhxmcMX/CeUyV/wG6L+SR
        wIRk08OwipXpL+8O8JeRIeAWePbWuLC0WWCM9W0x5lIM54vKllcC/+KilaRvU8+yTMU6RI
        jrxIwI/l3AQRCFUfsuyfFMT+1eTeZZU=
Content-Language: en-US
In-Reply-To: <20230502133847.14570-2-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"; format="flowed"
To: =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Dave Chinner <dchinner@redhat.com>, Rik van Riel <riel@surriel.com>, Jiri Wiesner <jwiesner@suse.de>

On 5/2/23 09:38, Michal Koutný wrote:
> There is no current user and there are alternative methods to obtain
> task's cgroup path.
>
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>   kernel/cgroup/cgroup.c | 39 ---------------------------------------
>   1 file changed, 39 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 625d7483951c..55e5f0110e3b 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -2378,45 +2378,6 @@ int cgroup_path_ns(struct cgroup *cgrp, char *buf, size_t buflen,
>   }
>   EXPORT_SYMBOL_GPL(cgroup_path_ns);
>   
> -/**
> - * task_cgroup_path - cgroup path of a task in the first cgroup hierarchy
> - * @task: target task
> - * @buf: the buffer to write the path into
> - * @buflen: the length of the buffer
> - *
> - * Determine @task's cgroup on the first (the one with the lowest non-zero
> - * hierarchy_id) cgroup hierarchy and copy its path into @buf.  This
> - * function grabs cgroup_mutex and shouldn't be used inside locks used by
> - * cgroup controller callbacks.
> - *
> - * Return value is the same as kernfs_path().
> - */
> -int task_cgroup_path(struct task_struct *task, char *buf, size_t buflen)
> -{
> -	struct cgroup_root *root;
> -	struct cgroup *cgrp;
> -	int hierarchy_id = 1;
> -	int ret;
> -
> -	cgroup_lock();
> -	spin_lock_irq(&css_set_lock);
> -
> -	root = idr_get_next(&cgroup_hierarchy_idr, &hierarchy_id);
> -
> -	if (root) {
> -		cgrp = task_cgroup_from_root(task, root);
> -		ret = cgroup_path_ns_locked(cgrp, buf, buflen, &init_cgroup_ns);
> -	} else {
> -		/* if no hierarchy exists, everyone is in "/" */
> -		ret = strscpy(buf, "/", buflen);
> -	}
> -
> -	spin_unlock_irq(&css_set_lock);
> -	cgroup_unlock();
> -	return ret;
> -}
> -EXPORT_SYMBOL_GPL(task_cgroup_path);
> -
>   /**
>    * cgroup_attach_lock - Lock for ->attach()
>    * @lock_threadgroup: whether to down_write cgroup_threadgroup_rwsem

I went to a few of earlier Linux version down to v3.11. 
task_cgroup_path() doesn't seems to have any users in my few attempts. 
Anyway,

Reviewed-by: Waiman Long <longman@redhat.com>

