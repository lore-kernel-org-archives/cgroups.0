From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 2 Oct 2017 12:45:18 -0700
Message-ID: <CALvZod4=+GVg+hrT4ubp9P4b+LUZ+q9mz4ztC=Fc_cmTZmvpcw@mail.gmail.com>
References: <20170926133040.uupv3ibkt3jtbotf@dhcp22.suse.cz>
 <20170926172610.GA26694@cmpxchg.org> <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
 <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz> <CAAAKZws2CFExeg6A9AzrGjiHnFHU1h2xdk6J5Jw2kqxy=V+_YQ@mail.gmail.com>
 <20170927162300.GA5623@castle.DHCP.thefacebook.com> <CAAAKZwtApj-FgRc2V77nEb3BUd97Rwhgf-b-k0zhf1u+Y4fqxA@mail.gmail.com>
 <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
 <20171002122434.llbaarb6yw3o3mx3@dhcp22.suse.cz> <CALvZod65LYZZYy6uE=DQaQRPXYAhAci=NMG_w=ZANPGATgRwfg@mail.gmail.com>
 <20171002192814.sad75tqklp3nmr4m@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=svpG0jYDhwoiuvs1oQWXY4S30o5tZT0OGvwLjR4O4iM=;
        b=iGURmybtFLK2aMSIlEJagqKnv1dtYN2tx+VOZugmnyXhZNSm3eFSjeSPA8ZxVLAxqL
         2h2h5lgrwqy/9a34GHwpXsa0rB2EOT1TarEaJDfAHEIYNcPvgITAFH2ukLUTq5nbJZ5J
         /eIhp55ZBNxybYxyzgx/L+q2qHfYUP13Anq1aG+a1KrCOBBvQr72NjHelT5Wlm/tPeB8
         wNGEGL46lN0pwu70+D8rtWQmWRTDLI6v/2AurrpN70UG7PvBtk04PwNyY0Xy0JgUkvC1
         wwgyt2d4zhJfiOT0QDy3TvNRxRcJqueq5YOt3nBsxUsyAorQl4QgwIP0N0wZrShERwnW
         OkGA==
In-Reply-To: <20171002192814.sad75tqklp3nmr4m@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Tim Hockin <thockin@hockin.org>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

> I am sorry to cut the rest of your proposal because it simply goes over
> the scope of the proposed solution while the usecase you are mentioning
> is still possible. If we want to compare intermediate nodes (which seems
> to be the case) then we can always provide a knob to opt-in - be it your
> oom_gang or others.

In the Roman's proposed solution we can already force the comparison
of intermediate nodes using 'oom_group', I am just requesting to
separate the killall semantics from it.
