From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [RFC PATCH 0/7] Make rstat flushing IRQ and sleep friendly
Date: Wed, 22 Mar 2023 22:07:43 -0700
Message-ID: <CAJD7tkYYQjZyDpTc02WTGG_aW+wS8m2k407X3NhLrN8Y_5RKPA@mail.gmail.com>
References: <20230323040037.2389095-1-yosryahmed@google.com> <CALvZod5uyZRsvA5ntw0jSBXUNa1_HzB9zOabsGKsndyA5KCYnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679548103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=irOCu6qMS+se6H9bO0nEHf2Vgt336FUw4SAiYtLjT5U=;
        b=BqoBVzRuIH8J9krQGYDjW2lWJAbsyVIbf54oq0OxDs8xWSUXzKrPjJFi9K972u6e4Y
         y/WyGtS2YaZab2zyJzmpClXNAUt0Fvy5kT7BMkYWzvuydcQjU94k/Kwekd9E46Cjri/2
         O+AyFp7RSfLmAQ6+Lp71LY5X76waPqmxpGicoeDUt+pDLFmY/Qnz1EIa3j3xxaSs/JgT
         1M+WnK+NgenBX6Rz/kWFePDYEHcwxigsbxOboPo3tY+4Zxt0O6QI73Dbr/KwLnsWa9ut
         bng9scnddfnOejaHZOiUDLeyML3IeISce4O9Zwns1kdY8oue8KvKtY6wqq5uKRWDExoe
         6FrQ==
In-Reply-To: <CALvZod5uyZRsvA5ntw0jSBXUNa1_HzB9zOabsGKsndyA5KCYnQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

On Wed, Mar 22, 2023 at 9:10=E2=80=AFPM Shakeel Butt <shakeelb@google.com> =
wrote:
>
> On Wed, Mar 22, 2023 at 9:00=E2=80=AFPM Yosry Ahmed <yosryahmed@google.co=
m> wrote:
> >
> > Currently, if rstat flushing is invoked using the irqsafe variant
> > cgroup_rstat_flush_irqsafe(), we keep interrupts disabled and do not
> > sleep for the entire flush operation, which is O(# cpus * # cgroups).
> > This can be rather dangerous.
> >
> > Not all contexts that use cgroup_rstat_flush_irqsafe() actually cannot
> > sleep, and among those that cannot sleep, not all contexts require
> > interrupts to be disabled.
>
> Too many negations in the above sentence is making it very confusing.

Sorry, this is indeed very confusing. I guess a better rephrasing is:

Multiple code paths use cgroup_rstat_flush_irqsafe(), but many of them
can sleep. Even among the code paths that actually cannot sleep,
multiple ones are interruptible.
