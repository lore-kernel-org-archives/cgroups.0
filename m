From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Subject: Re: [v8 0/4] cgroup-aware OOM killer
Date: Mon, 2 Oct 2017 20:56:31 +0900
Message-ID: <201710022056.EJI43796.FSFLOHQJtOVMOF@I-love.SAKURA.ne.jp>
References: <20170927074319.o3k26kja43rfqmvb@dhcp22.suse.cz>
        <CAAAKZws2CFExeg6A9AzrGjiHnFHU1h2xdk6J5Jw2kqxy=V+_YQ@mail.gmail.com>
        <20170927162300.GA5623@castle.DHCP.thefacebook.com>
        <CAAAKZwtApj-FgRc2V77nEb3BUd97Rwhgf-b-k0zhf1u+Y4fqxA@mail.gmail.com>
        <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CALvZod7iaOEeGmDJA0cZvJWpuzc-hMRn3PG2cfzcMniJtAjKqA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: shakeelb@google.com, thockin@hockin.org
Cc: guro@fb.com, mhocko@kernel.org, hannes@cmpxchg.org, tj@kernel.org, kernel-team@fb.com, rientjes@google.com, linux-mm@kvack.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

Shakeel Butt wrote:
> I think Tim has given very clear explanation why comparing A & D makes
> perfect sense. However I think the above example, a single user system
> where a user has designed and created the whole hierarchy and then
> attaches different jobs/applications to different nodes in this
> hierarchy, is also a valid scenario. One solution I can think of, to
> cater both scenarios, is to introduce a notion of 'bypass oom' or not
> include a memcg for oom comparision and instead include its children
> in the comparison.

I'm not catching up to this thread because I don't use memcg.
But if there are multiple scenarios, what about offloading memcg OOM
handling to loadable kernel modules (like there are many filesystems
which are called by VFS interface) ? We can do try and error more casually.
