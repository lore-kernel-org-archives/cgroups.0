From: Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Thu, 28 Jun 2018 12:02:53 +0200
Message-ID: <20180628100253.jscxkw2d6vfhnbo5@quack2.suse.cz>
References: <20180627191250.209150-1-shakeelb@google.com>
 <20180627191250.209150-2-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180627191250.209150-2-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Jan Kara <jack@suse.cz>

On Wed 27-06-18 12:12:49, Shakeel Butt wrote:
> A lot of memory can be consumed by the events generated for the huge or
> unlimited queues if there is either no or slow listener.  This can cause
> system level memory pressure or OOMs.  So, it's better to account the
> fsnotify kmem caches to the memcg of the listener.
> 
> However the listener can be in a different memcg than the memcg of the
> producer and these allocations happen in the context of the event
> producer. This patch introduces remote memcg charging API which the
> producer can use to charge the allocations to the memcg of the listener.
> 
> There are seven fsnotify kmem caches and among them allocations from
> dnotify_struct_cache, dnotify_mark_cache, fanotify_mark_cache and
> inotify_inode_mark_cachep happens in the context of syscall from the
> listener.  So, SLAB_ACCOUNT is enough for these caches.
> 
> The objects from fsnotify_mark_connector_cachep are not accounted as they
> are small compared to the notification mark or events and it is unclear
> whom to account connector to since it is shared by all events attached to
> the inode.
> 
> The allocations from the event caches happen in the context of the event
> producer.  For such caches we will need to remote charge the allocations
> to the listener's memcg.  Thus we save the memcg reference in the
> fsnotify_group structure of the listener.
> 
> This patch has also moved the members of fsnotify_group to keep the size
> same, at least for 64 bit build, even with additional member by filling
> the holes.

...

>  static int __init fanotify_user_setup(void)
>  {
> -	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark, SLAB_PANIC);
> +	fanotify_mark_cache = KMEM_CACHE(fsnotify_mark,
> +					 SLAB_PANIC|SLAB_ACCOUNT);
>  	fanotify_event_cachep = KMEM_CACHE(fanotify_event_info, SLAB_PANIC);
>  	if (IS_ENABLED(CONFIG_FANOTIFY_ACCESS_PERMISSIONS)) {
>  		fanotify_perm_event_cachep =

Why don't you setup also fanotify_event_cachep and
fanotify_perm_event_cachep caches with SLAB_ACCOUNT and instead specify
__GFP_ACCOUNT manually? Otherwise the patch looks good to me.

								Honza

-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
