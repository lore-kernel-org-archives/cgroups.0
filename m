From: Tejun Heo <tj@kernel.org>
Subject: Re: Race condition between "read CFQ stats" and "block device
 shutdown"
Date: Thu, 26 Sep 2013 09:54:43 -0400
Message-ID: <20130926135443.GC2480@htj.dyndns.org>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
 <5226D661.7070301@suse.de>
 <CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
 <20130904160723.GC26609@mtj.dyndns.org>
 <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-scsi-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=/WynM0R9Q8Sb0JunGp6d7BzzagwDVbk+OTJQuEfaocg=;
        b=ge427A/3KGzsgkcyB+BEfTUC3QtAoBYeJQ/rqx0KsDFTLOucIwwOWKagZaWJPedcw6
         P0xbXJdYkArOKRxeUG5DRBNUECo2TUU+VnbCWiSJlJPXOJwrtwfOeClbFNiKPsvQam71
         EuTR2JM96DEmu+kaPe/NCOJy29WHQ8i6q6chUbr33UdP721yfLc380mZo0g1ZrgBfuoH
         a4BkCMfBsCX4VD50CLsxx3Bs5IRA+ow9YQ5eeBO3Q2WTzqXVkscA0V+SrKFSi8Kr/FI+
         A4Oe40YggThcOf7SmDdHq1cMMgUOMXUx7e6+5yE1a/HS3CnJTAMLryZdNlojftD3SS+W
         zDew==
Content-Disposition: inline
In-Reply-To: <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Anatol Pomozov <anatol.pomozov@gmail.com>
Cc: Hannes Reinecke <hare@suse.de>, Cgroups <cgroups@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

Hello, (cc'ing linux-scsi)

On Wed, Sep 25, 2013 at 01:37:51PM -0700, Anatol Pomozov wrote:
> Hi
> 
> On Wed, Sep 4, 2013 at 9:07 AM, Tejun Heo <tj@kernel.org> wrote:
> > Hello,
> >
> > On Wed, Sep 04, 2013 at 08:45:33AM -0700, Anatol Pomozov wrote:
> >> I am not an expect in block code, so I have a few questions here:
> >>
> >> - are we sure that this operation is atomic? What if blkg->q becomes
> >> dead right after we checked it, and blkg->q->queue_lock got invalid so
> >> we have the same crash as before?
> >
> > request_queue lock switching is something inherently broken in block
> > layer.  It's unsalvageable.
> 
> Fully agree. The problem that request_queue->queue_lock is a shared
> resource that concurrently modified/accessed. In this case (when one
> thread changes, another thread access it) we need synchronization to
> prevent race conditions. So we need a spin_lock to access queue_lock
> spin_lock, otherwise we have a crash like one above...
> 
> >  Maybe we can drop lock switching once blk-mq is fully merged.
> 
> Could you please provide more information about it? What is the timeline?

I have no idea.  Hopefully, not too far out.  Jens would have better
idea.

> If there is an easy way to fix the race condition I would like to
> help. Please give me some pointer what direction I should move.

The first step would be identifying who are actually making use of
lock switching, why and how much difference it would make for them to
not do that.

> PS Just a little bit of context why I care about this bug. We test a
> large farm that actively uses iscsi. We are going to have a lot of
> iscsi device startup/shutdown. I am testing whether this codepath has
> race conditions and I found one above.

Thanks.

-- 
tejun
