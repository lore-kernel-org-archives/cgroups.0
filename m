From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4] mm: vmpressure: don't count proactive reclaim in vmpressure
Date: Wed, 20 Jul 2022 11:02:56 -0700
Message-ID: <CAJD7tkYBm+L_-GTLDux0ZsJ6=kw-zzHjs6vgKUtmeZhcxLwqiw@mail.gmail.com>
References: <20220714064918.2576464-1-yosryahmed@google.com>
 <YtfJug77XJ9BPA8L@dhcp22.suse.cz> <CALvZod7X3PsM2+ZrWXwb75FNBBjaBGJpjd+WVmzr5hStROvW+g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2YSXf98rTw+aM6nqedJXsMdekQD67mGphdqXFvr1fbM=;
        b=dnV0YHWvnhuMUuSd57347+DOzR3AxQcrR7zzAGoWSmv8OwPuA4SNbmOO5Dz88dFjqy
         kls9OTarVd8bmE/zaV7DVW5OrVc2W6xDg9rvm85GE0fVrn+2S8m/4yEbf3pPxfB1qZKb
         v3sjYgyUFN3/vHk3+826GcexfrrE6GCpCZu4Q6Bn1efuiZU9eBg1uXRDZTJRXJx3UKbN
         2zfN3FZLP1hZvN7KZrO1h+8oAIhvt5/VumAis5ShZIb7OCuHVOo5kkDLK+zwYpcXRfgC
         lQX0lzUNZpJW6zkqJ6iPyGtc7lQuGW3RZ6Ssly/XvZ0alzMjN4C6DqQBTB3InJ3Gmly1
         XlvA==
In-Reply-To: <CALvZod7X3PsM2+ZrWXwb75FNBBjaBGJpjd+WVmzr5hStROvW+g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, NeilBrown <neilb-l3A5Bk7waGM@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Xu <peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Wed, Jul 20, 2022 at 10:50 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Jul 20, 2022 at 2:24 AM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> >
> [...]
> >
> > I think what we are missing here is
> > - explain that this doesn't have any effect on existing users of
> >   vmpressure user interface because that is cgroup v1 and memory.reclaim
> >   is v2 feature. This is a trivial statement but quite useful for future
> >   readers of this commit
> > - explain the effect on the networking layer and typical usecases
> >   memory.reclaim is used for currently and ideally document that.
>
> I agree with the above two points (Yosry, please address those) but
> the following third point is orthogonal and we don't really need to
> have an answer for this patch to be accepted.
>

That's great feedback, thanks Michal and Shakeel!

How do you feel about the following commit message instead? Does it
address your concerns?:

memory.reclaim is a cgroup v2 interface that allows users to
proactively reclaim memory from a memcg, without real memory pressure.
Reclaim operations invoke vmpressure, which is used in cgroup v1 to
notify userspace of reclaim efficiency, and used in both v1 and v2 as
a signal for a memcg being under memory pressure for networking (see
mem_cgroup_under_socket_pressure()). For the former, vmpressure
notifications in v1 are not affected by this change since
memory.reclaim is a v2 feature.

For the latter, the effects of the vmpressure signal (according to
Shakeel [1]) are as follows:
1. Reducing send and receive buffers of the current socket.
2. May drop packets on the rx path.
3. May throttle current thread on the tx path.

Since proactive reclaim is invoked directly by userspace, not by
memory pressure, it makes sense not to throttle networking. Hence,
this change makes sure that proactive reclaim caused by memory.reclaim
does not trigger vmpressure.

[1] https://lore.kernel.org/lkml/CALvZod68WdrXEmBpOkadhB5GPYmCXaDZzXH=yyGOCAjFRn4NDQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org/

> > - how are we going to deal with users who would really want to use
> >   memory.reclaim interface as a replacement for existing hard/high
> >   memory reclaim? Is that even something that the interface is intended
> >   for?
>
> I do agree that this question is important. Nowadays I am looking at
> this from a different perspective and use-case. More concretely how
> (and why) to replace vmpressure based network throttling for cgroup
> v2. I will start a separate thread for that discussion.
