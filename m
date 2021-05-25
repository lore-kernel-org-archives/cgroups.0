From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 1/1] cgroup: make per-cgroup pressure stall tracking
 configurable
Date: Tue, 25 May 2021 09:00:30 -0400
Message-ID: <YKz07nx3E8UEo1xa@cmpxchg.org>
References: <20210524195339.1233449-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Y28saWW4RbQx7WFyioP30Xg1gnMSgGnjvex8TrgoAmQ=;
        b=SmfdiXxkr36Ea/32dUzc9goah/P/GDAmfDbfC23QxapWU+TYijU+tfipqVELo7UnNb
         kCjW74Q30JDB5fgFGsHqgJCEmxBDKG9IApVbKABuX/KOwPBR0S9vlJjymq+MrMGk51h3
         6ydpK/iuWp9N2XdHcbwhGAfcdpizobjsabPIpm0tzrNvmu9Bxekatij9qaP2uru6JWkm
         9Q/bdYcBQsR1yN1XYUK+IHclcbpDWwfEhDxrstMqMj+GfnNWOoDjxxvTrZpSn3pYUBV+
         tBirFOf/cNxOyaXXED4cDuzfXDrAdEmlM6leYVvOPcAJrsNxmqDTUvm5putYq5K3bzNj
         AP8g==
Content-Disposition: inline
In-Reply-To: <20210524195339.1233449-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: tj@kernel.org, lizefan.x@bytedance.com, mingo@redhat.com, peterz@infradead.org, shakeelb@google.com, juri.lelli@redhat.com, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, mgorman@suse.de, minchan@kernel.org, corbet@lwn.net, bristot@redhat.com, paulmck@kernel.org, rdunlap@infradead.org, akpm@linux-foundation.org, tglx@linutronix.de, macro@orcam.me.uk, viresh.kumar@linaro.org, mike.kravetz@oracle.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, kernel-team@android.com

On Mon, May 24, 2021 at 12:53:39PM -0700, Suren Baghdasaryan wrote:
> PSI accounts stalls for each cgroup separately and aggregates it at each
> level of the hierarchy. This causes additional overhead with psi_avgs_work
> being called for each cgroup in the hierarchy. psi_avgs_work has been
> highly optimized, however on systems with large number of cgroups the
> overhead becomes noticeable.
> Systems which use PSI only at the system level could avoid this overhead
> if PSI can be configured to skip per-cgroup stall accounting.
> Add "cgroup_disable=pressure" kernel command-line option to allow
> requesting system-wide only pressure stall accounting. When set, it
> keeps system-wide accounting under /proc/pressure/ but skips accounting
> for individual cgroups and does not expose PSI nodes in cgroup hierarchy.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
