From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup, perf_event: make perf_event controller work
 on cgroup2 hierarchy
Date: Tue, 8 Mar 2016 11:11:34 +0100
Message-ID: <20160308101133.GW6344@twins.programming.kicks-ass.net>
References: <1456351975-1899-1-git-send-email-tj@kernel.org>
 <1456351975-1899-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1456351975-1899-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 24, 2016 at 05:12:55PM -0500, Tejun Heo wrote:
> perf_event is a utility controller whose primary role is identifying
> cgroup membership to filter perf events; however, because it also
> tracks some per-css state, it can't be replaced by pure cgroup
> membership test.  Mark the controller as implicitly enabled on the
> default hierarchy so that perf events can always be filtered based on
> cgroup v2 path as long as the controller is not mounted on a legacy
> hierarchy.
> 
> "perf record" is updated accordingly so that it searches for both v1
> and v2 hierarchies.  A v1 hierarchy is used if perf_event is mounted
> on it; otherwise, it uses the v2 hierarchy.
> 
> v2: Doc updated to reflect more flexible rebinding behavior.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>

Acked-by: Peter Zijlstra (Intel) <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

> Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Arnaldo Carvalho de Melo <acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Arnaldo, do the userspace bits look ok?
