From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] cgroup/cpuset: remove circular dependency deadlock
Date: Wed, 25 Oct 2017 11:30:41 +0200
Message-ID: <20171025093041.GO3165@worktop.lehotels.local>
References: <1504792583-10424-1-git-send-email-prsood@codeaurora.org>
 <20170907175107.GG17526@worktop.programming.kicks-ass.net>
 <4668d1ec-dc43-8a9c-4f94-a421683d3c17@codeaurora.org>
 <20171011094833.pdp4torvotvjdmkt@hirez.programming.kicks-ass.net>
 <00043e79-3647-3979-07bb-27039921efb4@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SrNaMVjtczdVKvWrJ/Ke5gPNt3W6mWQUMRAc3dUaCZA=; b=xIeOqHUQXj5K9jbHlQsFNlMsV
        4TgfqCpEu4xY/5HsUWTCJ49iS8l+mDwHLkRDVCFP3nU5ouYvid0sb7IVNakPX4sKMswIV7j9N2P5G
        ga1cm32S5g0yFYKtZEfZkKP174LsVr18JMNcKjyQWOtZ2544VEywMBcluzNhrTGm49fP5lHlZQXYf
        u+s5jIcTng1WhdyKHYGhHemG8+1l/biTVy6CaiTg9wl4vbezGIOLKdRjdplGOjtKZM51pfR22xSsS
        hejFUy+YBsVu0s5Ky7LxZdnWn51215QYrHhPQZpPJJfJMf6Wz3KQXhwOSqpGEYCrXIXDS9UfPl0zx
      
Content-Disposition: inline
In-Reply-To: <00043e79-3647-3979-07bb-27039921efb4@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Prateek Sood <prsood@codeaurora.org>
Cc: tj@kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, mingo@kernel.org, longman@redhat.com, boqun.feng@gmail.com, tglx@linutronix.de, linux-kernel@vger.kernel.org, sramana@codeaurora.org

On Wed, Oct 25, 2017 at 02:09:54PM +0530, Prateek Sood wrote:
> >  void cpuset_update_active_cpus(void)
> >  {
> > +	mutex_lock(&cpuset_mutex);
> > +	rebuild_sched_domains_cpuslocked();
> > +	mutex_unlock(&cpuset_mutex);
> >  }
> 
> In the above patch rebuild_sched_domains_cpuslocked() has been
> used directly. Earlier cpuset_hotplug_update_tasks() was also
> called from cpuset_hotplug_workfn(). So migration of tasks
> related to cgroup which has empty cpuset would not happen
> during cpu hotplug.
> 
> 
> Could you please help in understanding more on this.
> 

That was me being lazy...
