From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 1/4] kselftests: memcg: update the oom group leaf events
 test
Date: Fri, 15 Apr 2022 07:08:17 -0700
Message-ID: <20220415140817.ljznpvacne6nchg5@dev0025.ash9.facebook.com>
References: <20220415000133.3955987-1-roman.gushchin@linux.dev>
 <20220415000133.3955987-2-roman.gushchin@linux.dev>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220415000133.3955987-2-roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>

On Thu, Apr 14, 2022 at 05:01:30PM -0700, Roman Gushchin wrote:
> Commit 9852ae3fe529 ("mm, memcg: consider subtrees in memory.events") made
> memory.events recursive: all events are propagated upwards by the
> tree. It was a change in semantics.

In one of our offline discussions you mentioned that we may want to
consider having the test take mount options into account. If we decide to
go that route we should probably have this testcase take memory_localevents
into account as well. If so, I'm happy to take care of that in a follow-on
patch after this is merged as I already have a patch locally that reads and
parses /proc/mounts to detect these mount options.

> 
> It broke the oom group leaf events test: it assumes that after
> an OOM the oom_kill counter is zero on parent's level.
> 
> Let's adjust the test: it should have similar expectations
> for the child and parent levels.
> 
> The test passes after this fix.
> 
> Signed-off-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> Cc: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> ---
>  tools/testing/selftests/cgroup/test_memcontrol.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> index 36ccf2322e21..00b430e7f2a2 100644
> --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> @@ -1079,7 +1079,8 @@ static int test_memcg_sock(const char *root)
>  /*
>   * This test disables swapping and tries to allocate anonymous memory
>   * up to OOM with memory.group.oom set. Then it checks that all
> - * processes in the leaf (but not the parent) were killed.
> + * processes in the leaf were killed. It also checks that oom_events
> + * were propagated to the parent level.
>   */
>  static int test_memcg_oom_group_leaf_events(const char *root)
>  {
> @@ -1122,7 +1123,7 @@ static int test_memcg_oom_group_leaf_events(const char *root)
>  	if (cg_read_key_long(child, "memory.events", "oom_kill ") <= 0)
>  		goto cleanup;
>  
> -	if (cg_read_key_long(parent, "memory.events", "oom_kill ") != 0)
> +	if (cg_read_key_long(parent, "memory.events", "oom_kill ") <= 0)
>  		goto cleanup;
>  
>  	ret = KSFT_PASS;
> -- 
> 2.35.1
> 

Looks good, thanks.

Reviewed-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
