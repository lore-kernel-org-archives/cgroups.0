From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup racy sum avoidance code
Date: Wed, 28 Jul 2021 12:43:26 -0700
Message-ID: <20210728124326.a3e6cc29f670062185fb57d7@linux-foundation.org>
References: <20210728012243.3369123-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1627501407;
        bh=TgcJqwLoPTRv4fk6gzrVlBugar75L/QJwtcHNSkMUJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tjfRiQvZF1G/igSUwx43shhbBOQEqN091BYafBeKw7pF2opxclayI80Sqozlu7XJb
         UM7ImzliQbGmesD9ts7CZU10l7Nn6pEJOV9FBYgw6A/Lzk08zEQTwsWjvYFs/umYny
         HW8XEHdL8aHqj7IE3AUFQcUDSI9vBDL3mUC8rPRo=
In-Reply-To: <20210728012243.3369123-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 27 Jul 2021 18:22:43 -0700 Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> We used to have per-cpu memcg and lruvec stats and the readers have to
> traverse and sum the stats from each cpu. This summing was racy and may
> expose transient negative values. So, an explicit check was added to
> avoid such scenarios. Now these stats are moved to rstat infrastructure
> and are no more per-cpu, so we can remove the fixup for transient
> negative values.

We can't do anything about the same code in lruvec_page_state_local()?
