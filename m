From: Mike Galbraith <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 27 Oct 2015 06:56:42 +0100
Message-ID: <1445925402.2909.86.camel@gmail.com>
References: <20150912144007.GA8942@htj.duckdns.org>
	 <CAPM31RLAtuaDbE9+nvMvgMB8zaOpxVcriCyE9qqszNM3XXTo5Q@mail.gmail.com>
	 <20151001184629.GB26498@mtj.duckdns.org>
	 <CAPM31RKx0vT-9VFN=XASYM4iv4U5ZGZW93XRtJd_7mOHwu76NA@mail.gmail.com>
	 <20151023222110.GA4390@mtj.duckdns.org>
	 <1445661367.3218.62.camel@gmail.com>
	 <20151025021829.GA15471@mtj.duckdns.org>
	 <1445744613.3180.60.camel@gmail.com>
	 <20151027031656.GA11962@mtj.duckdns.org>
	 <1445924531.2909.79.camel@gmail.com>
	 <20151027054634.GA16310@mtj.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=1rwJWmbnYRHQrWFMQFOLzhPjtfKcD24D8qPRNKShbPk=;
        b=kp7rbJIUnv3esUF/4AngzQmDXMrQtm80tYuR6uJliQj+4Gzk5OZ5n0gfTRr15/W4oK
         aaPs4tsEMUEuYaDb0oyePJyrdT65OkgkSBgjGlbGKqXxnfDTWjoFTf38f7H/IL6Mf/m9
         uF2Dk+xHd2/IQDQH+ZtCBPixK5VprXNrTxE9cCGYUebIAqgdj3N31LYW7YuJkIEtPssf
         TOh+wVodvbz9fjhPBEDweVaaM8dJ0GoObp/44sjfKWD4mGT7dlMMdD4/hqXYOg1Wkiem
         3NoG4zTVMfk0TIjDhsa2etX3HEtQJJsQhrtG+NSCeGtYt7/YGAs8Pm+82HcdBpGkwDQD
         3e9w==
In-Reply-To: <20151027054634.GA16310@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>

On Tue, 2015-10-27 at 14:46 +0900, Tejun Heo wrote:
> Hello,
> 
> On Tue, Oct 27, 2015 at 06:42:11AM +0100, Mike Galbraith wrote:
> > Sure, sounds fine, I just fervently hope that the below is foul swamp
> > gas having nothing what so ever to do with your definition of "saner".
> 
> lol, idk, you keep taking things in weird directions.  Let's just stay
> technical, okay?
> 
> > http://www.linuxfoundation.org/news-media/blogs/browse/2013/08/all-about-linux-kernel-cgroup%E2%80%99s-redesign
> > 
> > http://www.freedesktop.org/wiki/Software/systemd/ControlGroupInterface/
> > 
> > I'm not into begging.  I really don't want to have to ask anyone to
> > pretty please do for me what I can currently do all by my little self
> > without having to give a rats ass less whether what I want to do fits in
> > the world view of this or that obnoxious little control freak.
> 
> Well, if you think certain things are being missed, please speak up.
> Not in some media campaign way but with technical reasoning and
> justifications.

Inserting a middle-man is extremely unlikely to improve performance.

	-Mike
