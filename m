From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: Only perform the debug checks on !PREEMPT_RT
Date: Fri, 25 Feb 2022 16:05:39 -0800
Message-ID: <20220225160539.22f5613abc0df8b75285f22c@linux-foundation.org>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
        <20220221182540.380526-4-bigeasy@linutronix.de>
        <CALvZod7DfxHp+_NenW+NY81WN_Li4kEx4rDodb2vKhpC==sd5g@mail.gmail.com>
        <YhjzE/8LgbULbj/C@linutronix.de>
        <CALvZod48Tp7i_BbA4Um57m989iuFU5kSvbzLhSOUt23_CiWmjw@mail.gmail.com>
        <Yhlf29/HqyNMOvGb@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1645833940;
        bh=QnhN6FEIU1CbIXSpB7aRtuB1l8uYNL5aDrMq0ZS9vcI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rHkUzOZfWtMXlFqvgGtbLMBBgN6m0LVpS3+miQKtYhFbABnQho0jtStHZuVULnYCi
         hmEsKKmVD2BMrYhSzR5A4UJddq0SztB7RiLUEk5+yDd0rkfo+BbEuTTfdvTp5YrdQl
         AQInCPHyG7Lr8Yrx+D5gfIv4YWPBzVpR6t3grrpo=
In-Reply-To: <Yhlf29/HqyNMOvGb-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

On Sat, 26 Feb 2022 00:01:47 +0100 Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:

> 
> Andrew, if this getting to confused at some point, I can fold it myself
> and repost the whole lot. Whatever works best for your.

I think I have it all but yes please, do send along a v5 series and
I'll double-check.

