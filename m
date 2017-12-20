From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Wed, 20 Dec 2017 15:36:58 -0800
Message-ID: <20171220233658.GB1084507@devbig577.frc2.facebook.com>
References: <20171219124908.GS2787@dhcp22.suse.cz>
 <CALvZod5jU9vPoJaf44TVT0_HQpEESiELJU5MD_DDRbcOkPNQbg@mail.gmail.com>
 <20171219152444.GP3919388@devbig577.frc2.facebook.com>
 <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com>
 <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
 <20171219214107.GR3919388@devbig577.frc2.facebook.com>
 <CALvZod5XRhXc3XrQw50Jw_OpRQB2iCCbgG-NMDCa8xRmGNdLrw@mail.gmail.com>
 <20171220193741.GD3413940@devbig577.frc2.facebook.com>
 <CALvZod7Z1Yh+ZhU8qxzSiN0Pph2R7O4Mki5E23FbJFAzhyCH8g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g7QxeTES23zDtJDLKdncM3g9N2JE2Z9+d/LRD3xEYEU=;
        b=TIqbGkTHc4WvhB10AT/g3qxNvpzT4dzJQEQtn09UMOwGnrWjZBjNVmnm1G1kqMbFud
         d6CljQzR9DZXfwyYOboggwH3swQKDqw9cobvi/O+B60y1gPtKipZIzh6+SB0tmua0LI7
         wJVcd7N9YGjhHgS0ITuDr4ApJc7wdZBf6TVIwx4hTiN8mSJMWI4tqvbejGCA5a6YW8uI
         nAssxZQrRx7KVj2W2J6rX7cwRjkqCSWS7rz/6FIJvCtH5WBzWQl5xwp9Jw44WsqZkeSm
         Y1X4uiNDW4V0U6PAc9RCRqI175orbgGt8g4GFHpeZ/BnpX6z0zp3uDYQLrrvBTou9tN+
         Wwww==
Content-Disposition: inline
In-Reply-To: <CALvZod7Z1Yh+ZhU8qxzSiN0Pph2R7O4Mki5E23FbJFAzhyCH8g@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

Hello, Shakeel.

On Wed, Dec 20, 2017 at 12:15:46PM -0800, Shakeel Butt wrote:
> > I don't understand how this invariant is useful across different
> > backing swap devices and availability.  e.g. Our OOM decisions are
> > currently not great in that the kernel can easily thrash for a very
> > long time without making actual progresses.  If you combine that with
> > widely varying types and availability of swaps,
> 
> The kernel never swaps out on hitting memsw limit. So, the varying
> types and availability of swaps becomes invariant to the memcg OOM
> behavior of the job.

The kernel doesn't swap because of memsw because that wouldn't change
the memsw number; however, that has nothing to do with whether the
underlying swap device affects OOM behavior or not.  That invariant
can't prevent memcg decisions from being affected by the performance
of the underlying swap device.  How could it possibly achieve that?

The only reason memsw was designed the way it was designed was to
avoid lower swap limit meaning more memory consumption.  It is true
that swap and memory consumptions are interlinked; however, so are
memory and io, and we can't solve these issues by interlinking
separate resources in a single resource knob and that's why they're
separate in cgroup2.

> > Sure, but what does memswap achieve?
> 
> 1. memswap provides consistent memcg OOM killer and memcg memory
> reclaim behavior independent to swap.
> 2. With memswap, the job owners do not have to think or worry about swaps.

To me, you sound massively confused on what memsw can do.  It could be
that I'm just not understanding what you're saying.  So, let's try
this one more time.  Can you please give one concrete example of memsw
achieving critical capabilities that aren't possible without it?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
