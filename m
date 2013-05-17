From: Konstantin Khlebnikov <khlebnikov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH V2 0/3] memcg: simply lock of page stat accounting
Date: Fri, 17 May 2013 14:29:33 +0400
Message-ID: <5196068D.2050608@openvz.org>
References: <1368421410-4795-1-git-send-email-handai.szj@taobao.com> <519380FC.1040504@openvz.org> <20130515134110.GD5455@dhcp22.suse.cz> <51946071.4030101@openvz.org> <20130516132846.GE13848@dhcp22.suse.cz> <5195C6D1.6040005@openvz.org> <20130517083806.GB5048@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:message-id:date:from:user-agent:mime-version:to
         :cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=AmY09ellrRMAuVeTs9G2Wn3yI4h0MSmVDQDvlqKI2hc=;
        b=RhfQ6YcZjKI+rym8mhve4uGpGIwn5hkf+BVGbmD7FkxqVFiJ7IxJFm3oP65woxfHOP
         jGThoFwOyzX5SqC7xHaEj/B3GonRiGZ2OlUOFQpMoDACAjc2YLNmHxNzgpKMmDysZcQi
         935oQkqFyKhZmSmFmffbH1vbEkPM6JAbtuLERYuuN8/brqT4HyWcqQS5LbeV74J4q1ST
         pQKoB9p438B9a5hJUy6vfU6kd8F/l0SNaECqb1wTEhOaFDiJZxMS7QEyXyKvMS/xppLJ
         Zk/3H83fnt2mS/Vh99idS4mY0GgJnRLhAIXXRW7fDcos7R/lsv875XhkjZou5BYAO2TW
         5e2w==
In-Reply-To: <20130517083806.GB5048-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Michal Hocko wrote:
> On Fri 17-05-13 09:57:37, Konstantin Khlebnikov wrote:
>> Michal Hocko wrote:
>>> On Thu 16-05-13 08:28:33, Konstantin Khlebnikov wrote:
> [...]
>>>> If somebody needs more detailed information there are enough ways to get it.
>>>> Amount of mapped pages can be estimated via summing rss counters from mm-structs.
>>>> Exact numbers can be obtained via examining /proc/pid/pagemap.
>>>
>>> How do you find out whether given pages were charged to the group of
>>> interest - e.g. shared data or taks that has moved from a different
>>> group without move_at_immigrate?
>>
>> For example we can export pages ownership and charging state via
>> single file in proc, something similar to /proc/kpageflags
>
> So you would like to add a new interface with cryptic api (I consider
> kpageflags to be a devel tool not an admin aid) to replace something
> that is easy to use? Doesn't make much sense to me.

Hmm. Kernel api is just api. It's not supposed to be a tool itself.
It must be usable for making tools which admins can use.

>
>> BTW
>> In our kernel the memory controller tries to change page's ownership
>> at first mmap and at each page activation, probably it's worth to add
>> this into mainline memcg too.
>
> Dunno, there are different approaches for this. I haven't evalueted them
> so I don't know all the pros and cons. Why not just unmap&uncharge the
> page when the charging process dies. This should be more lightweight
> wrt. recharge on re-activation.

On activation it's mostly free, because we need to lock lru anyway.
If memcg charge/uncharge isn't fast enough for that it should be optimized.


So, you propose to uncharge pages at unmap and charge them to who?
To the next mm in rmap?

What if next map will happens from different memcg, but after that unmap:

A:map
<pages owned by A>
A:unmap
<no new owner in rmap>
B:map
<pages still owned by A>

Anyway this is difficult question and I bring this just to show that currently
used logic isn't perfect in many ways. Switching ownership lazily in particular
places is a best solution which I can see now. So, page will be owned by its last
active user.

>
>>>> I don't think that simulating 'Mapped' line in /proc/mapfile is a worth reason
>>>> for adding such weird stuff into the rmap code on map/unmap paths.
>>>
>>> The accounting code is trying to be not intrusive as much as possible.
>>> This patchset makes it more complicated without a good reason and that
>>> is why it has been Nacked by me.
>>
>> I think we can remove it or replace it with something different but
>> much less intrusive, if nobody strictly requires exactly this approach
>> in managing 'mapped' pages counters.
>
> Do you have any numbers on the intrusiveness? I do not mind to change
> the internal implementation but the file is a part of the user space API
> so we cannot get rid of it.

Main problem here that it increases complexity of switching pages' ownership.
We need not just charge/uncharge page and move it to the different LRU, but
also synchronize with map/unmap paths in rmap to update nr-mapped counters
carefully. If you want to add per-page dirty/writeback counters it will
increase that complexity even further.

I haven't started yet migrating our product to mainline memory controller,
so I don't have any numbers. But my old code completely lockless on charging
and uncharging fast paths. LRU lock is the only lock on changing page's owner,
LRU isolation itself protects page ownership reference.
