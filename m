From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: Re: [PATCH 1/3] sched/fair: Add tg_load_contrib cfs_rq decay checking
Date: Thu, 27 May 2021 13:04:18 +0200
Message-ID: <CAFpoUr0PTYs+CSiWt3WOXnxq=wN3uEyC=h+_3kDc9wLoqaRC_Q@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-2-odin@uged.al>
 <CAKfTPtCCZhjOCZR6DMSxb9qffG2KceWONP_MzoY6TpYBmWp+hg@mail.gmail.com>
 <CAFpoUr0f50hKUtWvpTy221xT+pUocY7LXCMCo3cPJupjgMtotg@mail.gmail.com>
 <CAKfTPtCaZOSEzRXVN9fTR2vTxGiANEARo6iDNMFiQV5=qAA4Tw@mail.gmail.com>
 <CAKfTPtAFn3=anfTCxKTDXF0wpttpEiAhksLvcEPdSiYZTj38_A@mail.gmail.com>
 <CAFpoUr1zGNf9vTbWjwsfY9E8YBjyE5xJ0SwzLebPiS7b=xz_Zw@mail.gmail.com>
 <CAKfTPtDRdFQqphysOL+0g=befwtJky0zixyme_V5eDz71hC5pQ@mail.gmail.com>
 <CAFpoUr0SOqyGifT5Lpf=t+A+REWdWezR-AY2fM_u1-CCs8KFYQ@mail.gmail.com> <CAKfTPtArj_XkgPXRJKZxN0MM2+v=3+RjAVVkmbpB1gBLCuzJvA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XKuENeFAgLIoL5+XgHz8hQNxrwiJoPEw10HrNs/Gaaw=;
        b=tU4ZEb/yV70ErzupnLLI8qX0LRJtuEl5gH/tESbYnyYx1pkyGt2KvOBney1Tt7Squn
         fQs2goEXPg8AwytKWVqyh9iAMVUSNLRZFcdGAQ74TZ58Kjiv3OzKkUSXPpw4v7TY8ODP
         4tUUgSYsfYnZVoXM6fIVvtxhsllB7nE6Dg+SI+6pzkt8n3MUfXaJlV9Uxv5dnPceHKwW
         52AkymOG9Zl4d6OHJ9tIpZuxM4KF8efcj8YxuuoWYKSaAVL4i+CMKq6okkHejryw4uVH
         rgDbs5IICAp1yWk0uG7Ssdo6PkqfaAL+lqFPv82poBEsvU9UCDk/hOvrKVEMJ5pRsTEP
         bU1A==
In-Reply-To: <CAKfTPtArj_XkgPXRJKZxN0MM2+v=3+RjAVVkmbpB1gBLCuzJvA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> 1st : ensure that cfs_rq->load_sum is not null if cfs_rq-> load_isn't too
> 2nd : call update_tg_load_avg() during child update so we will be sure
> to update tg_load_avg_contrib before removing the cfs from the list

Ahh, yeah, with "1st" that would work. Yeah, that was my initial
implementation of the change, but I thought that it was better to keep
the logic away from the "hot path". We can verify this in
update_tg_cfs_load(), and then force update_tg_load_avg() inside
__update_blocked_fair() when avg.load_avg is 0. (Given that this is
the only place where we can end up in this situation. I can update
this patch to do that instead.

Another solution is to update avg.load_avg
inside__update_blocked_fair() when load_sum is 0, and then propagate
that with update_tg_load_avg(). This removes the logic from the hot
path all together.

Not sure what the preferred way is. I have not found any other places
where this situation _should_ occur, but who knows..

Odin
