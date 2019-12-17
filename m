From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under CONFIG_MMU
Date: Tue, 17 Dec 2019 10:09:33 -0500
Message-ID: <5D853968-99FD-4B66-9784-C1C540B23F92@lca.pw>
References: <20191217143720.GB131030@chrisdown.name>
Mime-Version: 1.0 (1.0)
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=0OkMwroxaFTIfHX5v7BwxiXC57WOkvd1SruP9P6F2gQ=;
        b=AqbMRymX9CPH4mO3hD6Uyz9s6YZsLavTX4LxKYda/0ELAak4kzRE/RPLbedix3FfB0
         iMU1mgu77Wqy0j6Psmm6DAK2UifEGoCWvQkAdq0VDBDHBCGfYG8T0kBkkTEsN0g17kV3
         8EbFihrTBwEGteAhyplEHTnvjYsRUIDBoj5hS4K4q124bMhSAJotdOEjqgfDlUgFjOPF
         23cIZboMOWo821f2gNCNtFM5cbbe/0QbiTU2VKtAItwRPgpSOLR44cx5UjESNPh+Q8Dv
         jbdD8EQ+hwNjT09z+o9vDTcAnTa1GdT4TGp05AaKX5pCPe8xB6IPgMYE5tZY9pBSJC8O
         eh+A==
In-Reply-To: <20191217143720.GB131030@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Chris Down <chris@chrisdown.name>
Cc: Michal Hocko <mhocko@kernel.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org



> On Dec 17, 2019, at 9:37 AM, Chris Down <chris@chrisdown.name> wrote:
>=20
> I struggle to imagine a real issue this would catch that wouldn't already b=
e caught by other means. If it's just the risks of dead code, that seems equ=
ally risky as taking time away from reviewers.

Hate to say this but ignore unrealistic configs compiling test should not ta=
ke that much time.=
