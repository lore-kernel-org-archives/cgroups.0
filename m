From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 2 Oct 2017 13:20:20 -0700
Message-ID: <CALvZod4dVOJr6By9XPSqxHM_fEAQnRd5TTN6vkFoYJ2MMYA_aQ@mail.gmail.com>
References: <CAAAKZws88uF2dVrXwRV0V6AH5X68rWy7AfJxTxYjpuiyiNJFWA@mail.gmail.com>
 <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz> <CAAAKZws2CFExeg6A9AzrGjiHnFHU1h2xdk6J5Jw2kqxy=V+_YQ@mail.gmail.com>
 <20170927162300.GA5623@castle.DHCP.thefacebook.com> <CAAAKZwtApj-FgRc2V77nEb3BUd97Rwhgf-b-k0zhf1u+Y4fqxA@mail.gmail.com>
 <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
 <20171002122434.llbaarb6yw3o3mx3@dhcp22.suse.cz> <CALvZod65LYZZYy6uE=DQaQRPXYAhAci=NMG_w=ZANPGATgRwfg@mail.gmail.com>
 <20171002192814.sad75tqklp3nmr4m@dhcp22.suse.cz> <CALvZod4=+GVg+hrT4ubp9P4b+LUZ+q9mz4ztC=Fc_cmTZmvpcw@mail.gmail.com>
 <20171002195601.3jeocmmzyf2jl3dw@dhcp22.suse.cz> <CAAAKZwtfXBEe=K93J0U35aMeFaBS8eJ9yN3kRE9=+yKzNnV_Nw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=dfGOkkOJV8g2dHpkYYDi7lDQ5Cn7TGQUyFdUiEQmbaw=;
        b=wGUQwhBGOy97hsQM3gKequCakMVmnLaoTLEDVVoijNpioA0vwple1LpIx8qC07gQgM
         CW5eOk/3DqIJKmm1CDi2Grz9q0HY8ZUus78DF9zijhB4bwNlJ8Oi1+j81nV/UZUnyUkH
         xr32RUCfq3gZrzFRyZE6btXWcIojDcbDJfpfLN7zi8ZdW9CF55RJShytisdqCljHtexp
         dQvBqnmNDSNhjaLKXYpwRCHU6UCNq9gizXwErKxOz5kUOaxhHk+EQ6mNPu+iWuUjUCIQ
         ayhkC22Y5j6o1Fseoy0SOhRu02gcnoyk797PnZgOOP87mWaVyS/FKKwPN4yYlQyV1g+E
         58qA==
In-Reply-To: <CAAAKZwtfXBEe=K93J0U35aMeFaBS8eJ9yN3kRE9=+yKzNnV_Nw@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin@hockin.org>
Cc: Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, David Rientjes <rientjes@google.com>, Linux MM <linux-mm@kvack.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

(Replying again as format of previous reply got messed up).

On Mon, Oct 2, 2017 at 1:00 PM, Tim Hockin <thockin@hockin.org> wrote:
> In the example above:
>
>        root
>        /    \
>      A      D
>      / \
>    B   C
>
> Does oom_group allow me to express "compare A and D; if A is chosen
> compare B and C; kill the loser" ?  As I understand the proposal (from
> reading thread, not patch) it does not.

It will let you compare A and D and if A is chosen then kill A, B and C.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
