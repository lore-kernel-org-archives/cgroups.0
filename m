From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 4/8] cgroup: rstat: support cgroup1
Date: Fri, 5 Feb 2021 14:11:13 -0800
Message-ID: <CALvZod6R7Qbx2JgTHM-uLeRHZLhaMZiCkbevQBTN=jVizrt-Lw@mail.gmail.com>
References: <20210205182806.17220-1-hannes@cmpxchg.org> <20210205182806.17220-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/4qEkNOrLEa6lxN/95STT61avrFjfvYnDY/MmP9s+0o=;
        b=SFMRg/15SplEen1Sye0qlnbdi+BfK5VijvW5vUJ3y4Bmd4WNJhz6tl0srP2+1DuSsw
         C3lWkUPurWOVp2t0RFiov09RInfN7R/g5i+K4WwL4uTDcMOdhpN9CeSp801NpEtNOBEC
         SUdZb4605uhwR5bxZZ2IVZ3+ObmydPjYJuSCzxaXilJ1YgjkzpbLxmNch2OjtoJfI10g
         USfaUm4N8916uETHmf91lTR6yn2JpFCCrQuufBqk+FfCam5Z/XPbN5uKx99d7R/QHtcn
         sP15nQFOITOtaQ/eAIvwbrPPeGrV1BcVQa5PrUgUWKGhSDaW5yOE5xD6ccRkRVR1ZMNi
         ue2A==
In-Reply-To: <20210205182806.17220-5-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Fri, Feb 5, 2021 at 10:28 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Rstat currently only supports the default hierarchy in cgroup2. In
> order to replace memcg's private stats infrastructure - used in both
> cgroup1 and cgroup2 - with rstat, the latter needs to support cgroup1.
>
> The initialization and destruction callbacks for regular cgroups are
> already in place. Remove the cgroup_on_dfl() guards to handle cgroup1.
>
> The initialization of the root cgroup is currently hardcoded to only
> handle cgrp_dfl_root.cgrp. Move those callbacks to cgroup_setup_root()
> and cgroup_destroy_root() to handle the default root as well as the
> various cgroup1 roots we may set up during mounting.
>
> The linking of css to cgroups happens in code shared between cgroup1
> and cgroup2 as well. Simply remove the cgroup_on_dfl() guard.
>
> Linkage of the root css to the root cgroup is a bit trickier: per
> default, the root css of a subsystem controller belongs to the default
> hierarchy (i.e. the cgroup2 root). When a controller is mounted in its
> cgroup1 version, the root css is stolen and moved to the cgroup1 root;
> on unmount, the css moves back to the default hierarchy. Annotate
> rebind_subsystems() to move the root css linkage along between roots.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
