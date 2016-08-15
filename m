From: Mahesh Bandewar <maheshb@google.com>
Subject: Re: [PATCH 3/5] net: add udp limit to net cgroup
Date: Mon, 15 Aug 2016 12:16:17 -0700
Message-ID: <CAF2d9jiq=MpT71Pzd5AdDbvnEaA3BD6pa_Ov6NZOFrQiHK5i4w@mail.gmail.com>
References: <1470876798-4024-1-git-send-email-anaravaram@google.com>
 <1470876798-4024-4-git-send-email-anaravaram@google.com> <20160813043535.GB55856@ast-mbp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=GMWudeSN3BcY7Ctln9InL5skwTR56lFfN08ls/X+6WE=;
        b=iX41HvfZsVfcxzrb5Q9E6hKWYWg4uOuyTP5Op5jvIB8gFz1f84TMLDeGHKn/BkgB9E
         XG5ydyWj6G0+NNj3zCjfH9rqwfwGJDxGio7hiyTAU51iWRcri+9l/XbYNK5ByQNTBLtK
         Gv6berRqAa/HYGFjWZeYbZAoxx9y3hM39rfgHrMMgsKOK9Pk7b6ZZUo12iFhJCIkF/du
         jRjmM5EVsicHvwR96u/22qhfQb93qc01+psj+pTOTTBuw9j5Ge3mNbVzcdtumEDkAg4E
         4xNk7X6aBljbk1J709n9B+EGkNPbTT1oaX+mtnR5BazAOe+Xh2ZzjSybQWwtXvcM3jJE
         5DZg==
In-Reply-To: <20160813043535.GB55856@ast-mbp.thefacebook.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc: Anoop Naravaram <anaravaram@google.com>, corbet@lwn.net, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, David Miller <davem@davemloft.net>, kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org, kaber@trash.net, linux-doc@vger.kernel.org, cgroups@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>, Eric Dumazet <edumazet@google.com>, Wei Wang <weiwan@google.com>, tom@herbertland.com

On Fri, Aug 12, 2016 at 9:35 PM, Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
[...]
>> * 'net.udp_usage': Reading this file gives the number of udp ports used by
>> processes in this cgroup and all its descendants.
>> * 'net.udp_limit': Writing this file sets the total number of udp ports
>> that can be used by processes in this cgroup and all
>> its descendants. This file can also be read.
>> * 'net.udp_maxusage': Reading this file gives the highest value of
>> net.udp_usage that has been seen for this cgroup.
>> * 'net.udp_failcnt': Reading this file gives the number of times a
>> process in this cgroup or one of its descendants has attempted to acquire
>> a udp port but failed because the limit of this cgroup was reached.
>> * 'net.udp_underflowcnt': Reading this file gives the number of times a
>> process in this cgroup or one of its descendants released a udp port when
>> the usage value of this cgroup was 0.
>
> I have similar concern here. I don't think we should bloat the kernel by
> trying implement every possible port restriction combination and count.
> For the same reasons we don't do all possible tcp stats that research
> community finds useful. This additional code is a maintenance headache.
>
At this moment if a rampant process decides to just open a datagram
socket and just binds (does not listen) and does this for all
available ports, you are guaranteed to have machine becoming useless
for some (totally unrelated) legitimate process trying to do useful
things.

From kernel we can't control such user-space behavior, but at least
restrict the damage to "a specific set of processes". This code
provides that feature to restrict the damage.

Additional code is always a maintenance headache but that doesn't stop
us from adding new code, isn't it? :)
