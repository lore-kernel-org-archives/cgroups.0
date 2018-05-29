From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: force charge kmem counter too
Date: Tue, 29 May 2018 10:31:53 +0200
Message-ID: <20180529083153.GR27180@dhcp22.suse.cz>
References: <20180525185501.82098-1-shakeelb@google.com>
 <20180526185144.xvh7ejlyelzvqwdb@esperanza>
 <CALvZod5yTxcuB_Aao-a0ChNEnwyBJk9UPvEQ80s9tZFBQ0cxpw@mail.gmail.com>
 <20180528091110.GG1517@dhcp22.suse.cz>
 <CALvZod6x5iRmcJ6pYKS+jwJd855jnwmVcPK9tnKbuJ9Hfppa-A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALvZod6x5iRmcJ6pYKS+jwJd855jnwmVcPK9tnKbuJ9Hfppa-A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Mon 28-05-18 10:23:07, Shakeel Butt wrote:
> On Mon, May 28, 2018 at 2:11 AM, Michal Hocko <mhocko@kernel.org> wrote:
> Though is there a precedence where the broken feature is not fixed
> because an alternative is available?

Well, I can see how breaking GFP_NOFAIL semantic is problematic, on the
other hand we keep saying that kmem accounting in v1 is hard usable and
strongly discourage people from using it. Sure we can add the code which
handles _this_ particular case but that wouldn't make the whole thing
more usable I strongly suspect. Maybe I am wrong and you can provide
some specific examples. Is GFP_NOFAIL that common to matter?

In any case we should balance between the code maintainability here.
Adding more cruft into the allocator path is not free.

-- 
Michal Hocko
SUSE Labs
