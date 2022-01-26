From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/4] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Wed, 26 Jan 2022 16:21:40 +0100
Message-ID: <YfFnBBMDVjESaj/y@dhcp22.suse.cz>
References: <20220125164337.2071854-1-bigeasy@linutronix.de>
 <20220125164337.2071854-2-bigeasy@linutronix.de>
 <YfFddqkAhd1YKqX9@dhcp22.suse.cz>
 <YfFegDwQSm9v2Qcu@linutronix.de>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1643210500; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9sue3kCU/ER/IRMi/KZAJ26mZGkZjDDlVHexxnqqTGg=;
        b=dfLKbiy0WMK2IkpK8jhJ+IeLwjkBdRovBxvwdU1hq0H/lvUXIU92Iaqh36UeOnOZl5Hj9f
        z38jbCewLromjpSf/P2y+iPKzY2uRj5pNMQzEaHGc90LTjtukT252VDBW1MvsjVjwY25xD
        pUttU46/HhTLQDkj11tWZO2E4uWAT8M=
Content-Disposition: inline
In-Reply-To: <YfFegDwQSm9v2Qcu-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Wed 26-01-22 15:45:20, Sebastian Andrzej Siewior wrote:
> On 2022-01-26 15:40:54 [+0100], Michal Hocko wrote:
> > I still support this approach but the patch is much larger than
> > necessary. The code moving shouldn't be really necessary and a simple
> > "do not allow" to set any thresholds or soft limit should be good
> > enough.=20
> >=20
> > While in general it is better to disable the unreachable code I do not
> > think this is worth the code churn here.
>=20
> I got the "defined but not used" warnings by the compiler after I
> disabled the two functions. Then I moved everything to one code block to
> avoid the multiple ifdefs.
> If that is not good, let me think of something else=E2=80=A6

If this is really needed then just split the patch into two. First to
add the special RT handling and the other one to move the code without
any other changes.

--=20
Michal Hocko
SUSE Labs
