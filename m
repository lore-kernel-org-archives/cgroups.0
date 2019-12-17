From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH] mm: memcontrol.c: move mem_cgroup_id_get_many under
 CONFIG_MMU
Date: Tue, 17 Dec 2019 15:09:21 +0000
Message-ID: <20191217150921.GA136178@chrisdown.name>
References: <20191217135440.GB58496@chrisdown.name>
 <392D7C59-5538-4A9B-8974-DB0B64880C2C@lca.pw>
 <20191217144652.GA7272@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uRifrYHkApcXnKzKR9sZGrhWwRmDmhE0ikbPGadvDHM=;
        b=crKI2MrdTHir1/QxP/Gc2TF/K5LQOSpYr8URTRvZSMKKZd2IgIojFD0O83S/Bq7wBT
         yjLxMTafYMdzf3fF/MvlxezrtHOD813wOAA/PfVag2ndv+LWndeMEvvqrBl174t8ahcL
         v1msU5U/qfNvNJUvqwR/V3PDAfi2JdKH0xG5U=
Content-Disposition: inline
In-Reply-To: <20191217144652.GA7272@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Qian Cai <cai@lca.pw>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Michal Hocko writes:
>yes, I would just ignore this warning. Btw. it seems that this is
>enabled by default for -Wall. Is this useful for kernel builds at
>all? Does it realistically help discovering real issues? If not then
>can we simply blacklist it?

There's no way we're the first people to encounter these problems, so what did 
we do in the past when situations like this (adding a generic API which is not 
yet used by non-configurable code) came up, and in retrospect did they work 
well?

As far as I know -Wunused-function also guards against other errors, like when 
a function is prototyped but not actually defined, which might be more useful 
to know about.

(Side note: I'm moderately baffled that a tightly scoped __maybe_unused is 
considered sinister but somehow disabling -Wunused-function is on the table 
:-))
