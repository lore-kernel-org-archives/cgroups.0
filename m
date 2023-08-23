From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 3/3] mm: memcg: use non-unified stats flushing for
 userspace reads
Date: Wed, 23 Aug 2023 09:33:17 +0200
Message-ID: <ZOW2PZN8Sgqq6uR2@dhcp22.suse.cz>
References: <20230821205458.1764662-1-yosryahmed@google.com>
 <20230821205458.1764662-4-yosryahmed@google.com>
 <ZOR6eyYfJYlxdMet@dhcp22.suse.cz>
 <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692775998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0SctbqgZjFFOicN/oLKPgrVMYfxZTnrl4bohndLZhFw=;
        b=hCXFa9a5NNinjYOciz1NJlp40rerbNvpu4j7TEmXTMQ7b/kHiHRYrRtrQdx0wxJ9Qk0XW3
        TY0lUbZdY3FxijHgvhI3EJy+T4gupko+GkbciMQzNq+K3sJ3p88yJRGydrsJL5ojb26tLo
        +FZLVZ+yG3y6bDmDpf4RHgjJQYLrVbk=
Content-Disposition: inline
In-Reply-To: <CAJD7tka13M-zVZTyQJYL1iUAYvuQ1fcHbCjcOBZcz6POYTV-4g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 22-08-23 08:30:05, Yosry Ahmed wrote:
> On Tue, Aug 22, 2023 at 2:06=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@=
public.gmane.org> wrote:
> >
> > On Mon 21-08-23 20:54:58, Yosry Ahmed wrote:
[...]
> So to answer your question, I don't think a random user can really
> affect the system in a significant way by constantly flushing. In
> fact, in the test script (which I am now attaching, in case you're
> interested), there are hundreds of threads that are reading stats of
> different cgroups every 1s, and I don't see any negative effects on
> in-kernel flushers in this case (reclaimers).

I suspect you have missed my point. Maybe I am just misunderstanding
the code but it seems to me that the lock dropping inside
cgroup_rstat_flush_locked effectivelly allows unbounded number of
contenders which is really dangerous when it is triggerable from the
userspace. The number of spinners at a moment is always bound by the
number CPUs but depending on timing many potential spinners might be
cond_rescheded and the worst time latency to complete can be really
high. Makes more sense?
--=20
Michal Hocko
SUSE Labs
