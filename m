From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 4 Apr 2022 11:25:35 -0700
Message-ID: <Yks4H1pQx1YN37gH@carbon.dhcp.thefacebook.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <YkXkA+Oh1Bx33PrU@carbon.dhcp.thefacebook.com>
 <YkcC3z5ReeQ5vdg9@dhcp22.suse.cz>
 <YkcvU2hosJV3cL8F@carbon.dhcp.thefacebook.com>
 <Ykqv1CvGwgmF2jlT@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1649096743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Og7JJS97Y7kZpeaH/i0wuDH1r4Ru5n8sJ0IhUTsaTkc=;
        b=IFf94GWr/6nr/4HgPNIQTPJGHrC3WBKmIpRxtM36jz9zsR04NOjeL/8OfSzqcvZG0zgjq5
        bxiztvliLfe6bwYLU/TybmMsDuIL3Dv81VLiVs4OB9hzOhwlSPvHK8CDaU4e7vrJKGzg2u
        I0k54olorsvEY4ZnPZLQZx8TVXRhjg8=
Content-Disposition: inline
In-Reply-To: <Ykqv1CvGwgmF2jlT@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Mon, Apr 04, 2022 at 10:44:04AM +0200, Michal Hocko wrote:
> On Fri 01-04-22 09:58:59, Roman Gushchin wrote:
> > On Fri, Apr 01, 2022 at 03:49:19PM +0200, Michal Hocko wrote:
> > > On Thu 31-03-22 10:25:23, Roman Gushchin wrote:
> > > > On Thu, Mar 31, 2022 at 08:41:51AM +0000, Yosry Ahmed wrote:
> > > [...]
> > > > > - A similar per-node interface can also be added to support proactive
> > > > >   reclaim and reclaim-based demotion in systems without memcg.
> > > > 
> > > > Maybe an option to specify a timeout? That might simplify the userspace part.
> > > 
> > > What do you mean by timeout here? Isn't
> > > timeout $N echo $RECLAIM > ....
> > > 
> > > enough?
> > 
> > It's nice and simple when it's a bash script, but when it's a complex
> > application trying to do the same, it quickly becomes less simple and
> > likely will require a dedicated thread to avoid blocking the main app
> > for too long and a mechanism to unblock it by timer/when the need arises.
> > 
> > In my experience using correctly such semi-blocking interfaces (semi- because
> > it's not clearly defined how much time the syscall can take and whether it
> > makes sense to wait longer) is tricky.
> 
> We have the same approach to setting other limits which need to perform
> the reclaim. Have we ever hit that as a limitation that would make
> userspace unnecessarily too complex?

The difference here is that some limits are most likely set once and
never adjusted, e.g. memory.max or memory.low.
I do definitely remember some issues around memory.high, but as I recall,
we've fixed them on the kernel side. We've even had a private memory.high.tmp
interface with a value and a timeout, which later was replaced with
a memory.reclaim interface similar to what we discuss here.
But with memory.high we set the limit first, so if a user tries to reclaim
a lot of hot memory, it will soon put all processes in the cgroup into
the sleep/direct reclaim. So it's not expected to block for too long.

In general it all comes to the question how hard the kernel should try to
reclaim the memory before giving up. The userspace might have different
needs in different cases. But if the interface is defined very vaguely like
it tries for an undefined amount of time and then gives up, it's hard to
use it in a predictive manner.

Thanks!
