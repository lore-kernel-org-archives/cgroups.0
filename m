From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: Re: [PATCH] mm/memcontrol: Disable on PREEMPT_RT
Date: Wed, 15 Dec 2021 17:47:54 +0100
Message-ID: <YbocOh+h3o/Yc5Ag@linutronix.de>
References: <20211207155208.eyre5svucpg7krxe@linutronix.de>
 <Ya+SCkLOLBVN/kiY@cmpxchg.org>
 <YbNwmUMPFM/MO0cX@linutronix.de>
 <YbcbmvQk+Sgdsi9G@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639586875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWKQmVaUmlhlu4LBLW0y54JVGs+emTP6yYulZAfEBlg=;
        b=2IFozc2UCxRwnxaxcLhssB5iej7201xbCCVh3mTjGNBMlWNimNqL7TkMlTvKyGFxza0wth
        PyNePnpWcaCgpgpYKdzHl9bzT1M9BO/3eF1UmmO+4+cmsF1t+7/oVp4M+cSY8O64//i9dP
        kYR02Dg4IhK8BEvyds5Ex1knUiQ5Oa/LxRn8BWMgFhswIKoanv+4/94SkrsTeeXAzetmo3
        lECFr4EbWVuF9LZBzWs9zGRYm+QZ76vGw+xCBBhTS5o17FB7atEJn2kDBCOWy0eYyuAF3T
        LoUr8FQaYsOnNZlMsrxgagkHtCbgn54lnXB7SJyJeTHTVlGEJXUSJnIdKHO3Eg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639586875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PWKQmVaUmlhlu4LBLW0y54JVGs+emTP6yYulZAfEBlg=;
        b=0Siez4oA1M3vHIh4cpe9gkN+9TKepZa4ecFRf7RzuKjMHsn5DxCtj3g7bRl6LFklw2Q0k5
        b3xLWqKEywIERQAg==
Content-Disposition: inline
In-Reply-To: <YbcbmvQk+Sgdsi9G-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On 2021-12-13 11:08:26 [+0100], Michal Hocko wrote:
> On Fri 10-12-21 16:22:01, Sebastian Andrzej Siewior wrote:
> [...]
> I am sorry but I didn't get to read and digest the rest of the message
> yet. Let me just point out this
>=20
> > The problematic part here is mem_cgroup_tree_per_node::lock which can
> > not be acquired with disabled interrupts on PREEMPT_RT.  The "locking
> > scope" is not always clear to me.  Also, if it is _just_ the counter,
> > then we might solve this differently.
>=20
> I do not think you should be losing sleep over soft limit reclaim. This
> is certainly not something to be used for RT workloads and rather than
> touching that code I think it makes some sense to simply disallow soft
> limit with RT enabled (i.e. do not allow to set any soft limit).

Okay. So instead of disabling it entirely you suggest I should take
another stab at it? Okay. Disabling softlimit, where should I start with
it? Should mem_cgroup_write() for RES_SOFT_LIMIT always return an error
or something else?
In the meantime I try to swap in my memcg memory=E2=80=A6

Sebastian
