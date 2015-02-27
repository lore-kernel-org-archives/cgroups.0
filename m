From: Tim Hockin <thockin@google.com>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Fri, 27 Feb 2015 09:12:45 -0800
Message-ID: <CAO_RewbeTbMuqVG5wsui_gHwrdgqjF0KLk6yr5a3bb76VOkofg@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=OdSdoKMnueinnaiugYCMRsb84D41YuGTcVxFUFq+h7o=;
        b=Oa1/jCCzctws1ptATXhq5EiXusG9ZzpZE79U7QLHRre5eUSksRWfpCymZTqnTVINmL
         Hr/C4APFpLyKAnXgNYaaBuFDi9AgIMJNfzhMU0qWzzZ7YMwIjsjdr2Pns7qjcfQKlehv
         R8ipzD4VWY39ZVnxLSZwGhc1b5R1Ia+5hqwhmjkYby9oFRBEgfhsycZGNrRRS0eCDnPu
         5Clcgsp19YDm4jxlmu3//UvGV8kfADhBZ/6vwaImX1AMEPGUwpVo5uo+1AMRiYxv0Nz0
         lpFC5QRiUz7QzH6oVz83Vzx1MRyDRbmot0nTH9dzTFsIVXPJ+9xcgnt66XAD3bHbQpkN
         zdDg==
In-Reply-To: <54F09E62.8000007@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Aleksa Sarai <cyphar@cyphar.com>, lizefan@huawei.com, mingo@redhat.com, peterz@infradead.org, richard@nod.at, =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org

On Fri, Feb 27, 2015 at 8:42 AM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-02-27 06:49, Tejun Heo wrote:
>>
>> Hello,
>>
>> On Mon, Feb 23, 2015 at 02:08:09PM +1100, Aleksa Sarai wrote:
>>>
>>> The current state of resource limitation for the number of open
>>> processes (as well as the number of open file descriptors) requires you
>>> to use setrlimit(2), which means that you are limited to resource
>>> limiting process trees rather than resource limiting cgroups (which is
>>> the point of cgroups).
>>>
>>> There was a patch to implement this in 2011[1], but that was rejected
>>> because it implemented a general-purpose rlimit subsystem -- which meant
>>> that you couldn't control distinct resource limits in different
>>> heirarchies. This patch implements a resource controller *specifically*
>>> for the number of processes in a cgroup, overcoming this issue.
>>>
>>> There has been a similar attempt to implement a resource controller for
>>> the number of open file descriptors[2], which has not been merged
>>> becasue the reasons were dubious. Merely from a "sane interface"
>>> perspective, it should be possible to utilise cgroups to do such
>>> rudimentary resource management (which currently only exists for process
>>> trees).
>>
>>
>> This isn't a proper resource to control.  kmemcg just grew proper
>> reclaim support and will be useable to control kernel side of memory
>> consumption.

I was told that the plan was to use kmemcg - but I was told that YEARS
AGO.  In the mean time we all either do our own thing or we do nothing
and suffer.

Something like this is long overdue, IMO, and is still more
appropriate and obvious than kmemcg anyway.


>> Thanks.
>>
> Kernel memory consumption isn't the only valid reason to want to limit the
> number of processes in a cgroup.  Limiting the number of processes is very
> useful to ensure that a program is working correctly (for example, the NTP
> daemon should (usually) have an _exact_ number of children if it is
> functioning correctly, and rpcbind shouldn't (AFAIK) ever have _any_
> children), to prevent PID number exhaustion, to head off DoS attacks against
> forking network servers before they get to the point of causing kmem
> exhaustion, and to limit the number of processes in a cgroup that uses lots
> of kernel memory very infrequently.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
