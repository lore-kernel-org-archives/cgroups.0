From: Tim Murray <timmurray-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Thu, 30 Mar 2017 00:10:46 -0700
Message-ID: <CAEe=Sx=rg=YLagFX4LBQ7Z7wRjwsQGHbc7dNo8P5qQk9P8oLAA@mail.gmail.com>
References: <20170317231636.142311-1-timmurray@google.com> <20170330055908.GA6603@bbox>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=JSmP0tsRO1s6Hj2An3pOBauOQbGkj6xi8MjVkO7ikbY=;
        b=j9GFtS1ErZLCo3Js2TbsmE2kowilvlfRsRHTKBTBgTU1+rIv8saEarGv3QNtv+EP67
         FplxUMJ+ahqxxmml616MuKRGzdKQW3tjinSYU1fUl1Rzrz62DqZzmtUpMWQ1bF5ls0by
         pezoe9YxXiCF9zZZRSJ32e05hXAx0QajcXrHYJtC90WqLK1kt/WVAuGn/hpmLmSQJB8u
         kOh38OJUzXQGba2TmRZ8Q9AR16F4pCl0VbXxzakyEPAz4+8HS9ZJbRf5FSnfHIfnw31k
         z7Gmuo4gotloB/S35LVBSE6EtOVjs9gwyYOJo4UEEP4VxbdJcwv8NPOgqhCdy/Q7pEt+
         F1gw==
In-Reply-To: <20170330055908.GA6603@bbox>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Patrik Torstensson <totte-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Android Kernel Team <kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>

Sorry for the delay on my end as well. I realized that given multiple
equivalent prioritization implementations, my favorite would be the
one that provides the clearest signal to vmpressure. I've been
experimenting with different approaches to using memcg priority in
vmpressure, and I'm cautiously optimistic about my latest attempt. I
like the data I get from vmscan, but I'm still wiring up userspace and
testing different thresholds so I don't yet know that it's a strong
enough signal. I hope to have a new RFC before the weekend.

On Wed, Mar 29, 2017 at 10:59 PM, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> To memcg maintainer,
>
> Could you comment about this topic?
>
> On Fri, Mar 17, 2017 at 04:16:35PM -0700, Tim Murray wrote:
>> Hi all,
>>
>> I've been working to improve Android's memory management and drop lowmem=
orykiller from the kernel, and I'd like to get some feedback on a small pat=
ch with a lot of side effects.
>>
>> Currently, when an Android device is under memory pressure, one of three=
 things will happen from kswapd:
>>
>> 1. Compress an anonymous page to ZRAM.
>> 2. Evict a file page.
>> 3. Kill a process via lowmemorykiller.
>>
>> The first two are cheap and per-page, the third is relatively cheap in t=
he short term, frees many pages, and may cause power and performance penalt=
ies later on when the process has to be started again. For lots of reasons,=
 I'd like a better balance between reclamation and killing on Android.
>>
>> One of the nice things about Android from an optimization POV is that th=
e execution model is more constrained than a generic Linux machine. There a=
re only a limited number of processes that need to execute quickly for the =
device to appear to have good performance, and a userspace daemon (called A=
ctivityManagerService) knows exactly what those processes are at any given =
time. We've made use of that in the past via cpusets and schedtune to limit=
 the CPU resources available to background processes, and I think we can ap=
ply the same concept to memory.
>>
>> This patch adds a new tunable to mem cgroups, memory.priority. A mem cgr=
oup with a non-zero priority will not be eligible for scanning until the sc=
an_control's priority is greater than zero. Once the mem cgroup is eligible=
 for scanning, the priority acts as a bias to reduce the number of pages th=
at should be scanned.
>>
>> We've seen cases on Android where the global LRU isn't sufficient. For e=
xample, notifications in Android are rendered as part of a separate process=
 that runs infrequently. However, when a notification appears and the user =
slides down the notification tray, we'll often see dropped frames due to pa=
ge faults if there has been severe memory pressure. There are similar issue=
s with other persistent processes.
>>
>> The goal on an Android device is to aggressively evict from very low-pri=
ority background tasks that are likely to be killed anyway, since this will=
 reduce the likelihood of lowmemorykiller running in the first place. It wi=
ll still evict some from foreground and persistent processes, but it should=
 help ensure that background processes are effectively reduced to the size =
of their heaps before evicting from more critical tasks. This should mean f=
ewer background processes end up killed, which should improve performance a=
nd power on Android across the board (since it costs significantly less to =
page things back in than to replay the entirety of application startup).
>>
>> The follow-on that I'm also experimenting with is how to improve vmpress=
ure such that userspace can have some idea when low-priority memory cgroups=
 are about as small as they can get. The correct time for Android to kill a=
 background process under memory pressure is when there is evidence that a =
process has to be killed in order to alleviate memory pressure. If the devi=
ce is below the low memory watermark and we know that there's probably no w=
ay to reclaim any more from background processes, then a userspace daemon s=
hould kill one or more background processes to fix that. Per-cgroup priorit=
y could be the first step toward that information.
>>
>> I've tested a version of this patch on a Pixel running 3.18 along with a=
n overhauled version of lmkd (the Android userspace lowmemorykiller daemon)=
, and it does seem to work fine. I've ported it forward but have not yet ri=
gorously tested it at TOT, since I don't have an Android test setup running=
 TOT. While I'm getting my tests ported over, I would like some feedback on=
 adding another tunable as well as what the tunable's interface should be--=
I really don't like the 0-10 priority scheme I have in the patch but I don'=
t have a better idea.
>>
>> Thanks,
>> Tim
>>
>> Tim Murray (1):
>>   mm, memcg: add prioritized reclaim
>>
>>  include/linux/memcontrol.h | 20 +++++++++++++++++++-
>>  mm/memcontrol.c            | 33 +++++++++++++++++++++++++++++++++
>>  mm/vmscan.c                |  3 ++-
>>  3 files changed, 54 insertions(+), 2 deletions(-)
>>
>> --
>> 2.12.0.367.g23dc2f6d3c-goog
>>
>> --
>> To unsubscribe, send a message with 'unsubscribe linux-mm' in
>> the body to majordomo-Bw31MaZKKs0EbZ0PF+XxCw@public.gmane.org  For more info on Linux MM,
>> see: http://www.linux-mm.org/ .
>> Don't email: <a href=3Dmailto:"dont-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org"> email-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org </a>
