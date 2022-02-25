From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Add missing counter index which are not update
 in interrupt.
Date: Fri, 25 Feb 2022 09:08:22 -0800
Message-ID: <CALvZod48Tp7i_BbA4Um57m989iuFU5kSvbzLhSOUt23_CiWmjw@mail.gmail.com>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
 <20220221182540.380526-4-bigeasy@linutronix.de> <CALvZod7DfxHp+_NenW+NY81WN_Li4kEx4rDodb2vKhpC==sd5g@mail.gmail.com>
 <YhjzE/8LgbULbj/C@linutronix.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=JKBFp/+QmdkMl3W2CNCuhdgLoZgTOVOm62o/vgJZi/w=;
        b=HvtTf0aOv5iPGo064vKxcuLQ17FFIg+BoA294KV6ssoXN0UKe1Irs+22XOPAWWqtGE
         4iEfPdX03oAOFR9M7UMcq6Yfzj85bvEYotaIp6nft1LKgTj/QgVYoNRtIVQvi271iVY2
         qfVuvMzoZfV/R9IegCaNbraeZ222UG0SN6Bco9sAgTRz0lbWGhbXqMhUjGJkeB+SNUG3
         re3NDnnS1q0E3NnRZiZJS+swJy/YLm8Xo9UGKX1PXWmp+eEZbhrQZkQM8Inh3BZpIrkq
         YFN2ixSSHfssooXM+6HvJY/i1VNwO4802U2JuKTiozHH0MGmg7/JrsyEpL0ztObKX3TN
         hG2g==
In-Reply-To: <YhjzE/8LgbULbj/C@linutronix.de>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Fri, Feb 25, 2022 at 7:17 AM Sebastian Andrzej Siewior
<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
> Shakeel Butt reported that I missed a few counters which are not updated
> in-interrupt context and therefore disabling preemption is fine.
>
> Please fold into:
>      "Protect per-CPU counter by disabling preemption on PREEMPT_RT"
>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>

Thanks. For the folded patch:

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
