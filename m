From: bsegall@google.com
Subject: Re: [PATCH v4 1/1] sched/fair: Return all runtime when cfs_b has very little remaining.
Date: Thu, 27 Jun 2019 13:18:08 -0700
Message-ID: <xm26pnmywznj.fsf@bsegall-linux.svl.corp.google.com>
References: <1558121424-2914-1-git-send-email-chiluk+linux@indeed.com>
        <1561391404-14450-1-git-send-email-chiluk+linux@indeed.com>
        <1561391404-14450-2-git-send-email-chiluk+linux@indeed.com>
        <xm26tvcex50s.fsf@bsegall-linux.svl.corp.google.com>
        <CAC=E7cUxcNkc7T7AXCr3PO6rqqxrk269JW3SDnXG-LtO-6-BVQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version;
        bh=S0lkRqMuPGYVFDWL/aCSm9jlU++otPFj3p6mx8+rEfU=;
        b=lcXiMKYy7faHTeobky/d/atpZ34DqKNpFa5w/YRy+2wzQioqbugwenqZuVgZ9qqR01
         UtG5m7TVMIqxtREqc5LGU4ZmDErwg5uU2i84zvYNkhkHDZAk+rLoNYmWmg5ck5XTfrZg
         gVOXUB5HmN4D3RGUkQlXsDx/3R4bbn6aD5bQBEFjLCg3OEeCBIoSspKUuRYfM28xmWPJ
         8T+l6ZNKDOi4kXlQ4R2GAqLCiwJ7/afzkXcTcL9pH/ky4e2bNYtTG7gwqliOVTUchuiw
         EBZmXYBiY0Pb2+UdhnPMkeCrdvB4yCOtqjrUKvZ9puwRPT49A39ia0hPl9Ik6SHMh5b1
         Nl4Q==
In-Reply-To: <CAC=E7cUxcNkc7T7AXCr3PO6rqqxrk269JW3SDnXG-LtO-6-BVQ@mail.gmail.com>
        (Dave Chiluk's message of "Wed, 26 Jun 2019 17:10:04 -0500")
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chiluk <chiluk+linux@indeed.com>
Cc: Phil Auld <pauld@redhat.com>, Peter Oskolkov <posk@posk.io>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Brendan Gregg <bgregg@netflix.com>, Kyle Anderson <kwa@yelp.com>, Gabriel Munos <gmunoz@netflix.com>, John Hammond <jhammond@indeed.com>, Cong Wang <xiyou.wangcong@gmail.com>

Dave Chiluk <chiluk+linux@indeed.com> writes:

> On Mon, Jun 24, 2019 at 10:33:07AM -0700, bsegall@google.com wrote:
>> This still has a similar cost as reducing min_cfs_rq_runtime to 0 - we
>> now take a tg-global lock on every group se dequeue. Setting min=0 means
>> that we have to take it on both enqueue and dequeue, while baseline
>> means we take it once per min_cfs_rq_runtime in the worst case.
> Yep, it's only slightly better than simply setting min_cfs_rq_runtime=0.
> There's definitely a tradeoff of having to grab the lock every time.
>
> The other non-obvious benefit to this is that when the application
> starts hitting throttling the entire application starts hitting
> throttling closer to simultaneously.  Previously, threads that don't do
> much could continue sipping on their 1ms of min_cfs_rq_runtime, while
> main threads were throttled.  With this the application would more or
> less halt within 5ms of full quota usage.
>
>> In addition how much this helps is very dependent on the exact pattern
>> of sleep/wake - you can still strand all but 15ms of runtime with a
>> pretty reasonable pattern.
>
> I thought this change would have an upper bound stranded time of:
> NUMCPUs * min_cfs_rq_runtime - 3 * sched_cfs_bandwidth_slice().
> From the stranding of 1ms on each queue minues the amount that we'd
> return when we forcibly hit the 3 x bandwidth slice Am I missing
> something here? Additionally that's worst case, and would require that
> threads be scheduled on distinct cpus mostly sequentially, and then
> never run again.

Yeah, to be exact it's that. It's just that this is only relevant at all
when NUMCPUs*min_cfs_rq_runtime is at least a significant fraction of
quota, and when "scheduled on distinct cpus, and then never run again"
happens. How sequential it needs to be depends on the threads vs num
cpus.


>
>> If the cost of taking this global lock across all cpus without a
>> ratelimit was somehow not a problem, I'd much prefer to just set
>> min_cfs_rq_runtime = 0. (Assuming it is, I definitely prefer the "lie
>> and sorta have 2x period 2x runtime" solution of removing expiration)
>
> Can I take this as an technical ack of the v3 patchset?  Do you have any
> other comments for that patchset you'd like to see corrected before it
> gets integrated?  If you are indeed good with that patchset, I'll clean
> up the comment and Documentation text and re-submit as a v5 patchset. I
>
> actually like that patchset best as well, for all the reasons already
> discussed.  Especially the one where it's been running like this for 5
> years prior to 512ac999.
>
> Also given my new-found understanding of min_cfs_rq_runtime, doesn't
> this mean that if we don't expire runtime we could potentially have a
> worst case of 1ms * NUMCPUs of extra runtime instead of 2x runtime?
> This is because min_cfs_rq_runtime could theoretically live on a per-cpu
> indefinitely?  Still this is actually much smaller than I previously had
> feared.  Also it still holds that average runtime is still bounded by
> runtime/period on average.

Yeah, I think I was misremembering or thinking only about one example or
something. Meanwhile I'm thinking this is potentially /worse/ than just
2x runtime per 2x period, though obviously it depends on cpus vs quota.


One thing I'm trying now is if we made the slack timer go and collect
all the min_cfs_rq_runtime left behind, which would provide something
similar to the min=0 case for fixing not only this but other cases of
stranding bandwidth, but also some level of rate limiting.



>
> Thanks
