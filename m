From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v8 0/7] freezer for cgroup v2
Date: Fri, 22 Feb 2019 10:17:40 -0800
Message-ID: <20190222181740.GZ50184@devbig004.ftw2.facebook.com>
References: <20190219220252.4906-1-guro@fb.com>
 <20190220143748.GA9477@redhat.com>
 <20190220220020.GA16335@castle.DHCP.thefacebook.com>
 <20190221162923.GA26064@redhat.com>
 <20190221173422.GY50184@devbig004.ftw2.facebook.com>
 <20190222163441.GA5596@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0bawKPdSciLwxYkj5tT0CcwjFzFD912EtDh0Rtp/xl0=;
        b=UUIgJ9YCbjXdf5DGn47xL/rjuyMZs7+Z8zc/LuZDzDKENNi95g3fuW7QPG8JOJyyga
         D65YjVCHZRrD36AzY13M4HPg8nKmaW5e2CPnXU3IPK14ACiMw4irkqoL0+AUgMMK5H5w
         +K/qzCE3dzl0kNlm9trrgVWusOuf3yiSD+QexEthHcF+tz/tvEFrCY4mE00nRql/YQaE
         5Z/mdn5M/QRpfv6AMOut0G22KGtmb9/T4C1NGcvsOuhFA8vVmCqCFZ/sRJnsIPcf2KIS
         0ocbx997oHZ/C99HtIkcDywlGg2CWHZ84z3awRuOLjGK1PQHL875nmBAMeP3nmcorP1/
         HTkA==
Content-Disposition: inline
In-Reply-To: <20190222163441.GA5596@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roman Gushchin <guro@fb.com>, Roman Gushchin <guroan@gmail.com>, Kernel Team <Kernel-team@fb.com>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hey, Oleg.

On Fri, Feb 22, 2019 at 05:34:42PM +0100, Oleg Nesterov wrote:
> > ptrace support is a lot less important than kill for sure but if at
> > all possible I think it'd be better to have it
> 
> Tejun, I agree it would be better. I did not argue with that.
> 
> The question is how this can be implemented. And how much uglifications^W
> complications in the core kernel code this needs.

Yeah, sure thing.  It's always a trade-off but given that this is
something we're gonna expose to userspace as an API which will be
difficult to change too noticeably once released, I think it'd be
worthwhile to spend some effort to get the visible semantics right.

> > To summarize, the ideal result is the frozen state to be "stuck in
> > jobctl stop loop"
> 
> Not sure I understand, but I don't think this can work...
> 
> Let me repeat, imo the freezer should be "reliable", it shouldn't stuck
> in CGRP_FREEZE state forever if, say, it races with vfork(). And personally
> I think this is more important than (very limited) ptrace support.

Absolutely, it makes no sense to ship it otherwise.  I don't think
anyone is saying that we can ship it while it doesn't work reliably.

> So I think it too should somehow interact with freezable_schedule/etc.

You mean freezer_do_not_count(), right?  As long as the task is
guaranteed to be trapped by signal stop afterwards (and they are), we
likely can use them the same way.  The only thing to be careful about
would be ensuring that we don't end up flipping group level frozen
state inbetween.  Would something like that work?

Thanks.

-- 
tejun
