From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v10 4/4] cgroups: implement the PIDs subsystem
Date: Fri, 24 Apr 2015 11:26:13 -0400
Message-ID: <20150424152613.GB24029@htj.duckdns.org>
References: <CAOviyagQTu_ARVURBmtHtXGMugMsgSyZ2Es3ix8mQASCNkuPyA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=THwABdYWdPfJFaTxsKgSW/70IH/LBDrFjv3aM4M971Q=;
        b=vUpK7Vw7IVpGwBh5Qj3Xj2D+PxsyKo/rlNCQACjp2bqr8INXr+bs4K5R/7Ds7o1Dph
         8eEqgiPy4GTDZ0vIF2uhcqlrOyBzSn8n/LTQak2o7KLSiFhtTLMYmdwcb5JNm4FwSG6O
         kWkqD8CnB7cU3gEy7wK08nR9waNCOr7AuWjyTVPIDPekkz8ibcV+vo2pJEdSZ2ykg0QS
         r4f80z9D4DXNrS/KMsU/rGcRNEqhIZUQUUTf4jQfbpjZ1+XU7yl7aLwTqyYdCxFuNUys
         XOvnMW9TYVqNgV6ynirJmtuQa9J5nfSKILEREf2xXA1zQVZPqmMHZodnlGTEWhdfv6i9
         BYQQ==
Content-Disposition: inline
In-Reply-To: <CAOviyagQTu_ARVURBmtHtXGMugMsgSyZ2Es3ix8mQASCNkuPyA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Hello, Aleksa.

On Sat, Apr 25, 2015 at 12:07:34AM +1000, Aleksa Sarai wrote:
> Would something like this suffice?
> 
> struct cgroup_subsys_state *task_get_css(struct task_struct *task, int
> subsys_id) {
>         bool have_ref = false;
>         struct cgroup_subsys_state *css;
> 
>         while(!have_ref) {
>                 rcu_read_lock();
>                 css = task_css(task, subsys_id);
>                 have_ref = !css_tryget(css);
>                 rcu_read_unlock();
>         }
> 
>         return css;
> }

I was thinking why this felt so familiar and realized that I have the
patch pending.

 http://lkml.kernel.org/g/1428350318-8215-8-git-send-email-tj@kernel.org

Please feel free to include it in the patch series.  I'll sort out the
merging later.

> Also, as a side note (in the same vein I guess), does a ref on a
> css_set give you an implicit ref on a css inside that css_set, or are
> those two orthogonal operations?

Yes, it does, but if you're gonna depend on that, please document that.

Thanks.

-- 
tejun
