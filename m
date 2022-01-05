From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [RFC PATCH 0/3] mm/memcg: Address PREEMPT_RT problems instead of
 disabling it.
Date: Wed, 5 Jan 2022 16:06:05 +0100
Message-ID: <YdWz3RvPemg3m7WD@linutronix.de>
References: <20211222114111.2206248-1-bigeasy@linutronix.de>
 <20220105145956.GB6464@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1641395167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zU5XndrFq1/DafMJeyDTRNBd9Wg4rCfP6rL7TcC+Lc=;
        b=24kGuqLfhX/BEMR4PTr/BvWPUcn1JGhQ5Zw4BtzQW9OZd3CM2f+BjM5utCwhvxqapFbneX
        Q2Zwva6OXJ/Bw88fm9pg6NAw+AiQB9zDsQ+3/7M52slVkzO21P+u2Uui4TbRTwjwNJ+JS9
        3dztBRTTt6VC9vC4sxj88X5A8zGA+1bu9h6M2vk3qiXQ4Nqqu/+gxO6jmYbE140b8KMMSj
        7GmvVZuRAJ6di1/LgAI5Nyvc+VGKnFpZped4B6hsYNZRStWcgCWNkHonRJqErX/cCnxVq7
        3jGQZEVDlR6HBqmW3r2XYHD1AO/VPbD9tElTcrw2SrhpyPrfp88mSVI74qEJ9g==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1641395167;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7zU5XndrFq1/DafMJeyDTRNBd9Wg4rCfP6rL7TcC+Lc=;
        b=co63aLbokqKOOwFoxm+1Taneq4FpYk5r/lTtHAduUD3NL3Lq5RIZNn4RQ3QBibFnkuAJ/3
        H2ldUGLDfljEIABQ==
Content-Disposition: inline
In-Reply-To: <20220105145956.GB6464-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On 2022-01-05 15:59:56 [+0100], Michal Koutn=C3=BD wrote:
> On Wed, Dec 22, 2021 at 12:41:08PM +0100, Sebastian Andrzej Siewior <bige=
asy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org> wrote:
> > - lockdep complains were triggered by test_core and test_freezer (both
> >   had to run):
>=20
> This doesn't happen on the patched kernel, correct?

I saw it first on the patched kernel (with this series) then went back
to the -rc and saw it there, too.

> Thanks,
> Michal

Sebastian
