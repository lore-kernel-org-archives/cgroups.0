From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under CONFIG_MMU
Date: Tue, 17 Dec 2019 10:04:36 -0500
Message-ID: <43881F9C-90D0-4DE0-BA1E-B74ACF8567BD@lca.pw>
References: <20191217144652.GA7272@dhcp22.suse.cz>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=KWvMnp6WnFUpycSP8rv3DWkxz/r0qpxVC39yfCQNPZc=;
        b=IYatTteW5y6ti8LEqO+/zdTUGmCv1KDv68bKa61tkxNA/krQNPJ1DcjdPIRpuOQLC3
         CQOpF0MVR3hP3jJVnCgTINdUmiwkvge6ogGB8p+KpBWDIf6ejcEzpsE2U1eNGaPv9sIQ
         GF2AUiR4gIIR/kxu9qTp2EaJ2HYUJgsv9IZXk/PxhrE7pOPhIrGf/0JpEBXcEl3tBWk3
         BErm+rW/yMR4fReQaGo/GSsnxoxkPELI5fdYm2psftBMpuKG1M8MjB1sbfNP/s4N4Wkl
         J8uf4/kz+JjLvRoPmXI0VkUKEv9SwZscKFi+6nhMH/+7bEsK52Pwc6VQW+kOmZVgKMG0
         pEKQ==
In-Reply-To: <20191217144652.GA7272@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@kernel.org>
Cc: Chris Down <chris@chrisdown.name>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Dec 17, 2019, at 9:46 AM, Michal Hocko <mhocko@kernel.org> wrote:
>=20
> yes, I would just ignore this warning. Btw. it seems that this is
> enabled by default for -Wall. Is this useful for kernel builds at
> all? Does it realistically help discovering real issues? If not then
> can we simply blacklist it?

-Wunused-function is useful in-general as it caught many dead code that some=
 commits left unintentionally with real-world configs.=
