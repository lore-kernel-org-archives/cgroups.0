From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH] mm: memcontrol: reign in CONFIG space madness
Date: Thu, 10 Dec 2015 12:15:59 -0500
Message-ID: <20151210171559.GA4642@cmpxchg.org>
References: <20151209203004.GA5820@cmpxchg.org>
 <20151210134031.GN19496@dhcp22.suse.cz>
 <20151210150650.GA1431@cmpxchg.org>
 <20151210161212.GB11778@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151210161212.GB11778@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Dec 10, 2015 at 05:12:12PM +0100, Michal Hocko wrote:
> This is what we call a review process. Raise concerns and deal with
> them. My review hasn't implied this would be a show stopper or block
> those change to get merged. I was merely asking whether we can keep
> the code size with a _reasonable_ maintenance burden. If the answer is
> no then I can live with that even when I might not like that fact. That
> has been reflected by a lack of my acked-by.

Everything we do bears a cost, our entire work is making tradeoffs
(with a few exceptions where code is just dumb). So when you bring up
cost, you have to weigh it against what you're trading off. There is
simply no value in saying "this costs X" and nothing else. It's
meaningless on its own. Unless X is so unreasonably large that there
MUST be another way of doing it, and investing the time is worth it.

8K is not unreasonably large given the history and overall trend of
the memcg code. And the only possible tradeoff is to make even more
CONFIG options and encourage balkanization of cgroup users, which is
hardly a reasonable route to go down. So what exactly ARE you saying
when you post `size' results that you don't consider show stoppers?
That you don't like increasing the kernel size? Do you think I do?

Pointing out the unexpected (bugs, excessive cost, design problems) is
part of a healthy review process. Proposing a different tradeoff,
supported by a cost/benefit analysis in both directions is useful.

What's happening here is definitely not a constructive review process.

> You sound as if you had to overrule a nack which sounds like over
> reacting because this is not the case.

Issues raised are usually considered showstoppers unless it's clear
from the way they're raised that we can live with them.

And I'm tired of having the same discussion over and over.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
