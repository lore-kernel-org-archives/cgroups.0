From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered memory
Date: Thu, 8 Apr 2021 10:18:47 -0700
Message-ID: <CALvZod7StYJCPnWRNLnYQV8S5CBLtE0w4r2rH-wZzNs9jGJSRg@mail.gmail.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0gEpNulq0JouzND7X8G/z4bZ8lZh7ERFU8FSsc0Dzac=;
        b=noL0zUmUFj2zwRUlYv3RquGNc8nwvDeqlE7uolCFVwehPyaRUjY3VAKKdGmRjzbZLl
         fD/PB2RNqDPIm2ezoQBU50070lVbfVsBOPRUfF+ZdyFQ+u6wHf9KMr7fBrLDaTEI1FbC
         XnC8zE6YqHXvJ/ZndiMiAa/1OhHSxtZ5S2Qa5UuUIrwGZtS96hvH34Wr1Io9GkW4/YgG
         zP/vAfPyeqU0PLkig/L+1rfZZmne+DWF9FAvwzjvjDLs6bwdvCIEtJyrdhIzts+iS2OA
         TCT04r2xZHuzfYbs0VIAhgUPfg2fj8fWboitjtol+M2nlDBeCyOsQessN0yhxxmJ/rQH
         Ix3A==
In-Reply-To: <cover.1617642417.git.tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hi Tim,

On Mon, Apr 5, 2021 at 11:08 AM Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org> wrote:
>
> Traditionally, all memory is DRAM.  Some DRAM might be closer/faster than
> others NUMA wise, but a byte of media has about the same cost whether it
> is close or far.  But, with new memory tiers such as Persistent Memory
> (PMEM).  there is a choice between fast/expensive DRAM and slow/cheap
> PMEM.
>
> The fast/expensive memory lives in the top tier of the memory hierachy.
>
> Previously, the patchset
> [PATCH 00/10] [v7] Migrate Pages in lieu of discard
> https://lore.kernel.org/linux-mm/20210401183216.443C4443-LXbPSdftPKxrdx17CPfAsdBPR1lH4CV8@public.gmane.org/
> provides a mechanism to demote cold pages from DRAM node into PMEM.
>
> And the patchset
> [PATCH 0/6] [RFC v6] NUMA balancing: optimize memory placement for memory tiering system
> https://lore.kernel.org/linux-mm/20210311081821.138467-1-ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> provides a mechanism to promote hot pages in PMEM to the DRAM node
> leveraging autonuma.
>
> The two patchsets together keep the hot pages in DRAM and colder pages
> in PMEM.

Thanks for working on this as this is becoming more and more important
particularly in the data centers where memory is a big portion of the
cost.

I see you have responded to Michal and I will add my more specific
response there. Here I wanted to give my high level concern regarding
using v1's soft limit like semantics for top tier memory.

This patch series aims to distribute/partition top tier memory between
jobs of different priorities. We want high priority jobs to have
preferential access to the top tier memory and we don't want low
priority jobs to hog the top tier memory.

Using v1's soft limit like behavior can potentially cause high
priority jobs to stall to make enough space on top tier memory on
their allocation path and I think this patchset is aiming to reduce
that impact by making kswapd do that work. However I think the more
concerning issue is the low priority job hogging the top tier memory.

The possible ways the low priority job can hog the top tier memory are
by allocating non-movable memory or by mlocking the memory. (Oh there
is also pinning the memory but I don't know if there is a user api to
pin memory?) For the mlocked memory, you need to either modify the
reclaim code or use a different mechanism for demoting cold memory.

Basically I am saying we should put the upfront control (limit) on the
usage of top tier memory by the jobs.
