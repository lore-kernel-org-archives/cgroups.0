From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: use NUMA_NO_NODE to indicate allocation
 from unspecified node
Date: Sun, 16 Jan 2022 11:23:36 -0800
Message-ID: <CALvZod6odMTNMXNqc2KsmOYv0vEAT-eTZ2xP-UhkQSo0pf7+bA@mail.gmail.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <Yd1CdJA5NelzoK1D@dhcp22.suse.cz> <20220112004634.dc5suwei4ymyxaxg@master> <Yd6Xr7K9bKGVgGtI@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hU+OS4Mtwv3I0vy+iNW/4UuAtkSDs3qfMaH9agtczxw=;
        b=IXBWqMIvZmgkCjiwt9Q3j+mjCGE+6J+S4UDiBSUUpGUCfcno5XNU/zEfNYKufj9pbo
         mN46XqggL2AKWpLF0dagxWhuVQJhVngCZkW9t7ZU/R9pPe5cSQNatJ6t6mewMX7oANMP
         o5i4BneUdKCm/W9x7ztGVl2/TpDJFubZ62AkNI2JLiQKEwH0S0m+W99r1bilWzu101ML
         bqPIDTz+r6IkzCdhBBmz7iKT71B32Z+USN41d9Bb/QkL4dHC6bALBYyopRq3S85iZJ+w
         w3njQ/ET4IoYJunHTC9QAZ6JfphnkZkpJgO/tY4Gn3+B+1gN3CczulAwseNhpKLxexfF
         R3bw==
In-Reply-To: <Yd6Xr7K9bKGVgGtI-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Jan 12, 2022 at 12:56 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
>
> On Wed 12-01-22 00:46:34, Wei Yang wrote:
> > On Tue, Jan 11, 2022 at 09:40:20AM +0100, Michal Hocko wrote:
> > >On Tue 11-01-22 01:02:59, Wei Yang wrote:
> > >> Instead of use "-1", let's use NUMA_NO_NODE for consistency.
> > >>
> > >> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > >
> > >I am not really sure this is worth it. After the merge window I plan to
> > >post http://lkml.kernel.org/r/20211214100732.26335-1-mhocko-DgEjT+Ai2yi4UlQgPVntAg@public.gmane.org
> >
> > Give me some time to understand it :-)
>
> Just for the record, here is what I have put on top of that series:
> ---
> From b7195eba02fe6308a6927450f4630057c05e808e Mon Sep 17 00:00:00 2001
> From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Date: Tue, 11 Jan 2022 09:45:25 +0100
> Subject: [PATCH] memcg: do not tweak node in alloc_mem_cgroup_per_node_info
>
> alloc_mem_cgroup_per_node_info is allocated for each possible node and
> this used to be a problem because not !node_online nodes didn't have
> appropriate data structure allocated. This has changed by "mm: handle
> uninitialized numa nodes gracefully" so we can drop the special casing
> here.
>
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
