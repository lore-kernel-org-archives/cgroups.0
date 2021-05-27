From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/3] sched/fair: Add tg_load_contrib cfs_rq decay checking
Date: Thu, 27 May 2021 12:49:22 +0200
Message-ID: <CAKfTPtArj_XkgPXRJKZxN0MM2+v=3+RjAVVkmbpB1gBLCuzJvA@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-2-odin@uged.al>
 <CAKfTPtCCZhjOCZR6DMSxb9qffG2KceWONP_MzoY6TpYBmWp+hg@mail.gmail.com>
 <CAFpoUr0f50hKUtWvpTy221xT+pUocY7LXCMCo3cPJupjgMtotg@mail.gmail.com>
 <CAKfTPtCaZOSEzRXVN9fTR2vTxGiANEARo6iDNMFiQV5=qAA4Tw@mail.gmail.com>
 <CAKfTPtAFn3=anfTCxKTDXF0wpttpEiAhksLvcEPdSiYZTj38_A@mail.gmail.com>
 <CAFpoUr1zGNf9vTbWjwsfY9E8YBjyE5xJ0SwzLebPiS7b=xz_Zw@mail.gmail.com>
 <CAKfTPtDRdFQqphysOL+0g=befwtJky0zixyme_V5eDz71hC5pQ@mail.gmail.com> <CAFpoUr0SOqyGifT5Lpf=t+A+REWdWezR-AY2fM_u1-CCs8KFYQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Ua/saZqvwIMzSQnurwAoIde+A9NKg6vplyBhL5Gjil4=;
        b=n3Ys6kd7oq4RSx9GNj8DAA5OwUiXPsXOyHkKi4ZRtB5UzEfN9jKd8g9uQ+py8Fchnu
         fI7VGGVjbWZy5DS5ow4F8bDjLto8EruGhYNLiocK0BczIXSdROGiHePAUQv0qODETxxA
         G2p21I16bmk3PmwbTJlbd/AbqrRwZohgPCkEIBMmzq0nbqqaJZmGrFqx9q4Y7ktsaM2S
         /+UL/lN3Lu1j+/wVUJjJqf6gvjEkcxY26sZWu4IU5uWRbI3wyXkK9tzIx5CrU51KmbSw
         EujG94Xm2TUwhicxy48R02bwtQQMzRXMSSY8dTBGEXDxAKL7en4rsM+CtVzkyhO+qq9V
         ASyg==
In-Reply-To: <CAFpoUr0SOqyGifT5Lpf=t+A+REWdWezR-AY2fM_u1-CCs8KFYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, 27 May 2021 at 11:46, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org> wrote:
>
> Hi,
>
> > I finally got it this morning with your script and I confirm that the
> > problem of load_sum == 0 but load_avg != 0 comes from
> > update_tg_cfs_load(). Then, it seems that we don't call
> > update_tg_load_avg for this cfs_rq in __update_blocked_fair() because
> > of a recent update while propagating child's load changes. At the end
> > we remove the cfs_rq from the list without updating its contribution.
> >
> > I'm going to prepare a patch to fix this
>
> Yeah, that is another way to look at it. Have not verified, but
> wouldn't update_tg_load_avg() in this case
> just remove the diff (load_avg - tg_load_avg_contrib)? Wouldn't we
> still see some tg_load_avg_contrib
> after the cfs_rq is removed from the list then? Eg. in my example
> above, the cfs_rq will be removed from
> the list while tg_load_avg_contrib=2, or am I missing something? That
> was my thought when I looked
> at it last week at least..

1st : ensure that cfs_rq->load_sum is not null if cfs_rq-> load_isn't too
2nd : call update_tg_load_avg() during child update so we will be sure
to update tg_load_avg_contrib before removing the cfs from the list

>
> Thanks
> Odin
