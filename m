From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC PATCH 02/27] containers: Implement containers as kernel
 objects
Date: Tue, 19 Feb 2019 18:20:20 -0800
Message-ID: <1550629220.11684.3.camel@HansenPartnership.com>
References: <1550432358.2809.21.camel@HansenPartnership.com>
         <155024683432.21651.14153938339749694146.stgit@warthog.procyon.org.uk>
         <155024685321.21651.1504201877881622756.stgit@warthog.procyon.org.uk>
         <19562.1550617574@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1550629221;
        bh=Sv05kO616trax6QX+MKM8GQoT95dBmrnAy9m8tcgS+U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Hx/2U7zh6bPP50kPafInPt5h8xpRnWpTE6DK1PBZw4PWDDrBwQMwyUajynAGYxcPd
         KxEkrdu1tD2aCxGQTLl5dxmVgEuC21bt3yFrqUir4ZIl6XB9G3miFn/zIFccie3Gox
         TX7lmNgsPT0d1ornz8fKEze4OEViFT4q5xX4Y0UA=
In-Reply-To: <19562.1550617574@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, trond.myklebust@hammerspace.com, sfrench@samba.org, linux-security-module@vger.kernel.org, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-fsdevel@vger.kernel.org, rgb@redhat.com, linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org, cgroups@vger.kernel.org

On Tue, 2019-02-19 at 23:06 +0000, David Howells wrote:
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > I thought we got agreement years ago that containers don't exist in
> > Linux as a single entity: they're currently a collection of cgroups
> > and namespaces some of which may and some of which may not be local
> > to the entity the orchestration system thinks of as a "container".
> 
> I wasn't party to that agreement and don't feel particularly bound by
> it.

That's not at all relevant, is it?  The point is we have widespread
uses of namespaces and cgroups that span containers today meaning that
a "container id" becomes a problematic concept.  What we finally got to
with the audit people was an unmodifiable label which the orchestration
system can set ... can't you just use that?

James

