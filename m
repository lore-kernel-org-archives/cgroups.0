From: Juri Lelli <juri.lelli@redhat.com>
Subject: Re: [PATCH v6 3/5] cgroup/cpuset: make callback_lock raw
Date: Tue, 5 Feb 2019 10:18:01 +0100
Message-ID: <20190205091801.GD30905@localhost.localdomain>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
 <20190117084739.17078-4-juri.lelli@redhat.com>
 <20190204115550.GB17550@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190204115550.GB17550@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On 04/02/19 12:55, Peter Zijlstra wrote:
> On Thu, Jan 17, 2019 at 09:47:37AM +0100, Juri Lelli wrote:
> > @@ -2366,7 +2366,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
> >  	cpuset_filetype_t type = seq_cft(sf)->private;
> >  	int ret = 0;
> >  
> > -	spin_lock_irq(&callback_lock);
> > +	raw_spin_lock_irq(&callback_lock);
> >  
> >  	switch (type) {
> >  	case FILE_CPULIST:
> > @@ -2388,7 +2388,7 @@ static int cpuset_common_seq_show(struct seq_file *sf, void *v)
> >  		ret = -EINVAL;
> >  	}
> >  
> > -	spin_unlock_irq(&callback_lock);
> > +	raw_spin_unlock_irq(&callback_lock);
> >  	return ret;
> >  }
> >  
> could we not convert this to use cpuset_mutex ?

Looks like we can.

I'll do the change.
