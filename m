From: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFD] Merge task counter into memcg
Date: Wed, 18 Apr 2012 09:53:00 +0200
Message-ID: <CAFTL4hw3C4s6VS07pJzdBawv0ugKJJa+Vnb-Q_9FrWEq4=ka9Q@mail.gmail.com>
References: <4F862851.3040208@jp.fujitsu.com>
	<20120412113217.GB11455@somewhere.redhat.com>
	<4F86BFC6.2050400@parallels.com>
	<20120412123256.GI1787@cmpxchg.org>
	<4F86D4BD.1040305@parallels.com>
	<20120412153055.GL1787@cmpxchg.org>
	<20120412163825.GB13069@google.com>
	<20120412172309.GM1787@cmpxchg.org>
	<20120412174155.GC13069@google.com>
	<4F878480.60505@jp.fujitsu.com>
	<20120417154117.GE32402@google.com>
	<4F8D9FC4.3080800@parallels.com>
	<4F8E646B.1020807@jp.fujitsu.com>
Mime-Version: 1.0
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        bh=7wXexwd7954lHk3oKtwvKe8xD2jayuV0ImP0DtEvXDM=;
        b=WLm2oGc6JGd+9PEMVIlS/VrODOkFexbVwfjklrQKvP1X+U1z0tuQcDprk1Wu48MSPF
         tEVRf6e0+iBzw5hGibKkucQpBnWmJoa/pbW3yepwIOgKlNHCYSRejTo/rVxW84gzFbsw
         ZV7tMjBtQUsI/kn6kIrJfxXbAM0UFcNBN+XKoeGYfDao4PxbNMhJCHnkWw/GWpHl2ioT
         Ate+Fv3d0YlM+11qlbZO78IM4SdQoms7KkOtNa9J8jplGKXCQkLOXiKHL6R8ESP/jJ1G
         SRMAf2724XK8Mp9uDM0eySNeuD1O3B/xXF8nkt4UTvvAjuz2zB0jXXqjet7dFZMgDQ7v
         l/qA==
In-Reply-To: <4F8E646B.1020807-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Daniel Walsh <dwalsh-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Daniel P. Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>

2012/4/18 KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>:
> (2012/04/18 1:52), Glauber Costa wrote:
>
>>
>>>> In short, I don't think it's better to have task-counting and fd-c=
ounting in memcg.
>>>> It's kmem, but it's more than that, I think.
>>>> Please provide subsys like ulimit.
>>>
>>> So, you think that while kmem would be enough to prevent fork-bombs=
,
>>> it would still make sense to limit in more traditional ways
>>> (ie. ulimit style object limits). =A0Hmmm....
>>>
>>
>> I personally think this is namespaces business, not cgroups.
>> If you have a process namespace, an interface that works to limit th=
e
>> number of processes should keep working given the constraints you ar=
e
>> given.
>>
>> What doesn't make sense, is to create a *new* interface to limit
>> something that doesn't really need to be limited, just because you
>> limited a similar resource before.
>>
>
>
> Ok, limitiing forkbomb is unnecessary. ulimit+namespace should work.
> What we need is user-id namespace, isn't it ? If we have that, ulimit
> works enough fine, no overheads.

I have considered using NR_PROC rlimit on top of user namespaces to
fight forkbombs inside a container.
ie: one user namespace per container with its own rlimit.

But it doesn't work because we can have multiuser apps running in a
single container.
