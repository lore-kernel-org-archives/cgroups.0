From: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 11:42:10 -0500
Message-ID: <54F09E62.8000007@gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com> <20150227114940.GB3964@htj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:disposition-notification-to:date:from:user-agent
         :mime-version:to:cc:subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        bh=y1Ow/T9PlC4+d3+hwQpqDIUQnY8MZL/MblNo3wz4KOA=;
        b=M3RxwUxrFcsPX5fuo2RZzjeI/Bm6MrVb3joPDzEKtqb9SpaBb+zvG6wpsbVvKJkD2K
         Eiqf6pfkP42FYJ7IMtJyYGE7aOSccrxFkORQTqIaIZRiR0/4wj8dd/jo3Gzc2TjdI87N
         m8ptfIQ1SO3g8sSCx1dIrY0n6S03Kixf+JS8067B4BBiW41CV3xLni9R8LmwSpg4B94F
         eLq3Whd4ReHL8AjMZdTyI7HsNw/KRWPNIE9yEvY/xHnfJgZkq45apqcIAksoTbIvzxkc
         bdfySbOKVG7fNFZXp52asQHlULv/YWO7xCH05xh9lCHu5dwV6nPDkCxWZjyXR9d6mU6g
         RKhA==
In-Reply-To: <20150227114940.GB3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 2015-02-27 06:49, Tejun Heo wrote:
> Hello,
>
> On Mon, Feb 23, 2015 at 02:08:09PM +1100, Aleksa Sarai wrote:
>> The current state of resource limitation for the number of open
>> processes (as well as the number of open file descriptors) requires you
>> to use setrlimit(2), which means that you are limited to resource
>> limiting process trees rather than resource limiting cgroups (which is
>> the point of cgroups).
>>
>> There was a patch to implement this in 2011[1], but that was rejected
>> because it implemented a general-purpose rlimit subsystem -- which meant
>> that you couldn't control distinct resource limits in different
>> heirarchies. This patch implements a resource controller *specifically*
>> for the number of processes in a cgroup, overcoming this issue.
>>
>> There has been a similar attempt to implement a resource controller for
>> the number of open file descriptors[2], which has not been merged
>> becasue the reasons were dubious. Merely from a "sane interface"
>> perspective, it should be possible to utilise cgroups to do such
>> rudimentary resource management (which currently only exists for process
>> trees).
>
> This isn't a proper resource to control.  kmemcg just grew proper
> reclaim support and will be useable to control kernel side of memory
> consumption.
>
> Thanks.
>
Kernel memory consumption isn't the only valid reason to want to limit 
the number of processes in a cgroup.  Limiting the number of processes 
is very useful to ensure that a program is working correctly (for 
example, the NTP daemon should (usually) have an _exact_ number of 
children if it is functioning correctly, and rpcbind shouldn't (AFAIK) 
ever have _any_ children), to prevent PID number exhaustion, to head off 
DoS attacks against forking network servers before they get to the point 
of causing kmem exhaustion, and to limit the number of processes in a 
cgroup that uses lots of kernel memory very infrequently.
