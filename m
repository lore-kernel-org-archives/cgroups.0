From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Sat, 14 Jul 2018 08:38:17 -0700
Message-ID: <CALvZod57QFRVQ7kM4LSNQJACQ+dGC_otJkqK-5+i-0b53Zq5aA@mail.gmail.com>
References: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iluyll3MCCBbrDy+jCMfsrBekBknlCkm0XifQvaH1mE=;
        b=M6Sz+C2P0N3PoJ0mQ2Gasps7WsdEUP/I8XExH8cIdMf+umBw99aG5DcAocXVXrFs8F
         bGleg9/NiJQ21OGl88F5BBYsb0zJ+nJ7U9sVyiFCk83FgclMilHDHzZVWD5utHBDutDR
         9Q1U05yS6BwyOpTt07JQK31m19nIIYNPXwjhKwYeuSBKoCROzb3sfH6rEzhrJOUaieU1
         /pD6q9/NFNzi5/nvTyvZ/Uw7G+mLPvgNfdt7YceCPN0D6oyB0ZpTwLw9u16gOO334y8R
         RwBVWm9tMQXA81RYF7bV5mWDRhWUJS1kI1EEU73vCN+nvV/6dS+IjgdX8+A8qrYQkGM3
         fskw==
In-Reply-To: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Sat, Jul 14, 2018 at 1:32 AM Yafang Shao <laoar.shao@gmail.com> wrote:
>
> try_charge maybe executed in packet receive path, which is in interrupt
> context.
> In this situation, the 'current' is the interrupted task, which may has
> no relation to the rx softirq, So it is nonsense to use 'current'.
>

Have you actually seen this occurring? I am not very familiar with the
network code but I can think of two ways try_charge() can be called
from network code. Either through kmem charging or through
mem_cgroup_charge_skmem() and both locations correctly handle
interrupt context.

Shakeel
