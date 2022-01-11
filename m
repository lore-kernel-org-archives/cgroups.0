From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Mon, 10 Jan 2022 18:55:10 -0800
Message-ID: <CAHk-=whxmsa7mnzwe-DV6m26teV32geB-n-aKbYHXNm1k4rVwg@mail.gmail.com>
References: <20220111025138.1071848-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=u+Y28XxOTbwhPxzWhN6RbihwTYYfYJcoL9vjrnUr5zE=;
        b=dUok9tPThdjODcNE51pXamu5TwIzsdpaI5zTXGTRW4tg5ulv80Dh6+vkkiIFZ/PpyT
         FkFAgWhiQVPIXAOMWzUy1TGBrsE3Nu4l6kZFbOCJZ5CN61JWBAM6rkoXCl6at0rWQxhI
         PCR0gQqsIgknv2e3sVxB+FPFIdXxYloQtZRyw=
In-Reply-To: <20220111025138.1071848-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Eric Biggers <ebiggers@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Android Kernel Team <kernel-team@android.com>, syzbot <syzbot+cdb5dd11c97cc532efad@syzkaller.appspotm>

On Mon, Jan 10, 2022 at 6:51 PM Suren Baghdasaryan <surenb@google.com> wrote:
>
> Fix this by disallowing to redefine an existing psi trigger. If a write
> operation is used on a file descriptor with an already existing psi
> trigger, the operation will fail with EBUSY error.

Looks fine to me. Eric?

I assume I'll get it through the usual channels unless there are issues,

                Linus
