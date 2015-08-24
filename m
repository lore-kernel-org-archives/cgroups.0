From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 14:19:29 -0700
Message-ID: <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
References: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org> <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org> <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=c/aWyQ/LY/v+rbowWpZ/se6UvhzmQqww4bjRB+Cm1es=;
        b=KN+X0WX23iSTK4Y01XBtJgZCugEv8pKpCP2isSRwDJz3r6h8XKFaEt5RkxokDQh+Hr
         ZRXF0umzBlLRksM9+bFO2uBb9AjdQh/4w50dt0fg4x+zFTizto/z+dsq73+yMafsqUr5
         nsTNFYP5MWNZqGH67ZAzKrSDUxOWg6Ghs0hhuP6pQLFks3XnAZwQFmT8Qtc77R64lrn7
         kvZRzzdWwaeIneQ7/QGhqaOKvmoQjW/XmZpOVpqrhKnf9CfiFy4fNy/zgxA9LihmNnL9
         72Nd1KIKNLIE2xS4AvlhhzlPASKLFPfGTIYvmlGaO5P8tzG6umorZ7TkhGRUqCVKbg9Y
         Bwvw==
In-Reply-To: <20150824211707.GJ28944-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Aug 24, 2015 at 2:17 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Mon, Aug 24, 2015 at 02:10:17PM -0700, Paul Turner wrote:
>> Suppose that we have 10 vcpu threads and 100 support threads.
>> Suppose that we want the support threads to receive up to 10% of the
>> time available to the VM as a whole on that machine.
>>
>> If I have one particular support thread that is busy, I want it to
>> receive that entire 10% (maybe a guest is pounding on scsi for
>> example, or in the thread-pool case, I've passed a single expensive
>> computation).  Conversely, suppose the guest is doing lots of
>> different things and several support threads are active, I want the
>> time to be shared between them.
>>
>> There is no way to implement this with nice.  Either a single thread
>> can consume 10%, and the group can dominate, or the group cannot
>> dominate and the single thread can be starved.
>
> Would it be possible for you to give realistic and concrete examples?
> I'm not trying to play down the use cases but concrete examples are
> usually helpful at putting things in perspective.

I don't think there's anything that's not realistic or concrete about
the example above.  The "suppose" parts were only for qualifying the
pool sizes for vcpu and non-vcpu threads above since discussion of
implementation using nice is dependent on knowing these counts.


>
> Thanks.
>
> --
> tejun
