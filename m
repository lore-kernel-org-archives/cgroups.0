From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/2] mm: memcontrol: don't allocate cgroup swap arrays
 when memcg is disabled
Date: Fri, 19 Mar 2021 07:00:24 -0700
Message-ID: <CALvZod4RD6ALiQHrFBMWMytYW0Lg+RFZapKKSWJbK+-ue9BG2A@mail.gmail.com>
References: <20210319054944.50048-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CCZAHZFhptxcyqdqzzX/b+llWDB9Z2cdnFChdhi5Vwg=;
        b=hbuafUMuXP312PXrZHnMp/92FBrmirq42lyx06C8Agvn87xHEoPo7OQu6gl2wSVWMO
         I6doAnkI5UZ0G0OdBgSgw7TdfurM6EjLVZBa0M+Y5aZUPhfzckmx9H30C15CVZeAxFZe
         4uxJHzgd5zNB2Shl7VKLfHcAFXrQwXeJ22Nl9RzXfrTV9PaT8nCUomECivrsQ5FaaqiI
         T/ltkh0E+Md2wAJzG94MHdJ1IKPJKBvqP5Tsd9Cnyp/TB1utqQwprQzjEXCNltXpJ/xP
         zC8uwR6rKEg5aBhOXxJ5CgMIva1CslYrhntNPzlA5wX9c0C5QrxEKEd066vPiNwcTJER
         pPfg==
In-Reply-To: <20210319054944.50048-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Thu, Mar 18, 2021 at 10:49 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> Since commit 2d1c498072de ("mm: memcontrol: make swap tracking an
> integral part of memory control"), the cgroup swap arrays are used to
> track memory ownership at the time of swap readahead and swapoff, even
> if swap space *accounting* has been turned off by the user via
> swapaccount=0 (which sets cgroup_memory_noswap).
>
> However, the patch was overzealous: by simply dropping the
> cgroup_memory_noswap conditionals in the swapon, swapoff and uncharge
> path, it caused the cgroup arrays being allocated even when the memory
> controller as a whole is disabled. This is a waste of that memory.
>
> Restore mem_cgroup_disabled() checks, implied previously by
> cgroup_memory_noswap, in the swapon, swapoff, and swap_entry_free
> callbacks.
>
> Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
> Reported-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
