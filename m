From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under CONFIG_MMU
Date: Tue, 17 Dec 2019 10:17:10 -0500
Message-ID: <E7311A37-F5D9-4248-A51A-9B105A49A923@lca.pw>
References: <20191217151343.GC7272@dhcp22.suse.cz>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=QBbJhTwA/z9GheRdVz6DmV0ve21qD4tE529ywgzTv4I=;
        b=d9bCdpSbGIQ2bZQYmFNSt27dYg2M8iWZwhztIVSpbfasIXUPfe9wfODDgBXYwS+JyO
         Gv3TTGJk82AvVWFURXKuscdcGA0HsfV01pD/QIDsVJmelRXOfAde709zspdbcG8ICcc7
         7TNB7KXnhm1FIo4TfOcfXQvk5nlWUU9HlOKjB4BCaP67Vuf1CgtKnicQw9mirkKllLU2
         M/a7YslEdG6U+m8J2FZ77M+8bRBnh3JeZWOf4vPXkFIzi7HAeKhBmRNHQe1i7gyA1pzn
         a8+ey1AIdl0lgF0SWzVjIXgYk2NCOn6AkDxukN3hUDa+fNb/qaSLFPWl6523TIa7FcdY
         zL8Q==
In-Reply-To: <20191217151343.GC7272@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Dec 17, 2019, at 10:13 AM, Michal Hocko <mhocko@kernel.org> wrote:
>=20
> I do understand the general purpose of the warning. I am simply not sure
> the kernel tree is a good candidate with a huge number of different
> config combinations that might easily result in warnings which would
> tend to result in even more ifdeferry than we have.

Yes, compiling test without real-world use case is evil. Once we ignore the e=
vil, it becomes much more manageable.=
