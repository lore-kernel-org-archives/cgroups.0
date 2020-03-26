From: Joel Fernandes <joel@joelfernandes.org>
Subject: Re: [PATCH RFC] cpuset: Make cpusets get restored on hotplug
Date: Thu, 26 Mar 2020 15:44:48 -0400
Message-ID: <20200326194448.GA133524@google.com>
References: <20200326191623.129285-1-joel@joelfernandes.org>
 <20200326192035.GO162390@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Vz8M+WY12BuCsCLe/S9A2YcP2dqH4GItbGgYzpSKVks=;
        b=Wvi8sFDy3Xelku+ev0Z+8Z88gUwLdh49TKjzgpvENdRnjLybfJv52p2eJGWj4Po7mX
         9ZiDd3dnWbFl0RVSEDSIc7JcCinAuAswL3ehy/VJRT+S+Z294BqheymwNr9VaspjVkRw
         jDTamd/KQWz5bhF0xB8oGvoDFbXtqoH/LflMo=
Content-Disposition: inline
In-Reply-To: <20200326192035.GO162390@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Dmitry Shmidt <dimitrysh@google.com>, Amit Pundir <amit.pundir@linaro.org>, kernel-team@android.com, jsbarnes@google.com, sonnyrao@google.com, vpillai@digitalocean.com, peterz@infradead.org, Guenter Roeck <groeck@chromium.org>, Waiman Long <longman@redhat.com>, Greg Kerr <kerrnel@google.com>, cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>

Hi Tejun,

On Thu, Mar 26, 2020 at 03:20:35PM -0400, Tejun Heo wrote:
> On Thu, Mar 26, 2020 at 03:16:23PM -0400, Joel Fernandes (Google) wrote:
> > This deliberately changes the behavior of the per-cpuset
> > cpus file to not be effected by hotplug. When a cpu is offlined,
> > it will be removed from the cpuset/cpus file. When a cpu is onlined,
> > if the cpuset originally requested that that cpu was part of the cpuset,
> > that cpu will be restored to the cpuset. The cpus files still
> > have to be hierachical, but the ranges no longer have to be out of
> > the currently online cpus, just the physically present cpus.
> 
> This is already the behavior on cgroup2 and I don't think we want to
> introduce this big a behavior change to cgroup1 cpuset at this point.

It is not really that big a change. Please go over the patch, we are not
changing anything with how ->cpus_allowed works and interacts with the rest
of the system and the scheduler. We have just introduced a new mask to keep
track of which CPUs were requested without them being affected by hotplug. On
CPU onlining, we restore the state of ->cpus_allowed as not be affected by
hotplug.

There's 3 companies that have this issue so that should tell you something.
We don't want to carry this patch forever. Many people consider the hotplug
behavior to be completely broken.

thanks,

 - Joel

