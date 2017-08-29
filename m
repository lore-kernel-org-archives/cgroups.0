From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroup: Implement cgroup2 basic CPU usage accounting
Date: Tue, 29 Aug 2017 11:32:35 -0400
Message-ID: <02e84780-1ad7-95e3-345e-baec3dc6db84@redhat.com>
References: <20170811163754.3939102-1-tj@kernel.org>
 <20170811163754.3939102-4-tj@kernel.org>
 <20170829143252.6zoes63bwfflukjy@hirez.programming.kicks-ass.net>
 <20170829152426.GL491396@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170829152426.GL491396-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org, efault-Mmb7MZpHnFY@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org

On 08/29/2017 11:24 AM, Tejun Heo wrote:
> Hello, Peter.
>
> On Tue, Aug 29, 2017 at 04:32:52PM +0200, Peter Zijlstra wrote:
>> So I mostly like. On accounting it only adds to the immediate cgroup (if
>> it has a parent, aka !root).
>>
>> On update it does a DFS of all sub-groups and propagates the deltas up
>> to the requested group.
> ...
>> What I don't get is why you need cgroup_cpu_stat_updated(). That is, I
>> see you use it to keep the keep the DFS 'stack' up-to-date, but what I
>> don't see is why you'd need that.
> That is to make reading stats O(number of descendants which have been
> active since last read) instad of O(number of all descendants) as
> there can be a lot of not-too-active cgroups in a system.  Stat
> reading can be frequent, so the combination can get really bad.  By
> keeping the updated list separate, increasing read frequency decreases
> the cost of each read.
>
> Also, please note that a system may end up with a lot of cgroups
> without the user intending to.  memcg drains removed cgroups lazily
> and the number of draining cgroups can reach very high numbers if the
> system isn't under memory pressure.  The plan is to add basic stats
> for other resources too and keeping it scalable w.r.t. idle cgroups
> allows using the same mechanism for all resources.

I think it will be good to put the rationale behind this function as a
comment in the code.

Cheers,
Longman
