From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 4/5] mm: memcontrol: move remote memcg charging APIs to CONFIG_MEMCG_KMEM
Date: Mon, 1 Mar 2021 19:43:27 -0800
Message-ID: <CALvZod4rWvMJdnbfMm4SGtj0WyqDzvH8RY9G32y=NLNCZqJ2Gg@mail.gmail.com>
References: <20210301062227.59292-1-songmuchun@bytedance.com>
 <20210301062227.59292-5-songmuchun@bytedance.com> <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3B0Sx20A1r9upf4Kb0C/kpU0MZoTOmOraXVoNYgXq+0=;
        b=vhnQXwzEG4fSKT+nNG8JUDOp8WuwtYyM9Vz5u8UuMP5J6E6kOng7zABNCZkGIvqO/Z
         lF4txvkAhYVRIOspQwJRhpV/pfvlYUWQ8uOzwdf7klS7QjLw4GNL+ZBCxj7jb1kaXaWW
         2EVpdc+nUpLUFYKejU4N1/NkqXpsK+iNO2iUhOD5PzWkGPjRXlFH5Vq9hI5nweviVxJ0
         NpiRLjezGtQ6dFxliVjEln5wPhPJNrZsZ1EAFlEqOtxnHA3L0FT4PBwuk8yR82LJKP06
         vMlaRaiuezL4cMfKgC2gSDIA/EiixC0Hmd9+1A8bYAQyOZYqpDyERlYiqDTLSGk7L7Vd
         2HCw==
In-Reply-To: <YD2RuPzikjPnI82h@carbon.dhcp.thefacebook.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>, Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Muchun Song <songmuchun@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, esyr@redhat.com, linux-fsdevel <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>

On Mon, Mar 1, 2021 at 5:16 PM Roman Gushchin <guro@fb.com> wrote:
>
> On Mon, Mar 01, 2021 at 02:22:26PM +0800, Muchun Song wrote:
> > The remote memcg charing APIs is a mechanism to charge kernel memory
> > to a given memcg. So we can move the infrastructure to the scope of
> > the CONFIG_MEMCG_KMEM.
>
> This is not a good idea, because there is nothing kmem-specific
> in the idea of remote charging, and we definitely will see cases
> when user memory is charged to the process different from the current.
>

Indeed and which remind me: what happened to the "Charge loop device
i/o to issuing cgroup" series? That series was doing remote charging
for user pages.
