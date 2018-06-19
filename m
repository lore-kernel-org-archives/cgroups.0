From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v6 0/3] Directed kmem charging
Date: Tue, 19 Jun 2018 15:58:38 -0700
Message-ID: <CALvZod56hRAjCE25Wc-+O-rc+v_t6a9n3JrD4gTRaFotkcrMCQ@mail.gmail.com>
References: <20180619051327.149716-1-shakeelb@google.com> <20180619161149.GA27423@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zb3AjJowosb9dhIaQWVidJRDXoJHlmvZeXg5JHXf2xg=;
        b=o+kdv+GSp/AQxWgH4loxhm4G7MLU9afWCP2I8pgEwr24jnPSbZGqm/jRg1iP4gePW1
         UwmrDpSEvwAv1RcPe/nJX1BNZ8FKPBng+YRmS8CuFnKTLrFbmptc0w+gKxgoqHWPGGQE
         eDJSa5B1Q+320W7PfohDAVQk/1ZvADDF3bQxt5TCQ7R1TYAQiLehY+MT5urDSV40Bb4P
         q4ZbvCTzDZhustuEQWOlrWjK3ISVDYb4SRHeukzaRafhtoofYK8mO2dtYak5nA2cqndu
         NugDjEfIY/U/O68/vF3J01WkIknbZQHS4WSnhoX/GVOau8XTIY4W+ItvX+RTETU/8Cdk
         xZCQ==
In-Reply-To: <20180619161149.GA27423@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Tue, Jun 19, 2018 at 9:09 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> Hi Shakeel,
>
> this looks generally reasonable to me.
>
> However, patch 1 introduces API that isn't used until patch 2 and 3,
> which makes reviewing harder since you have to jump back and forth
> between emails. Please fold patch 1 and introduce API along with the
> users.
>

Thanks a lot for the review. Ack, I will do as you suggested in next version.

> On Mon, Jun 18, 2018 at 10:13:24PM -0700, Shakeel Butt wrote:
> > This patchset introduces memcg variant memory allocation functions.  The
> > caller can explicitly pass the memcg to charge for kmem allocations.
> > Currently the kernel, for __GFP_ACCOUNT memory allocation requests,
> > extract the memcg of the current task to charge for the kmem allocation.
> > This patch series introduces kmem allocation functions where the caller
> > can pass the pointer to the remote memcg.  The remote memcg will be
> > charged for the allocation instead of the memcg of the caller.  However
> > the caller must have a reference to the remote memcg.  This patch series
> > also introduces scope API for targeted memcg charging. So, all the
> > __GFP_ACCOUNT alloctions within the specified scope will be charged to
> > the given target memcg.
>
> Can you open with the rationale for the series, i.e. the problem
> statement (fsnotify and bh memory footprint), *then* follow with the
> proposed solution?
>

Sure.

thanks,
Shakeel
