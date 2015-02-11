From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Making memcg track ownership per address_space or anon_vma
Date: Wed, 11 Feb 2015 15:33:59 -0500
Message-ID: <20150211203359.GF21356@htj.duckdns.org>
References: <xr93zj8ti6ca.fsf@gthelen.mtv.corp.google.com>
 <20150205131514.GD25736@htj.dyndns.org>
 <xr93siekt3p3.fsf@gthelen.mtv.corp.google.com>
 <20150205222522.GA10580@htj.dyndns.org>
 <xr93pp9nucrt.fsf@gthelen.mtv.corp.google.com>
 <20150206141746.GB10580@htj.dyndns.org>
 <CAHH2K0bxvc34u1PugVQsSfxXhmN8qU6KRpiCWwOVBa6BPqMDOg@mail.gmail.com>
 <20150207143839.GA9926@htj.dyndns.org>
 <20150211021906.GA21356@htj.duckdns.org>
 <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=Sadr7cIwd9D4EJUM75Na2fDtUZys3CNhciQiQu74SBw=;
        b=DKuRRtslrFfRXgxTE6ewo5TTxZsx2lFqftmCXin7D27p2f2hS0UzJcYl71MrxOVda8
         vAVpovD1zVv0y73/FqN1cD2SB90PGhJM2AkKweY9dO9R/6M09/weRX9je+aKW9TWKO6Y
         cDstnSvFDUTJRJ5FW/GZrJMJ9u+tSpsWbxOxi76cY8nTgInLruxnl38pKZthmjl3OJVb
         mPHo4Sp+LRwgb2KPp0s5lir1uTh17fNYQUVyzF1r3yX9Spy6aRoekSwWYJuemG7ELG2t
         qrmyEdK5e3JCXX68TcDK0/YiOps7rlzopvkl4nOZqk1sI9N227leFcPyKKTCAHAHNOGJ
         3i7Q==
Content-Disposition: inline
In-Reply-To: <CAHH2K0aHM=jmzbgkSCdFX0NxWbHBcVXqi3EAr0MS-gE3Txk93w@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Greg Thelen <gthelen@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>

Hello, Greg.

On Wed, Feb 11, 2015 at 10:28:44AM -0800, Greg Thelen wrote:
> This seems good.  I assume that blkcg writeback would query
> corresponding memcg for dirty page count to determine if over
> background limit.  And balance_dirty_pages() would query memcg's dirty

Yeah, available memory to the matching memcg and the number of dirty
pages in it.  It's gonna work the same way as the global case just
scoped to the cgroup.

> page count to throttle based on blkcg's bandwidth.  Note: memcg
> doesn't yet have dirty page counts, but several of us have made
> attempts at adding the counters.  And it shouldn't be hard to get them
> merged.

Can you please post those?

So, cool, we're in agreement.  Working on it.  It shouldn't take too
long, hopefully.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
