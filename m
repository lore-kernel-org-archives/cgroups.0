From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 0/9] psi: pressure stall information for CPU, memory, and
 IO v4
Date: Fri, 7 Sep 2018 13:04:07 +0200
Message-ID: <20180907110407.GQ24106@hirez.programming.kicks-ass.net>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180905214303.GA30178@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Zj9m3bL7/GgZO6pd5S6/GDfgJpek/j4NHkhjpGW5ueg=; b=yzZHaAUklP+KBx3mEVEfW/ZMY
        vXFpwnbTFa85MRnCiD5xEt7/JkNQRFdeVjiDTEbgwoYWKG+4KyLCo4K2uM3rL+0tcAkeNRDioOpe8
        C5QbbmQ/iF7OyOrgqdjEKvM2ayJZKh7rX49/A1CS7//fQRCcsTP3hdmZsC86biJlwipQlWGp4hPGa
        5z+iT6cMkXuvfP7TaWJHOFK25JDinH83ZOWYgj7JqIJZdYtpYMTfdJmJjy4MXP09G626dIC7khjoR
        dNxQiBI8tCDiEqi0+BUbBj1KELBV78HL2v5Kh9O4ngzC/PCs2ZkWhOMxwSMiDvInRoWNcmqc1o4In
      
Content-Disposition: inline
In-Reply-To: <20180905214303.GA30178@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Sep 05, 2018 at 05:43:03PM -0400, Johannes Weiner wrote:
> On Tue, Aug 28, 2018 at 01:22:49PM -0400, Johannes Weiner wrote:
> > This version 4 of the PSI series incorporates feedback from Peter and
> > fixes two races in the lockless aggregator that Suren found in his
> > testing and which caused the sample calculation to sometimes underflow
> > and record bogusly large samples; details at the bottom of this email.
> 
> Peter, do the changes from v3 look sane to you?
> 
> If there aren't any further objections, I was hoping we could get this
> lined up for 4.20.

I suppose it looks ok, there's a few small nits, but nothing big.

I still hate psi_ttwu_dequeue(), but I don't really know what to about
that.

So yeah, grudingly acked. Did you want me to pick this up through the
scheduler tree since most of this lives there?
