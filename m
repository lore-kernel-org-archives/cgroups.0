From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v3 2/4] mm/oom: handle remote ooms
Date: Mon, 15 Nov 2021 11:58:45 +0100
Message-ID: <YZI9ZbRVdRtE2m70@dhcp22.suse.cz>
References: <20211111234203.1824138-1-almasrymina@google.com>
 <20211111234203.1824138-3-almasrymina@google.com>
 <YY4dHPu/bcVdoJ4R@dhcp22.suse.cz>
 <CAHS8izNMTcctY7NLL9+qQN8+WVztJod2TfBHp85NqOCvHsjFwQ@mail.gmail.com>
 <YY4nm9Kvkt2FJPph@dhcp22.suse.cz>
 <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1636973926; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vM9+eNo6ERXQ4h/WUE/dmFMupZWi1IETUaQIKqTmnlk=;
        b=g3lwX5BznrpmCjZTXX+HgLaWbRuG2tfzrSs/fJlqGEbFsuZwW3FW8O61dB4QRonTX+NQxj
        TlaLIO+AEpofdSkGfZcTjf+JMOQJNeCfvnZXwistYm45PQTt/MiwszfqGzjBPgjUvwJG3S
        pr5COIH3NF6MO3B6kp4m3+ExV3tq3AU=
Content-Disposition: inline
In-Reply-To: <CAHS8izMjfwgiNEoJWGSub6iqgPKyyoMZK5ONrMV2=MeMJsM5sg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mina Almasry <almasrymina@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>, Greg Thelen <gthelen@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <songmuchun@bytedance.com>, riel@surriel.com, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Fri 12-11-21 09:59:22, Mina Almasry wrote:
> On Fri, Nov 12, 2021 at 12:36 AM Michal Hocko <mhocko@suse.com> wrote:
> >
> > On Fri 12-11-21 00:12:52, Mina Almasry wrote:
> > > On Thu, Nov 11, 2021 at 11:52 PM Michal Hocko <mhocko@suse.com> wrote:
> > > >
> > > > On Thu 11-11-21 15:42:01, Mina Almasry wrote:
> > > > > On remote ooms (OOMs due to remote charging), the oom-killer will attempt
> > > > > to find a task to kill in the memcg under oom, if the oom-killer
> > > > > is unable to find one, the oom-killer should simply return ENOMEM to the
> > > > > allocating process.
> > > >
> > > > This really begs for some justification.
> > > >
> > >
> > > I'm thinking (and I can add to the commit message in v4) that we have
> > > 2 reasonable options when the oom-killer gets invoked and finds
> > > nothing to kill: (1) return ENOMEM, (2) kill the allocating task. I'm
> > > thinking returning ENOMEM allows the application to gracefully handle
> > > the failure to remote charge and continue operation.
> > >
> > > For example, in the network service use case that I mentioned in the
> > > RFC proposal, it's beneficial for the network service to get an ENOMEM
> > > and continue to service network requests for other clients running on
> > > the machine, rather than get oom-killed when hitting the remote memcg
> > > limit. But, this is not a hard requirement, the network service could
> > > fork a process that does the remote charging to guard against the
> > > remote charge bringing down the entire process.
> >
> > This all belongs to the changelog so that we can discuss all potential
> > implication and do not rely on any implicit assumptions.
> 
> Understood. Maybe I'll wait to collect more feedback and upload v4
> with a thorough explanation of the thought process.
> 
> > E.g. why does
> > it even make sense to kill a task in the origin cgroup?
> >
> 
> The behavior I saw returning ENOMEM for this edge case was that the
> code was forever looping the pagefault, and I was (seemingly
> incorrectly) under the impression that a suggestion to forever loop
> the pagefault would be completely fundamentally unacceptable.

Well, I have to say I am not entirely sure what is the best way to
handle this situation. Another option would be to treat this similar to
ENOSPACE situation. This would result into SIGBUS IIRC.

The main problem with OOM killer is that it will not resolve the
underlying problem in most situations. Shmem files would likely stay
laying around and their charge along with them. Killing the allocating
task has problems on its own because this could be just a DoS vector by
other unrelated tasks sharing the shmem mount point without a gracefull
fallback. Retrying the page fault is hard to detect. SIGBUS might be
something that helps with the latest. The question is how to communicate
this requerement down to the memcg code to know that the memory reclaim
should happen (Should it? How hard we should try?) but do not invoke the
oom killer. The more I think about this the nastier this is.
-- 
Michal Hocko
SUSE Labs
