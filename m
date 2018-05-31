From: Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] memcg: force charge kmem counter too
Date: Thu, 31 May 2018 15:01:33 +0900
Message-ID: <20180531060133.GA31477@rodete-desktop-imager.corp.google.com>
References: <20180525185501.82098-1-shakeelb@google.com>
 <20180526185144.xvh7ejlyelzvqwdb@esperanza>
 <CALvZod5yTxcuB_Aao-a0ChNEnwyBJk9UPvEQ80s9tZFBQ0cxpw@mail.gmail.com>
 <20180528091110.GG1517@dhcp22.suse.cz>
 <CALvZod6x5iRmcJ6pYKS+jwJd855jnwmVcPK9tnKbuJ9Hfppa-A@mail.gmail.com>
 <20180529083153.GR27180@dhcp22.suse.cz>
 <CALvZod67qzq+hQLms4Wut5LNVBjBcEQPpMp9zxF6NE5k+7CLOw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DMfMZJjO4b5UMB8MlVj899MPNkeAiZPUjYuUJ9keC0E=;
        b=tU0/i3s/dusFT+dzc0DZZTeO/E075aW6W8V6ZDXEPlHLQ9Kcbe3V5Lsy1HDrcrgdQW
         BX6FpQ4qpcnE3cpJf4iuw/1vKHRSTkzOeFm9MGBOfe/7TqnWSsJKFswPMZbPk2uhEc7o
         wcmoqcvsWVPTz6N+l/OilNrll80BUxEtM1zhbQiOgEZPg+McE2MOFM16GMjjN4dtuZnS
         bx0VZ2dsOAHq0Gz1SfDUWkHETFEfx358KG1xsiiImxerUIRpDpbNtFCqNwNxvnpXgpnr
         CBkgdmz+2+pboMw3tJuj+QLSLdXzk8MK7vJ3cDDW84s7pEJ/gBo49rJYsFdnfcKGmreB
         SOrA==
Content-Disposition: inline
In-Reply-To: <CALvZod67qzq+hQLms4Wut5LNVBjBcEQPpMp9zxF6NE5k+7CLOw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Wed, May 30, 2018 at 11:14:33AM -0700, Shakeel Butt wrote:
> On Tue, May 29, 2018 at 1:31 AM, Michal Hocko <mhocko@kernel.org> wrote:
> > On Mon 28-05-18 10:23:07, Shakeel Butt wrote:
> >> On Mon, May 28, 2018 at 2:11 AM, Michal Hocko <mhocko@kernel.org> wrote:
> >> Though is there a precedence where the broken feature is not fixed
> >> because an alternative is available?
> >
> > Well, I can see how breaking GFP_NOFAIL semantic is problematic, on the
> > other hand we keep saying that kmem accounting in v1 is hard usable and
> > strongly discourage people from using it. Sure we can add the code which
> > handles _this_ particular case but that wouldn't make the whole thing
> > more usable I strongly suspect. Maybe I am wrong and you can provide
> > some specific examples. Is GFP_NOFAIL that common to matter?
> >
> > In any case we should balance between the code maintainability here.
> > Adding more cruft into the allocator path is not free.
> >
> 
> We do not use kmem limits internally and this is something I found
> through code inspection. If this patch is increasing the cost of code
> maintainability I am fine with dropping it but at least there should a
> comment saying that kmem limits are broken and no need fix.
 
I agree.

Even, I didn't know kmem is strongly discouraged until now. Then,
why is it enabled by default on cgroup v1?

Let's turn if off with comment "It's broken so do not use/fix. Instead,
please move to cgroup v2".
