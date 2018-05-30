From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: force charge kmem counter too
Date: Wed, 30 May 2018 11:14:33 -0700
Message-ID: <CALvZod67qzq+hQLms4Wut5LNVBjBcEQPpMp9zxF6NE5k+7CLOw@mail.gmail.com>
References: <20180525185501.82098-1-shakeelb@google.com> <20180526185144.xvh7ejlyelzvqwdb@esperanza>
 <CALvZod5yTxcuB_Aao-a0ChNEnwyBJk9UPvEQ80s9tZFBQ0cxpw@mail.gmail.com>
 <20180528091110.GG1517@dhcp22.suse.cz> <CALvZod6x5iRmcJ6pYKS+jwJd855jnwmVcPK9tnKbuJ9Hfppa-A@mail.gmail.com>
 <20180529083153.GR27180@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=bH1fbk66ldNL3s7EMF466MPVK5koMb9gAcbp402ATr0=;
        b=YdkxRkj8+3/+6g3rj7RykwttHriJbLAaX0XgcEh1Y7RkrT0UgZnHmWqew6zG/t4b9o
         LnTKOAck9NvNhGvHL8w3h+q4qKfVkpiWvPa/DTh2Vc65Rv75W9FpyVdgOElJRoNfUCpz
         tMfc0CGTBbG8qjVzKe8gMHlzHo3Vmeku1n03+BKmSeFyRT/lCUbHAAeo+eoQ+xCHum1L
         Y9Fe4lkiXrDD70A1EIUFJlGE/QQhBbzmwUqt/B6hh21+kXiA+J90ar/9ktPL4ESc38e/
         SDpRc4+pRlkKyGNS+1zO+SNm2FRnuS5GPnUZpHnHg4VZDH6ILkU6x6PmD1kDTtUqugSj
         CxZg==
In-Reply-To: <20180529083153.GR27180@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Tue, May 29, 2018 at 1:31 AM, Michal Hocko <mhocko@kernel.org> wrote:
> On Mon 28-05-18 10:23:07, Shakeel Butt wrote:
>> On Mon, May 28, 2018 at 2:11 AM, Michal Hocko <mhocko@kernel.org> wrote:
>> Though is there a precedence where the broken feature is not fixed
>> because an alternative is available?
>
> Well, I can see how breaking GFP_NOFAIL semantic is problematic, on the
> other hand we keep saying that kmem accounting in v1 is hard usable and
> strongly discourage people from using it. Sure we can add the code which
> handles _this_ particular case but that wouldn't make the whole thing
> more usable I strongly suspect. Maybe I am wrong and you can provide
> some specific examples. Is GFP_NOFAIL that common to matter?
>
> In any case we should balance between the code maintainability here.
> Adding more cruft into the allocator path is not free.
>

We do not use kmem limits internally and this is something I found
through code inspection. If this patch is increasing the cost of code
maintainability I am fine with dropping it but at least there should a
comment saying that kmem limits are broken and no need fix.

Shakeel
