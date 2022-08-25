From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 10/10] sched/psi: per-cgroup PSI accounting
 disable/re-enable interface
Date: Thu, 25 Aug 2022 09:20:43 -0400
Message-ID: <Ywd3K1+5blotUEtU@cmpxchg.org>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-11-zhouchengming@bytedance.com>
 <YwX2jC2UQ/zeY2E8@cmpxchg.org>
 <324b1d0f-42e5-8947-68cb-a3d20135f2c6@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=tGI/HgI5RJ0IOQ7oCC9l+UoRS3M/KBpS5rSBAd3MZgo=;
        b=whhwMf11JScRmGvZpTzi4pm8aQUE+LI1b+HFpqXieLoJb6OwFEWMMa+Y/SI3hiRfSa
         JVJvBQuNwEbjYGDBjUlhLzIqA8xnjXhvYDwpro7ItADA2pIOZ4lUne38Gc06R0mw4ydw
         4UAEy9/ZJ1W3J0CXMP6jJo9Ou6s22HAdt12AOj0xjT5d04mLaOjV30rQy9Mzd1ffVcmr
         4U6pSbwSpLZQy12eWKyJ/eyJUQn67mpFP0t6UmF6CMmAk9GR1k2VTGeSIfOAfAF0BJ6w
         MaWFv/K4v+A18UkkelXRxiWWvHCgEqeGL05vBTUHARhmihHnqcnkXCImasUJj5pFMN0c
         oocg==
Content-Disposition: inline
In-Reply-To: <324b1d0f-42e5-8947-68cb-a3d20135f2c6@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: tj@kernel.org, mkoutny@suse.com, surenb@google.com, gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 25, 2022 at 08:28:39PM +0800, Chengming Zhou wrote:
> On 2022/8/24 17:59, Johannes Weiner wrote:
> > Hi Chengming,
> > 
> > Thanks for incorporating all the feedback. I have a few nitpicks
> > below, but with those considered, please add:
> > 
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > On Wed, Aug 24, 2022 at 04:18:29PM +0800, Chengming Zhou wrote:
> >> @@ -5171,12 +5220,19 @@ static struct cftype cgroup_base_files[] = {
> >>  	{
> >>  		.name = "irq.pressure",
> >>  		.flags = CFTYPE_PRESSURE,
> >> +		.file_offset = offsetof(struct cgroup, psi_files[PSI_IRQ]),
> >>  		.seq_show = cgroup_irq_pressure_show,
> >>  		.write = cgroup_irq_pressure_write,
> >>  		.poll = cgroup_pressure_poll,
> >>  		.release = cgroup_pressure_release,
> >>  	},
> >>  #endif
> >> +	{
> >> +		.name = "cgroup.pressure",
> >> +		.flags = CFTYPE_PRESSURE,
> >> +		.seq_show = cgroup_psi_show,
> >> +		.write = cgroup_psi_write,
> > 
> > To match the naming convention, these should be called
> > cgroup_pressure_show() and cgroup_pressure_write().
> 
> I just find cgroup_pressure_write() already exists, so I change the names
> to cgroup_pressure_enable_show() and cgroup_pressure_enable_write(),
> since this file name is simplified from "cgroup.pressure.enable".

That makes two outliers instead of one. It's probably better to steal
cgroup_pressure_write for cgroup.pressure, and rename the currently
misnamed helper. How about do_pressure_write()? pressure_write()?
