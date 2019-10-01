From: Qian Cai <cai@lca.pw>
Subject: Re: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Tue, 01 Oct 2019 12:44:32 -0400
Message-ID: <1569948272.5576.259.camel@lca.pw>
References: <20191001142227.1227176-1-arnd@arndb.de>
         <1569940805.5576.257.camel@lca.pw>
         <CAK8P3a04nMwy3VpdtD6x_tdPC14LPPbt3JKrGN48qRo_sDVk-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7GPDFQWuJXwzJuqgdtkv8cWj1/rryU2amRMgaS7klwk=;
        b=UI4eNsI01cw12FCH1szI/WpOWDa4aYdcfwkvjF0IataQqplLO5GIZr4lLpKiTNA1Ay
         30U8FhzxOnozK/bML5k8xB8Vk/Mvr4T7avhwBHv7jt3G0Id/wFihN8VFw3eyKc8pGSLF
         vhJd5VxytmfI8W3SVJ6Y70mWApfvtdP0qOYh7jZjeIuXbqyZ30E6+7D8kBMzAJGnJwMj
         JO2DFGWYAm8+CuNdxW50PvPeOpgJUYiXllV7SB789XKFpeK9CDGSwG6iG7kBSIKxpHeE
         2GhuyBg5Imcu8wBPi3w4si8hU8R9pLqCkPmY8iyZyieAMvzcmNRhTOiCeB3x7VYWf7L3
         MWRw==
In-Reply-To: <CAK8P3a04nMwy3VpdtD6x_tdPC14LPPbt3JKrGN48qRo_sDVk-Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Arnd Bergmann <arnd@arndb.de>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, clang-built-linux <clang-built-linux@googlegroups.com>

On Tue, 2019-10-01 at 18:00 +0200, Arnd Bergmann wrote:
> On Tue, Oct 1, 2019 at 4:40 PM Qian Cai <cai@lca.pw> wrote:
> > 
> > On Tue, 2019-10-01 at 16:22 +0200, Arnd Bergmann wrote:
> > > Removing the mem_cgroup_id_get() stub function introduced a new warning
> > > of the same kind when CONFIG_MMU is disabled:
> > 
> > Shouldn't CONFIG_MEMCG depends on CONFIG_MMU instead?
> 
> Maybe. Generally we allow building a lot of stuff without CONFIG_MMU that
> may not make sense, so I just followed the same idea here.

Those blindly mark __maybe_unused might just mask important warnings off in the
future, and they are ugly. Let's fix it properly.
