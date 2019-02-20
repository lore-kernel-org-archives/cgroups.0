From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH 02/27] containers: Implement containers as kernel
 objects
Date: Tue, 19 Feb 2019 19:46:07 -0800
Message-ID: <1550634367.11684.6.camel@HansenPartnership.com>
References: <1550432358.2809.21.camel@HansenPartnership.com>
         <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
         <155024685321.21651.1504201877881622756.stgit@warthog.procyon.org.uk>
         <19562.1550617574@warthog.procyon.org.uk>
         <1550629220.11684.3.camel@HansenPartnership.com>
         <054c1e762d28306abd4db9c42fb1c5f4261332fd.camel@themaw.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1550634368;
        bh=cEDK3lEfHrreJCccK0Dd5gVCu+Tr4jNJS5ay2Gnb2kc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pP6wgthcj49eY6pQeV91ziLwO/JyuKUsONGF8G2Y9nYvAUKFnAEevgESRJLLQMgjK
         utXe4l1xPNv5z2eqt5Yd/T2FHmI85T+VA71NliIvmQ6XbzfPLm+Z2q/Vwc7e3fWUta
         ECcVLpE/Bi/iovfDOaIsL0J1XCLE4oMYRH5BcoK0=
In-Reply-To: <054c1e762d28306abd4db9c42fb1c5f4261332fd.camel@themaw.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Ian Kent <raven@themaw.net>, David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, sfrench@samba.org, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, rgb@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Wed, 2019-02-20 at 11:04 +0800, Ian Kent wrote:
> On Tue, 2019-02-19 at 18:20 -0800, James Bottomley wrote:
> > On Tue, 2019-02-19 at 23:06 +0000, David Howells wrote:
> > > James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> > > 
> > > > I thought we got agreement years ago that containers don't
> > > > exist in Linux as a single entity: they're currently a
> > > > collection of cgroups and namespaces some of which may and some
> > > > of which may not be local to the entity the orchestration
> > > > system thinks of as a "container".
> > > 
> > > I wasn't party to that agreement and don't feel particularly
> > > bound by it.
> > 
> > That's not at all relevant, is it?  The point is we have widespread
> > uses of namespaces and cgroups that span containers today meaning
> > that a "container id" becomes a problematic concept.  What we
> > finally got to with the audit people was an unmodifiable label
> > which the orchestration system can set ... can't you just use that?
> 
> Sorry James, I fail to see how assigning an id to a collection of
> objects constitutes a problem or how that could restrict the way a
> container is used.

Rather than rehash the whole argument again, what's the reason you
can't use the audit label?  It seems to do what you want in a way that
doesn't cause problems.  If you can just use it there's little point
arguing over what is effectively a moot issue.

James


> Isn't the only problem here the current restrictions on the way
> objects need to be combined as a set and the ability to be able add
> or subtract from that set.
> 
> Then again the notion of active vs. inactive might not be sufficient
> to allow for the needed flexibility ...
> 
> Ian
> 

