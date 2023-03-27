From: David Vernet <void@manifault.com>
Subject: Re: [PATCH] selftests: cgroup: Fix exception handling in
 test_memcg_oom_group_score_events()
Date: Mon, 27 Mar 2023 04:13:27 -0500
Message-ID: <20230327091327.GK363182@maniforge>
References: <f9303bdc-b1a7-be5e-56c6-dfa8232b8b55@web.de>
 <c383bdca-6f0d-4a75-e788-e1920faa0a62@web.de>
 <fffcd98a-bb73-41cd-8545-0f2c55dd38f9@lucifer.local>
 <5b7921c9-ee5d-c372-b19b-2701bcf33148@web.de>
 <20230326213900.GJ363182@maniforge>
 <c46dbb48-259b-1de9-2364-9bfaf1061944@web.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c46dbb48-259b-1de9-2364-9bfaf1061944@web.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Markus Elfring <Markus.Elfring@web.de>
Cc: kernel-janitors@vger.kernel.org, linux-kselftest@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Jay Kamat <jgkamat@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Shuah Khan <shuah@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Lorenzo Stoakes <lstoakes@gmail.com>, cocci@inria.fr, LKML <linux-kernel@vger.kernel.org>

On Mon, Mar 27, 2023 at 07:56:03AM +0200, Markus Elfring wrote:
> >> 2. Can a cg_destroy() call ever work as expected if a cg_create() call failed?
> >
> > Perhaps next time you can answer your own question by spending 30
> > seconds actually reading the code you're "fixing":
> >
> > int cg_destroy(const char *cgroup)
> > {
> …
> >         ret = rmdir(cgroup);
> …
> >         if (ret && errno == ENOENT) <<< that case is explicitly handled here
> >                 ret = 0;
> >
> >         return ret;
> > }
> 
> Is it interesting somehow that a non-existing directory (which would occasionally
> not be found) is tolerated so far?
> https://elixir.bootlin.com/linux/v6.3-rc3/source/tools/testing/selftests/cgroup/cgroup_util.c#L285
> 
> Should such a function call be avoided because of a failed cg_create() call?

The point is that (a) you were wrong that this is fixing anything, and
(b) this patch is functionally useless. Sure, we could move some goto's
around and subjectively improve "something". Why?  What's the point?
It's highly debatable that what you're doing is even an improvement, and
I'm not interested in wasting time pontificating about the merits of a
trivial "fix" for a test cleanup function that isn't even broken.

Several people have already either advised or directly asked you to stop
sending these patches. I'm not sure why you're choosing to ignore them,
but I'll throw my hat in the ring regardless and do the same. Please
stop sending these fake cleanup patches.
