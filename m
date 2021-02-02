From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/7] mm: memcontrol: kill mem_cgroup_nodeinfo()
Date: Tue, 2 Feb 2021 14:24:41 -0800
Message-ID: <CALvZod5LRn=c0RUQqTgSbnRS6NbV+9XNZi14MHxKSmYSXOnDSg@mail.gmail.com>
References: <20210202184746.119084-1-hannes@cmpxchg.org> <20210202184746.119084-3-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JXK8oq2DlbA7lyIsSaGTbwXFgGanxEu82dZ8lLRpgRw=;
        b=ABwNqw1tZfnQ+pjITPrqd6B5h0qyKE2MxWTXL9GsCi2M91XYgvXwF7Yl98c8LCnnhV
         /zXHZNkSQZbH8iPevzHgFl0+/BWPbH+9+aUkc2dL4Oc+W8jHh4vFJ6WvIMcapMqmaLIT
         Rbkd/ekRkrGWHJ9hMDQv5pG4d0jF7pdXi2DZhpZk8RUUSipEjBk0eJDul3rKfgl1bOrL
         W8pqkiA+BJJHTf1rYvImkuwiCJbpqq5EXP2UsyQvGjQp6zsDIUnSRqHvPu79JZHrdomV
         hjUVD8PLX9jOyTqvLZv0w29ni00p6EvVp6iQLrkqgrk7cEDz4ucCdkzm/Ly29omQXrZQ
         1GBw==
In-Reply-To: <20210202184746.119084-3-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>

On Tue, Feb 2, 2021 at 12:51 PM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> No need to encapsulate a simple struct member access.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
