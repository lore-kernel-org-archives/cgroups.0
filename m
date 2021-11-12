From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Fri, 12 Nov 2021 09:59:22 -0800
Message-ID: <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
 <20211111234203.1824138-3-almasrymina@google.com> <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
 <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com> <YY4nm9Kvkt2FJPph@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=S6FWsJvUFWayhY8ePzqwxfqSm+uqimRoHquPyN3bod4=;
        b=pOcgdEtKmvGA71hjumZT/MxPEHC50zxapDrdz8scR0Apuzc4LR7SZuiOSj/l+GJBCW
         oa5fA0BUm8gzn/Dhve/36mdUZQTznyp2QiiczqGB5uGPeujGMWC/UfflN6lSlhJn59dM
         gBFPmsqSOLPospqb/Y5RdFPfM93wKxcS7+12lcMs3N6PjJIHVXWvslcRh0jMnF53kQ4C
         msEUYivdrNqlWciPxKuhAnidDrA4KJeeJQSNQvfJib2dLbi5v4+A1fpbt0qU5Y7DQYuK
         ZnUkuTKV1EJiIAyF2FFqkfiPO1+HdR3+n51PwiTEK+NHLbpe8atAG3WPRFBkN/+YbKLz
         4hMQ==
In-Reply-To: <YY4nm9Kvkt2FJPph-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Nov 12, 2021 at 12:36 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 12-11-21 00:12:52, Mina Almasry wrote:
> > On Thu, Nov 11, 2021 at 11:52 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Thu 11-11-21 15:42:01, Mina Almasry wrote:
> > > > On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> > > > to find a task to kill in the memcg under oom, if the oom-killer
> > > > is unable to find one, the oom-killer should simply return ENOMEM to the
> > > > allocating process.
> > >
> > > This really begs for some justification.
> > >
> >
> > I'm thinking (and I can add to the commit message in v4) that we have
> > 2 reasonable options when the oom-killer gets invoked and finds
> > nothing to kill: (1) return ENOMEM, (2) kill the allocating task. I'm
> > thinking returning ENOMEM allows the application to gracefully handle
> > the failure to remote charge and continue operation.
> >
> > For example, in the network service use case that I mentioned in the
> > RFC proposal, it's beneficial for the network service to get an ENOMEM
> > and continue to service network requests for other clients running on
> > the machine, rather than get oom-killed when hitting the remote memcg
> > limit. But, this is not a hard requirement, the network service could
> > fork a process that does the remote charging to guard against the
> > remote charge bringing down the entire process.
>
> This all belongs to the changelog so that we can discuss all potential
> implication and do not rely on any implicit assumptions.

Understood. Maybe I'll wait to collect more feedback and upload v4
with a thorough explanation of the thought process.

> E.g. why does
> it even make sense to kill a task in the origin cgroup?
>

The behavior I saw returning ENOMEM for this edge case was that the
code was forever looping the pagefault, and I was (seemingly
incorrectly) under the impression that a suggestion to forever loop
the pagefault would be completely fundamentally unacceptable.

> > > > If we're in pagefault path and we're unable to return ENOMEM to the
> > > > allocating process, we instead kill the allocating process.
> > >
> > > Why do you handle those differently?
> > >
> >
> > I'm thinking (possibly incorrectly) it's beneficial to return ENOMEM
> > to the allocating task rather than killing it. I would love to return
> > ENOMEM in both these cases, but I can't return ENOMEM in the fault
> > path. The behavior I see is that the oom-killer gets invoked over and
> > over again looking to find something to kill and continually failing
> > to find something to kill and the pagefault never gets handled.
>
> Just one remark. Until just very recently VM_FAULT_OOM (a result of
> ENOMEM) would trigger the global OOM killer. This has changed by
> 60e2793d440a ("mm, oom: do not trigger out_of_memory from the #PF").
> But you are right that you might just end up looping in the page fault
> for ever. Is that bad though? The situation is fundamentaly
> unresolveable at this stage. On the other hand the task is still
> killable so the userspace can decide to terminate and break out of the
> loop.
>

I think what you're saying here makes a lot of sense and I think is a
workable approach, and maybe is slightly preferable to killing the
task IMO (and both are workable IMO). The pagefault can loop until
memory becomes available in the remote memcg, and the userspace can
decide to always terminate the process if desired or maybe handle the
issue more gracefully by freeing memory in the remote memcg somehow;
i.e. maybe we don't need the kernel to be heavy handed here and kill
the remote allocating task immediately.

> What is the best approach I am not quite sure. As I've said earlier this
> is very likely going to open a can of worms and so it should be
> evaluated very carefuly. For that, please make sure to describe your
> thinking in details.
>

OK, thanks for reviewing and the next iteration should include a
thorough explanation of my thinking.

> > I could, however, kill the allocating task whether it's in the
> > pagefault path or not; it's not a hard requirement that I return
> > ENOMEM. If this is what you'd like to see in v4, please let me know,
> > but I do see some value in allowing some callers to gracefully handle
> > the ENOMEM.
> >
> > > > Signed-off-by: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > >
> > > > Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> > > > Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>
> > > > Cc: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> > > > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > CC: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> > > > Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > > > Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> > > > Cc: riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org
> > > > Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> > > > Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > --
> > > Michal Hocko
> > > SUSE Labs
>
> --
> Michal Hocko
> SUSE Labs
