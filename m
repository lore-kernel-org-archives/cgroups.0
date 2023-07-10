From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/9] cgroup/cpuset: Support remote partitions
Date: Mon, 10 Jul 2023 11:08:30 -1000
Message-ID: <ZKxzTrN2yiKfXndI@slm.duckdns.org>
References: <20230627143508.1576882-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689023312; x=1691615312;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2WumLpz2xEP5+8PT8olwpPEOtDAiclqdr88UfJwne5c=;
        b=OhfDziLrK2LihIMSV6Z5P3zQNZYTDuSYuR8reJ6mavc6O7MDoHRKA37qk5HQD1rPhV
         GMX25JEahad1Ok1SEOZx1cHicb1IDroG39pagy2/Iic6K5MpsmwB5YxGzB11o0SixbS7
         wZwZgDiKPWl0PdZFMh+yU0+2rVPvzI5y2LLoekGFF27w7Kd59mgZ996dPc/NKNnvra1u
         klwVwjPUt+5La3erZOgYk6H1rkrMWsPghzZTGFHHQRwaex8geYy/fp/P5OHXO7ByuyzQ
         hytxk+WWevZj71KI0BUNYig41ytJDNHpcw1qJ1zelX7bzxhPIKNW4EiL8+AtK17SvzWF
         rcEA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20230627143508.1576882-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>

Hello, Waiman.

I applied the prep patches. They look good on their own.

On Tue, Jun 27, 2023 at 10:34:59AM -0400, Waiman Long wrote:
...
> cpuset. Unlike "cpuset.cpus", invalid input to "cpuset.cpus.exclusive"
> will be rejected with an error. This new control file has no effect on

We cannot maintain this as an invariant tho, right? For example, what
happens when a parent cgroup later wants to withdraw a CPU from its
cpuset.cpus which should always be allowed regardless of what its
descendants are doing? Even with cpus.exclusive itself, I think it'd be
important to always allow ancestors to be able to withdraw from the
commitment as with other resources. I suppose one can argue that giving
exclusive access to CPUs is a special case which doesn't follow this rule
but cpus.exclusive having to be nested inside cpus which is subject to that
rule makes that combination too contorted.

Would it be difficult to follow how isolation modes behave when the target
configuration can't be achieved?

Thanks.

-- 
tejun
