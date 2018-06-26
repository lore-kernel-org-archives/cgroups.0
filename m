From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 26 Jun 2018 15:06:19 -0400
Message-ID: <20180626190619.GB3958@cmpxchg.org>
References: <20180625230659.139822-1-shakeelb@google.com>
 <20180625230659.139822-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PPSeppZvMDg0ZRlfiMVRQ2Q8cq4oVs68U1a3OI3sANE=; b=K88mHbGO7lZfegACplZZG3hCNQ
        gR5UhoWoFMaMwoIA/9CSHxMsCQlHoPqu/ozBNvGpFlIew+2CcPwTNyUmzx7o1mc64biC3puhqrQIT
        Y+Os1fDPpsxysmuGO77YOtDQ37TkN06Mh+7wV5Q8p4hd5YN791wAiP89PIZpSsYejzlg=;
Content-Disposition: inline
In-Reply-To: <20180625230659.139822-2-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

On Mon, Jun 25, 2018 at 04:06:58PM -0700, Shakeel Butt wrote:
> @@ -140,8 +141,9 @@ struct fanotify_event_info *fanotify_alloc_event(struct fsnotify_group *group,
>  						 struct inode *inode, u32 mask,
>  						 const struct path *path)
>  {
> -	struct fanotify_event_info *event;
> +	struct fanotify_event_info *event = NULL;
>  	gfp_t gfp = GFP_KERNEL;
> +	struct mem_cgroup *old_memcg = NULL;
>  
>  	/*
>  	 * For queues with unlimited length lost events are not expected and
> @@ -151,19 +153,25 @@ struct fanotify_event_info *fanotify_alloc_event(struct fsnotify_group *group,
>  	if (group->max_events == UINT_MAX)
>  		gfp |= __GFP_NOFAIL;
>  
> +	/* Whoever is interested in the event, pays for the allocation. */
> +	if (group->memcg) {
> +		gfp |= __GFP_ACCOUNT;
> +		old_memcg = memalloc_use_memcg(group->memcg);
> +	}

group->memcg is only NULL when memcg is disabled or there is some
offlining race. Can you make memalloc_use_memcg(NULL) mean that it
should charge root_mem_cgroup instead of current->mm->memcg? That way
we can make this site unconditional while retaining the behavior:

	gfp_t gfp = GFP_KERNEL | __GFP_ACCOUNT;

	memalloc_use_memcg(group->memcg);
	kmem_cache_alloc(..., gfp);
out:
	memalloc_unuse_memcg();

(dropping old_memcg and the unuse parameter as per the other mail)

>  	if (fanotify_is_perm_event(mask)) {
>  		struct fanotify_perm_event_info *pevent;
>  
>  		pevent = kmem_cache_alloc(fanotify_perm_event_cachep, gfp);
>  		if (!pevent)
> -			return NULL;
> +			goto out;
>  		event = &pevent->fae;
>  		pevent->response = 0;
>  		goto init;
>  	}
>  	event = kmem_cache_alloc(fanotify_event_cachep, gfp);
>  	if (!event)
> -		return NULL;
> +		goto out;
>  init: __maybe_unused
>  	fsnotify_init_event(&event->fse, inode, mask);
>  	event->tgid = get_pid(task_tgid(current));
> @@ -174,6 +182,9 @@ init: __maybe_unused
>  		event->path.mnt = NULL;
>  		event->path.dentry = NULL;
>  	}
> +out:
> +	if (group->memcg)
> +		memalloc_unuse_memcg(old_memcg);
>  	return event;
>  }

Thanks,
Johannes
