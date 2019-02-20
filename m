From: Ian Kent <raven@themaw.net>
Subject: Re: [RFC PATCH 02/27] containers: Implement containers as kernel
 objects
Date: Wed, 20 Feb 2019 12:42:42 +0800
Message-ID: <e41d7a4e072ac33774090b6a5aff6d3a45445a36.camel@themaw.net>
References: <1550432358.2809.21.camel@HansenPartnership.com>
         <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
         <155024685321.21651.1504201877881622756.stgit@warthog.procyon.org.uk>
         <19562.1550617574@warthog.procyon.org.uk>
         <1550629220.11684.3.camel@HansenPartnership.com>
         <054c1e762d28306abd4db9c42fb1c5f4261332fd.camel@themaw.net>
         <1550634367.11684.6.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        +5dvOBycnYMWuGZj6lOtHEPlsD1MLuFNwkZZ2UZcDGw=; b=fJWHCeDOWJrB9d4b
        iQS6dWvTeNrvNVeL2v0xBmihJLVqJsZsrhvLo6XN6PMo8Evb3im/zikl/E7Zg1rb
        VQYToPokZnDk5DQn1frkaSDk/ReS5QUeWlWYnGXVSsQ/OGx7haV2wpKPRtZRnWtW
        C1nYsGtyRScX+Mzlcp1ybQJlsSZqF7DFap5p/L8VEDDXcx99tqSmeXVD1wjbbQ5C
        vG1Zi8kWwmTgxcTGimK0wMXv017MuiChymz/rOKkrh1jYHPR1ieQSMPkBfbspwxK
        xXWl4w5wOAG7SH/hv+yVL1ZNrwgXVFuPseiC5z51BPXjYxS0UajMpfqIf4PaBcJG
        C89uDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=+5dvOBycnYMWuGZj6lOtHEPlsD1MLuFNwkZZ2UZcD
        Gw=; b=bbW61jV/iwi5m//ywRL+OjAd3wt+EUip16xooYsM1fmdfSedUn+4UUKut
        GD2h9YQynC7mPbmqfsYLG9/wecn5bfNzc5ma4tpesWe7V3d/vKBPlHdQLXI+xDrZ
        xURlUj2XrfKr/QbZQ+pojzfiNAgWroNjTfDneK4lYwv0GWXaq0/lo8VCA+rIoh54
        /FZ+f5Hxq1Utgq0dFLVy3LxBXhXYvQPdXTVm7oQ5KcN2Ic0+SNux8ltXpfG6RqG2
        MxUdzz1JvKHhr90swWKm1MYWsuqt8Qx/3HvlA0s2XVercy2/jskJ6a1/4jlDd6qQ
        LLs0F36dWNrwWCf0EijHflZmJ0vKw==
In-Reply-To: <1550634367.11684.6.camel@HansenPartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: James Bottomley <James.Bottomley@HansenPartnership.com>, David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, sfrench@samba.org, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, rgb@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Tue, 2019-02-19 at 19:46 -0800, James Bottomley wrote:
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

David might want to use the audit label for this, I don't know.
And maybe that's a good choice initially.

But going way off topic.

Because there is a need to not clutter kernel space with logging,
leaving it to user space to handle but also without providing user
space with sufficient information to do so there will need to be
some sort of globally unique (sub-system) identifiers of kernel
objects for which user space needs logging information so that
if or when that kernel to user space information flow is
implemented the consistent identifiers that will be needed will
at least exist for some kernel objects.

Yes, that's way off topic for this series but I think it's something
that needs at least some consideration for new implementation work.

Unfortunately properly implementing such an encoding scheme probably
warrants a completely separate project so, as you say moot wrt. this
series.

> 
> James
> 
> 
> > Isn't the only problem here the current restrictions on the way
> > objects need to be combined as a set and the ability to be able add
> > or subtract from that set.
> > 
> > Then again the notion of active vs. inactive might not be sufficient
> > to allow for the needed flexibility ...
> > 
> > Ian
> > 
> 
> 

