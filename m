From: Mina Almasry <almasrymina-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Mon, 15 Nov 2021 16:58:19 -0800
Message-ID: <CAHS8izPcnwOqf8bjfrEd9VFxdA6yX3+a-TeHsxGgpAR+_bRdNA@mail.gmail.com>
References: <20211111234203.1824138-1-almasrymina@google.com>
 <20211111234203.1824138-3-almasrymina@google.com> <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
 <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
 <YY4nm9Kvkt2FJPph@dhcp22.suse.cz> <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
 <YZI9ZbRVdRtE2m70@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bh/uK2OAEBnWDXMyTu+rO+aF369+IR1K4BMvSsecSlI=;
        b=AZMD85bqC+7gsP1XAnO971ULv4k2BveTBFp9oanHT79FoQxM+qPkMv9UOoYjeAVSc4
         D4bjDHMhC/Hz7sqzqJx4vrvczTQcC6tDkpjQqYf6w2dMSZdqqm9HJqNqjOkOsjTAbLAy
         9M2nFXZ9xV/WkZYZ+KqwlM8mKB/hQSnLV7QpEq7CE19BGOXT6Cg3bLXoEfwx8n8i6hU5
         KcZZHw2s9eQ7TAFMm62h6GH2YTl+rWMDO82q6U4TBwQoQjNq3AqqOPndKcQyJtR2uxIZ
         AcpRpOrsWrMu5ETmoa04yBB8Pie1Y7k3j+6CRIW9Lri6Qq0BItJnPU3wwy+Mi/dhNj06
         cG7A==
In-Reply-To: <YZI9ZbRVdRtE2m70-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, riel-ebMLmSuQjDVBDgjK7y7TUQ@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Nov 15, 2021 at 2:58 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Fri 12-11-21 09:59:22, Mina Almasry wrote:
> > On Fri, Nov 12, 2021 at 12:36 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > >
> > > On Fri 12-11-21 00:12:52, Mina Almasry wrote:
> > > > On Thu, Nov 11, 2021 at 11:52 PM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> > > > >
> > > > > On Thu 11-11-21 15:42:01, Mina Almasry wrote:
> > > > > > On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> > > > > > to find a task to kill in the memcg under oom, if the oom-killer
> > > > > > is unable to find one, the oom-killer should simply return ENOMEM to the
> > > > > > allocating process.
> > > > >
> > > > > This really begs for some justification.
> > > > >
> > > >
> > > > I'm thinking (and I can add to the commit message in v4) that we have
> > > > 2 reasonable options when the oom-killer gets invoked and finds
> > > > nothing to kill: (1) return ENOMEM, (2) kill the allocating task. I'm
> > > > thinking returning ENOMEM allows the application to gracefully handle
> > > > the failure to remote charge and continue operation.
> > > >
> > > > For example, in the network service use case that I mentioned in the
> > > > RFC proposal, it's beneficial for the network service to get an ENOMEM
> > > > and continue to service network requests for other clients running on
> > > > the machine, rather than get oom-killed when hitting the remote memcg
> > > > limit. But, this is not a hard requirement, the network service could
> > > > fork a process that does the remote charging to guard against the
> > > > remote charge bringing down the entire process.
> > >
> > > This all belongs to the changelog so that we can discuss all potential
> > > implication and do not rely on any implicit assumptions.
> >
> > Understood. Maybe I'll wait to collect more feedback and upload v4
> > with a thorough explanation of the thought process.
> >
> > > E.g. why does
> > > it even make sense to kill a task in the origin cgroup?
> > >
> >
> > The behavior I saw returning ENOMEM for this edge case was that the
> > code was forever looping the pagefault, and I was (seemingly
> > incorrectly) under the impression that a suggestion to forever loop
> > the pagefault would be completely fundamentally unacceptable.
>
> Well, I have to say I am not entirely sure what is the best way to
> handle this situation. Another option would be to treat this similar to
> ENOSPACE situation. This would result into SIGBUS IIRC.
>
> The main problem with OOM killer is that it will not resolve the
> underlying problem in most situations. Shmem files would likely stay
> laying around and their charge along with them. Killing the allocating
> task has problems on its own because this could be just a DoS vector by
> other unrelated tasks sharing the shmem mount point without a gracefull
> fallback. Retrying the page fault is hard to detect. SIGBUS might be
> something that helps with the latest. The question is how to communicate
> this requerement down to the memcg code to know that the memory reclaim
> should happen (Should it? How hard we should try?) but do not invoke the
> oom killer. The more I think about this the nastier this is.

So actually I thought the ENOSPC suggestion was interesting so I took
the liberty to prototype it. The changes required:

1. In out_of_memory() we return false if !oc->chosen &&
is_remote_oom(). This gets bubbled up to try_charge_memcg() as
mem_cgroup_oom() returning OOM_FAILED.
2. In try_charge_memcg(), if we get an OOM_FAILED we again check
is_remote_oom(), if it is a remote oom, return ENOSPC.
3. The calling code would return ENOSPC to the user in the no-fault
path, and SIGBUS the user in the fault path with no changes.

To be honest I think this is very workable, as is Shakeel's suggestion
of MEMCG_OOM_NO_VICTIM. Since this is an opt-in feature, we can
document the behavior and if the userspace doesn't want to get killed
they can catch the sigbus and handle it gracefully. If not, the
userspace just gets killed if we hit this edge case.

I may be missing something but AFAICT we don't have to "communicate
this requirement down to the memcg code" with this implementation. The
memcg code is aware the memcg is oom and will do the reclaim or
whatever before invoking the oom-killer. It's only when the oom-killer
can't find something to kill that we return ENOSPC or SIGBUS.

As always thank you very much for reviewing and providing feedback.
