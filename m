From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] tg: add cpu's wait_count of a task group
Date: Tue, 19 Jan 2021 10:32:25 -0500
Message-ID: <YAb7icZqetp5c827@mtj.duckdns.org>
References: <20210115143005.7071-1-wu860403@gmail.com>
 <YAH4w5T3/oCTGJny@mtj.duckdns.org>
 <CAPnMXWWmfzWh9J_G4OPT=eCFySaD2NAFE0_OiWFQKL-1R0uOkA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kSkC2qIvnSbPN0EBpd70Gg0QmXoZHEfwntVfKkWRT5Y=;
        b=heLkTAXMu7tor2Dhd0hqS7RlJXkXrZS8bRbn9D98yRqAUqeSwcmb03MFAJjeYTndSu
         7Umtbpq1+cipanv6fsWnAeAopTJMUp0CtQDWtpeSRbh93VmEahoHq+gFACF/mZNJqKwc
         RPpBA5u2q0hNlML5Uj6SCAqtSNx3zvrchDcVXzX89TKPbZlhe2xkRe+0ZtdedAKZnEey
         TPdF9etfTVmMu9O+IfXatJSYl09Bj+rPqrGR4mgd7xAYPWJEAPKd8Sy502AXeuSPWpWk
         pPlfRr4A65ATWgcPPXh+pgSNusrdfkxsSVjN1jvO10e7sSStKKcwKgS16Cdd27ZnGBXU
         NGjQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAPnMXWWmfzWh9J_G4OPT=eCFySaD2NAFE0_OiWFQKL-1R0uOkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: liming wu <wu860403-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 398776277 <398776277-9uewiaClKEY@public.gmane.org>

Hello,

On Mon, Jan 18, 2021 at 11:07:47AM +0800, liming wu wrote:
> > > +             if (schedstat_enabled() && tg != &root_task_group) {
> > > +                     u64 ws = 0;
> > > +                     u64 wc = 0;
> > > +                     int i;
> > > +
> > > +                     for_each_possible_cpu(i) {
> > > +                             ws += schedstat_val(tg->se[i]->statistics.wait_sum);
> > > +                             wc += schedstat_val(tg->se[i]->statistics.wait_count);
> > > +                     }
> > > +
> > > +                     seq_printf(sf, "wait_sum %llu\n"
> > > +                             "wait_count %llu\n", ws, wc);
> > > +             }
> >
> > What does sum/count tell?
> It can tell the task group average latency of every context switch
> wait_sum is equivalent to sched_info->run_delay (the second parameter
> of /proc/$pid/schedstat)
> wait_count is equivalent to sched_info->pcount(the third parameter of
> /proc/$pid/schedstat)

Sounds good to me but can you please:

* Rename wait_sum to wait_usec and make sure the duration is in usecs.

* Rename wait_count to nr_waits.

* This should go through the scheduler tree. When you post the updated
  version, please cc the scheduler folks from MAINAINERS.

Thanks.

-- 
tejun
