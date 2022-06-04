From: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 2/3] blk-cgroup: Return -ENOMEM directly in
 blkcg_css_alloc() error path
Date: Sat, 4 Jun 2022 10:16:19 +0800
Message-ID: <YprAc9uLaDPXUW2s@T590>
References: <20220602192020.166940-1-longman@redhat.com>
 <20220602192020.166940-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654308992;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CAVPgM6qZdc+rcFlXJ6cxNAqdIfu1YMLp42YefCDdmM=;
        b=bhIYuC63yTTE46WyO8LaveJ+ryGb1ahxVjGrp3/JSvbKKB2QROqXgVuuMv4NTpWohSmRNV
        Zg9QUHHuspBHOXMhPsNu9O3d/fP/zmxpNOHuMsvoLs6sjmZF4DscEJMOdyjr3S/6mWsTGt
        U3hTUjYY+nG2w987HAHc2Qq0BjtcADs=
Content-Disposition: inline
In-Reply-To: <20220602192020.166940-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jun 02, 2022 at 03:20:19PM -0400, Waiman Long wrote:
> For blkcg_css_alloc(), the only error that will be returned is -ENOMEM.
> Simplify error handling code by returning this error directly instead
> of setting an intermediate "ret" variable.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Looks fine:

Reviewed-by: Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Thanks,
Ming

