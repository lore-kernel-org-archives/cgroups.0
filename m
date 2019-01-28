From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 5/5] psi: introduce psi monitor
Date: Mon, 28 Jan 2019 16:26:32 -0500
Message-ID: <20190128212632.GD1416@cmpxchg.org>
References: <20190124211518.244221-1-surenb@google.com>
 <20190124211518.244221-6-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=doeprTD75a3wN3TW5uXx5DNXAT9rchfp4Kk5IuJTQxU=;
        b=CoGlOMn7uIwWJDcMJfm+Rj/Qm/gD747PAjoLMDuaAsDCqLhZQSn/JpFhVuDGuDVsjF
         ZCc8zkEIpRrNHtUDlnkc1025YEepn5whj5fHLPPzwg/nGaOXJ4pD5bxCR2wI5TuxUC48
         BWSV8pZ8PCO4Myh5kKyI+tOm9WAx/oi7OMNMgHZUxJn7ycktWfXZZsol5OtiRFtjo1HM
         WCiToVrQxB7D49DqB2cfga9Imv1GfrUhMWjHVChx4ubG1zTMX4qOhNIsAbTi2dC5vikw
         xTOivor07e6gs17gDt22abifNO9qMz2FPPi8SCfL2ZFPvFyjHEY7VVO+xC22K209SvVq
         OA/g==
Content-Disposition: inline
In-Reply-To: <20190124211518.244221-6-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, peterz@infradead.org, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

One thought on the v3 delta that I missed earlier:

On Thu, Jan 24, 2019 at 01:15:18PM -0800, Suren Baghdasaryan wrote:
> +/*
> + * psi_update_work represents slowpath accounting part while psi_group_change
> + * represents hotpath part. There are two potential races between them:
> + * 1. Changes to group->polling when slowpath checks for new stall, then hotpath
> + *    records new stall and then slowpath resets group->polling flag. This leads
> + *    to the exit from the polling mode while monitored state is still changing.
> + * 2. Slowpath overwriting an immediate update scheduled from the hotpath with
> + *    a regular update further in the future and missing the immediate update.
> + * Both races are handled with a retry cycle in the slowpath:
> + *
> + *    HOTPATH:                         |    SLOWPATH:
> + *                                     |
> + * A) times[cpu] += delta              | E) delta = times[*]
> + * B) start_poll = (delta[poll_mask] &&|    if delta[poll_mask]:
> + *      cmpxchg(g->polling, 0, 1) == 0)| F)   polling_until = now + grace_period
> + *    if start_poll:                   |    if now > polling_until:
> + * C)   mod_delayed_work(1)            |      if g->polling:

With the polling flag being atomic now, this "if g->polling" line
isn't accurate anymore. Since this diagram is specifically about
memory ordering, this should move the g->polling load up to where
delta is read and then refer to unordered local variables down here.
