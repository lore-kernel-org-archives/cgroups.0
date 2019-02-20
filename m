From: Paul Moore <paul@paul-moore.com>
Subject: Re: [RFC PATCH 02/27] containers: Implement containers as kernel objects
Date: Wed, 20 Feb 2019 01:57:34 -0500
Message-ID: <CAHC9VhQga+bSVEyKbAtfxDsV9RqK5Hv6h-cbs4ArQ3KedxvgpQ@mail.gmail.com>
References: <1550432358.2809.21.camel@HansenPartnership.com>
 <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
 <155024685321.21651.1504201877881622756.stgit@warthog.procyon.org.uk>
 <19562.1550617574@warthog.procyon.org.uk> <1550629220.11684.3.camel@HansenPartnership.com>
 <054c1e762d28306abd4db9c42fb1c5f4261332fd.camel@themaw.net> <1550634367.11684.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ncoDYnqxH3gs9Sc4jdqZc699sEVY31p6X34ojqSqzzM=;
        b=OcCZh083AzJ6sYc48woP23gRRbpaNKLC68TAdlArP77RO3+mrjVrj/iw4ZpWg3rNV3
         29swcTzY/zTMAOqxs45u579zp81oWJDiOwSJh6tom9D/tAOgnuzVSLlkcuqb8zkvn041
         kOisgtVcvn0D2ldK2m99xkgmKknYygp1QYdTxOKnNijCZ/APmJ7hGFeM3e3VsCDdMErt
         wx0sR0iBJ+9HphZXJkooMsrO2GYHiQuoD7D0L5Nb1CAmiVGw+uEgE5SHW+LeT4H60qrm
         snbkENIP97Ktg8O/dDr3jUbp95t4Oa9ezjlJLisfHr/j4+wT/VqcxY16IMT2kuOtYSUn
         LRcw==
In-Reply-To: <1550634367.11684.6.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, sfrench@samba.org, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, rgb@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Tue, Feb 19, 2019 at 10:46 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2019-02-20 at 11:04 +0800, Ian Kent wrote:
> > On Tue, 2019-02-19 at 18:20 -0800, James Bottomley wrote:
> > > On Tue, 2019-02-19 at 23:06 +0000, David Howells wrote:
> > > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > >
> > > > > I thought we got agreement years ago that containers don't
> > > > > exist in Linux as a single entity: they're currently a
> > > > > collection of cgroups and namespaces some of which may and some
> > > > > of which may not be local to the entity the orchestration
> > > > > system thinks of as a "container".
> > > >
> > > > I wasn't party to that agreement and don't feel particularly
> > > > bound by it.
> > >
> > > That's not at all relevant, is it?  The point is we have widespread
> > > uses of namespaces and cgroups that span containers today meaning
> > > that a "container id" becomes a problematic concept.  What we
> > > finally got to with the audit people was an unmodifiable label
> > > which the orchestration system can set ... can't you just use that?
> >
> > Sorry James, I fail to see how assigning an id to a collection of
> > objects constitutes a problem or how that could restrict the way a
> > container is used.
>
> Rather than rehash the whole argument again, what's the reason you
> can't use the audit label?  It seems to do what you want in a way that
> doesn't cause problems.  If you can just use it there's little point
> arguing over what is effectively a moot issue.

Ignoring for a moment whether or not the audit container ID is
applicable here, one of the things I've been focused on with the audit
container ID work is trying to make it difficult for other subsystems
to use it.  I've taken this stance not because I don't think something
like a container ID would be useful outside the audit subsystem, but
rather because I'm afraid of how it might be abused by other
subsystems and that abuse might threaten the existence of the audit
container ID.

If there is a willingness to implement a general kernel container ID
that behaves similarly to how the audit container ID is envisioned,
I'd much rather do that then implement something which is audit
specific.

-- 
paul moore
www.paul-moore.com
