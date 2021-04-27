From: Odin Ugedal <odin-lVFEcm3hDZTQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/1] sched/fair: Fix unfairness caused by missing load decay
Date: Tue, 27 Apr 2021 10:36:23 +0200
Message-ID: <CAFpoUr2t0OXLJZi9wJzYg2uOhSLfwRa7sxCxxWzriJgXDsgEdA@mail.gmail.com>
References: <20210425080902.11854-1-odin@uged.al> <CAKfTPtBHm+CjBTA614P9F2Vx3Bj7vv9Pt0CGFsiwqcrTFmKzjg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ugedal.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zh33Yh7lW0dlBQiRgpyt2psV9Y8igA+5UjDIZx32BfY=;
        b=R80hr1wa0Mn4k9VnGUbjc2R4cixMJ5ZgNIsARabk5tPMu6Xepea/w5ho7Xc+BrYwxe
         RzVMetIIjm8bZYHV94xbetqPI3rgYcmAT7Nrf8Dq39rGvxBcqXoeXnQ7GesBx3HvsUES
         y8tiElerXVsLUim5FOz5JOxbTJoBMrtc63Y/8T+OOTjI7PYvJ0/xb4rO/cOynbxkZZUf
         EyqUNqvy6ym8veTJ9KzmuW0L/PJlrPuQ9zJAejiUYWsuDsIUEffKgPUIlE7cYyTAucyZ
         MW76yf/Qz4jtb3+hk6kV9THp4URfVjGSiTN+UZmk55DKeUifX6PsQ7ZTvUmp9qKKJ+Gl
         J5yQ==
In-Reply-To: <CAKfTPtBHm+CjBTA614P9F2Vx3Bj7vv9Pt0CGFsiwqcrTFmKzjg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Also, instead of bpftrace, one can look at the /proc/sched_debug file,
and infer from there.

Something like:

$ cat /proc/sched_debug | grep ":/slice" -A 28 | egrep "(:/slice)|load_avg"

gives me the output (when one stress proc gets 99%, and the other one 1%):

cfs_rq[0]:/slice/cg-2/sub
  .load_avg                      : 1023
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1035
  .tg_load_avg                   : 1870
  .se->avg.load_avg              : 56391
cfs_rq[0]:/slice/cg-1/sub
  .load_avg                      : 1023
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1024
  .tg_load_avg                   : 1847
  .se->avg.load_avg              : 4
cfs_rq[0]:/slice/cg-1
  .load_avg                      : 4
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 4
  .tg_load_avg                   : 794
  .se->avg.load_avg              : 5
cfs_rq[0]:/slice/cg-2
  .load_avg                      : 56401
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 56700
  .tg_load_avg                   : 57496
  .se->avg.load_avg              : 1008
cfs_rq[0]:/slice
  .load_avg                      : 1015
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1009
  .tg_load_avg                   : 2314
  .se->avg.load_avg              : 447


As can be seen here, no other cfs_rq for the relevant cgroups are
"active" and listed, but they still contribute to eg. the "tg_load_avg". In this
example, "cfs_rq[0]:/slice/cg-1" has a load_avg of 4, and contributes with 4 to
tg_load_avg.  However, the total total tg_load_avg is 794. That means
that the other 790 have to come from somewhere, and in this example,
they come from the cfs_rq on another cpu.

Hopefully that clarified a bit.

For reference, here is the output when the issue is not occuring:
cfs_rq[1]:/slice/cg-2/sub
  .load_avg                      : 1024
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1039
  .tg_load_avg                   : 1039
  .se->avg.load_avg              : 1
cfs_rq[1]:/slice/cg-1/sub
  .load_avg                      : 1023
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1034
  .tg_load_avg                   : 1034
  .se->avg.load_avg              : 49994
cfs_rq[1]:/slice/cg-1
  .load_avg                      : 49998
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 49534
  .tg_load_avg                   : 49534
  .se->avg.load_avg              : 1023
cfs_rq[1]:/slice/cg-2
  .load_avg                      : 1
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 1
  .tg_load_avg                   : 1
  .se->avg.load_avg              : 1023
cfs_rq[1]:/slice
  .load_avg                      : 2048
  .removed.load_avg              : 0
  .tg_load_avg_contrib           : 2021
  .tg_load_avg                   : 2021
  .se->avg.load_avg              : 1023


Odin
