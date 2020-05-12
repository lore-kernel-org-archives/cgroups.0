From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v5 0/4] Charge loop device i/o to issuing cgroup
Date: Tue, 12 May 2020 06:35:45 -0700
Message-ID: <20200512133545.GA26535@infradead.org>
References: <20200428161355.6377-1-schatzberg.dan@gmail.com>
 <20200512132521.GA28700@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rMH+9QgUtTVvwUjMFs5R0kAMnSoYcqtdBp9bIG81UY8=; b=DStgMniB6mmhqq2+TCJtvFKba6
        8jzL11QfzrdLwH+aW4ipFz6eHpZGYLeuVvZ4ip+kknFX4C0X/jT7C2ds7mbsAjc757W7RAFhts7lc
        QlLgzrXlQ7CU1I1upcvPe0frQgORmA8tTcgf90GgFA3YUjrs9uKTTA51saW0Qsx1h8DalMS/Z1E32
        l4WCjcj2kG86ripIglQm59Qot22JT45WiImx35jxW3awum6slfEPJLzonIvewi5DIuqfZKCpOg/p/
        PXHgn/VFY2Fk4xqpO/LIgAB9p0I5DDpYwctAIeZ8T5KD6Jy/EiQ4ZHOHULBT6mkxchECcZ13o7K01
        +Jr8CRRw==;
Content-Disposition: inline
In-Reply-To: <20200512132521.GA28700@dschatzberg-fedora-PC0Y6AEN.dhcp.thefacebook.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Yang Shi <yang.shi@linux.alibaba.com>, Ingo Molnar <mingo@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>, Andrea Arcangeli <aarcange@redhat.com>, Thomas

On Tue, May 12, 2020 at 09:25:21AM -0400, Dan Schatzberg wrote:
> Seems like discussion on this patch series has died down. There's been
> a concern raised that we could generalize infrastructure across loop,
> md, etc. This may be possible, in the future, but it isn't clear to me
> how this would look like. I'm inclined to fix the existing issue with
> loop devices now (this is a problem we hit at FB) and address
> consolidation with other cases if and when those are addressed.
> 
> Jens, you've expressed interest in seeing this series go through the
> block tree so I'm interested in your perspective here. Barring any
> concrete implementation bugs, would you be okay merging this version?

Independ of any higher level issues you need to sort out the spinlock
mess I pointed out.
