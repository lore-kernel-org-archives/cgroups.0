From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC PATCH v1 00/11] Manage the top tier memory in a tiered memory
Date: Mon, 12 Apr 2021 07:03:34 -0700
Message-ID: <CALvZod7y08qE0Zw0TB+1y28w19cRyccNXRC=Cy6bazW1HAXLZQ@mail.gmail.com>
References: <cover.1617642417.git.tim.c.chen@linux.intel.com>
 <YGwlGrHtDJPQF7UG@dhcp22.suse.cz> <c615a610-eb4b-7e1e-16d1-4bc12938b08a@linux.intel.com>
 <YG7ugXZZ9BcXyGGk@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wOKg8etxKl6YU4OPpm5oIEWuzY94vpojhhr8xmBl7+Y=;
        b=V5ll4uIP+zT1lm6DYY43H7k9LdxpTRg3xHNiausluEsx6vKF5oCOVESII5zB8hXmBz
         lLlw2WxfZ9cjqayt0wf2jk2rpQCrq3cwjESyVEGFSCMvzjaaVp5iQC1cMaoWLjpdQPqd
         9kiXTv/S8Hg5m7H2mSTrboWfW7xnyUrxF/ZXLfHYiJaqu3P14g/OBlcusSBEO6RUHvD4
         m6wYFi3jTQFyq2KEXVZXvd4di+U/43o2PnS/bVsqO/1yEJmBp/rAHNiuNZ1u3qMWti/Q
         HAPW3k72DPHLl0Gvf+k8ahbsXU95uf1COrhoj77lfWCOA8vBsxGUcGoVXKKQDNUV03aA
         XEpw==
In-Reply-To: <YG7ugXZZ9BcXyGGk-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tim Chen <tim.c.chen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Dave Hansen <dave.hansen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ying Huang <ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Apr 8, 2021 at 4:52 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
[...]
>
> What I am trying to say (and I have brought that up when demotion has been
> discussed at LSFMM) is that the implementation shouldn't be PMEM aware.
> The specific technology shouldn't be imprinted into the interface.
> Fundamentally you are trying to balance memory among NUMA nodes as we do
> not have other abstraction to use. So rather than talking about top,
> secondary, nth tier we have different NUMA nodes with different
> characteristics and you want to express your "priorities" for them.
>

I am also inclined towards NUMA based approach. It makes the solution
more general and even existing systems with multiple numa nodes and
DRAM can take advantage of this approach (if it makes sense).
