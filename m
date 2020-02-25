From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 3/3] mm: memcontrol: recursive memory.low protection
Date: Tue, 25 Feb 2020 10:03:04 -0500
Message-ID: <20200225150304.GA10257@cmpxchg.org>
References: <20191219200718.15696-1-hannes@cmpxchg.org>
 <20191219200718.15696-4-hannes@cmpxchg.org>
 <20200221171256.GB23476@blackbody.suse.cz>
 <20200221185839.GB70967@cmpxchg.org>
 <20200225133720.GA6709@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=HXcnWME3zqMcGPYyd8AtzUf91f9WMm8RU0Wrk+XdU2s=;
        b=Ny9hNRmJQiK2If/FIB2PQP4sL7zzQYgnWFwVLDzOiibHdt19oxudGd0SHvGWPzjVeQ
         XGY0QhuMkDZgd4oDp5ihkgArtje58gT8a0fsQ0iO8vcsF6XXdRT6/8/AVq7pwtkXdiLE
         C8zwUi4Sf4y0zeHdNlZzQrVXn0HRJIZ27TWdAICO58+7AcjslqOoiJZXUkiJacQHz33y
         vaEL1bVZwb/Y1IngUor2Ly5tHSY36Qu6nPgAPS8O9MXsXksR9zsh9Fd4LjSJUx/9XT4e
         oDyeUbMMTnERTgjdu8KNhd1TODAJykPEqAqCKEA7Qe5SNYrkR3KczxEjIvKJ3aIc8Gm7
         0wNw==
Content-Disposition: inline
In-Reply-To: <20200225133720.GA6709-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hello Michal,

On Tue, Feb 25, 2020 at 02:37:20PM +0100, Michal Koutn=FD wrote:
> On Fri, Feb 21, 2020 at 01:58:39PM -0500, Johannes Weiner <hannes-druUgvl=
0LCNAfugRpC6u6w@public.gmane.org> wrote:
> > When you set task's and logger's memory.low to "max" or 10G or any
> > bogus number like this, a limit reclaim in job treats this as origin
> > protection and tries hard to avoid reclaiming anything in either of
> > the two cgroups.
> What do you mean by origin protection? (I'm starting to see some
> misunderstanding here, c.f. my remark regarding the parent=3D=3Droot
> condition in the other patch [1]).

By origin protection I mean protection values at the first level of
children in a reclaim scope. Those are taken as absolute numbers
during a reclaim cycle and propagated down the tree.

Say you have the following configuration:

                root_mem_cgroup
               /
              A (max=3D12G, low=3D10G)
             /
            B (low=3Dmax)

If global reclaim occurs, the protection for subtree A is 10G, and B
then gets a proportional share of that.

However, if limit reclaim in A occurs due to the 12G max limit, the
protection for subtree B is max.

> > memory.events::low skyrockets even though no intended
> > protection was violated, we'll have reclaim latencies (especially when
> > there are a few dying cgroups accumluated in subtree).
> Hopefully, I see where are you coming from. There would be no (false)
> low notifications if the elow was calculated all they way top-down from
> the real root. Would such calculation be the way to go?

That hinges on whether an opt-out mechanism makes sense, and we
disagree on that part.

> > that job can't possibly *know* about the top-level host
> > protection that lies beyond the delegation point and outside its own
> > namespace,
> Yes, I agree.
>=20
> > and that it needs to propagate protection against rpm upgrades into
> > its own leaf groups for each tasklet and component.
> If a job wants to use concrete protection than it sets it, if it wants
> to use protection from above, then it can express it with the infinity
> (after changing the effective calculation I described above).
>=20
> Now, you may argue that the infinity would be nonsensical if it's not a
> subordinate job. Simplest approach would be likely to introduce the
> special "inherit" value (such a literal name may be misleading as it
> would be also "dont-care").

Again, a complication of the interface for *everybody* on the premise
that retaining an opt-out mechanism makes sense. We disagree on that.

> > Again, in practice we have found this to be totally unmanageable and
> > routinely first forgot and then had trouble hacking the propagation
> > into random jobs that create their own groups.
> I've been bitten by this as well. However, the protection defaults to
> off and I find it this matches the general rule that kernel provides the
> mechanism and user(space) the policy.
>
> > And when you add new hardware configurations, you cannot just make a
> > top-level change in the host config, you have to update all the job
> > specs of workloads running in the fleet.
> (I acknowledge the current mechanism lacks an explicit way to express
> the inherit/dont-care value.)
>=20
>=20
> > My patch brings memory configuration in line with other cgroup2
> > controllers.
> Other controllers mostly provide the limit or weight controls, I'd say
> protection semantics is specific only to the memory controller so
> far [2]. I don't think (at least by now) it can be aligned as the weight
> or limit semantics.

Can you explain why you think protection is different from a weight?

Both specify a minimum amount of a resource that the cgroup can use
under contention, while allowing the cgroup to use more than that
share if there is no contention with siblings.

You configure memory in bytes instead of a relative proportion, but
that's only because bytes are a natural unit of memory whereas a
relative proportion of time is a natural unit of CPU and IO.

I'm having trouble concluding from this that the inheritance rules
must be fundamentally different.

For example, if you assign a share of CPU or IO to a subtree, that
applies to the entire subtree. Nobody has proposed being able to
opt-out of shares in a subtree, let alone forcing individual cgroups
to *opt-in* to receive these shares.

I can't fathom why you think assigning pieces of memory to a subtree
must be fundamentally different.

> > I've made the case why it's not a supported usecase, and why it is a
> > meaningless configuration in practice due to the way other controllers
> > already behave.
> I see how your reasoning works for limits (you set memory limit and you
> need to control io/cpu too to maintain intended isolation). I'm confused
> why having a scapegoat (or donor) sibling for protection should not be
> supported or how it breaks protection for others if not combined with
> io/cpu controllers. Feel free to point me to the message if I overlooked
> it.

Because a lack of memory translates to paging, which consumes IO and
CPU. If you relinquish a cgroup's share of memory (whether with a
limit or with a lack of protection under pressure), you increases its
share of IO. To express a priority order between workloads, you cannot
opt out of memory protection without also opting out of the IO shares.

Say you have the following configuration:

                   A
                  / \
                 B   C
                /\
               D  E

D houses your main workload, C a secondary workload, E is not
important. You give B protection and C less protection. You opt E out
of B's memory share to give it all to D. You established a memory
order of D > C > E.

Now to the IO side. You assign B a higher weight than C, and D a
higher weight then E.

Now you apply memory pressure, what happens?. D isn't reclaimed, C is
somewhat reclaimed, E is reclaimed hard. D will not page, C will page
a little bit, E will page hard *with the higher IO priority of B*.

Now C is stuck behind E. This is a priority inversion.

Yes, from a pure accounting perspective, you've managed to enforce
that E will never have more physical pages allocated than C at any
given time. But what did that accomplish? What was the practical
benefit of having made E a scapegoat?

Since I'm repeating myself on this topic, I would really like to turn
your questions around:

1. Can you please make a practical use case for having scape goats or
   donor groups to justify retaining what I consider to be an
   unimportant artifact in the memory.low semantics?

2. If you think opting out of hierarchically assigned resources is a
   fundamentally important usecase, can you please either make an
   argument why it should also apply to CPU and IO, or alternatively
   explain in detail why they are meaningfully different?
