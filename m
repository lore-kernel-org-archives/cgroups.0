From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Wed, 26 Jan 2022 16:04:55 +0100
Message-ID: <20220126150455.GC2516@blackbody.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-2-bigeasy@linutronix.de>
 <YfFddqkAhd1YKqX9@dhcp22.suse.cz>
 <YfFegDwQSm9v2Qcu@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643209497; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wve7EDfUiotTqBF9gXhZsF9PhXL/T2VSywPA7zpoBhs=;
        b=AcpcmlAldD0ooUGgzhIY1qoKd9Tu9uvjxPlJzz9L8Nx2kKK47YY/ymKLq52bEQyPFdjGNl
        mWc+kU/NxSqStSWxnoCjLG8mGej1nUWqaD9Kv6QtIr3qquzZBjAe0OhIggJq6NVcOeRff2
        T5lyZygK5811yuxA5nyGyyCx/FIDk54=
Content-Disposition: inline
In-Reply-To: <YfFegDwQSm9v2Qcu-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed, Jan 26, 2022 at 03:45:20PM +0100, Sebastian Andrzej Siewior <bigeas=
y-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> If that is not good, let me think of something else=E2=80=A6

I like ifdefing just the static branch enablement. *wink*

Michal
