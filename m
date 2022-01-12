From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH v3 1/1] psi: Fix uaf issue when psi trigger is destroyed
 while being polled
Date: Wed, 12 Jan 2022 18:16:17 +0000
Message-ID: <Yd8a8TdThrGHsf2o@casper.infradead.org>
References: <20220111232309.1786347-1-surenb@google.com>
 <Yd7oPlxCpnzNmFzc@cmpxchg.org>
 <CAJuCfpGHLXDvMU1GLMcgK_K72_ErPhbcFh1ZvEeHg025yinNuw@mail.gmail.com>
 <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bJY3C+X7zHwgbbceCQDqbl+wqxvIGfAy5Ps2Lrhqv8U=; b=Vr7TaC/2N3GIKrsxqJRI2k0Rvb
        xAJPJVpk8rxPdllApzyyVjzOpJF3+OYTb/teUsQLRWFGhv2U4cVV5o3oSak2raGXEj/1klVGrZxME
        LjGuMqxaP3EwxIjlWByP+vFii+vXvQidw/dTgrY+3jQ6ILt26vmnzdaoZoVLtXqAcU+SmiUtKSpoF
        dwW4SRlqx5N7fDCLar7VRGHDXOnxV+8PzhCoxHmDA/qjR1jkbmoeXpYX7KxQJzE3SUjSqFW4JlDqB
        WSbwc28U8Dk+68oG6SAU0h3AghEJxz7TLoKY2wDj3XN9WZRcxwzbbJ4/xg6mLy+UCmXRwLFpfiYRU
        2QJyusZw==;
Content-Disposition: inline
In-Reply-To: <CAJuCfpEaM3KoPy3MUG7HW2yzcT6oJ5gdceyHPNpHrqTErq27eQ@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Linus Torvalds <torvalds@linux-foundation.org>, Eric Biggers <ebiggers@kernel.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Benjamin Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Daniel Bristot de Oliveira <bristot@redhat.com>, Jonathan Corbet <corbet@lwn.net>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, cgroups mailinglist <cgroups@vger.kernel.org>, stable <stable@vger.kernel.org>, kernel-t

On Wed, Jan 12, 2022 at 09:49:00AM -0800, Suren Baghdasaryan wrote:
> > This happens with the following config:
> >
> > CONFIG_CGROUPS=n
> > CONFIG_PSI=y
> >
> > With cgroups disabled these functions are defined as non-static but
> > are not defined in the header
> > (https://elixir.bootlin.com/linux/latest/source/include/linux/psi.h#L28)
> > since the only external user cgroup.c is disabled. The cleanest way to
> > fix these I think is by doing smth like this in psi.c:

A cleaner way to solve these is simply:

#ifndef CONFIG_CGROUPS
static struct psi_trigger *psi_trigger_create(...);
...
#endif

I tested this works:

$ cat foo5.c
static int psi(void *);

int psi(void *x)
{
	return (int)(long)x;
}

int bar(void *x)
{
	return psi(x);
}
$ gcc -W -Wall -O2 -c -o foo5.o foo5.c
$ readelf -s foo5.o

Symbol table '.symtab' contains 4 entries:
   Num:    Value          Size Type    Bind   Vis      Ndx Name
     0: 0000000000000000     0 NOTYPE  LOCAL  DEFAULT  UND
     1: 0000000000000000     0 FILE    LOCAL  DEFAULT  ABS foo5.c
     2: 0000000000000000     0 SECTION LOCAL  DEFAULT    1 .text
     3: 0000000000000000     3 FUNC    GLOBAL DEFAULT    1 bar

