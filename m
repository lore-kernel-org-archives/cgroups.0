From: Roman Gushchin <guro@fb.com>
Subject: Re: [v9 3/5] mm, oom: cgroup-aware OOM killer
Date: Wed, 4 Oct 2017 16:04:52 +0100
Message-ID: <20171004150452.GA23299@castle>
References: <20170927130936.8601-1-guro@fb.com>
 <20170927130936.8601-4-guro@fb.com>
 <20171003114848.gstdawonla2gmfio@dhcp22.suse.cz>
 <20171003123721.GA27919@castle.dhcp.TheFacebook.com>
 <20171003133623.hoskmd3fsh4t2phf@dhcp22.suse.cz>
 <20171003140841.GA29624@castle.DHCP.thefacebook.com>
 <20171003142246.xactdt7xddqdhvtu@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=e8Ba5IA8V7v9ISnuIymEVBSgUYYB1oQkLj76WII8AnY=;
 b=jQFORA8+ZFJyktuGy1a0IMeY3kiwGsggXgxeDjVsg0UtP9PDK/gL0mjW6jxVu1oN08X2
 y/FMFOjYIshp82nuI4nwmTn/UT6enUTeZf+oYqQ1N7tuubCk7PDyF895EjW2fNiVn9l0
 MaPz/E5Mr5uWDkdkyy4S0tKJJ9GWFbNYLzU= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=e8Ba5IA8V7v9ISnuIymEVBSgUYYB1oQkLj76WII8AnY=;
 b=WfNUsDHlwJCccurddLCTuqCojeEqp47QgYry+ETsbVVI1q2bpTWVrs2xnBUyMh3iw09F5f74H14P7p1RqKVn81pGk0U9WTzQ/VvC0ovQ9y4tLKzFM4HZj3F0lEIH0RJOIC/PlAC0EqHvAyuL7AFFjLd0/TMYvuSFTWX1hL/i0fo=
Content-Disposition: inline
In-Reply-To: <20171003142246.xactdt7xddqdhvtu@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, David Rientjes <rientjes@google.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Oct 03, 2017 at 04:22:46PM +0200, Michal Hocko wrote:
> On Tue 03-10-17 15:08:41, Roman Gushchin wrote:
> > On Tue, Oct 03, 2017 at 03:36:23PM +0200, Michal Hocko wrote:
> [...]
> > > I guess we want to inherit the value on the memcg creation but I agree
> > > that enforcing parent setting is weird. I will think about it some more
> > > but I agree that it is saner to only enforce per memcg value.
> > 
> > I'm not against, but we should come up with a good explanation, why we're
> > inheriting it; or not inherit.
> 
> Inheriting sounds like a less surprising behavior. Once you opt in for
> oom_group you can expect that descendants are going to assume the same
> unless they explicitly state otherwise.

Not sure I understand why. Setting memory.oom_group on a child memcg
has absolutely no meaning until memory.max is also set. In case of OOM
scoped to the parent memcg or above, parent's value defines the behavior.

If a user decides to create a separate OOM domain (be setting the hard
memory limit), he/she can also make a decision on how OOM event should
be handled.

Thanks!
