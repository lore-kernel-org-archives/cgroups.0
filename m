From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Race condition between "read CFQ stats" and "block device shutdown"
Date: Wed, 25 Sep 2013 13:37:51 -0700
Message-ID: <CAOMFOmWWfxCZ7ND_Vso4UkSEOqGm=o-xsqrfrj5MKdf9_jr1gA@mail.gmail.com>
References: <CAOMFOmXJ5ZTYdOvdUt-oxsouhPGRmMshCRhn6AFgmFAGZw5WZA@mail.gmail.com>
	<5226D661.7070301@suse.de>
	<CAOMFOmUCqXN1uaqBEWH3PStuZXvnvLw=YrARgv7DvqO6Y4bFPQ@mail.gmail.com>
	<20130904160723.GC26609@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=7cB8t1jVv8Xo/kD17FBGoglrHUJLTdxQ1XpFALTlzdQ=;
        b=l53qGIiH2SJS74Qd/X5wwogtDV/uFB7pKwHtcE+8t/scA2ap98rfr0qmaRGlrj0cMj
         HUmGZd4CAMzjBPRuua2MTNjSvfLXpWublVSBvzAYkYfvndKdSwZRLzYN8nhzdVvNu5Np
         EHGyX9aqhBJQSG062fwmqPQ4Ms9gFgy+sO3bS00rydu/KcCDHjOjcRQzu9N/zJq9m/y2
         i58BxZf1oPu4qNoXX5Lxnw9OFGZMFxSQUSIlM3aigsr/RX5i3vzPw4Lf7iaqq/YPHgMb
         0PFHovrL+ONQehd8aTvyNYONiNNn8fzzkuZAPoqlr/t08qLf0yjJnvN52nSfk5BNzAAX
         YYkg==
In-Reply-To: <20130904160723.GC26609-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hi

On Wed, Sep 4, 2013 at 9:07 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Sep 04, 2013 at 08:45:33AM -0700, Anatol Pomozov wrote:
>> I am not an expect in block code, so I have a few questions here:
>>
>> - are we sure that this operation is atomic? What if blkg->q becomes
>> dead right after we checked it, and blkg->q->queue_lock got invalid so
>> we have the same crash as before?
>
> request_queue lock switching is something inherently broken in block
> layer.  It's unsalvageable.

Fully agree. The problem that request_queue->queue_lock is a shared
resource that concurrently modified/accessed. In this case (when one
thread changes, another thread access it) we need synchronization to
prevent race conditions. So we need a spin_lock to access queue_lock
spin_lock, otherwise we have a crash like one above...

>  Maybe we can drop lock switching once blk-mq is fully merged.

Could you please provide more information about it? What is the timeline?

If there is an easy way to fix the race condition I would like to
help. Please give me some pointer what direction I should move.

PS Just a little bit of context why I care about this bug. We test a
large farm that actively uses iscsi. We are going to have a lot of
iscsi device startup/shutdown. I am testing whether this codepath has
race conditions and I found one above.
