From: Waiman Long <longman@redhat.com>
Subject: Re: Expensive memory.stat + cpu.stat reads
Date: Mon, 10 Jul 2023 20:44:15 -0400
Message-ID: <d3f3a7bc-b181-a408-af1d-dd401c172cbf@redhat.com>
References: <CABWYdi0c6__rh-K7dcM_pkf9BJdTRtAU08M43KO9ME4-dsgfoQ@mail.gmail.com>
 <20230706062045.xwmwns7cm4fxd7iu@google.com>
 <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689036260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xh89EtaamRoEiOvIq1NF8NCe+vpDYxFReDkvfE9D/uk=;
        b=BR1zNz1ZCVZwH2AxbQQsRswWHGFuyDPDNM4kWJB2/QMt5vKMi03944gMtpbOHiONaRYNcO
        4Vkh+INgiDQfzEn4E+GrNYQSvu5fx7H5BnOf3+XJ4YwdJ/tVRiv8vgavW95jbaFQgjv1hL
        H6u6OOkFwlD4pC6ZA3wvZyzreeQRx5w=
Content-Language: en-US
In-Reply-To: <CABWYdi2pBaCrdKcM37oBomc+5W8MdRp1HwPpOExBGYfZitxyWA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"; format="flowed"
To: Ivan Babrou <ivan@cloudflare.com>, Shakeel Butt <shakeelb@google.com>
Cc: cgroups@vger.kernel.org, Linux MM <linux-mm@kvack.org>, kernel-team <kernel-team@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On 7/10/23 19:21, Ivan Babrou wrote:
> On Wed, Jul 5, 2023 at 11:20=E2=80=AFPM Shakeel Butt <shakeelb@google.com=
> wrote:
>> On Fri, Jun 30, 2023 at 04:22:28PM -0700, Ivan Babrou wrote:
>>> Hello,
>>>
>>> We're seeing CPU load issues with cgroup stats retrieval. I made a
>>> public gist with all the details, including the repro code (which
>>> unfortunately requires heavily loaded hardware) and some flamegraphs:
>>>
>>> * https://gist.github.com/bobrik/5ba58fb75a48620a1965026ad30a0a13
>>>
>>> I'll repeat the gist of that gist here. Our repro has the following
>>> output after a warm-up run:
>>>
>>> completed:  5.17s [manual / mem-stat + cpu-stat]
>>> completed:  5.59s [manual / cpu-stat + mem-stat]
>>> completed:  0.52s [manual / mem-stat]
>>> completed:  0.04s [manual / cpu-stat]
>>>
>>> The first two lines do effectively the following:
>>>
>>> for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/memory.stat
>>> /sys/fs/cgroup/system.slice/cpu.stat > /dev/null
>>>
>>> The latter two are the same thing, but via two loops:
>>>
>>> for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/cpu.stat >
>>> /dev/null; done
>>> for _ in $(seq 1 1000); do cat /sys/fs/cgroup/system.slice/memory.stat
>>>> /dev/null; done
>>> As you might've noticed from the output, splitting the loop into two
>>> makes the code run 10x faster. This isn't great, because most
>>> monitoring software likes to get all stats for one service before
>>> reading the stats for the next one, which maps to the slow and
>>> expensive way of doing this.
>>>
>>> We're running Linux v6.1 (the output is from v6.1.25) with no patches
>>> that touch the cgroup or mm subsystems, so you can assume vanilla
>>> kernel.
>>>
>>>  From the flamegraph it just looks like rstat flushing takes longer. I
>>> used the following flags on an AMD EPYC 7642 system (our usual pick
>>> cpu-clock was blaming spinlock irqrestore, which was questionable):
>>>
>>> perf -e cycles -g --call-graph fp -F 999 -- /tmp/repro
>>>
>>> Naturally, there are two questions that arise:
>>>
>>> * Is this expected (I guess not, but good to be sure)?
>>> * What can we do to make this better?
>>>
>>> I am happy to try out patches or to do some tracing to help understand
>>> this better.
>> Hi Ivan,
>>
>> Thanks a lot, as always, for reporting this. This is not expected and
>> should be fixed. Is the issue easy to repro or some specific workload or
>> high load/traffic is required? Can you repro this with the latest linus
>> tree? Also do you see any difference of root's cgroup.stat where this
>> issue happens vs good state?
> I'm afraid there's no easy way to reproduce. We see it from time to
> time in different locations. The one that I was looking at for the
> initial email does not reproduce it anymore:

My understanding of mem-stat and cpu-stat is that they are independent=20
of each other. In theory, reading one shouldn't affect the performance=20
of reading the others. Since you are doing mem-stat and cpu-stat reading=20
repetitively in a loop, it is likely that all the data are in the cache=20
most of the time resulting in very fast processing time. If it happens=20
that the specific memory location of mem-stat and cpu-stat data are such=20
that reading one will cause the other data to be flushed out of the=20
cache and have to be re-read from memory again, you could see=20
significant performance regression.

It is one of the possible causes, but I may be wrong.

Cheers,
Longman


