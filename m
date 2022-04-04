From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Mon, 4 Apr 2022 10:18:42 -0700
Message-ID: <CAJD7tka01bKnxQuizxTN7MtHj_hYu+dSztC2fY0jUPCcvk-9JA@mail.gmail.com>
References: <20220331084151.2600229-1-yosryahmed@google.com>
 <874k3d6vuq.fsf@vajain21.in.ibm.com> <CAJD7tka1UstKYBVrie-_1CgvtaLtVD1uwgzfk5SifxW4FQbOVw@mail.gmail.com>
 <871qyd7bif.fsf@vajain21.in.ibm.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uhZvWBIYSPxrHtL/UXP4sOCKqMqAgTQ5cHbzprIzUlI=;
        b=rzW4aaUe8wJHBTW/ExLvJddgYRg1t4YhtSpQVQScLfUwXMUjqtSxLLNi52Rpn5/B9e
         4fm33kwEjNNC8PObxWVWNVFke/MshRfAUZolEP0oeRGIcWs1cMZ8dqnCMHUOTSSXF2R+
         Nxc7bj+ITBZAcBUCg6yEKcw6zz2obIN/RDEpBS+4YLPJ4AjvRWmQYm9ga69a1RiY4EDX
         oGzty137ABa8Ztyvwr1RlrkdXRpVcepr1eO0rJxfGr76K3XVs6VQ3L6PIza3Wro/7erv
         oZSbbPlhDhdZagCPj0TuB4euNN0h0a1bfMWvh80WoOYfDkjShCEByhv1m6HFJ/OrDhaM
         E/NQ==
In-Reply-To: <871qyd7bif.fsf@vajain21.in.ibm.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vaibhav Jain <vaibhav@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Roman Gushchin <roman.gushchin@linux.dev>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Sun, Apr 3, 2022 at 8:50 PM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
>
>
> Apologies for the delayed response,
>
> Yosry Ahmed <yosryahmed@google.com> writes:
>
> > On Fri, Apr 1, 2022 at 1:39 AM Vaibhav Jain <vaibhav@linux.ibm.com> wrote:
> >>
> >>
> >> Yosry Ahmed <yosryahmed@google.com> writes:
> >> > From: Shakeel Butt <shakeelb@google.com>
> >> >
> >> > Introduce an memcg interface to trigger memory reclaim on a memory cgroup.
> >> <snip>
> >>
> >> > +
> >> > +     while (nr_reclaimed < nr_to_reclaim) {
> >> > +             unsigned long reclaimed;
> >> > +
> >> > +             if (signal_pending(current))
> >> > +                     break;
> >> > +
> >> > +             reclaimed = try_to_free_mem_cgroup_pages(memcg,
> >> > +                                             nr_to_reclaim - nr_reclaimed,
> >> > +                                             GFP_KERNEL, true);
> >> > +
> >> > +             if (!reclaimed && !nr_retries--)
> >> > +                     break;
> >> > +
> >> > +             nr_reclaimed += reclaimed;
> >>
> >> I think there should be a cond_resched() in this loop before
> >> try_to_free_mem_cgroup_pages() to have better chances of reclaim
> >> succeding early.
> >>
> > Thanks for taking the time to look at this!
> >
> > I believe this loop is modeled after the loop in memory_high_write()
> > for the memory.high interface. Is there a reason why it should be
> > needed here but not there?
> >
>
> memory_high_write() calls drain_all_stock() atleast once before calling
> try_to_free_mem_cgroup_pages(). This would drain all percpu stocks
> for the given memcg and its descendents, giving a high chance
> try_to_free_mem_cgroup_pages() to succeed quickly. Such a functionality
> is missing from this patch.
>
> Adding a cond_resched() would atleast give chance to other processess
> within the memcg to run and make forward progress thereby making more
> pages available for reclaim.
>
> Suggestion is partly based on __perform_reclaim() issues a cond_resche()
> as it may get called repeatedly during direct reclaim path.
>
As Michal pointed out, there is already a call to cond_resched() in
shrink_node_memcgs().
>
> >> <snip>
> >>
> >> --
> >> Cheers
> >> ~ Vaibhav
> >
>
> --
> Cheers
> ~ Vaibhav
