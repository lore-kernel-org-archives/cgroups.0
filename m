From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 5/5] cgroup/cpuset: Optimize out unneeded
 cpuset_can_fork/cpuset_cancel_fork calls
Date: Wed, 12 Apr 2023 09:17:25 -1000
Message-ID: <ZDcDxecF0Y5F0pV6@slm.duckdns.org>
References: <20230411133601.2969636-1-longman@redhat.com>
 <20230411133601.2969636-6-longman@redhat.com>
 <ZDb4G2jgQFK8h8Ys@slm.duckdns.org>
 <90b7bc16-0673-02b7-dad1-f24bc956f1c5@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681327047; x=1683919047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NjLJTegoBtBUML6y27GTBTrp1rLhDXKko66W4791iCA=;
        b=j0gZBYxWyEXymMs5NkUYqqKa3kXVdR62FTlnXgVOum98NKSobo61ps0XVpgAUbZWKO
         ss3mCtQRP9lLnLZK8UK0NBxSbzY+orD9b9k9H4BVoRkjnuJMHNMLOk6GkxwJUSLQV+o/
         fAXVfMvBzoCGfc0tjyCoBXZcu+SaahlssZ4c+uYCKwivVxzOMwtsXuA53aEAK0vsyHyy
         HmEY8+4/hLS8VvcZjpmWPg1uMJrWAG7pjBHfZvUb0z0nhSsNquS/9Hr+g829OL04AKav
         s3zax5q/aYkeVJxomd6QW0JXgnMR5q06iRrgQH9XqYX5uHzyziIfVKl91kD7wsu4C6de
         wQXA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <90b7bc16-0673-02b7-dad1-f24bc956f1c5-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Hello,

On Wed, Apr 12, 2023 at 02:40:53PM -0400, Waiman Long wrote:
> On 4/12/23 14:27, Tejun Heo wrote:
> > On Tue, Apr 11, 2023 at 09:36:01AM -0400, Waiman Long wrote:
> > > The newly introduced cpuset_can_fork() and cpuset_cancel_fork() calls
> > > are only needed when the CLONE_INTO_CGROUP flag is set which is not
> > > likely. Adding an extra cpuset_can_fork() call does introduce a bit
> > > of performance overhead in the fork/clone fastpath. To reduce this
> > > performance overhead, introduce a new clone_into_cgroup_can_fork flag
> > > into the cgroup_subsys structure. This flag, when set, will call the
> > > can_fork and cancel_fork methods only if the CLONE_INTO_CGROUP flag
> > > is set.
> > > 
> > > The cpuset code is now modified to set this flag. The same cpuset
> > > checking code in cpuset_can_fork() and cpuset_cancel_fork() will have
> > > to stay as the cgroups can be different, but the cpusets may still be
> > > the same. So the same check must be present in both cpuset_fork() and
> > > cpuset_can_fork() to make sure that attach_in_progress is correctly set.
> > > 
> > > Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Waiman, I'm not necessarily against this optimization but can we at least
> > have some performance numbers to show that this is actually meaningful?
> > Given how heavy our fork path is, I'm not too sure this would show up in any
> > meaningful way.
> 
> That make sense to me. I am OK to leave it for now as it is an optimization
> patch anyway.
> 
> BTW, another question that I have is about the cgroup_threadgroup_rwsem. It
> is currently a percpu rwsem. Is it possible to change it into a regular
> rwsem instead? It is causing quite a bit of latency for workloads that
> require rather frequent changes to cgroups. I know we have a "favordynmods"
> mount option to disable the percpu operation. This will still be less
> performant than a normal rwsem. Of course the downside is that the fork/exit
> fastpaths will be slowed down a bit.

I don't know. Maybe? A rwsem actually has a scalability factor in that the
more CPUs are forking, the more expensive the rwsem becomes, so it is a bit
more of a concern. Another factor is that in majority of use cases we're
almost completely bypassing write-locking percpu_rwsem, so it feel a bit sad
to convert it to a regular rwsem. So, if favordynmods is good enough, I'd
like to keep it that way.

Thanks.

-- 
tejun
