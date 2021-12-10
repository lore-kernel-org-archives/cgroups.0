From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Properly handle memcg_stock access for
 PREEMPT_RT
Date: Thu, 9 Dec 2021 21:47:16 -0500
Message-ID: <3c06c8b3-c6ed-50c5-79ac-21982a10d417@redhat.com>
References: <20211210020632.150769-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639104443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2NBrZb9MWEkfnRCq35Z7md/5O5MZ6n/FZXnIl859Do4=;
        b=ZhDrkIVOqPCgXlN54J8vttrDDBUHitaonxwh+eG/oVKJbv7yyM8jvqH56YlGwGDCxHEkhO
        ecUNOq9/6QHyBJUDfzI3wDi0fp5RKW1QKudlbIgIzEZh9v2SXavjfgbSRnd67qm7FpffQS
        NSAtUXtO06TrpATKsMe8JKV4rV6zwCI=
Content-Language: en-US
In-Reply-To: <20211210020632.150769-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

On 12/9/21 21:06, Waiman Long wrote:
> Direct calls to local_irq_{save/restore}() and preempt_{enable/disable}()
> are not appropriate for PREEMPT_RT. To provide better PREEMPT_RT support,
> change local_irq_{save/restore}() to local_lock_irq{save/restore}() and
> add a local_lock_t to struct memcg_stock_pcp.
>
> Also disable the task and interrupt context optimization for obj_stock as
> there will be no performance gain in the case of PREEMPT_RT. In this case,
> task obj_stock will be there but remain unused.
>
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   mm/memcontrol.c | 41 ++++++++++++++++++++++-------------------
>   1 file changed, 22 insertions(+), 19 deletions(-)

Sorry, this doesn't apply to linux-next as it conflicts with a previous 
patch that I sent out. Will send out a v2 soon.

-Longman

