From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: CLONE_INTO_CGROUP probably needs to call controller attach
 handlers
Date: Wed, 29 Mar 2023 10:52:32 -0400
Message-ID: <ZCRQsAoe1lN1qCiB@cmpxchg.org>
References: <20230328153943.op62j3sw7qaixdsq@wittgenstein>
 <c3d9cf24-1c3a-cda4-5063-6b7d27e9116f@redhat.com>
 <5937b51b-164a-b6b3-532d-43b46f2d49a2@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112; t=1680101553;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=l8Mqvm0nKUvf+W++zPjp5WnzzCK3tCnipop5FneNhZo=;
        b=IZrsd/EeSRA/8xG07wwhIk5QDqYCo2hkZ6V6YXWiKJhFkN+veTM2lYH2srjQ1t4Pqu
         guBPE8IQadmmW9YGskAXG0ekZqD94jF6lVL/45fHa6gpNpsKFR2i4IzXwJd2BE4VvlTS
         FfgMgdPow39X+yuC3ylw/5eO//h7xOjuAjcH9IkPFfJt1ml0dX7ZPB0k6tEtb8acPCBH
         N4BRh30oaIdgMHXnJj9GWFYjOejU8fHSlyIBo+3I2qT6I6tXtuqDnuK2x2Mw+/Y8W9zX
         K3enTh942dzMf729kx41+mDbAzjZ9X8sEfvvXdKbH7IPwNJZzQUn7pdF8e3az0LRXPaY
         sOaw==
Content-Disposition: inline
In-Reply-To: <5937b51b-164a-b6b3-532d-43b46f2d49a2-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Tue, Mar 28, 2023 at 10:48:49PM -0400, Waiman Long wrote:
> On 3/28/23 21:30, Waiman Long wrote:
> > On 3/28/23 11:39, Christian Brauner wrote:
> > > Hey,
> > > 
> > > Giuseppe reported that the the affinity mask isn't updated when a
> > > process is spawned directly into the target cgroup via
> > > CLONE_INTO_CGROUP. However, migrating a process will cause the affinity
> > > mask to be updated (see the repro at [1].
> > > 
> > > I took a quick look and the issue seems to be that we don't call the
> > > various attach handlers during CLONE_INTO_CGROUP whereas we do for
> > > migration. So the solution seems to roughly be that we need to call the
> > > various attach handlers during CLONE_INTO_CGROUP as well when the
> > > parent's cgroups is different from the child cgroup. I think we need to
> > > call all of them, can, cancel and attach.
> > > 
> > > The plumbing here might be a bit intricate since the arguments that the
> > > fork handlers take are different from the attach handlers.
> > > 
> > > Christian
> > > 
> > > [1]: https://paste.centos.org/view/f434fa1a
> > > 
> > I saw that the current cgroup code already have the can_fork, fork and
> > cancel_fork callbacks. Unfortunately such callbacks are not defined for
> > cpuset yet. That is why the cpu affinity isn't correctly updated. I can
> > post a patch to add those callback functions to cpuset which should then
> > able to correctly address this issue.
> 
> Looking further into this issue, I am thinking that forking into a cgroup
> should be equivalent to write the child pid into the "cgroup.threads" file
> of the target cgroup. By taking this route, all the existing can_attach,
> attach and cancel_attach methods can be used. I believe the original fork
> method is for the limited use case of forking into the same cgroup. So right
> now, only the pids controller has the fork methods. Otherwise, we will have
> to modify a number of different controllers to add the necessary fork
> methods. They will be somewhat similar to the existing attach methods and so
> it will be a lot of duplication. What do you think about this idea?

That's what I thought at first too, but then I had some doubts.

The callback is called 'attach', but it's historically implemented
when moving an established task between two cgroups. Many controllers
use it to move state between groups (memcg, pids, cpuset). So in
practice it isn't the natural fit that its name would suggest, and it
would require reworking those controllers to handle both scenarios:
moving tasks between groups, and new tasks attaching to a cgroup.

Now I'm thinking it probably makes more sense to keep using attach for
moving between groups, and fork for being born into a cgroup. That's
what the pid controller does, and it handles CLONE_INTO_CGROUP fine.

There is naturally some overlap between the two operations. But it
seems cleaner to me to use common helpers for that, as opposed to
having both attach and fork callbacks handling forks.
