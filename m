From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/18] mm: memcontrol: move out cgroup swaprate throttling
Date: Wed, 22 Apr 2020 15:20:15 -0700
Message-ID: <CALvZod6mHQZ=fK4F2az+11q2t8mBU7EWU_FedGrZ--sjwFTo3w@mail.gmail.com>
References: <20200420221126.341272-1-hannes@cmpxchg.org> <20200420221126.341272-5-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7RkYliGFMdqXvO717N2pm4NnCZwapAsCgxwoREIwOrQ=;
        b=CLGEo+u6Ol6OoAJw6QXk0qHvTJvCNzFarr5oZ0N0OMVK0XtleuSdVK7pspDWG+k8jZ
         Fm6/J0Sa0R+dGQWLaH2Zbx07U2d3gIJZb/HPrE7IkZdmhaPk23GjxGZsP3sxqcHhkuVA
         JFsolmPT4jwkqogLz/cwAuqgpFa1+OvRlp9T/mP0vAcqFi9KKYNHf8q8DT6m0kVrJ82t
         ETNo6nwSIlWJd3Fqek4NNLkYj1sNQgBMjr3ocYfmpru/Jzn4futMt2nX5p4XBcZb4SMq
         bxL7eaGouhPxxZIK/cYUP5Ge4aZsfSmKI5MYbgEpRXPj6Idx+OiBwCRD++V/dck67C/g
         FrlA==
In-Reply-To: <20200420221126.341272-5-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Joonsoo Kim <js1304-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Mon, Apr 20, 2020 at 3:11 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> The cgroup swaprate throttling is about matching new anon allocations
> to the rate of available IO when that is being throttled. It's the io
> controller hooking into the VM, rather than a memory controller thing.
>
> Rename mem_cgroup_throttle_swaprate() to cgroup_throttle_swaprate(),
> and drop the @memcg argument which is only used to check whether the
> preceding page charge has succeeded and the fault is proceeding.
>
> We could decouple the call from mem_cgroup_try_charge() here as well,
> but that would cause unnecessary churn: the following patches convert
> all callsites to a new charge API and we'll decouple as we go along.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
