From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 2/5] mm/memcg: Disable threshold event handlers on PREEMPT_RT
Date: Fri, 18 Feb 2022 08:39:12 -0800
Message-ID: <CALvZod7Jz91+px=Gpmd8qeY=eN1tS6vEGK0Dq_eGNq9Q=pj7xQ@mail.gmail.com>
References: <20220217094802.3644569-1-bigeasy@linutronix.de> <20220217094802.3644569-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZsaJ/52U7cZLmE6ctPyXK8XUe33/stjG8THMIu6wVGU=;
        b=RlQ/Wx7QFlwknPTQbVvjrxcl4E9RzQ2/VKYDGLGK3WW8txbJIsltBAIVTI5JcNwXK0
         iC5zOzJsOU6rKE+QZ7O3I3HYWBGzvq/2tdD+IyWDNJpEg3GbHdCCabSJ/s/CR9YEZmHX
         byRKHpIwAmFwny9oi9nwOwjo0yVzfG8ECrC0xIvtON8BR5FzQvZgQXw+Y8IO7vrRrDxp
         fulBnbHk6nI1z+KEDQVYwuXz3vg9vvlMZuDBm60mvAHxVxmiHAaXVYsHREDOKWfDgkRP
         4OX24fchdF5eAppQGXTXDOMF3lbC1N/HnbHVnsTHaGdfhLFiZ9EqJ8qVksLN/yzuOvyo
         QIRQ==
In-Reply-To: <20220217094802.3644569-3-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Thu, Feb 17, 2022 at 1:48 AM Sebastian Andrzej Siewior
<bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
>
> During the integration of PREEMPT_RT support, the code flow around
> memcg_check_events() resulted in `twisted code'. Moving the code around
> and avoiding then would then lead to an additional local-irq-save
> section within memcg_check_events(). While looking better, it adds a
> local-irq-save section to code flow which is usually within an
> local-irq-off block on non-PREEMPT_RT configurations.
>
> The threshold event handler is a deprecated memcg v1 feature. Instead of
> trying to get it to work under PREEMPT_RT just disable it. There should
> be no users on PREEMPT_RT. From that perspective it makes even less
> sense to get it to work under PREEMPT_RT while having zero users.
>
> Make memory.soft_limit_in_bytes and cgroup.event_control return
> -EOPNOTSUPP on PREEMPT_RT. Make an empty memcg_check_events() and
> memcg_write_event_control() which return only -EOPNOTSUPP on PREEMPT_RT.
> Document that the two knobs are disabled on PREEMPT_RT.
>
> Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Suggested-by: Michal Koutn=C3=BD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
