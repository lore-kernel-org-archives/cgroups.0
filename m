From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: Throttle allocators when failing reclaim over
 memory.high
Date: Fri, 1 Feb 2019 11:12:33 -0500
Message-ID: <20190201161233.GA11231@cmpxchg.org>
References: <20190201011352.GA14370@chrisdown.name>
 <20190201071757.GE11599@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=quiXn0eW8gENJQ2gJS+neNMOBIo/LLkWdIc48RQXTDM=;
        b=FJxtzyGWgskESR2k9L9isn828AO09+N+HuP3nAaDzFlbGiyI3IkRb+dI95b+qwHsFp
         taGu2/RGTS5RRJ9/Z5NiCbZDursEgcB8TqiiadpPycaR3JpyIY/J9RMNC4UvQwNXYEO6
         fCCT/0zdkELpkSqG/BBHYrSARXYUo/vOIfTH36h9Q2RSZ8lpWN7hgHmn0S0j57ey5ZCU
         IfzwwodbNPzWByHoHSoMWYAg2iOdSzGq83AW/VX9T99e5J6YTDt6Y1qyPudl/hw+d9N3
         aqkMde8RGGcBdEvy/8yMKeq3OfF0pJoavBeMkjiczMWFwZZ9wm9xKrgSQHxuAie9R+5k
         3LNg==
Content-Disposition: inline
In-Reply-To: <20190201071757.GE11599@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Fri, Feb 01, 2019 at 08:17:57AM +0100, Michal Hocko wrote:
> On Thu 31-01-19 20:13:52, Chris Down wrote:
> [...]
> > The current situation goes against both the expectations of users of
> > memory.high, and our intentions as cgroup v2 developers. In
> > cgroup-v2.txt, we claim that we will throttle and only under "extreme
> > conditions" will memory.high protection be breached. Likewise, cgroup v2
> > users generally also expect that memory.high should throttle workloads
> > as they exceed their high threshold. However, as seen above, this isn't
> > always how it works in practice -- even on banal setups like those with
> > no swap, or where swap has become exhausted, we can end up with
> > memory.high being breached and us having no weapons left in our arsenal
> > to combat runaway growth with, since reclaim is futile.
> > 
> > It's also hard for system monitoring software or users to tell how bad
> > the situation is, as "high" events for the memcg may in some cases be
> > benign, and in others be catastrophic. The current status quo is that we
> > fail containment in a way that doesn't provide any advance warning that
> > things are about to go horribly wrong (for example, we are about to
> > invoke the kernel OOM killer).
> > 
> > This patch introduces explicit throttling when reclaim is failing to
> > keep memcg size contained at the memory.high setting. It does so by
> > applying an exponential delay curve derived from the memcg's overage
> > compared to memory.high.  In the normal case where the memcg is either
> > below or only marginally over its memory.high setting, no throttling
> > will be performed.
> 
> How does this play wit the actual OOM when the user expects oom to
> resolve the situation because the reclaim is futile and there is nothing
> reclaimable except for killing a process?

Hm, can you elaborate on your question a bit?

The idea behind memory.high is to throttle allocations long enough for
the admin or a management daemon to intervene, but not to trigger the
kernel oom killer. It was designed as a replacement for the cgroup1
oom_control, but without the deadlock potential, ptrace problems etc.

What we specifically do is to set memory.high and have a daemon (oomd)
watch memory.pressure, io.pressure etc. in the group. If pressure
exceeds a certain threshold, the daemon kills something.

As you know, the kernel OOM killer does not kick in reliably when
e.g. page cache is thrashing heavily, since from a kernel POV it's
still successfully allocating and reclaiming - meanwhile the workload
is spending most its time in page faults. And when the kernel OOM
killer does kick in, its selection policy is not very workload-aware.

This daemon on the other hand can be configured to 1) kick in reliably
when the workload-specific tolerances for slowdowns and latencies are
violated (which tends to be way earlier than the kernel oom killer
usually kicks in) and 2) know about the workload and all its
components to make an informed kill decision.

Right now, that throttling mechanism works okay with swap enabled, but
we cannot enable swap everywhere, or sometimes run out of swap, and
then it breaks down and we run into system OOMs.

This patch makes sure memory.high *always* implements the throttling
semantics described in cgroup-v2.txt, not just most of the time.
