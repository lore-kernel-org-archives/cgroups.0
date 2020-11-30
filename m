From: Lorenzo Stoakes <lstoakes-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: BUG: KASAN: null-ptr-deref in workingset_eviction+0xf2/0x1e0
Date: Mon, 30 Nov 2020 20:02:20 +0000
Message-ID: <CAA5enKbujU+PRwA3qeYqx-Ydcj7owJnYkeTYJFdBweQJjWU78w@mail.gmail.com>
References: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wkgGZlXFTsc7rTynWbLSdwUFsTUmKl5GnDvKV+LtZYY=;
        b=PJ3KLIGamaGWru818Udw4jyMnVi7uD8Q1uTb8kV+YBiT8qN7akbLHVgO0WLRSFdVi6
         UAodIxUJbgfUcH2vqemO+bsC75Qjcdfx/N2ACm805ScjGXWrtLDfoze8RcOF0QepVLR2
         sqb/KPY2atxNIKr+MgTkoIDK3x4gM17F1F0lVClMCY+WKrrvpuQxJ0p51DsHF4/kcPeD
         Q8VnB221mfw4f3xKn6W1W7YwsanYztAiIlCAh4c/4PS6iaHNBuB8d7XReDv6V7MqHI05
         dyAcUVNB+U52efW/K8hRDKbuKmvoy643zzMZ/6P+SMLmC78+V3A2qbDqGhKH5ZBBVRvF
         Ctlg==
In-Reply-To: <CA+G9fYtk3fKy7ct-rT=T8iFDhE4CbjGgdfxsOBrKT9y8ntwXyg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: inux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux-Next Mailing List <linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkft-triage-cunTk1MwBs8s++Sfvej+rw@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, alexander.h.duyck-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, richard.weiyang-Re5JQEeQqe8@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>

On Mon, 30 Nov 2020 at 19:52, Naresh Kamboju <naresh.kamboju-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> [  285.863025] BUG: kernel NULL pointer dereference, address: 00000000000000c8

This looks to be the same as
https://lore.kernel.org/linux-mm/20201130132345.GJ17338-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/T/#t
