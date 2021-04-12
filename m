From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered memory
Date: Mon, 12 Apr 2021 07:03:27 -0700
Message-ID: <CALvZod4vYiT-OnQ8gmhs+NurMV+kSFptMig4FJS7RAAcJJeDNA@mail.gmail.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg@mail.gmail.com>
 <CAHbLzkrPD6s9vRy89cgQ36e+1cs6JbLqV84se7nnvP9MByizXA@mail.gmail.com>
 <CALvZod69-GcS2W57hAUvjbWBCD6B2dTeVsFbtpQuZOM2DphwCQ@mail.gmail.com> <CAHbLzkoce41b-pJ5x=6nRhex_xBdC-+cYACBw9HKtA87H71A-Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Txa0jtEnzVHszI7+7RurZSdLkTftdeKdRRITuMLu8Aw=;
        b=PKU//OewynQNd7SeSC4KENGCXLIca0cApDWlmgkcNZDG1kpsbr0rPgil0AfgvOY6dl
         xyI6oUsEgz7I5NjvX0nmU5gKYvslpr/DlU2IIRtDHNsKTNj5mYTMWpVOpf0jlmmt/S1y
         CUUPJrpfVC9XLPr2/2KydVFWwL1JDLBVppMWOyO+Az5d4syy4eLTXKVvpJh2no8LrH7e
         ex2ev3hbHYWC5eF6K2hYH3cFW/+lq19/RnT0xtAF8Di+nXWZY6q/eFfZ0rQhHO906gw/
         8g5iI2BKxf1UF0j4bm0jF5b9TGq687Vz2mq2c0Pjjaq4ByhtTs/YAEQgxKfs2aA9Fml4
         jqyg==
In-Reply-To: <CAHbLzkoce41b-pJ5x=6nRhex_xBdC-+cYACBw9HKtA87H71A-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 8, 2021 at 1:50 PM Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
[...]

> >
> > The low and min limits have semantics similar to the v1's soft limit
> > for this situation i.e. letting the low priority job occupy top tier
> > memory and depending on reclaim to take back the excess top tier
> > memory use of such jobs.
>
> I don't get why low priority jobs can *not* use top tier memory?

I am saying low priority jobs can use top tier memory. The only
difference is to limit them upfront (using limits) or reclaim from
them later (using min/low/soft-limit).

> I can
> think of it may incur latency overhead for high priority jobs. If it
> is not allowed, it could be restricted by cpuset without introducing
> in any new interfaces.
>
> I'm supposed the memory utilization could be maximized by allowing all
> jobs allocate memory from all applicable nodes, then let reclaimer (or
> something new if needed)

Most probably something new as we do want to consider unevictable
memory as well.

> do the job to migrate the memory to proper
> nodes by time. We could achieve some kind of balance between memory
> utilization and resource isolation.
>

Tradeoff between utilization and isolation should be decided by the user/admin.
