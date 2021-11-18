From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v3 1/4] cputime, cpuacct: Include guest time in user time
 in cpuacct.stat
Date: Thu, 18 Nov 2021 15:29:51 +0100
Message-ID: <YZZjX4NC5gc+poSI@hirez.programming.kicks-ass.net>
References: <20211115164607.23784-1-arbn@yandex-team.com>
 <YZLLyFnT95o4Sa8X@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ekjbeMSSluitq89HmbpZTemKWo5ngK3iUKiP5ZJguVc=; b=VF+HazTrHE8GalajWnK4zFuJLv
        D6WCXPblJLo7kFhjP+L3Uta2+eLf3mHsF6JXywBRZu7Q2I72TOBiYWvz5n95a+VQ4S6fDTJKKH3nU
        pfNI0hd+eTSPtOXC0l+u9QDssagKuvjr2G8h+Nn70Sn0mwIYsSMw6r2i1AfEVk+GVTytDXuJd5rr5
        eIkcgr7rtPSkjuR6memzpUw8VgQ6R1/pqPsKFhvEC41v7qoMTDzJN4CqhIQ3yNzjeAor1eWacV8ko
        Q5jrpfDvqRUc5JkyXRkeuwG1dpXI7GY03XKuFOgKkDWtn9V/3RWe2X7fIzc4nxFJ96YQlQUR6KJUD
        9cFvvqsA==;
Content-Disposition: inline
In-Reply-To: <YZLLyFnT95o4Sa8X@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Andrey Ryabinin <arbn@yandex-team.com>, Ingo Molnar <mingo@redhat.com>, Daniel Jordan <daniel.m.jordan@oracle.com>, stable@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Schatzberg <schatzberg.dan@gmail.com>

On Mon, Nov 15, 2021 at 11:06:16AM -1000, Tejun Heo wrote:
> Hello,
> 
> Ingo, Peter, this looks fine to be sans a couple typos in the descriptions.
> Please let me know if you wanna take them through sched tree. Otherwise,
> I'll route them through cgroup tree in a few days.

This is all cgroup only changes, right? That's not immediately obvious
from the changelogs.

But yeah, I can take them I suppose. Lemme go queue them.
