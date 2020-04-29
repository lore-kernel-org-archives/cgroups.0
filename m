From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Wed, 29 Apr 2020 10:22:30 -0400
Message-ID: <20200429142230.GE5462@mtj.thefacebook.com>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200428214653.GD2005@dread.disaster.area>
 <20200429102540.GA12716@quack2.suse.cz>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=U7CYd6LIahwn6A9pI4DbAiS85+k2nqU8qqxir3NJPME=;
        b=PeLTcvnmSUGReSfTmkROy81aqLORMcNPoEzmktkHawEeaPG9HbIpOgkxRx5xsqTpQN
         9WOnAOZe+xH0FileYYcNrelmGXfu6azM0W+0j00Gqz4DY4IH06QvwINlT5pc+HSxL/pK
         tL9rAA6decLe+wa6vxDWO8g3zqtmubZwuiwPEoUptoWJA3+7KoA+MkgAtnVVhQJUM9DY
         wpTIQHbFB4U9kPA+rHftrWb7uGODB+OAnl59MfqEMDVGQdAPHEeoDvi1SxtdIuuy/avM
         iKMnjfgO8zhSUvKYO2UoRaNkEWLAgHOzWvKrcLOGJ2S3I72q5M8zGXeI3EwZ/vf7SFyv
         ke6A==
Content-Disposition: inline
In-Reply-To: <20200429102540.GA12716@quack2.suse.cz>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack@suse.cz>
Cc: Dave Chinner <david@fromorbit.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Amir Goldstein <amir73il@gmail.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea

Hello,

On Wed, Apr 29, 2020 at 12:25:40PM +0200, Jan Kara wrote:
> Yeah, I was thinking about the same when reading the patch series
> description. We already have some cgroup workarounds for btrfs kthreads if
> I remember correctly, we have cgroup handling for flush workers, now we are
> adding cgroup handling for loopback device workers, and soon I'd expect
> someone comes with a need for DM/MD worker processes and IMHO it's getting
> out of hands because the complexity spreads through the kernel with every
> subsystem comming with slightly different solution to the problem and also
> the number of kthreads gets multiplied by the number of cgroups. So I
> agree some generic solution how to approach IO throttling of kthreads /
> workers would be desirable.
> 
> OTOH I don't have a great idea how the generic infrastructure should look
> like...

I don't really see a way around that. The only generic solution would be
letting all IOs through as root and handle everything through backcharging,
which we already can do as backcharging is already in use to handle metadata
updates which can't be controlled directly. However, doing that for all IOs
would make the control quality a lot worse as all control would be based on
first incurring deficit and then try to punish the issuer after the fact.

The infrastructure work done to make IO control work for btrfs is generic
and the changes needed on btrfs side was pretty small. Most of the work was
identifying non-regular IO pathways (bouncing through different kthreads and
whatnot) and making sure they're annotating IO ownership and the needed
mechanism correctly. The biggest challenge probably is ensuring that the
filesystem doesn't add ordering dependency between separate data IOs, which
is a nice property to have with or without cgroup support.

That leaves the nesting drivers, loop and md/dm. Given that they sit in the
middle of IO stack and proxy a lot of its roles, they'll have to be updated
to be transparent in terms of cgroup ownership if IO control is gonna work
through them. Maybe we can have a common infra shared between loop, dm and
md but they aren't many and may also be sufficiently different. idk

Thanks.

-- 
tejun
