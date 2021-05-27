From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: Re: [PATCH 1/3] sched/fair: Add tg_load_contrib cfs_rq decay checking
Date: Thu, 27 May 2021 14:39:59 +0200
Message-ID: <CAFpoUr0mTQym4cmN98Er=4byRo9wqYcuOsbMLDJEnjvD-2ZbMg@mail.gmail.com>
References: <20210518125202.78658-1-odin@uged.al> <20210518125202.78658-2-odin@uged.al>
 <CAKfTPtCCZhjOCZR6DMSxb9qffG2KceWONP_MzoY6TpYBmWp+hg@mail.gmail.com>
 <CAFpoUr0f50hKUtWvpTy221xT+pUocY7LXCMCo3cPJupjgMtotg@mail.gmail.com>
 <CAKfTPtCaZOSEzRXVN9fTR2vTxGiANEARo6iDNMFiQV5=qAA4Tw@mail.gmail.com>
 <CAKfTPtAFn3=anfTCxKTDXF0wpttpEiAhksLvcEPdSiYZTj38_A@mail.gmail.com>
 <CAFpoUr1zGNf9vTbWjwsfY9E8YBjyE5xJ0SwzLebPiS7b=xz_Zw@mail.gmail.com>
 <CAKfTPtDRdFQqphysOL+0g=befwtJky0zixyme_V5eDz71hC5pQ@mail.gmail.com>
 <CAFpoUr0SOqyGifT5Lpf=t+A+REWdWezR-AY2fM_u1-CCs8KFYQ@mail.gmail.com>
 <CAKfTPtArj_XkgPXRJKZxN0MM2+v=3+RjAVVkmbpB1gBLCuzJvA@mail.gmail.com> <CAFpoUr2NM9RHE=jdbi5aNj2LeVr4iKJ3thMPUNhp_SnCe7tnfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=eNiQoWn/9OHCszXvyBqQo+oFAxQxF89SUvYeB9IA70I=;
        b=jyNj5GwSxQNwfAKTy3gtmVCcmwrkUBb3JuWQPt37kUBY8+vtkcmYgiu6qbIlKFTffk
         E/9Irp8l8MnV9c+4Eoe/NM1V233e6y5vOr2tVdKvQHoU4HsM69G1quOBvLYRII2JV/Ki
         RSI6U3EtNmFREjJ82VIQ/njctZuuFWI9M9cq/fSU0e9Y2nCC6ZCUPnzBr4p2TMxlxLnE
         DG+c+1zleTR+YOJpCDBCMA5rll/J9LOTxmGXfZ7cf2SJ3WH4rlbTGibikytVWLcnXUBa
         K6MNzLl6hzbefsereyfuX4gBRygBS7Z48hBSUooL1cHMkUxZkgKQ5Fpbz86P8QLRt0bO
         akFg==
In-Reply-To: <CAFpoUr2NM9RHE=jdbi5aNj2LeVr4iKJ3thMPUNhp_SnCe7tnfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> For 1st problem, the way we were updating load_avg and load_sum, we
> were losing the sync between both value

Yeah, that would be a natural way to fix that.

> In fact, the update was already there but not always called (see the
> patchset i just sent)

Yeah, that was my exact point.

Odin
