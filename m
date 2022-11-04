From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v9 3/3] blk-cgroup: Flush stats at blkgs destruction path
Date: Fri, 4 Nov 2022 10:13:12 -1000
Message-ID: <Y2VyWDvtwOsMBcKB@slm.duckdns.org>
References: <20221104182050.342908-1-longman@redhat.com>
 <20221104182050.342908-4-longman@redhat.com>
 <Y2VvboMSxgF0pYpX@slm.duckdns.org>
 <84fd6656-d133-b9df-c39e-fbb3a1f4a873@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xtk7jcohFLeQIICJ2B6kR5VUoj6ZVbcGeRiMSZFQHdg=;
        b=E8v7jZxwUA9gU2qPlTl8J4Rg6OiD4OSKi0kctzeKiV3i+IKf+Sl/5z3x2urDsrYTVt
         wjVDEi4/kcm1sF0fEPcDGV4mat20G0KBFoNdEqv+XmJ3cl1g6nVrvcE+nSMAvCN7de0U
         fYLQaTK8Bvrs+VA8b40ugVlQzyiauUOEnc/QTv16FXBYGN0erJ2KPpb3wGMKcw9Dfkvm
         GowtvrKej9023b75yQFFnY5sDs5PFzLKJR2wo/J+9I8Px7rzCvkzvqAWirFjrLWFQayZ
         KkmyPfd0uXymiDTEItGJHnbwoFPEPIVhkGojG1fQDTmqfUCREvS4ioKUQ7rAElcQi9F0
         Rr7g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <84fd6656-d133-b9df-c39e-fbb3a1f4a873-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Hillf Danton <hdanton-k+cT0dCbe1g@public.gmane.org>

On Fri, Nov 04, 2022 at 04:12:05PM -0400, Waiman Long wrote:
> I should have named the function cgroup_rstat_css_cpu_flush() to indicate
> that the cpu is a needed parameter. We can have a cgroup_rstat_css_flush()
> in the future if the need arises.
> 
> It is an optimization to call this function only if the corresponding cpu
> has a pending lockless list. I could do cpu iteration here and call the
> flushing function for all the CPUs. It is less optimized this way. Since it
> is a slow path, I guess performance is not that critical. So I can go either
> way. Please let me know your preference.

Yeah, cpu_flush is fine. Let's leave it that way.

Thanks.

-- 
tejun
