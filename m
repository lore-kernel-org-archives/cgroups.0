From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 16:46:33 +0100
Message-ID: <20191217154633.GE7272@dhcp22.suse.cz>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
 <20191217144652.GA7272@dhcp22.suse.cz>
 <20191217150921.GA136178@chrisdown.name>
 <20191217151931.GD7272@dhcp22.suse.cz>
 <20191217152814.GB136178@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20191217152814.GB136178@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Qian Cai <cai@lca.pw>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 17-12-19 15:28:14, Chris Down wrote:
> Michal Hocko writes:
> > On Tue 17-12-19 15:09:21, Chris Down wrote:
> > [...]
> > > (Side note: I'm moderately baffled that a tightly scoped __maybe_unused is
> > > considered sinister but somehow disabling -Wunused-function is on the table
> > > :-))
> > 
> > Well, I usually do not like to see __maybe_unused because that is prone
> > to bit-rot and loses its usefulness. Looking into the recent git logs
> > most -Wunused-function led to the code removal (which is really good
> > but the compiler is likely to do that already so the overall impact is
> > not that large) or more ifdefery. I do not really see many instance of
> > __maybe_unused.
> 
> Hmm, but __maybe_unused is easy to find and document the reasons behind
> nearby, and then reevaluate at some later time. On the other hand, it's much
> *harder* to reevaluate which functions actually are unused in the long term
> if we remove -Wunused-function, because enabling it to find candidates will
> result in an incredibly amount of noise from those who have missed unused
> functions previously due to the lack of the warning.

I usually git grep for the function and that covers many cases. But
realistically, I am more than skeptical people are going to do a regular
cleanup like that. And that is the biggest deal with this annotation.
Once it gets marked it will just stay that way and potentially get
really unused eventually. So the overall benefit is close the zero in
that case.

Maybe dropping -Wunused-function is an overreaction. Git log shows there
has been some code removed which is probably the most viable reaction to
those reports. Maybe we just want to add those for W=1 or something like
that.

> Maybe Qian is right and we should just ignore such patches, but I think that
> comes with its own risks that we will alienate perfectly well intentioned
> new contributors to mm without them having any idea why we did that.

I believe that both possitive and negative reaction to _any_ patch has
to be properly justified - same applies to the patch itself. A warning
report/fix is not an expcetion. In this particular case it has been pointed
out that the reported function is a general purpose one which just
happens to be used only for CONFIG_SWAP (rather than CONFIG_MMU) and
using additional ifdeferry is likely not going to help long term.
-- 
Michal Hocko
SUSE Labs
