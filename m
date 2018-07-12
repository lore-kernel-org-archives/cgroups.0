From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 10/10] psi: aggregate ongoing stall events when
 somebody reads pressure
Date: Thu, 12 Jul 2018 16:45:37 -0700
Message-ID: <20180712164537.324caee21fd68c47a02af009@linux-foundation.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
        <20180712172942.10094-11-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180712172942.10094-11-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, 12 Jul 2018 13:29:42 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> Right now, psi reports pressure and stall times of already concluded
> stall events. For most use cases this is current enough, but certain
> highly latency-sensitive applications, like the Android OOM killer,
> might want to know about and react to stall states before they have
> even concluded (e.g. a prolonged reclaim cycle).
> 
> This patches the procfs/cgroupfs interface such that when the pressure
> metrics are read, the current per-cpu states, if any, are taken into
> account as well.
> 
> Any ongoing states are concluded, their time snapshotted, and then
> restarted. This requires holding the rq lock to avoid corruption. It
> could use some form of rq lock ratelimiting or avoidance.
> 
> Requested-by: Suren Baghdasaryan <surenb@google.com>
> Not-yet-signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

What-does-that-mean:?
