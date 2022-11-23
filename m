From: Ivan Babrou <ivan@cloudflare.com>
Subject: Re: Low TCP throughput due to vmpressure with swap enabled
Date: Tue, 22 Nov 2022 17:28:24 -0800
Message-ID: <CABWYdi0qhWs56WK=k+KoQBAMh+Tb6Rr0nY4kJN+E5YqfGhKTmQ@mail.gmail.com>
References: <CABWYdi0G7cyNFbndM-ELTDAR3x4Ngm0AehEp5aP0tfNkXUE+Uw@mail.gmail.com>
 <Y30rdnZ+lrfOxjTB@cmpxchg.org> <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M42sWyNVtSXf63+/nFxRglHm/7sJT4os0b4YITaV5ns=;
        b=EEDxxsC8axWN6EfK6HuKM4nKLyz6jyKaF6MQb03199u9fI9ncH2Pzi0Pkz2Rmfaln3
         0LcVHqzeUlYiBsH/6c+Cd8NT5OeaxAlFYOn2KKOOs0oao+6e3/WwTuRD4LxatCOIGywm
         VjfLjjAHKCoOCfpD6aq+RuMP4XmMlWcW/Y98o=
In-Reply-To: <CABWYdi3PqipLxnqeepXeZ471pfeBg06-PV0Uw04fU-LHnx_A4g@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Linux MM <linux-mm@kvack.org>, Linux Kernel Network Developers <netdev@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, David Ahern <dsahern@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, cgroups@vger.kernel.org, kernel-team <kernel-team@cloudflare.com>

On Tue, Nov 22, 2022 at 2:11 PM Ivan Babrou <ivan@cloudflare.com> wrote:
>
> On Tue, Nov 22, 2022 at 12:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> > On Mon, Nov 21, 2022 at 04:53:43PM -0800, Ivan Babrou wrote:
> > > Hello,
> > >
> > > We have observed a negative TCP throughput behavior from the following commit:
> > >
> > > * 8e8ae645249b mm: memcontrol: hook up vmpressure to socket pressure
> > >
> > > It landed back in 2016 in v4.5, so it's not exactly a new issue.
> > >
> > > The crux of the issue is that in some cases with swap present the
> > > workload can be unfairly throttled in terms of TCP throughput.
> >
> > Thanks for the detailed analysis, Ivan.
> >
> > Originally, we pushed back on sockets only when regular page reclaim
> > had completely failed and we were about to OOM. This patch was an
> > attempt to be smarter about it and equalize pressure more smoothly
> > between socket memory, file cache, anonymous pages.
> >
> > After a recent discussion with Shakeel, I'm no longer quite sure the
> > kernel is the right place to attempt this sort of balancing. It kind
> > of depends on the workload which type of memory is more imporant. And
> > your report shows that vmpressure is a flawed mechanism to implement
> > this, anyway.
> >
> > So I'm thinking we should delete the vmpressure thing, and go back to
> > socket throttling only if an OOM is imminent. This is in line with
> > what we do at the system level: sockets get throttled only after
> > reclaim fails and we hit hard limits. It's then up to the users and
> > sysadmin to allocate a reasonable amount of buffers given the overall
> > memory budget.
> >
> > Cgroup accounting, limiting and OOM enforcement is still there for the
> > socket buffers, so misbehaving groups will be contained either way.
> >
> > What do you think? Something like the below patch?
>
> The idea sounds very reasonable to me. I can't really speak for the
> patch contents with any sort of authority, but it looks ok to my
> non-expert eyes.
>
> There were some conflicts when cherry-picking this into v5.15. I think
> the only real one was for the "!sc->proactive" condition not being
> present there. For the rest I just accepted the incoming change.
>
> I'm going to be away from my work computer until December 5th, but
> I'll try to expedite my backported patch to a production machine today
> to confirm that it makes the difference. If I can get some approvals
> on my internal PRs, I should be able to provide the results by EOD
> tomorrow.

I tried the patch and something isn't right here.

With the patch applied I'm capped at ~120MB/s, which is a symptom of a
clamped window.

I can't find any sockets with memcg->socket_pressure = 1, but at the
same time I only see the following rcv_ssthresh assigned to sockets:

$ sudo ss -tim dport 6443 | fgrep rcv_ssthresh | sed
's/.*rcv_ssthresh://' | awk '{ print $1 }' | sort -n | uniq -c | sort
-n | tail
      1 64076
    181 65495
   1456 5792
  16531 64088

* 64088 is the default value
* 5792 is 4 * advmss (clamped)

Compare this to a machine without the patch but with
cgroup.memory=nosocket in cmdline:
$ sudo ss -tim dport 6443 | fgrep rcv_ssthresh | sed
's/.*rcv_ssthresh://' | awk '{ print $1 }' | sort -n | uniq -c | sort
-n | tail
      8 2806862
      8 3777338
      8 72776
      8 86068
     10 2024018
     12 3777354
     23 91172
     29 66984
    101 65495
   5439 64088

There aren't any clamped sockets here and there are many different
rcv_ssthresh values.
