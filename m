From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RESEND PATCH v2 2/2] memcg, fsnotify: no oom-kill for remote
 memcg charging
Date: Mon, 13 May 2019 10:51:14 +0200
Message-ID: <20190513085114.GD24036@dhcp22.suse.cz>
References: <20190512160927.80042-1-shakeelb@google.com>
 <20190512160927.80042-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190512160927.80042-2-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

On Sun 12-05-19 09:09:27, Shakeel Butt wrote:
[...]
> diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
> index 6b9c27548997..f78fd4c8f12d 100644
> --- a/fs/notify/fanotify/fanotify.c
> +++ b/fs/notify/fanotify/fanotify.c
> @@ -288,10 +288,13 @@ struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
>  	/*
>  	 * For queues with unlimited length lost events are not expected and
>  	 * can possibly have security implications. Avoid losing events when
> -	 * memory is short.
> +	 * memory is short. Also make sure to not trigger OOM killer in the
> +	 * target memcg for the limited size queues.
>  	 */
>  	if (group->max_events == UINT_MAX)
>  		gfp |= __GFP_NOFAIL;
> +	else
> +		gfp |= __GFP_RETRY_MAYFAIL;
>  
>  	/* Whoever is interested in the event, pays for the allocation. */
>  	memalloc_use_memcg(group->memcg);
> diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
> index ff30abd6a49b..17c08daa1ba7 100644
> --- a/fs/notify/inotify/inotify_fsnotify.c
> +++ b/fs/notify/inotify/inotify_fsnotify.c
> @@ -99,9 +99,12 @@ int inotify_handle_event(struct fsnotify_group *group,
>  	i_mark = container_of(inode_mark, struct inotify_inode_mark,
>  			      fsn_mark);
>  
> -	/* Whoever is interested in the event, pays for the allocation. */
> +	/*
> +	 * Whoever is interested in the event, pays for the allocation. However
> +	 * do not trigger the OOM killer in the target memcg.

Both comments would be much more helpful if they mentioned _why_ we do
not want to trigger the OOM iller.

> +	 */
>  	memalloc_use_memcg(group->memcg);
> -	event = kmalloc(alloc_len, GFP_KERNEL_ACCOUNT);
> +	event = kmalloc(alloc_len, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
>  	memalloc_unuse_memcg();
>  
>  	if (unlikely(!event)) {
-- 
Michal Hocko
SUSE Labs
