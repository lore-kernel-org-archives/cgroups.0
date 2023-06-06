From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: Reinit blkg_iostat_set after clearing in
 blkcg_reset_stats()
Date: Tue, 6 Jun 2023 09:46:35 -1000
Message-ID: <ZH-NG5VFl3dpln7A@slm.duckdns.org>
References: <20230606180724.2455066-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686080797; x=1688672797;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yc73F63LtY0R3e3jd8aXo3gZg8F1PNW5E1lmdjRfGIw=;
        b=hN8GRjG/znPgtKtttYBsMmV9UxnG2Wz6olapQ1TKb9pgE6iWFqkxjLqkjj9Qj8x2Vn
         CQVXqppCsf29UF9YV0jlXkdaOQzIqnGuJeDQurXYtKeC1jQ6zz3UZheq33bN6O3NFvku
         gOgfd7b42+0sAuUwp/DG4UMS3jWhZTjWiIJKNv5EAqtVrFuMY6iV6maNfBK2MaJB0/lL
         LfLlxaF+3eG1WYhHDXjz/NFOCX663fAaK0VdmVVFggqXCVkmTvArZMIHsxDQAddNbadr
         z67f+Qa2RcNVvJ/Wxq4v7/NaQmdwDCPKIaLDwPx8Wge1Hdq6Bk432nH8eXjN1JFaHMlO
         w7LA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230606180724.2455066-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Tue, Jun 06, 2023 at 02:07:24PM -0400, Waiman Long wrote:
> When blkg_alloc() is called to allocate a blkcg_gq structure
> with the associated blkg_iostat_set's, there are 2 fields within
> blkg_iostat_set that requires proper initialization - blkg & sync.
> The former field was introduced by commit 3b8cc6298724 ("blk-cgroup:
> Optimize blkcg_rstat_flush()") while the later one was introduced by
> commit f73316482977 ("blk-cgroup: reimplement basic IO stats using
> cgroup rstat").
> 
> Unfortunately those fields in the blkg_iostat_set's are not properly
> re-initialized when they are cleared in v1's blkcg_reset_stats(). This
> can lead to a kernel panic due to NULL pointer access of the blkg
> pointer. The missing initialization of sync is less problematic and
> can be a problem in a debug kernel due to missing lockdep initialization.
> 
> Fix these problems by re-initializing them after memory clearing.
> 
> Fixes: 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
> Fixes: f73316482977 ("blk-cgroup: reimplement basic IO stats using cgroup rstat")
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
