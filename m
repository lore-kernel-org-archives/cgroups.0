From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: Re: [PATCH v4] sched/fair: Correctly insert cfs_rq's to list on unthrottle
Date: Mon, 7 Jun 2021 15:36:12 +0200
Message-ID: <CAFpoUr1vta7F7PhzsTazqwrehhiySmD71veOxTo=PTBrGhpvLg@mail.gmail.com>
References: <20210604102314.697749-1-odin@uged.al> <CAKfTPtDHrD_QGoLeUkR0ALRakWH+KOopHZk=29fyi-oonerd9g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=igiYe7SwyKBt7A5QKk3rIAjajnn7ad4fy0OWQQgiPI4=;
        b=AL0ARjGG2d5UzLScoqRAbXYinCmVuWXQBcHoLRgl5VkHuKhtrwKqmto+JNVUYgKPl2
         b3k4tNPWnwv4RcbyMRhhfOdEm01keBZ51WwEy3xtnoGWJHdy0O9oVdSCYKB9gJalztcE
         1O17QCIDR4emE/ABvZa7F4Pk6t48ADo7f1xfiGv8qs/T5cpIWZlrxkMA5GxlvBrTWGM9
         rljNNoAyIx9MkJQ75F6YKWrBtHge3WmRDRtPJ9xyNH6bSTE4P+sjkFPsXDjcZH35ArlB
         4T+hETApzFiQSXxIXIyMMdJXcT5Oa1Db+FDW7mQa13hipnaroVt4L8oh7MhuQxDfEgyH
         4MZg==
In-Reply-To: <CAKfTPtDHrD_QGoLeUkR0ALRakWH+KOopHZk=29fyi-oonerd9g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

> It's not the best place for this function:
> - pelt.h header file is included below but cfs_rq_is_decayed() uses PELT
> - CONFIG_SMP is already defined few lines below
> - cfs_rq_is_decayed() is only used with CONFIG_FAIR_GROUP_SCHED and
> now with CONFIG_CFS_BANDWIDTH which depends on the former
>
> so moving cfs_rq_is_decayed() just above update_tg_load_avg() with
> other functions used for propagating and updating tg load seems a
> better place

Ack. When looking at it now, your suggestion makes more sense. Will fix it.

Thanks
Odin
