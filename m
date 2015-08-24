From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Mon, 24 Aug 2015 18:49:36 -0400
Message-ID: <20150824224936.GO28944@mtj.duckdns.org>
References: <20150822182916.GE20768@mtj.duckdns.org>
 <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
 <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=4nDaBqM3NwNB3bss609BUay62IxNpd669+oJnx3kQGM=;
        b=KS72yU3j8n2W8U+WmJPTf2h84vIwEXXaSKmnJ1eR3cRZa4TfzrrWZkwGGlkKEzaQan
         ensEls7J59UGMThY67pTryWn/PH9ZShJa7zvOgoZL8U632sxNKMNJL8Cg/pxFMoTlmvw
         /ZR29J4hbhzTmT3R44NfzIcigP+mNhRQJUg0UU/vFl+Rj98w4udmiFBxc2jsSWe5BGJW
         zeoVV5F8wh8EcMqwBdiHEs+hqcxq/LJ8ullyOAtKqY0HDhJ9s9LKlLkJUMBdmEinMw2s
         7zCDEssxCKXfC6ISx9UXoPvrvh6otD/xWLAgszBYOphzBTdcuTrRgVRYPMDr1ePz7DDr
         rhIw==
Content-Disposition: inline
In-Reply-To: <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Mon, Aug 24, 2015 at 03:03:05PM -0700, Paul Turner wrote:
> > Hmm... I was hoping for an actual configurations and usage scenarios.
> > Preferably something people can set up and play with.
> 
> This is much easier to set up and play with synthetically.  Just
> create the 10 threads and 100 threads above then experiment with
> configurations designed at guaranteeing the set of 100 threads
> relatively uniform throughput regardless of how many are active.   I
> don't think trying to run a VM stack adds anything except complexity
> of reproduction here.

Well, but that loses most of details and why such use cases matter to
begin with.  We can imagine up stuff to induce arbitrary set of
requirements.

> > I take that the
> > CPU intensive helper threads are usually IO workers?  Is the scenario
> > where the VM is set up with a lot of IO devices and different ones may
> > consume large amount of CPU cycles at any given point?
> 
> Yes, generally speaking there are a few major classes of IO (flash,
> disk, network) that a guest may invoke.  Each of these backends is
> separate and chooses its own threading.

Hmmm... if that's the case, would limiting iops on those IO devices
(or classes of them) work?  qemu already implements IO limit mechanism
after all.

Anyways, a point here is that threads of the same process competing
isn't a new problem.  There are many ways to make those threads play
nice as the application itself often has to be involved anyway,
especially for something like qemu which is heavily involved in
provisioning resources.

cgroups can be a nice brute-force add-on which lets sysadmins do wild
things but it's inherently hacky and incomplete for coordinating
threads.  For example, what is it gonna do if qemu cloned vcpus and IO
helpers dynamically off of the same parent thread?  It requires
application's cooperation anyway but at the same time is painful to
actually interact from those applications.

Thanks.

-- 
tejun
