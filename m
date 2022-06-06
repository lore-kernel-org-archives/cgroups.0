From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 3/3] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Mon, 6 Jun 2022 11:16:29 +0800
Message-ID: <Yp1xjRyU9L5FiWXQ@T590>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654485400;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=k29yc7w9b88p8N/STUF61jAqzTNY+1ywx+KU40xq0aA=;
        b=GPOmoERIRU5zwlpWg8kZd70HxPMAM/J0PAb/aorTjxpdPdy0LLROj6iEoNm6Z5jLZWmnYo
        jkSKO8PtKbqG8LeefdXS3+Lgm9GCSHoVweEOWHNFeGIEjfXN9UA+Bq5aFTXxMVCcmimkQw
        R8utvyjLb1QU//AK84b6wyoraVjqeNk=
Content-Disposition: inline
In-Reply-To: <20220602192020.166940-4-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 02, 2022 at 03:20:20PM -0400, Waiman Long wrote:
> For a system with many CPUs and block devices, the time to do
> blkcg_rstat_flush() from cgroup_rstat_flush() can be rather long. It
> can be especially problematic as interrupt is disabled during the flush.
> It was reported that it might take seconds to complete in some extreme
> cases leading to hard lockup messages.
> 
> As it is likely that not all the percpu blkg_iostat_set's has been
> updated since the last flush, those stale blkg_iostat_set's don't need
> to be flushed in this case. This patch optimizes blkcg_rstat_flush()
> by keeping a lockless list of recently updated blkg_iostat_set's in a
> newly added percpu blkcg->lhead pointer.
> 
> The blkg_iostat_set is added to the lockless list on the update side
> in blk_cgroup_bio_start(). It is removed from the lockless list when
> flushed in blkcg_rstat_flush(). Due to racing, it is possible that
> blk_iostat_set's in the lockless list may have no new IO stats to be
> flushed. To protect against destruction of blkg, a percpu reference is
> gotten when putting into the lockless list and put back when removed.
> 
> A blkg_iostat_set can determine if it is in a lockless list by checking
> the content of its lnode.next pointer which will be non-NULL when in
> a lockless list. This requires the presence of a special llist_last
> sentinel node to be put at the end of the lockless list.
> 
> When booting up an instrumented test kernel with this patch on a
> 2-socket 96-thread system with cgroup v2, out of the 2051 calls to
> cgroup_rstat_flush() after bootup, 1788 of the calls were exited
> immediately because of empty lockless list. After an all-cpu kernel
> build, the ratio became 6295424/6340513. That was more than 99%.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Ming

