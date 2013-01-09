From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 11/11] sched: introduce cgroup file stat_percpu
Date: Wed, 9 Jan 2013 13:17:05 -0800
Message-ID: <20130109131705.4156ba5c.akpm@linux-foundation.org>
References: <1357731938-8417-1-git-send-email-glommer@parallels.com>
	<1357731938-8417-12-git-send-email-glommer@parallels.com>
	<20130109124220.ad9f1a54.akpm@linux-foundation.org>
	<50EDDCAA.6070004@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <50EDDCAA.6070004@parallels.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>

On Thu, 10 Jan 2013 01:10:02 +0400
Glauber Costa <glommer@parallels.com> wrote:

> The main advantage I see in this approach, is that there is way less
> data to be written using a header. Although your way works, it means we
> will write the strings "nice", "system", etc. #cpu times. Quite a waste.

Yes, overhead can be a significant issue with this type of interface. 
But we already incurred a massive overhead by using a human-readable
ascii interface.  If performance is an issue, perhaps the whole thing
should be grafted onto taskstats instead.  Or create a new
taskstats-like thing.

btw, a more typical interface would be

cat /.../cpu0
nice:nn
system:nn
irq:nn

- the traditional one-per-line name:value tuples.  But I'd assumed that
having a file per CPU would be aawkward.
