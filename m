From: Waiman Long <llong@redhat.com>
Subject: Re: [PATCH v4 2/6] cgroup/cpuset: Properly handle partition root tree
Date: Thu, 12 Aug 2021 18:56:00 -0400
Message-ID: <55f61b66-5159-7e13-6e41-33df042612b0@redhat.com>
References: <20210811030607.13824-1-longman@redhat.com>
 <20210811030607.13824-3-longman@redhat.com>
 <YRQSKZB8rQUsfF2K@slm.duckdns.org>
 <b7897818-8fe6-8dd8-3ff6-6b15401162ba@redhat.com>
 <YRWeQH6gY5PqIanD@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1628808965;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pU1jcFqEFviufW4xVur65db047ti+YmuGAqH7xi6AYA=;
        b=F227wH2m+WktspAsKmf9g5iISMBbhkgJk/S9wl769RyyzK3XLbYoL+9+2TlJz2LkPOxHgj
        Ac5CMoVLjRDuT7UB912h4ss4hPEXrDp00nuwYlVhyqUf6Y19fKoYv4+SPyyWw//gwFOl8n
        +9sR3lH2AV0ccURNa2pwU8gTpWbneFI=
In-Reply-To: <YRWeQH6gY5PqIanD@slm.duckdns.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-9"; format="flowed"
To: Tejun Heo <tj@kernel.org>, Waiman Long <llong@redhat.com>
Cc: Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Phil Auld <pauld@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Marcelo Tosatti <mtosatti@redhat.com>, =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>

On 8/12/21 6:18 PM, Tejun Heo wrote:
> Hello,
>
> On Wed, Aug 11, 2021 at 03:27:20PM -0400, Waiman Long wrote:
>> Disabling partition at the parent level does invalidate all the child
>> partitions under it. So it must be done with care when we disable a
>> partition.
>>
>> How about we give some indication that a child partition exist when read=
ing
>> cpuset.cpus.partition and recommend double-checking it before disabling a
>> partition? For example, we keep track of the number of cpus delegated to
>> child partitions. Perhaps we can list that information on read.
>>
>> With that information available, I have no objection to allow disabling a
>> parent partition with child partitions under it.
> This is a general problem which has always existed regardless of whether =
the
> errors are synchronous or not. There are many different reasons that a wr=
ite
> to a cpuset interface file could fail and it has never been easy to tell =
why
> a given operation was rejected. Making error notifications asynchronous
> doesn't really change anything fundamental although it does make the
> situation a bit more opaque.
>
> I'm all for improving visibility. Now that we can consolidate most error
> states into a unified failure state, this might actually be easier to do.
> IOW, we now just have to explain why a given cgroup is in an invalid state
> rather than additionally having to explain why a given write has been
> rejected, which is pretty awkward to do as those failures are transient a=
nd
> local to the writer.
>
> So, if you wanna tackle this, let's do it right and provide something
> comprehensive rather than explaining just one failure.

That sounds reasonable. My current idea is to add invalid partition=20
reason string to cpuset. So when users read cpuset.cpus.partition of an=20
invalid partition, it will read something like "root invalid=C2=A0 (<reason=
>)".

What do you think?

Cheers,
Longman

