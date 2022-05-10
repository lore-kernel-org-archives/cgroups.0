From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v2 3/6] mm: Kconfig: group swap, slab, hotplug and thp
 options into submenus
Date: Tue, 10 May 2022 15:40:37 -0700
Message-ID: <20220510154037.c7916ee9d7de90eedd12f92c@linux-foundation.org>
References: <20220510152847.230957-1-hannes@cmpxchg.org>
        <20220510152847.230957-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1652222439;
        bh=Uep9omWAHUgcNmftnhT+OxXsLVstbaEvQlnJP1mh//w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aU3hfLPZDr+uUiq73DIBtXvAfY5S2GiWrylBB7qJs04cVSM3a032pbem+F+SzA3nD
         NmTFsl/iikJ9L8A13NTBsku9/0KwxWXCPXKeZ6/c0JvI6ckcVLMmTGJmlWcWt3QzJh
         PiasBPNTr9le1p4IUa0r4IApkoasZ/VAVs0RChD0=
In-Reply-To: <20220510152847.230957-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Seth Jennings <sjenning-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dan Streetman <ddstreet-EkmVulN54Sk@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, 10 May 2022 11:28:44 -0400 Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:

> There are several clusters of related config options spread throughout
> the mostly flat MM submenu. Group them together and put specialization
> options into further subdirectories to make the MM submenu a bit more
> organized and easier to navigate.

Causes

hp2:/usr/src/25> make allnoconfig

WARNING: unmet direct dependencies detected for ARCH_WANT_GENERAL_HUGETLB
  Depends on [n]: TRANSPARENT_HUGEPAGE [=n]
  Selected by [y]:
  - X86 [=y]

WARNING: unmet direct dependencies detected for ARCH_WANTS_THP_SWAP
  Depends on [n]: TRANSPARENT_HUGEPAGE [=n]
  Selected by [y]:
  - X86 [=y] && X86_64 [=y]
#
# configuration written to .config
#


I'll disable this and [4/6] for now.
