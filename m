From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: Enforce that a child's cpus must be a subset of
 the parent
Date: Thu, 31 May 2018 09:19:42 -0700
Message-ID: <20180531161942.GW1351649@devbig577.frc2.facebook.com>
References: <1527687991-1431-1-git-send-email-longman@redhat.com>
 <5B0F4F09.9050100@huawei.com>
 <5B0FAE72.1090204@huawei.com>
 <20180531082613.GF12180@hirez.programming.kicks-ass.net>
 <5B0FB58C.9030705@huawei.com>
 <4dc718bc-4bd5-4998-853b-9c6ba67b89a0@redhat.com>
 <20180531155807.GU1351649@devbig577.frc2.facebook.com>
 <20180531161645.GN12180@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iXsud8AO/VqPMP/AUI6IhoSYiSKrR2rIe4R3EMYxks8=;
        b=I1wD6JR/fg78umobxEsQSa/wh4sKp9DwYzSCEkFiLV7TUTM0UhIn0CsfOcXpPXyryj
         ITajAI2mLRooBLku3CeTLiw0hpuDwmgs+pjbWU8CyS7JsVAT2po2UNVLD0n+OIgdn59J
         nYma4et5+pklxkZzMS9paLVAoU6NkHp+F5owp1nEruNJdfDxhIv0ToDYzpPjI807v6Qw
         IVQT4D9KxLWXrPA8EF/cI73kQODdarKAQwf2UFB4oRV46+TMc0bCs87iIjfZSu8Ipd9r
         BKo98jyPQlkVuhBBghHuqTvhxa48Ncl1EBrwutTj9v6JxEC7MiJ6ejrhzlVJMk6Uk7nK
         q4Zw==
Content-Disposition: inline
In-Reply-To: <20180531161645.GN12180@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Waiman Long <longman@redhat.com>, Zefan Li <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>

Hello,

On Thu, May 31, 2018 at 06:16:45PM +0200, Peter Zijlstra wrote:
> > So, let's please stay away from it even if that means a bit of
> > overhead in terms of interface.
> 
> Urgh, that again :/

Yeah, well, it's pretty important.

> I'm still not convinced by your arguments though. The root container can
> access all the sub-groups anyway and can grub around in them to take
> away resources if it really wants to.

That's really messy and if you delegated away a subtree, you can't
walk the subtree in a race free way, not easily anyway.

> For cpuset in particular randomly restricting on the ancestor level can
> create an unrecoverable trainwreck inside a container. Affinities are
> not recoverable. Once a runnable task ends up with an empty set, its
> affinities are reset and the smaller (empty) set is lost.

Yeah, for cpuset, it's messier, but it isn't different from hotunplug
scenario, right?  I think the best we can do there is putting ancestor
operation on an equal footing as hotplug ops.

Thanks.

-- 
tejun
