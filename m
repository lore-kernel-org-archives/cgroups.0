From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: introduce per-memcg reclaim interface
Date: Tue, 6 Oct 2020 09:55:43 -0700
Message-ID: <CALvZod59cU40A3nbQtkP50Ae3g6T2MQSt+q1=O2=Gy9QUzNkbg@mail.gmail.com>
References: <20200909215752.1725525-1-shakeelb@google.com> <20200928210216.GA378894@cmpxchg.org>
 <20200929150444.GG2277@dhcp22.suse.cz> <20200929215341.GA408059@cmpxchg.org>
 <CALvZod5eN0PDtKo8SEp1n-xGvgCX9k6-OBGYLT3RmzhA+Q-2hw@mail.gmail.com> <20201001143149.GA493631@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6FMgIEmm68X+8barBvlty/GsDrmbyTvteiUC/zViSzM=;
        b=E+fs5Kb6ZtKcDpUZvLnSB08EOAVj2XhAZad69x+W3WhY0TvKQs7HLnWuX1DalOm5k3
         75g0XMp7neiJ0e9OM6kSd7eBrufBh65ij0geSUYX+V5pNfDC72uq3vfmfDr0gtlZMpbJ
         DcQ0L1pYWRcCDJNfvgKMXtdc4EmejdC6A7ZExgxw+UxR0Ojc0g9NL1qIJs/8vB0fMhdJ
         x1JgRTLTqvDnnjFkkyrjySeMyl+r5ulpW2pQVTHhS4Ehu9+aX8n2CePeR3tUCCaBQ07T
         OQZfOuGO2gJWiGAternLPjoBUgE1ZZbuHrHcPcpP/ZzCWyLa8C6aBNI8lPQeSibLV3XP
         Y+Xw==
In-Reply-To: <20201001143149.GA493631@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Yang Shi <yang.shi@linux.alibaba.com>, Greg Thelen <gthelen@google.com>, David Rientjes <rientjes@google.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andrea Righi <andrea.righi@canonical.com>, SeongJae Park <sjpark@amazon.com>

On Thu, Oct 1, 2020 at 7:33 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
>
[snip]
> > >    So instead of asking users for a target size whose suitability
> > >    heavily depends on the kernel's LRU implementation, the readahead
> > >    code, the IO device's capability and general load, why not directly
> > >    ask the user for a pressure level that the workload is comfortable
> > >    with and which captures all of the above factors implicitly? Then
> > >    let the kernel do this feedback loop from a per-cgroup worker.
> >
> > I am assuming here by pressure level you are referring to the PSI like
> > interface e.g. allowing the users to tell about their jobs that X
> > amount of stalls in a fixed time window is tolerable.
>
> Right, essentially the same parameters that psi poll() would take.

I thought a bit more on the semantics of the psi usage for the
proactive reclaim.

Suppose I have a top level cgroup A on which I want to enable
proactive reclaim. Which memory psi events should the proactive
reclaim should consider?

The simplest would be the memory.psi at 'A'. However memory.psi is
hierarchical and I would not really want the pressure due limits in
children of 'A' to impact the proactive reclaim. PSI due to refaults
and slow IO should be included or maybe only those which are caused by
the proactive reclaim itself. I am undecided on the PSI due to
compaction. PSI due to global reclaim for 'A' is even more
complicated. This is a stall due to reclaiming from the system
including self. It might not really cause more refaults and IOs for
'A'. Should proactive reclaim ignore the pressure due to global
pressure when tuning its aggressiveness.

Am I overthinking here?
