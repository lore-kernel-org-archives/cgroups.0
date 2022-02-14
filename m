From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v2 2/4] mm/memcg: Disable threshold event handlers on
 PREEMPT_RT
Date: Mon, 14 Feb 2022 11:46:02 -0800
Message-ID: <Ygqxeq3UmFNrZqjP@carbon.dhcp.thefacebook.com>
References: <20220211223537.2175879-1-bigeasy@linutronix.de>
 <20220211223537.2175879-3-bigeasy@linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=kp6jXOEWknOWNgnpUOx3BYl1M1+KkCwo+I5QKInsF9U=;
 b=m3GzsayCxUahVgZcNrBR6i2eEbfu+gFQRburn7nb+7/3DVkPw1g03oCZ8YEnH5M/z3M1
 Kp2Z8D2Hqrq8qOjZjbV9HFGfTxaRsE69SwzMMVaQYVlFO0GQ+jqvx5OmetYBZ07UxWnZ
 E8IiCX4+GM4eVmMtdSVvJqfpaMPvf1wnCSs= 
Content-Disposition: inline
In-Reply-To: <20220211223537.2175879-3-bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
To: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Fri, Feb 11, 2022 at 11:35:35PM +0100, Sebastian Andrzej Siewior wrote:
> During the integration of PREEMPT_RT support, the code flow around
> memcg_check_events() resulted in `twisted code'. Moving the code around
> and avoiding then would then lead to an additional local-irq-save
> section within memcg_check_events(). While looking better, it adds a
> local-irq-save section to code flow which is usually within an
> local-irq-off block on non-PREEMPT_RT configurations.
>=20
> The threshold event handler is a deprecated memcg v1 feature. Instead of
> trying to get it to work under PREEMPT_RT just disable it. There should
> be no users on PREEMPT_RT. From that perspective it makes even less
> sense to get it to work under PREEMPT_RT while having zero users.
>=20
> Make memory.soft_limit_in_bytes and cgroup.event_control return
> -EOPNOTSUPP on PREEMPT_RT. Make an empty memcg_check_events() and
> memcg_write_event_control() which return only -EOPNOTSUPP on PREEMPT_RT.
> Document that the two knobs are disabled on PREEMPT_RT.
>=20
> Suggested-by: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.or=
g>
> Suggested-by: Michal Koutn=FD <mkoutny-IBi9RG/b67k@public.gmane.org>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@=
public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
