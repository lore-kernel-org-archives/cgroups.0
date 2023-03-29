From: Hugh Dickins <hughd@google.com>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Wed, 29 Mar 2023 12:22:24 -0700 (PDT)
Message-ID: <f9b6410-ee17-635f-a35d-559fa0191dc3@google.com>
References: <20230323040037.2389095-1-yosryahmed@google.com> <20230323040037.2389095-2-yosryahmed@google.com> <ZBz/V5a7/6PZeM7S@slm.duckdns.org> <CAJD7tkYNZeEytm_Px9_73Y-AYJfHAxaoTmmnO71HW5hd1B5tPg@mail.gmail.com> <ZB5UalkjGngcBDEJ@slm.duckdns.org>
 <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com> <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com> <CAJD7tkY_ESpMYMw72bsATpp6tPphv8qS6VbfEUjpKZW6vUqQSQ@mail.gmail.com> <CALvZod41ecuCKmuFBNtAjoKJjQgWYzoe4_B8zRK37HYk-rYDkA@mail.gmail.com>
 <CAJD7tkZrp=4zWvjE9_010TAG1T_crCbf9P64UzJABspgcrGPKg@mail.gmail.com> <ZCSJDpPPOVvBYfOy@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680117757;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=MD5vx/bj0saF4TqNG1nIF/YU28Jg42gUeejN+X2NCpY=;
        b=jT/j7PjxyG20P2CKl37aHA/z29PlP5r8hnouR7V1cEBZfIyQle/ffgyZ7SeY8TFDTN
         LriKUchyJMzRZTZfx2Ra1tFVLAY+IMhcDrjzjdXPhFcyX9wQ7Iq+ch1Lp8XCUn+PP+XT
         mDo99xFXTYufeJOx6O5lkcrR1KnrVe7fdgkK5wdj2U9WZ56B4j+7MKNJrYUu3YvPOJMS
         ddD10ubhfVeY9zNjMGsO05U3lUzlkLtHm4GWbA1tvIzVEXeRefinLhNUJ5Dyd+qyBevy
         Xp/QTExSKgMNuwRvOPQ7LHvWnn4acK885eIH7mW88e7D4Z3v4p2DeFo9+nXpGm8NXh8t
         I/VA==
In-Reply-To: <ZCSJDpPPOVvBYfOy@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeelb@google.com>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org

Hi Tejun,

On Wed, 29 Mar 2023, Tejun Heo wrote:
> On Mon, Mar 27, 2023 at 04:23:13PM -0700, Yosry Ahmed wrote:
> > Tejun, if having the lock be non-irq is a non-starter for you, I can
> 
> This is an actual hazard. We see in prod these unprotected locks causing
> very big spikes in tail latencies and they can be tricky to root cause too
> and given the way rstat lock is used it's highly likely to be involved in
> those scenarios with the proposed change, so it's gonna be a nack from my
> end.

Butting in here, I'm fascinated.  This is certainly not my area, I know
nothing about rstat, but this is the first time I ever heard someone
arguing for more disabling of interrupts rather than less.

An interrupt coming in while holding a contended resource can certainly
add to latencies, that I accept of course.  But until now, I thought it
was agreed best practice to disable irqs only regretfully, when strictly
necessary.

If that has changed, I for one want to know about it.  How should we
now judge which spinlocks should disable interrupts and which should not?
Page table locks are currently my main interest - should those be changed?

Thanks,
Hugh
