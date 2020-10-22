From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: add file_thp, shmem_thp to memory.stat
Date: Thu, 22 Oct 2020 09:51:01 -0700
Message-ID: <CALvZod7SOpaVcmVZDTw-UeVo3Jx=VfojBzO5f7k5ATPXeN7K+A@mail.gmail.com>
References: <20201022151844.489337-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xd+wFurjGt8mIia5D9RdI7kEY/qSyqqqpi8eDO7fd4U=;
        b=LrjBvKpulM/XMhJARW83BKyF12g1Mqfl10AXRgIMcG9LM7S6kcl4R6MlFwlFkEA/1a
         d/KzVeD+H36kd9k/4RiTQHrYtLgqMyf+qBYv/N8Ex//ESFw0YXOyN4StOv1ukEWWqeQr
         hyGdvREaI2zbnlt9ny7p45Sad/Gd/FFkejzXvXodXkc/tufjFz7F4cjPQcROrIrimbjt
         LDcWSPR2XQzbiqwiz3VAllqfZ39xfPGZTzfanQ2bJ2679ENBpGehMgtEagxaUfdusjuu
         Lz0bsQ5wNKlvGwK2a5JbDUGAVjzXcEQHfzg7+ZdDyW2WOdOAoN5ovZXyr1aABAUXxX9U
         T/Wg==
In-Reply-To: <20201022151844.489337-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Thu, Oct 22, 2020 at 8:20 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> As huge page usage in the page cache and for shmem files proliferates
> in our production environment, the performance monitoring team has
> asked for per-cgroup stats on those pages.
>
> We already track and export anon_thp per cgroup. We already track file
> THP and shmem THP per node, so making them per-cgroup is only a matter
> of switching from node to lruvec counters. All callsites are in places
> where the pages are charged and locked, so page->memcg is stable.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
