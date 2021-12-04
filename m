From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: add group_oom_kill memory event
Date: Fri, 3 Dec 2021 16:45:54 -0800
Message-ID: <CALvZod6y+_O49jzuD9wLXncCEGCgun4f-uf_yBzYcsfEiH1WOQ@mail.gmail.com>
References: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=84mOUp3LokD6J3j/XPGM8Gdyu0TNZ1hY1SXnt8ueQl0=;
        b=W00VL1dQdtqB96CSXr76uDShRNGRcJZoc5gxPBZH6JD2lO3sXg/MbNgoIepxvjgy/v
         1ngl4zAcaMGNYSSMFZUmcTZGNuuO8BREoXOAvrLF1NuaG6twbr/BvF8zVlA2WCvc2n+s
         3atBTFjXpvf1BSw+xfGON8yWnXNLilAs33nqQ3TOiIIAryw8JTfFkO7b1WoJAv3zh/vW
         q1r05yy7mWaFNdo7OI46VANrC5cGCWMoG3EInP4CFFm8+Q/q39qu7nPEsJ9jSHTc3IgO
         oyiqNf62GHUrdj+I5THRVlKdw6jqwGTlCFLYmU1q+05R2IZ7CtOuatZgdbmNpnfUpW6C
         1BoA==
In-Reply-To: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alexs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Fri, Dec 3, 2021 at 8:24 AM Dan Schatzberg <schatzberg.dan@gmail.com> wrote:
>
> Our container agent wants to know when a container exits if it was OOM
> killed or not to report to the user. We use memory.oom.group = 1 to
> ensure that OOM kills within the container's cgroup kill
> everything. Existing memory.events are insufficient for knowing if
> this triggered:
>
> 1) Our current approach reads memory.events oom_kill and reports the
> container was killed if the value is non-zero. This is erroneous in
> some cases where containers create their children cgroups with
> memory.oom.group=1 as such OOM kills will get counted against the
> container cgroup's oom_kill counter despite not actually OOM killing
> the entire container.
>
> 2) Reading memory.events.local will fail to identify OOM kills in leaf
> cgroups (that don't set memory.oom.group) within the container cgroup.
>
> This patch adds a new oom_group_kill event when memory.oom.group
> triggers to allow userspace to cleanly identify when an entire cgroup
> is oom killed.
>
> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>

So, with this patch, will you be watching oom_group_kill from
memory.events or memory.events.local file for your use-case?

Reviewed-by: Shakeel Butt <shakeelb@google.com>
