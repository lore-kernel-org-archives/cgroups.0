From: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified hierarchy
Date: Mon, 24 Aug 2015 14:15:37 -0700
Message-ID: <CAPM31RK-y0AUpS0ELnmg3yTz2HoS0OqS6vr-gxEA6oB12sU58A@mail.gmail.com>
References: <CAPM31RJTf0v=2v90kN6-HM9xUGab_k++upO0Ym=irmfO9+BbFw@mail.gmail.com>
 <CAPM31R+5=4bGQo++PrYoFuS86_7JqhhQ0OtPvCYooAzJsvhb=w@mail.gmail.com>
 <20150818203117.GC15739@mtj.duckdns.org> <CAPM31RJNy3jgG=DYe6GO=wyL4BPPxwUm1f2S6YXacQmo7viFZA@mail.gmail.com>
 <20150822182916.GE20768@mtj.duckdns.org> <55DB3C76.5010009@gmail.com>
 <20150824170427.GA27262@mtj.duckdns.org> <55DB77F1.5080802@gmail.com>
 <20150824202509.GF28944@mtj.duckdns.org> <CAPM31R+ckFO5vNG4L5+h-yokFaZQz6kHe5a+pkRCfbL0H+NjXg@mail.gmail.com>
 <20150824211238.GI28944@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=TNz7s6oqH6+E6TcP4/1ocx1bGBHeATwkspWx90gRZis=;
        b=Yrmsx6z/fYbjRZJ1QhBU/alyssfv1RJGmdkfCk7W6yIDzJf3y8PuvV4rOlRrx6YuPg
         btZ6dGI7ppyElZRYNw/RGxdUDj8C/0MlId8zBm5yyZbiL2aKPf2hI8Qfh1OaCxeo6F3y
         WFa9jus/e6iirfWOwP8PTyhcRkklO99+VX8JIe8N7iXVsxU2Q6aLCxav4+iDCQaVE1Oz
         GkJSI6awNio63DGGQALbp9ADR9aQpGN3ONVl0efm4nq/wIh0SlnsVNLddHeVi7LpAU9R
         y4rbK1/fKXX3YAOCUt+G37/jcEzFfqJGVaGZfmaVYoYdMV+hoSiNLwb/ShgKYGKp1CZS
         AfKg==
In-Reply-To: <20150824211238.GI28944-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-team <kernel-team-b10kYP2dOMg@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Mon, Aug 24, 2015 at 2:12 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Paul.
>
> On Mon, Aug 24, 2015 at 02:00:54PM -0700, Paul Turner wrote:
>> > Hmmm... I'm trying to understand the usecases where having hierarchy
>> > inside a process are actually required so that we don't end up doing
>> > something complex unnecessarily.  So far, it looks like an easy
>> > alternative for qemu would be teaching it to manage priorities of its
>> > threads given that the threads are mostly static - vcpus going up and
>> > down are explicit operations which can trigger priority adjustments if
>> > necessary, which is unlikely to begin with.
>>
>> What you're proposing is both unnecessarily complex and imprecise.
>> Arbitrating competition between groups of threads is exactly why we
>> support sub-hierarchies within cpu.
>
> Sure, and to make that behave half-way acceptable, we'll have to take
> on significant amount of effort and likely complexity and I'm trying
> to see whether the usecases are actually justifiable.  I get that
> priority based solution will be less precise and more complex on the
> application side but by how much and does the added precision enough
> to justify the extra facilities to support that?  If it is, sure,
> let's get to it but it'd be great if the concrete prolem cases are
> properly identified and understood.  I'll continue on the other reply.
>

No problem, I think the conversation is absolutely
constructive/important to have and am happy to help drill down.

> Thanks.
>
> --
> tejun
