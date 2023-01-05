From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while activating
 policy
Date: Thu, 5 Jan 2023 06:59:25 -1000
Message-ID: <Y7cB7f98+PNdXUnj@slm.duckdns.org>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
 <20230104151241.GA13268@blackbody.suse.cz>
 <4b559d1d-31e4-6049-4548-451bf7afb4f4@huaweicloud.com>
 <20230105104241.GA16920@blackbody.suse.cz>
 <6f54c858-be91-0fd3-d377-1aabb8a70c6f@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W6/pyn3vLiTu4LQPjq1YDQtDVZvW+kSX5YHBAxRyFO8=;
        b=pAjIbIyMHaELzfUibrA3v9W+sRKujPM33MXbNJU5pgHSE0PXYNtxJxzhKIuEhbYX2I
         //w0bNp5rM4kUuyqlJjg7UH2U6kdWagMOCFswiNMHO+MP5kKQmUJ0lnzwkYYNOWZOZVn
         EdugV+lRv0hIvf8c7FMNOtMle0x7h2E6Qnb049/E/YE/sTad3y00z5hxyx+IYbCfMZQc
         Peeez2SyIRJYa/Cj1o+eYfzKr7hFOa5Ue+JIcn3JJ8BHQ6F4lmQkn177ETZTiaIvddtn
         Kr2lAChV22biUhSCqdGzYEksLBQahie9+eCOp4KdEsgpyAzBOn9evh4V+o6ZsiU80js2
         jV2g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <6f54c858-be91-0fd3-d377-1aabb8a70c6f-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, "yukuai (C)" <yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Thu, Jan 05, 2023 at 09:52:29PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/01/05 18:45, Michal Koutný 写道:
> > On Thu, Jan 05, 2023 at 09:43:02AM +0800, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org> wrote:
> > > This is based only on code review, currently the only negative effects
> > > is that root blkg from blk-throtl won't call pd_online_fn().
> > 
> > Good, that's a NOP and there are no other uses of pd_online_fn.
> > 
> > I wonder are the separate pd_init_fn and pd_online_fn callbacks
> > necessary today?
> 
> I think online can combine to init, consider that only blk-throttle
> implement pd_online_fn(), but I'm not sure...
> 
> It seems to me the policies(bfq, iocost...) seem don't honor how pd
> apis works: alloc->init->online->offline->free, bfq combines online to
> init, iocost combines offline to free, ...

So, the distinction between alloc and online is that a pd which gets
allocated may be freed without ever going online if later allocations fail.
This is following cgroup init/exit pattern. Maybe it's a bit too elaborate
but the distinction is meaningful, at least in principle.

What seems truly spurious is pd_init_fn(). All that pd_init_fn() can do
should be achievable between pd_alloc_fn() and pd_online_fn(). The overlap
seems at least partially historical and we used to have pd_exit_fn() too.
So, yeah, getting rid of pd_init_fn() would be a nice first step.

Thanks.

-- 
tejun
