From: Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>
Subject: Re: [PATCH] memcg: oom: ignore oom warnings from memory.max
Date: Tue, 5 May 2020 00:44:00 +0900
Message-ID: <3c24ef6a-f1f4-38e6-2d0f-1eac18dc15bb@i-love.sakura.ne.jp>
References: <20200430182712.237526-1-shakeelb@google.com>
 <20200504065600.GA22838@dhcp22.suse.cz>
 <CALvZod5Ao2PEFPEOckW6URBfxisp9nNpNeon1GuctuHehqk_6Q@mail.gmail.com>
 <939b6744-6556-2733-b83e-bf14e848dabd@I-love.SAKURA.ne.jp>
 <CALvZod5T9pYG1xVHqNM=c68jgKPVXtKjuvV0DSAR+Ld_Mm1c4A@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CALvZod5T9pYG1xVHqNM=c68jgKPVXtKjuvV0DSAR+Ld_Mm1c4A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2020/05/04 23:57, Shakeel Butt wrote:
> On Mon, May 4, 2020 at 7:20 AM Tetsuo Handa
> <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org> wrote:
>>
>> On 2020/05/04 22:54, Shakeel Butt wrote:
>>> It may not be a problem for an individual or small scale deployment
>>> but when "sweep before tear down" is the part of the workflow for
>>> thousands of machines cycling through hundreds of thousands of cgroups
>>> then we can potentially flood the logs with not useful dumps and may
>>> hide (or overflow) any useful information in the logs.
>>
>> I'm proposing a patch which allows configuring which OOM-related messages
>> should be sent to consoles at
>> https://lkml.kernel.org/r/20200424024239.63607-1-penguin-kernel-JPay3/Yim36HaxMnTkn67Xf5DAMn2ifp@public.gmane.org .
>> Will that approach help you?
> 
>>From what I understand, that patch is specifically for controlling
> messages to consoles. The messages will still be in logs, right?
> 

Right.

If you want to control which OOM-related messages should be sent to syslog,
we could use similar approach.
