From: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
Subject: Re: [PATCH 3/5] cgroup: Account for memory_localevents in
 test_memcg_oom_group_leaf_events()
Date: Sat, 23 Apr 2022 04:36:52 -0700
Message-ID: <20220423113652.ys5gd7vvwkvbdte4@dev0025.ash9.facebook.com>
References: <20220422155728.3055914-1-void@manifault.com>
 <20220422155728.3055914-4-void@manifault.com>
 <YmM26XBZxWy4Widc@carbon>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YmM26XBZxWy4Widc@carbon>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Fri, Apr 22, 2022 at 04:14:49PM -0700, Roman Gushchin wrote:
> On Fri, Apr 22, 2022 at 08:57:27AM -0700, David Vernet wrote:
> > The test_memcg_oom_group_leaf_events() testcase in the cgroup memcg tests
> > validates that processes in a group that perform allocations exceeding
> > memory.oom.group are killed. It also validates that the
> > memory.events.oom_kill events are properly propagated in this case.  Commit
> > 06e11c907ea4 ("kselftests: memcg: update the oom group leaf events test")
> > fixed test_memcg_oom_group_leaf_events() to account for the fact that the
> > memory.events.oom_kill events in a child cgroup is propagated up to its
> > parent. This behavior can actually be configured by the memory_localevents
> > mount option, so this patch updates the testcase to properly account for
> > the possible presence of this mount option.
> > 
> > Signed-off-by: David Vernet <void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org>
> > ---
> >  .../testing/selftests/cgroup/test_memcontrol.c  | 17 ++++++++++++++++-
> >  1 file changed, 16 insertions(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> > index ea2fd27e52df..d88e0ca3f3d1 100644
> > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > @@ -21,6 +21,7 @@
> >  #include "../kselftest.h"
> >  #include "cgroup_util.h"
> >  
> > +static bool has_localevents;
> >  static bool has_recursiveprot;
> >  
> >  /*
> > @@ -1091,6 +1092,7 @@ static int test_memcg_oom_group_leaf_events(const char *root)
> >  {
> >  	int ret = KSFT_FAIL;
> >  	char *parent, *child;
> > +	long parent_oom_events;
> >  
> >  	parent = cg_name(root, "memcg_test_0");
> >  	child = cg_name(root, "memcg_test_0/memcg_test_1");
> > @@ -1128,7 +1130,15 @@ static int test_memcg_oom_group_leaf_events(const char *root)
> >  	if (cg_read_key_long(child, "memory.events", "oom_kill ") <= 0)
> >  		goto cleanup;
> >  
> > -	if (cg_read_key_long(parent, "memory.events", "oom_kill ") <= 0)
> > +	parent_oom_events = cg_read_key_long(
> > +			parent, "memory.events", "oom_kill ");
> > +	// If memory_localevents is not enabled (the default), the parent should
> > +	// count OOM events in its children groups. Otherwise, it should not
> > +	// have observed any events.
> 
> Please, use /* */ style comments, it's a generic kernel style.

Ack, will fix in a follow-on patch.

> 
> > +	if (has_localevents) {
> > +		if (parent_oom_events != 0)
> > +			goto cleanup;
> > +	} else if (parent_oom_events <= 0)
> >  		goto cleanup;
> 
> How about something like this? IMO a bit more clear what's going on.
> 	if ((has_local_events && parent_oom_events == 0) ||
> 	    parent_oom_events > 0)
> 		ret = KSFT_PASS;

Agreed that's a bit clearer, I'll include this in the follow-on patch.
