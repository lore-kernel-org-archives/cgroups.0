From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/9] sched/psi: move private helpers to sched/stats.h
Date: Mon, 25 Jul 2022 12:39:49 -0400
Message-ID: <Yt7HVcdXMYeNn6uS@cmpxchg.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-4-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7xVgMqmN/86GQHcqXO1yw7VSBDbzPsFu44uQMKjUJeE=;
        b=G1BoE6F8flgmzsQzfW3nkF7mptQonm328gZXYogDGG2IBIo/98/hfHLbhV7UAJkXQI
         X8ynxusv76jgdnblo7OxdqtfwPoXk/rNSeoDm2clKMjo+cyP+MkOivoz3cjRpyBfFOMl
         SIlEVNpakmxkbmqt4+XxLQLJ4QQ5PCkIi8fjAenSwWjxlcnBfytss8LLn3ERV7YvDbZa
         +VH8K1yK0xvi9ijH2dX3DZyfC4rI5TE1UjZr8z9tc/TucWdSj8cQGKObuYxB1bKQ6CbK
         2/AGAfXA0e/T+pDGaivYnTvUT5YBiUB+stnvoGNHnjm/BVx/LCqP/LJmcqT6Q4OGgHau
         mRpg==
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-4-zhouchengming@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: surenb@google.com, mingo@redhat.com, peterz@infradead.org, tj@kernel.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

On Thu, Jul 21, 2022 at 12:04:33PM +0800, Chengming Zhou wrote:
> This patch move psi_task_change/psi_task_switch declarations out of
> PSI public header, since they are only needed for implementing the
> PSI stats tracking in sched/stats.h
> 
> psi_task_switch is obvious, psi_task_change can't be public helper
> since it doesn't check psi_disabled static key. And there is no
> any user now, so put it in sched/stats.h too.
> 
> Signed-off-by: Chengming Zhou <zhouchengming@bytedance.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
