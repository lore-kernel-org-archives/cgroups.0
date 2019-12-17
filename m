From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under CONFIG_MMU
Date: Tue, 17 Dec 2019 10:34:55 -0500
Message-ID: <CE79F821-F17D-489D-81A9-CD87AEA9C0ED@lca.pw>
References: <20191217152814.GB136178@chrisdown.name>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=WIcgHN30dR2crDNHrX3sAimvrkTmgj4IY/+nrOsfb9k=;
        b=PywzVWBsXibwF9hDhJCdPW2VL32SQKqTUSKd6D+9UIqoIV7pmnlbaOJ+qTm0m1E0uT
         zFgW0p2F9QnGu1M/DylWPZyV5hnHz7D+ap0nWhNkLi86F7Q3MwF5Kbll87NdUFwBqgWX
         wXv0O7g9neyrEpeGc6JNk9zpV1O7hOjyaDdTtePzsVisZH/y5QHKU890sIAYZJ9TXJsz
         Zr/T/HpH6iUXsgmwVIILdLkrupJGp6j8eHGk2ibc3KSXeDV67Lr2jTB05m6geLtaJcXr
         UuumkHs7gyxZeREiJ/AOjM8DSejbrBZvtPQRT3oVIWlugpNoxcFSHGMhQCfMKr4QF7mE
         GdWw==
In-Reply-To: <20191217152814.GB136178@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Dec 17, 2019, at 10:28 AM, Chris Down <chris@chrisdown.name> wrote:
>=20
> Maybe Qian is right and we should just ignore such patches, but I think th=
at comes with its own risks that we will alienate perfectly well intentioned=
 new contributors to mm without them having any idea why we did that.

Yes, that is a good point, but in reality is that there are many subsystems h=
ave already done the same. We even have some famous introduction document fo=
r kernel development put in the way that if =E2=80=9Cthe maintainers (or Lin=
us) ignored your patches after the resend, they probably don=E2=80=99t like i=
t.=E2=80=9D=
