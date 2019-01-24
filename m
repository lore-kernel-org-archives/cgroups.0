From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Thu, 24 Jan 2019 13:23:28 -0500
Message-ID: <20190124182328.GA10820@cmpxchg.org>
References: <20190123223144.GA10798@chrisdown.name>
 <20190124082252.GD4087@dhcp22.suse.cz>
 <20190124160009.GA12436@cmpxchg.org>
 <20190124170117.GS4087@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FnNHJQWasIH8ZZGAghYWs1cLQc8v0FeaohIo7b3m2Xs=;
        b=UpO1W59KzBPUdYXozLMYbpPfsOUDVZyeBT4VNzyjJMCY/l6K3zJWWABEBEeRWkuRHU
         moaYIPc8Ndy6AhIYKdEVPAcsxqb7GKa3Uvi2WaT0YOH/ZgP62bvGHFeDML/RDP+/M4wH
         LG8Jv5nZSnzZmA3NYAEkC9h0EK2afBSQapanqLiboWqKMgGgh3Qcy4zmk0HnLhhJtDiU
         AsNi76Rm/cKHHjev068aGpWbJCLD9IJQmZOOC7MVccJiUOfb8f2CO1ZL6Qq+yOtltZXj
         aKcUuF9GSaNpHjQHFlKd4c2Yb0yTIrcXVKncNb0+y0QwM9zIplkaE+poacFzbo1cYYYF
         Nz0Q==
Content-Disposition: inline
In-Reply-To: <20190124170117.GS4087@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu, Jan 24, 2019 at 06:01:17PM +0100, Michal Hocko wrote:
> On Thu 24-01-19 11:00:10, Johannes Weiner wrote:
> [...]
> > We cannot fully eliminate a risk for regression, but it strikes me as
> > highly unlikely, given the extremely young age of cgroup2-based system
> > management and surrounding tooling.
> 
> I am not really sure what you consider young but this interface is 4.0+
> IIRC and the cgroup v2 is considered stable since 4.5 unless I
> missrememeber and that is not a short time period in my book.

If you read my sentence again, I'm not talking about the kernel but
the surrounding infrastructure that consumes this data. The risk is
not dependent on the age of the interface age, but on its adoption.

> Changing interfaces now represents a non-trivial risk and so far I
> haven't heard any actual usecase where the current semantic is
> actually wrong.  Inconsistency on its own is not a sufficient
> justification IMO.

It can be seen either way, and in isolation it wouldn't be wrong to
count events on the local level. But we made that decision for the
entire interface, and this file is the odd one out now. From that
comprehensive perspective, yes, the behavior is wrong. It really
confuses people who are trying to use it, because they *do* expect it
to behave recursively.

I'm really having a hard time believing there are existing cgroup2
users with specific expectations for the non-recursive behavior...
