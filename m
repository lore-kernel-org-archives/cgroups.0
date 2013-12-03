From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup management daemon
Date: Tue, 3 Dec 2013 08:54:03 -0500
Message-ID: <20131203135403.GI8277@htj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
 <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=iYtJonXHv/Lf+x6cfMI4Gq1jpMw4CZ3ldCVWQo3f9/w=;
        b=rv9NWPQGqAqRJ7D5a07jU1pO1HZ8HLZNM1CxT9xakb4D6SU9lan95aN2dXlq7/3PIj
         Hh3mdpxnRr7hL5LGqzCdiM2Re/g1jlHXHZopL+4gSymxh+T98YH6Df5jNi76hd2vhyVL
         3Tdy8kjmBj+GA3ZuAiob7ocGczFydYm401gMFe4o2FFzl2MFYuS8TIz68P8SFtBWcInp
         1Kp9sULihOPo9idomnpJlDWWpB5YwPF1XSMg2UpUIJtVWJtlWtt77z+31INdhvG1Jzl2
         MZNoO5xfY5FIwOmcLhVjQYO7nLcjfTS5cFDms6z3dw2CXOlOdz4XB4rnm9hXdTp4QCFT
         noJQ==
Content-Disposition: inline
In-Reply-To: <CAO_RewZGWARUafKzDc_t3G5OedGtEPTZgB2VYeHHiKSSrja8fA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>

Hello, Tim.

On Mon, Nov 25, 2013 at 08:58:09PM -0800, Tim Hockin wrote:
> Thanks for this!  I think it helps a lot to discuss now, rather than
> over nearly-done code.
> 
> On Mon, Nov 25, 2013 at 2:43 PM, Serge E. Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org> wrote:
> > Additionally, Tejun has specified that we do not want users to be
> > too closely tied to the cgroupfs implementation.  Therefore
> > commands will be just a hair more general than specifying cgroupfs
> > filenames and values.  I may go so far as to avoid specifying
> > specific controllers, as AFAIK there should be no redundancy in
> > features.  On the other hand, I don't want to get too general.
> > So I'm basing the API loosely on the lmctfy command line API.
> 
> I'm torn here.  While I agree in principle with Tejun, I am concerned
> that this agent will always lag new kernel features or that the thin
> abstraction you want to provide here does not easily accommodate some
> of the more ... oddball features of one cgroup interface or another.

Yeah, that's the trade-off but cgroupfs is a kernel API.  It shouldn't
change or grow rapidly once things settle down.  As long as there's
not too crazy way to step-aside when such rare case arises, I think
pros outweight cons.

> This agent is the very bottom of the stack, and should probably not do
> much by way of abstraction.  I think I'd rather let something like
> lmctfy provide the abstraction more holistically, and relegate this
> agent to very simple plumbing and policy.  It could be as simple as
> providing read/write/etc ops to specific control files.  It needs to
> handle event_fd, too, I guess.  This has the nice side-effect of
> always being "current" on kernel features :)

The level of abstraction is definitely something debatable.  Please
note that the existing event_fd based mechanism won't grow any new
users (BTW, event_control is one of the dos vectors if you give write
access to it) and all new notifications will be using inotify.

Thanks.

-- 
tejun
