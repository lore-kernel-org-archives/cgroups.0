From: Mike Galbraith <efault@gmx.de>
Subject: Re: [PATCH v4] cpuset: Enable cpuset controller in default hierarchy
Date: Tue, 20 Mar 2018 05:25:41 +0100
Message-ID: <1521519941.24215.2.camel@gmx.de>
References: <1c3fe7b0-2600-c46d-1527-d3aaf024bb91@redhat.com>
         <1520619426.27998.18.camel@gmx.de>
         <55809fe4-98ba-5566-86ed-457acfef0e1c@redhat.com>
         <1520624424.27998.76.camel@gmx.de>
         <53de9683-01b7-bac4-8b70-dc1f93ede600@redhat.com>
         <20180309221736.GB5926@hirez.programming.kicks-ass.net>
         <f0fca497-e4e7-3dbd-1e5c-a7f502c05dcb@redhat.com>
         <1520653648.12749.20.camel@gmx.de>
         <20180314195711.GD2943022@devbig577.frc2.facebook.com>
         <1521082141.7100.1.camel@gmx.de>
         <20180319153413.GO2943022@devbig577.frc2.facebook.com>
         <1521492550.16869.1.camel@gmx.de>
         <a334a234-3e87-a9a7-9589-8476fecb4149@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a334a234-3e87-a9a7-9589-8476fecb4149@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>

On Mon, 2018-03-19 at 17:41 -0400, Waiman Long wrote:
> On 03/19/2018 04:49 PM, Mike Galbraith wrote:
> > On Mon, 2018-03-19 at 08:34 -0700, Tejun Heo wrote:
> >> Hello, Mike.
> >>
> >> On Thu, Mar 15, 2018 at 03:49:01AM +0100, Mike Galbraith wrote:
> >>> Under the hood v2 details are entirely up to you.  My input ends at
> >>> please don't leave dynamic partitioning standing at the dock when v2
> >>> sails.
> >> So, this isn't about implementation details but about what the
> >> interface achieves - ie, what's the actual function?  The only thing I
> >> can see is blocking the entity which is configuring the hierarchy from
> >> making certain configs.  While that might be useful in some specific
> >> use cases, it seems to miss the bar for becoming its own kernel
> >> feature.  After all, nothing prevents the same entity from clearing
> >> the exlusive bit and making the said changes.
> > Yes, privileged contexts can maliciously or stupidly step all over one
> > other no matter what you do (finite resource), but oxymoron creation
> > (CPUs simultaneously balanced and isolated) should be handled.  If one
> > context can allocate a set overlapping a set another context intends to
> > or already has detached from scheduler domains, both are screwed.
> >
> > 	-Mike
> 
> The allocations of CPUs to child cgroups should be controlled by the
> parent cgroup. It is the parent's fault if some CPUs are in both
> balanced and isolated cgroups.
> 
> How about we don't allow turning off scheduling if the CPUs aren't
> exclusive from the parent's perspective? So you can't create an isolated
> cgroup if the CPUs aren't exclusive. Will this be a good enough compromise?

Sure.  The kernel need only ensure its own sanity.  Userspace conflicts
are more or less a non-issue.  In practice, all players but one will
have been constrained or eliminated prior to any partitioning.

	-Mike
