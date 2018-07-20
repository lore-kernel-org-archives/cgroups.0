From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Fri, 20 Jul 2018 10:13:54 -0400
Message-ID: <20180720141354.GA1729@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
 <20180717150142.GG2494@hirez.programming.kicks-ass.net>
 <20180718220623.GE2838@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1eKckAY6Q8yGz2v8taoR+58hqhVZAG5hgWuBNXgBA8U=;
        b=akk6uf5jnv3Zy1VFcpTFGgNmaYsJXuDrFH5QUCroLeAF902e3LhFgsUOau+Rbmb69q
         pOsOnvJfUd61S6IgFhCdCenoMS2fG87oXUatq/Y/QVZ8cDIbJ/vM+qmZmmKnRXCkCfPJ
         goofJZTR1N1BD9ct9W7dcOxXr2Jw75gMl6EEGqseQIYZKSaJu7lUJLCSGbcZqSSL45eJ
         jUI0UgMryTmnFRX+6E4ZrC0OWt4mhwe6oHaF21QuAmnUds1FnsmJ3gJDCSBurlox4m98
         zPRTBFzWh9dc0Cg0cfWx6B1UOFSf9Htl6afr6qx/At7erTcDqGGgB1l+O+R6lBNVeZAr
         a1qw==
Content-Disposition: inline
In-Reply-To: <20180718220623.GE2838@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Jul 18, 2018 at 06:06:23PM -0400, Johannes Weiner wrote:
> On Tue, Jul 17, 2018 at 05:01:42PM +0200, Peter Zijlstra wrote:
> > On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> > > +static bool psi_update_stats(struct psi_group *group)
> > > +{
> > > +	u64 some[NR_PSI_RESOURCES] = { 0, };
> > > +	u64 full[NR_PSI_RESOURCES] = { 0, };
> > > +	unsigned long nonidle_total = 0;
> > > +	unsigned long missed_periods;
> > > +	unsigned long expires;
> > > +	int cpu;
> > > +	int r;
> > > +
> > > +	mutex_lock(&group->stat_lock);
> > > +
> > > +	/*
> > > +	 * Collect the per-cpu time buckets and average them into a
> > > +	 * single time sample that is normalized to wallclock time.
> > > +	 *
> > > +	 * For averaging, each CPU is weighted by its non-idle time in
> > > +	 * the sampling period. This eliminates artifacts from uneven
> > > +	 * loading, or even entirely idle CPUs.
> > > +	 *
> > > +	 * We could pin the online CPUs here, but the noise introduced
> > > +	 * by missing up to one sample period from CPUs that are going
> > > +	 * away shouldn't matter in practice - just like the noise of
> > > +	 * previously offlined CPUs returning with a non-zero sample.
> > 
> > But why!? cpuu_read_lock() is neither expensive nor complicated. So why
> > try and avoid it?
> 
> Hm, I don't feel strongly about it either way. I'll add it.

Thinking more about it, this really doesn't buy anything. Whether a
CPU comes online or goes offline during the loop is no different than
that happening right before grabbing the cpus_read_lock(). If we see a
sample from a CPU, we incorporate it, if not we don't.

So it's not so much avoidance as it's lack of reason for synchronizing
against hotplugging in any fashion. The comment is wrong. This noise
it points to is there with and without the lock, and the only way to
avoid it would be to do either for_each_possible_cpu() in that loop or
having a hotplug callback that would flush the offlining CPU bucket
into a holding place for missed dead cpu samples that the aggregation
loop checks every time. Neither of these seem remotely worth the cost.

I'll fix the comment instead.
