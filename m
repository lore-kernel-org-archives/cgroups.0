From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: fix NR_WRITEBACK leak in memcg and
 system stats
Date: Wed, 7 Feb 2018 11:55:47 -0500
Message-ID: <20180207165547.GB29418@cmpxchg.org>
References: <20180203082353.17284-1-hannes@cmpxchg.org>
 <CALvZod5-35Y+_eot6-6J5HyssnmAW-wfYhuQdxxA9Zj8Ng2e+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
	; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
	Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=Bj4+YG1h0XbAXmRQg4EvAJuHGH96NtJRGKXXiXTFbJ0=; b=L75cdHM8fqeUOjdlBAF+sVExv2
	KknWEafW1rRrQC7A08l7FxMWs8WEG3BfKMP255p6oIN/sQekkRnsSPdRgYyiAoDxHt0OA4VV53ZdM
	x2us/lLty3GUKeczWBu1mKa17oBJaPax6AhDqutBrwAzSBm9Zh2fQ8ePbmkmzLUREh7E=;
Content-Disposition: inline
In-Reply-To: <CALvZod5-35Y+_eot6-6J5HyssnmAW-wfYhuQdxxA9Zj8Ng2e+g@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team@fb.com

Hi Shakeel,

On Wed, Feb 07, 2018 at 07:44:08AM -0800, Shakeel Butt wrote:
> On Sat, Feb 3, 2018 at 12:23 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > After the ("a983b5ebee57 mm: memcontrol: fix excessive complexity in
> > memory.stat reporting"), we observed slowly upward creeping
> > NR_WRITEBACK counts over the course of several days, both the
> > per-memcg stats as well as the system counter in e.g. /proc/meminfo.
> >
> > The conversion from full per-cpu stat counts to per-cpu cached atomic
> > stat counts introduced an irq-unsafe RMW operation into the updates.
> >
> > Most stat updates come from process context, but one notable exception
> > is the NR_WRITEBACK counter. While writebacks are issued from process
> > context, they are retired from (soft)irq context.
> >
> > When writeback completions interrupt the RMW counter updates of new
> > writebacks being issued, the decs from the completions are lost.
> >
> > Since the global updates are routed through the joint lruvec API, both
> > the memcg counters as well as the system counters are affected.
> >
> > This patch makes the joint stat and event API irq safe.
> >
> > Fixes: a983b5ebee57 ("mm: memcontrol: fix excessive complexity in memory.stat reporting")
> > Debugged-by: Tejun Heo <tj@kernel.org>
> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Should this be considered for stable?

The stable tree is only for fixes to already released kernels, but
there is no release containing the faulty patch:

$ git describe --tags a983b5ebee57
v4.15-3322-ga983b5ebee57

nor was the faulty patch itself marked for stable.

So as long as this fix makes it into 4.16 we should be good.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
