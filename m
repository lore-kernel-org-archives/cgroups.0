From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under CONFIG_MMU
Date: Tue, 17 Dec 2019 09:16:36 -0500
Message-ID: <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
References: <20191217135440.GB58496@chrisdown.name>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=ZkdzLix0g7TLx3w5KL71e42yAFa7G9Wu3yCJiO5zBhs=;
        b=R4VeKMX5z+UpczXH2iwhnXxVtV/oF7T7YQHHVdhLWz3zDT3WeJr7l93DvuR8yvVTv1
         b8K8T6PxnmokRbgIrYOjdgQoidBrClvkj/ONfMxQ5qwk5O8VdAzKcNBZJRcqHTxrR9fv
         6oZkLQMCNFUQ5RqfDFqqCiEYcPxcbVXU0GWa+V3TiQSvhU1WYhVdc+Wyyy3uWM0/S5EK
         hEiB9TnfsOs25eWmyhQX7mf8iQrlU2obMGSU/PBQ/Kdp7Cpq5otTFcelPh4cIsg5+vi1
         l7/uWYHT18DpZM2q2zh8DATf6vrIqr3vrPVB6SD6pC+LUQX8NwBm0Pev0kzsqmMQ18g+
         1smA==
In-Reply-To: <20191217135440.GB58496@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Dec 17, 2019, at 8:54 AM, Chris Down <chris@chrisdown.name> wrote:
>=20
> Let's just add __maybe_unused, since it seems like what we want in this sc=
enario -- it avoids new users having to enter preprocessor madness, while al=
so not polluting the build output.

__maybe_unused should only be used in the last resort as it mark the compile=
r to catch the real issues in the future. In this case, it might be better j=
ust ignore it as only non-realistic compiling test would use !CONFIG_MMU in t=
his case.=
