From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv3 1/3] rdmacg: Added rdma cgroup controller.
Date: Fri, 12 Feb 2016 11:45:21 -0500
Message-ID: <20160212164521.GH3741@mtj.duckdns.org>
References: <20160130183015.GP32380@htj.duckdns.org>
 <CAG53R5XrnYY1AVBnu1b6BVfWwiUgyq+EsXay=CianRXnsUDviQ@mail.gmail.com>
 <20160131100237.GS32380@htj.duckdns.org>
 <CAG53R5WOLA_=gD9qVnsVk_oPs0iyacL3M+1qD+RAbrnciVXEOA@mail.gmail.com>
 <20160131110420.GV32380@htj.duckdns.org>
 <CAG53R5XXaW-fhb9megcp+Xnv05bSuonDws2fE-D6Wk3JNqS2Aw@mail.gmail.com>
 <20160201184046.GD14091@mtj.duckdns.org>
 <CAG53R5U=ojbn5tQoq=xR0DUb3Tm6yw+oO6mXVAQ2cUOhbvCdKQ@mail.gmail.com>
 <56BB6502.8040507@mellanox.com>
 <CAG53R5WC17nLL2qjtB-_RZR+45qBDmJ2=12UtHxuKtvWhfN5XA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zRoDnTz9BRKHgbOusN2h7bGpJ06K4bRi3Z2mKGd1Yaw=;
        b=C4xLuwGR+84gkyn6Z4FCfyEZUCkK/oxR37p/6qLlKDrJfjB/AsK5BoXXx+3wfx3HeH
         xUj3sqHkl+zKBBsdOlwcJs7ZQIqmL1CjRPNplzGlKbdW4OgKBgo6xVthvqV2/IXqQ5UJ
         av7MkB4F1+oWAkHR711RFu2V5aYSt80bcA7jMf0pYA0ELnwoCqvUNCKy8kYMkDRwba8a
         nnHKjxsDy79aeA/UCplDYGMxYJOI4YtkpBzgPpywwsjWxxKpgZgSvDJ/sksUCm3RAPTd
         MWZ+YJdXeMulGtoKVEwDA4bPit1wzAH2S7+2LscqYGSkwYNMg7jPbSteFZqZW01bbhxy
         INWw==
Content-Disposition: inline
In-Reply-To: <CAG53R5WC17nLL2qjtB-_RZR+45qBDmJ2=12UtHxuKtvWhfN5XA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: Haggai Eran <haggaie@mellanox.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Hello, Parav.

On Fri, Feb 12, 2016 at 02:49:38AM +0530, Parav Pandit wrote:
> 1. Removed two type of resource pool, made is single type (as you
> described in past comment)
> 2. Removed match tokens and have array definition like "qp", "mr", "cq" etc.
> 3. Wrote small parser and avoided match_token API as that won't work
> due to different array definition
> 4. Removed one-off remove API to unconfigure cgroup, instead all
> resource should be set to max.
> 5. Removed resource pool type (user/default), instead having max_num_cnt,
> when ref_cnt drops to zero and max_num_cnt = total_rescource_cnt, pool is freed.
> 6. Resource definition ownership is now only with IB stack at single
> header file, no longer in each low level driver.
> This goes through IB maintainer and other reviewers eyes.
> This continue to give flexibility to not force kernel upgrade for few
> enums additions for new resource type.
> 7. Wherever possible pool lock is pushed out, except for hierarchical
> charging/unchanging points, as it not possible to do so, due to
> iterative process involves blocking allocations of rpool. Coming up
> more levels up to release locks doesn't make any sense either.
> This is anyway slow path where rpool is not allocated. Except for
> typical first resource allocation, this is less traveled path.
> 8.Other minor cleanups.
> 9. Avoided %d manipulation due to removal of match_token and replaced
> with seq_putc etc friend functions.

Sounds great.  Can't tell too much without looking at the code tho.

Thanks.

-- 
tejun
