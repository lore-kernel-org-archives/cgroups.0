From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Protect per-CPU counter by disabling
 preemption on PREEMPT_RT where needed.
Date: Mon, 21 Feb 2022 14:58:34 +0100
Message-ID: <YhOaiutkyyY9v/0G@linutronix.de>
References: <20220217094802.3644569-1-bigeasy@linutronix.de>
 <20220217094802.3644569-4-bigeasy@linutronix.de>
 <CALvZod4eZWVfibhxu0P0ZQ35cB=vDbde=VNeXiBZfED=k3YPOQ@mail.gmail.com>
 <YhN4BSQ1RLomLoyl@linutronix.de>
 <20220221131825.GA7534@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645451915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iitq/hbofHwFVa3nea7jsMf/rgjsnN6retKs9evBkAw=;
        b=qPEhuQ2CmF6oV7BGpiRhqhV00ivvDd2117OATOQJvxQ5UryEGmiFX8ty1T7Dq6VmLrqJam
        lZt17G/4o1+vEeoGKt32e/VmZKgo72F+dtG6OeGzdmRnIfPVZDW22HBXAotvv+yDL6+tSf
        KUjgff080D0UbvvtEAL3d8NcBBfJX6Nzp22r+cD6Ly33BjABwv8ZVZbTJc24LhxlcxKRqI
        Xmxq1NNghkrdWc0nT/WA8M6h5pK1RS2ImvWPaONdlEhViLprTVZaAeEXRO9bbupwJCNPjY
        arUW2yF590khxdSvX4ftEo5oG5qX2UKhPK3d/e8A4I+DHRxE3dqJB4LMGCQfZg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645451915;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iitq/hbofHwFVa3nea7jsMf/rgjsnN6retKs9evBkAw=;
        b=F+r+sm5WhlyUnRW5yuWA/mA7JSWd4B5U8tpnt6zrh5Hs4EU8B26lPuR9+TNU7mrc6Bvc+n
        lzqOS2tV/KjihuAQ==
Content-Disposition: inline
In-Reply-To: <20220221131825.GA7534-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On 2022-02-21 14:18:25 [+0100], Michal Koutn=C3=BD wrote:
> On Mon, Feb 21, 2022 at 12:31:17PM +0100, Sebastian Andrzej Siewior <bige=
asy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> > What about memcg_rstat_updated()? It does:
> >=20
> > |         x =3D __this_cpu_add_return(stats_updates, abs(val));
> > |         if (x > MEMCG_CHARGE_BATCH) {
> > |                 atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_thres=
hold);
> > |                 __this_cpu_write(stats_updates, 0);
> > |         }
> >=20
> > The writes to stats_updates can happen from IRQ-context and with
> > disabled preemption only. So this is not good, right?
>=20
> These counters serve as a hint for aggregating per-cpu per-cgroup stats.
> If they were systematically mis-updated, it could manifest by
> missing "refresh signal" from the given CPU. OTOH, this lagging is also
> meant to by limited by elapsed time thanks to periodic flushing.
>=20
> This could affect freshness of the stats not their accuracy though.

Oki. Then let me update the code as suggested and ignore this case since
it is nothing to worry about.

> HTH,
> Michal

Sebastian
