From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [patch 7/8] mm, memcg: allow processes handling oom
 notifications to access reserves
Date: Sat, 7 Dec 2013 14:06:53 -0500
Message-ID: <20131207190653.GI21724@cmpxchg.org>
References: <alpine.DEB.2.02.1312032116440.29733@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1312032118570.29733@chino.kir.corp.google.com>
 <20131204054533.GZ3556@cmpxchg.org>
 <alpine.DEB.2.02.1312041742560.20115@chino.kir.corp.google.com>
 <20131205025026.GA26777@htj.dyndns.org>
 <alpine.DEB.2.02.1312051537550.7717@chino.kir.corp.google.com>
 <20131206173438.GE21724@cmpxchg.org>
 <CAAAKZwsh3erB7PyG6FnvJRgrZhf2hDQCZDx3rMM7NdOdYNCzJw@mail.gmail.com>
 <20131207174039.GH21724@cmpxchg.org>
 <CAAAKZwvanMiz8QZVOU0-SUKYzqcaJAXn0HxYs5+=Zakmnbcfbg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date; bh=DFN86454D2OhmHNKPR4t0RfKlrAbSUHoyjsSZmsfCEw=;
	b=eN6D1vIfXG2xcHjm/O4mwZOhm1ptDS1WrFcqO0LkAm8tJn5Ek8NOSTlYBwqloyb7j+vpPVabjQ0OCV5bBmZvijXCAZCfBAeUwBzSDS3Oo4612IlwXxn26jTYdTmsJ4E+SO906k+xu+0MUqB6lcEnDSnoEIHf4fNLil3AaSnDxec=;
Content-Disposition: inline
In-Reply-To: <CAAAKZwvanMiz8QZVOU0-SUKYzqcaJAXn0HxYs5+=Zakmnbcfbg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 07, 2013 at 10:12:19AM -0800, Tim Hockin wrote:
> You more or less described the fundamental change - a score per memcg, with
> a recursive OOM killer which evaluates scores between siblings at the same
> level.
> 
> It gets a bit complicated because we have need if wider scoring ranges than
> are provided by default

If so, I'm sure you can make a convincing case to widen the internal
per-task score ranges.  The per-memcg score ranges have not even be
defined, so this is even easier.

> and because we score PIDs against mcgs at a given scope.

You are describing bits of a solution, not a problem.  And I can't
possibly infer a problem from this.

> We also have some tiebreaker heuristic (age).

Either periodically update the per-memcg score from userspace or
implement this in the kernel.  We have considered CPU usage
history/runtime etc. in the past when picking an OOM victim task.

But I'm again just speculating what your problem is, so this may or
may not be a feasible solution.

> We also have a handful of features that depend on OOM handling like the
> aforementioned automatically growing and changing the actual OOM score
> depending on usage in relation to various thresholds ( e.g. we sold you X,
> and we allow you to go over X but if you do, your likelihood of death in
> case of system OOM goes up.

You can trivially monitor threshold events from userspace with the
existing infrastructure and accordingly update the per-memcg score.

> Do you really want us to teach the kernel policies like this?  It would be
> way easier to do and test in userspace.

Maybe.  Providing fragments of your solution is not an efficient way
to communicate the problem.  And you have to sell the problem before
anybody can be expected to even consider your proposal as one of the
possible solutions.
