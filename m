From: John Fastabend <john.fastabend-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [BUG] Bug in netprio_cgroup and netcls_cgroup ?
Date: Mon, 21 Jan 2013 01:21:23 -0800
Message-ID: <50FD0893.1050805@gmail.com>
References: <50FCDB5C.4050608@huawei.com> <50FD0144.1000401@monom.org> <50FD0402.6060400@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:message-id:date:from:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=QUqoSCLCL7En3RlWSy/5y+pgzrkDRpmHtNGHyQakdj8=;
        b=KrSqLqiwLBG3IAIzi++s6EjzqVBNZiHNaNgkVvOyCdCeIebBmt0yac5b+hmF8NsBz/
         sZ2NlCvYV+Nz0/lgL1mSN+03E+YpuduZ8YrJcdkvo6nlYPhRIZNNdcenoKQRIUrWh4YW
         yau7ep1QF8pX+StraXeZfHb6qe5aw+DC3zighR/eQsmxsmlPMY6OGOW9c3b3foyGiLcp
         Vu2yXowGeqlJ67GTc5Nu3sNQLVeNoTvEiDZF43I5/3DDYgJWHSWrosq0y2Nd3S9z1iV1
         nxvgWfuujFYOf3VjPYe9aDope2tc1Wqt4PWy+s0nF4wdOwGZ8Fg57de1zmGvwuDSjWGn
         XpQg==
In-Reply-To: <50FD0402.6060400-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Daniel Wagner <wagi-kQCPcA+X3s7YtjvyW6yDsg@public.gmane.org>, John Fastabend <john.r.fastabend-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neil Horman <nhorman-2XuSBdqkA4R54TAoqtyWWQ@public.gmane.org>, Daniel Wagner <daniel.wagner-98C5kh4wR6ohFhg+JK9F0w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 01/21/2013 01:01 AM, Li Zefan wrote:
> On 2013/1/21 16:50, Daniel Wagner wrote:
>> Hi Li,
>>
>> On 21.01.2013 07:08, Li Zefan wrote:
>>> I'm not a network developer, so correct me if I'm wrong.
>>>
>>> Since commit 7955490f732c2b8
>>> ("net: netprio_cgroup: rework update socket logic"), sock->sk->sk_cgrp_prioidx
>>> is set when the socket is created, and won't be updated unless the task is
>>> moved to another cgroup.
>>>
>>> Now the problem is, a socket can be _shared_ by multiple processes (fork, SCM_RIGHT).
>>> If we place those processes in different cgroups, and each cgroup has
>>> different configs, but all of the processes will send data via this socket
>>> with the same network priority.
>>
>> Wouldn't that be addressed by 48a87cc26c13b68f6cce4e9d769fcb17a6b3e4b8
>>
>>     net: netprio: fd passed in SCM_RIGHTS datagram not set correctly
>>
>>      A socket fd passed in a SCM_RIGHTS datagram was not getting
>>      updated with the new tasks cgrp prioidx. This leaves IO on
>>      the socket tagged with the old tasks priority.
>>
>>      To fix this add a check in the scm recvmsg path to update the
>>      sock cgrp prioidx with the new tasks value.
>>
>> As I read this this should work for net_prio.
>>
> 
> But after process A passed the socket fd to B, both A and B can use the
> same socket to send data, right? Then if A and B were placed in different
> cgroups with differnt configs, A's config won't take effect anymore.
> 
> Am I missing something?
> 
> 

Hi Zefan,

Neil and I discusses this here, http://patchwork.ozlabs.org/patch/172343/
look towards the bottom of the thread. Quoted here.

>> I like the idea, but IIRC last time we tried this I think it caused problems
>> with processes that shared sockets.  That is to say, if you have a parent and
>> child process that dup an socket descriptior, and put them in separate cgroups,
>> you get unpredictable results, as the socket gets assigned a priority based on
>> the last processed that moved cgroups.
>>
>> Neil
>>
> 
> Shared sockets creates strange behavior as it exists today. If a dup
> of the socket fd is created the private data is still shared right. So
> in this case the sk_cgrp_prioidx value is going to get updated by both
> threads and then it is a race to see what it happens to be set to in
> the xmit path.
> 
> With this patch at least the behavior is deterministic. Without it
> I can create the above scenario but have no way to determine what the
> skb priority will actually be set to.
> 

Its unfortunate but I'm not sure how to fix it off hand with the shared
value
in the socket.

.John

-- 
John Fastabend         Intel Corporation
