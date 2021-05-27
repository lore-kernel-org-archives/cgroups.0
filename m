From: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] schd/fair: fix stalled cfs_rq->tg_load_avg_contrib
Date: Thu, 27 May 2021 14:29:14 +0200
Message-ID: <20210527122916.27683-1-vincent.guittot@linaro.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=fRBr6xZkzmbnPWuRrXfAqA5xA8c0t9k1LP7xSr+ydFk=;
        b=cJcApNTb2Db0TXRi89IcQr4nyCEsRga93qLPHyDs6EU05t1h6i/oYDaF12n8b+GavG
         ZTXVAtZCnQhfQgxMigaLcHpVNLryZuBBpuoW+KlpDBxJ54QVoLEtjvPgnDCkYZ6+SpJO
         2F1ysEYzdiZdJ9PUVM4ZgwEEsp8DQWN4MaZmWb6RSReO+9x4XZLMAxkH722s9bc2tS6m
         bdewnwiQO7ZPndm31rDyT/lUAtMij5Cy6RClkiD6m0x5b4koK80XW+7mBR8bZa/7rgVw
         c9ZhhwQw3YS0E2+Lc9cLJjDmwMUzc+1oWkkn3adS8EQV8WITToiaSbWN/GdJthsLhKdK
         tqpg==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, odin-RObV4cXtwVA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>

Odin reported some fairness problem between cgroup because of stalled
value in cfs_rq->tg_load_avg_contrib:

https://lkml.org/lkml/2021/5/18/566


2 problems generated this situation:
-1st: After propagating load in the hierarchy, load_sum can be null
 whereas load_avg isn't so the cfs_rq is removed whereas it still
 contribute to th tg's load
-2nd: cfs_rq->tg_load_avg_contrib was not always updated after
 significant changes like becoming null because cfs_rq had already
 been updated when propagating a child load.


Vincent Guittot (2):
  sched/fair: keep load_avg and load_sum synced
  sched/fair: make sure to update tg contrib for blocked load

 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

-- 
2.17.1

