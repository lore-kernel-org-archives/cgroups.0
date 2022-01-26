From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Wed, 26 Jan 2022 15:45:20 +0100
Message-ID: <YfFegDwQSm9v2Qcu@linutronix.de>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-2-bigeasy@linutronix.de>
 <YfFddqkAhd1YKqX9@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1643208321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oHTX2+frIu1UrhvB+dpyRcYGwmhZVbTk9VdBIsf28C0=;
        b=KHbir9cR5tJpv8jOUgX7x/r5Tk/L0cuWYWeeFytmAi8psS1tmbSxE081S2e8Y3KGsCU3gQ
        cv6mX9dMpwrZw3wwI3IsNghlLDfYdk5nvE6kAVIPY8XRMuVclHzgf+JDasZFIrYcs2sH+4
        NMc0ms8jS23QybtGd1JsDzEQ2HIxQFVnQTfUxa7ptOUbzKLd9SO7krduTma0OjkEsKB0Mq
        WkAwfysMe5xjx8AhWcQg1Iy7MBzheZgwqF08O6UD7hLH/G7g6DKHoHqJUYqPrj1m6Tv1ak
        ntOysuqxSe15Us1UATkiclte65DG8Vkk8Kewp+/rJ1MlF6hircPCtOoQsJKYKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1643208321;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=oHTX2+frIu1UrhvB+dpyRcYGwmhZVbTk9VdBIsf28C0=;
        b=+KcseHn/VigDpGR4syaqZQM7QlhQHbLoVsEP/sUWC4bNzMjC4P3GLRl4HEmFgbocdgG1BK
        rqMKQ+qvjPpsfgBw==
Content-Disposition: inline
In-Reply-To: <YfFddqkAhd1YKqX9-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2022-01-26 15:40:54 [+0100], Michal Hocko wrote:
> I still support this approach but the patch is much larger than
> necessary. The code moving shouldn't be really necessary and a simple
> "do not allow" to set any thresholds or soft limit should be good
> enough.=20
>=20
> While in general it is better to disable the unreachable code I do not
> think this is worth the code churn here.

I got the "defined but not used" warnings by the compiler after I
disabled the two functions. Then I moved everything to one code block to
avoid the multiple ifdefs.
If that is not good, let me think of something else=E2=80=A6

Sebastian
