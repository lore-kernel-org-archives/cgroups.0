From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease [memory,memsw].limit_in_bytes
Date: Fri, 12 Jan 2018 14:57:35 -0800
Message-ID: <CALvZod6y8EfQt02+rNOP_JXgzpJJHjuVzd++T3E=NEMwwBv_CQ@mail.gmail.com>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com> <20180111104239.GZ1732@dhcp22.suse.cz>
 <4a8f667d-c2ae-e3df-00fd-edc01afe19e1@virtuozzo.com> <20180111124629.GA1732@dhcp22.suse.cz>
 <ce885a69-67af-5f4c-1116-9f6803fb45ee@virtuozzo.com> <20180111162947.GG1732@dhcp22.suse.cz>
 <560a77b5-02d7-cbae-35f3-0b20a1c384c2@virtuozzo.com> <20180112122405.GK1732@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=z+FrYgU8xk/NCmx9upy+rN/a2beYKBInz31SrsHF2mE=;
        b=bvy0/dJQlP6JcYNGzsRIGpPy+FEwNUCw3GoF+jGOSexYQd3K0I6OPhjqRFCzHtdJO0
         33fVNBkIf+7H9qmv7DWw3+vKMnPEANdv+O9nLp25EJofoOxm2KvgceJpICEPrz3ILiAg
         Jd8UJZUAaGnRC21/VME3bNDG8XeTgUzbITlMH5mppYaQpPFOQlthx510ZUNqtXO5pvLn
         MEOJzL7KwBA0qjW6Oa+2F2KoID4yrK2haBdf1nVCo50fhP6BqJ7rsihNrnqtQZW+mYx3
         rCz+WCxmqEwdZlz72v/dmXCf5Tp45TFDFT8m9wNCUBiCSsKGDDcFNMSfdOeDz1TRjzOM
         qPPg==
In-Reply-To: <20180112122405.GK1732-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Jan 12, 2018 at 4:24 AM, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Fri 12-01-18 00:59:38, Andrey Ryabinin wrote:
>> On 01/11/2018 07:29 PM, Michal Hocko wrote:
> [...]
>> > I do not think so. Consider that this reclaim races with other
>> > reclaimers. Now you are reclaiming a large chunk so you might end up
>> > reclaiming more than necessary. SWAP_CLUSTER_MAX would reduce the over
>> > reclaim to be negligible.
>> >
>>
>> I did consider this. And I think, I already explained that sort of race in previous email.
>> Whether "Task B" is really a task in cgroup or it's actually a bunch of reclaimers,
>> doesn't matter. That doesn't change anything.
>
> I would _really_ prefer two patches here. The first one removing the
> hard coded reclaim count. That thing is just dubious at best. If you
> _really_ think that the higher reclaim target is meaningfull then make
> it a separate patch. I am not conviced but I will not nack it it either.
> But it will make our life much easier if my over reclaim concern is
> right and we will need to revert it. Conceptually those two changes are
> independent anywa.
>

Personally I feel that the cgroup-v2 semantics are much cleaner for
setting limit. There is no race with the allocators in the memcg,
though oom-killer can be triggered. For cgroup-v1, the user does not
expect OOM killer and EBUSY is expected on unsuccessful reclaim. How
about we do something similar here and make sure oom killer can not be
triggered for the given memcg?

// pseudo code
disable_oom(memcg)
old = xchg(&memcg->memory.limit, requested_limit)

reclaim memory until usage gets below new limit or retries are exhausted

if (unsuccessful) {
  reset_limit(memcg, old)
  ret = EBUSY
} else
  ret = 0;
enable_oom(memcg)

This way there is no race with the allocators and oom killer will not
be triggered. The processes in the memcg can suffer but that should be
within the expectation of the user. One disclaimer though, disabling
oom for memcg needs more thought.

Shakeel
