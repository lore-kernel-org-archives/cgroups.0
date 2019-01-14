From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 5/5] psi: introduce psi monitor
Date: Mon, 14 Jan 2019 11:21:37 +0100
Message-ID: <20190114102137.GB14054@worktop.programming.kicks-ass.net>
References: <20190110220718.261134-1-surenb@google.com>
 <20190110220718.261134-6-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bxkTnJx2ceAX8K5kersQk7t4n/UQEPJI29wphVIz808=; b=iTx0Df8cQ26qLeQXkOAlcgl6R
        S2nzh31CdDuB970VvEDUWiwBW5xA1/4XMZRIYQfWaBXIPctv1Oh8o6eORzQ2NCcZ2aiakvHxPtKov
        QDaWujMi7FJzuy52oerT/t1DRQ3sWQg99IplBuXO9NjqenPNZWhIS8q4lyyHrAly3odk8jk71RfYM
        VNuYVniepN5psaUaTbiQbXavkl44rAV3gREv6vZpgTgTluXk+FJfFBDrfHuj5yAjuy+J9JvqpiwGk
        hj3HI3zuIMkCDWk4AbOLKye8cp/bmldHJz5YUVqVAM7C5JvklIYE6Lft5Djf6BJIaCXfyjqaqYuD0
    
Content-Disposition: inline
In-Reply-To: <20190110220718.261134-6-surenb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: gregkh@linuxfoundation.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, axboe@kernel.dk, dennis@kernel.org, dennisszhou@gmail.com, mingo@redhat.com, akpm@linux-foundation.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@android.com

On Thu, Jan 10, 2019 at 02:07:18PM -0800, Suren Baghdasaryan wrote:
> +/*
> + * psi_update_work represents slowpath accounting part while
> + * psi_group_change represents hotpath part.
> + * There are two potential races between these path:
> + * 1. Changes to group->polling when slowpath checks for new stall, then
> + *    hotpath records new stall and then slowpath resets group->polling
> + *    flag. This leads to the exit from the polling mode while monitored
> + *    states are still changing.
> + * 2. Slowpath overwriting an immediate update scheduled from the hotpath
> + *    with a regular update further in the future and missing the
> + *    immediate update.
> + * Both races are handled with a retry cycle in the slowpath:
> + *
> + *    HOTPATH:                         |    SLOWPATH:
> + *                                     |
> + * A) times[cpu] += delta              | E) delta = times[*]
> + * B) start_poll = (delta[poll_mask] &&|    if delta[poll_mask]:
> + *      cmpxchg(g->polling, 0, 1) == 0)| F)   polling_until = now +
> + *                                     |              grace_period
> + *                                     |    if now > polling_until:
> + *    if start_poll:                   |      if g->polling:
> + * C)   mod_delayed_work(1)            | G)     g->polling = polling = 0
> + *    else if !delayed_work_pending(): | H)     goto SLOWPATH
> + * D)   schedule_delayed_work(PSI_FREQ)|    else:
> + *                                     |      if !g->polling:
> + *                                     | I)     g->polling = polling = 1
> + *                                     | J) if delta && first_pass:
> + *                                     |      next_avg = calculate_averages()
> + *                                     |      if polling:
> + *                                     |        next_poll = poll_triggers()
> + *                                     |    if (delta && first_pass) || polling:
> + *                                     | K)   mod_delayed_work(
> + *                                     |          min(next_avg, next_poll))
> + *                                     |      if !polling:
> + *                                     |        first_pass = false
> + *                                     | L)     goto SLOWPATH
> + *
> + * Race #1 is represented by (EABGD) sequence in which case slowpath
> + * deactivates polling mode because it misses new monitored stall and hotpath
> + * doesn't activate it because at (B) g->polling is not yet reset by slowpath
> + * in (G). This race is handled by the (H) retry, which in the race described
> + * above results in the new sequence of (EABGDHEIK) that reactivates polling
> + * mode.
> + *
> + * Race #2 is represented by polling==false && (JABCK) sequence which
> + * overwrites immediate update scheduled at (C) with a later (next_avg) update
> + * scheduled at (K). This race is handled by the (L) retry which results in the
> + * new sequence of polling==false && (JABCKLEIK) that reactivates polling mode
> + * and reschedules next polling update (next_poll).
> + *
> + * Note that retries can't result in an infinite loop because retry #1 happens
> + * only during polling reactivation and retry #2 happens only on the first
> + * pass. Constant reactivations are impossible because polling will stay active
> + * for at least grace_period. Worst case scenario involves two retries (HEJKLE)
> + */

I'm having a fairly hard time with this. There's a distinct lack of
memory ordering, and a suspicious mixing of atomic ops (cmpxchg) and
regular loads and stores (without READ_ONCE/WRITE_ONCE even).

Please clarify.

(also, you look to have a whole bunch of line-breaks that are really not
needed; concattenated the line would not be over 80 chars).
