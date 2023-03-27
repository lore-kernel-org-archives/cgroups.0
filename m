From: Michal Hocko <mhocko@suse.com>
Subject: Re: [RFC] memcg v1: provide read access to memory.pressure_level
Date: Mon, 27 Mar 2023 22:40:37 +0200
Message-ID: <ZCH/RVlh1M6DRXaU@dhcp22.suse.cz>
References: <20230322142525.162469-1-flosch@nutanix.com>
 <20230324150350.fu7itbqqvtjmyf3s@blackpad>
 <6f4420d0-2f86-7294-01e1-6806ef7e4686@nutanix.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1679949637; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IgIrKz0UNBCn4PDiHW0xzrI6MTRBYSXxkJu/zMHUvKg=;
        b=aTyTas8xnndKQ+7rRpt7+uxegjLQTBesNPvbKnCfTN5qLbE6ycmNqY7poDyjI3gNMFpEEc
        q9Tr3ZJm7OP//76yYW4qy6Urq56r/oM+X/rPvVywvwdlCrSja9e+wB0YDmj0DVFfr2QMqj
        TEEofls4ExVM5wz3WIr2NkNvgkrZNJI=
Content-Disposition: inline
In-Reply-To: <6f4420d0-2f86-7294-01e1-6806ef7e4686@nutanix.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Florian Schmidt <flosch@nutanix.com>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Mon 27-03-23 14:59:37, Florian Schmidt wrote:
> Hi Michal,
>=20
> On 24/03/2023 15:03, Michal Koutn=FD wrote:
> > On Wed, Mar 22, 2023 at 02:25:25PM +0000, Florian Schmidt <flosch@nutan=
ix.com> wrote:
[...]
> > > (b) would you be interested to take this patch, or is it too niche a =
fix
> > >      for a legacy subsystem?
> >=20
> > I'd rather not extend this "unique way" with additionally unique dummy
> > helpers.
>=20
> I understand that this is all code that has no modern user any more, which
> is why I tried to keep the fix as self-contained as possible.
> Another option would be to have a special handler in cgroup_file_mode(), =
but
> that feels a lot klunkier to me, and leaks a v1-specific behaviour into t=
he
> shared cgroup code.

Yes, this is effectivelly a deprecated interface but I do agree that we
shouldn't really make life of users more complicated than necessary. If
the simplest solution to address this is to provide an empty callback
then be it. I am not sure but I do not think there are other cgroup
interfaces to warrant a more generic solution.

--=20
Michal Hocko
SUSE Labs
