From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 8/9] sched/psi: add kernel cmdline parameter
 psi_inner_cgroup
Date: Wed, 3 Aug 2022 07:58:27 -1000
Message-ID: <Yuq3Q6Y9dRnjjcPt@slm.duckdns.org>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-9-zhouchengming@bytedance.com>
 <Yt7KQc0nnOypB2b2@cmpxchg.org>
 <YuAqWprKd6NsWs7C@slm.duckdns.org>
 <5a3410d6-428d-9ad1-3e5a-01ca805ceeeb@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=0F2KsgjThkMHJsCvW8q0mHWxfELmkopPA/c2rKsFWiQ=;
        b=irnvtNDIhFfQ5STKu/5oLxnXV9W5JZmn1EV32OigTb/j1H7T4y30vulOjAKaAlbI5P
         Cm8ZuZ0CLfsw55nypOyeR4PB2evi7h7MSyRZlw2hdAK/MSdj19G7f7D4dwdj5BHqiD6U
         x6EU71FTrPaqJBTtm5+s7omP3SqaHD8Fpnd3cQtNbMfSN/TnOC96P4qwRn+GINwaSJB5
         1usP0fEwBYFkR34DhK/fe6Yjff1IrmHA9CfJsgmjttZGEL1V+Ka/S6h/WISxaAyhpUwN
         g7av/flBcnUgkS5cXSDC/nKHPXOaaKUPksJkwn9uYjVcMhLDXTI+ghaJNfe1Ajwb74hh
         JXHw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <5a3410d6-428d-9ad1-3e5a-01ca805ceeeb@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, surenb@google.com, mingo@redhat.com, peterz@infradead.org, corbet@lwn.net, akpm@linux-foundation.org, rdunlap@infradead.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com, cgroups@vger.kernel.org

Hello,

On Wed, Aug 03, 2022 at 08:17:22PM +0800, Chengming Zhou wrote:
> > Assuming the above isn't wrong, if we can figure out how we can re-enable
> > it, which is more difficult as the counters need to be resynchronized with
> > the current state, that'd be ideal. Then, we can just allow each cgroup to
> > enable / disable PSI reporting dynamically as they see fit.
> 
> This method is more fine-grained but more difficult like you said above.
> I think it may meet most needs to disable PSI stats in intermediate cgroups?

So, I'm not necessarily against implementing something easier but we at
least wanna get the interface right, so that if we decide to do the full
thing later we can easily expand on the existing interface. ie. let's please
not be too hacky. I don't think it'd be that difficult to implement
per-cgroup disable-only operation that we can later expand to allow
re-enabling, right?

Thanks.

-- 
tejun
