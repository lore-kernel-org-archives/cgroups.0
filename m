From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 5/5] psi: introduce psi monitor
Date: Wed, 16 Jan 2019 14:24:46 +0100
Message-ID: <20190116132446.GF10803@hirez.programming.kicks-ass.net>
References: <20190110220718.261134-1-surenb@google.com>
 <20190110220718.261134-6-surenb@google.com>
 <20190114102137.GB14054@worktop.programming.kicks-ass.net>
 <CAJuCfpGUWs0E9oPUjPTNm=WhPJcE_DBjZCtCiaVu5WXabKRW6A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZhArKsuY/tKhYOpp7E5c4gvQHpi9b44Cpojgm9W2al4=; b=G2kfkJGQ6exaAg21qUWzW8RFv
        FQ9l92BqSsJceUcSKG4R1VM3c0MyYQN/3rHjb8KoLZjvjogEHb+B8sA1izOLaN0JrUSkC4gv9bOyX
        icZDBTwptY2OyEIWsWVlPwCX5Xroc0vphIyCUqPorrD0YdZFixmMfvbefX4A0l6Wjcwtw7gMDbvxB
        mmD3c6C2zLiXtrfR3iH4SBwwQLUtTlWjVdsVoh18NIgjrYPkQoyDrSeyuGsVBIVXutUt3+nA8OU3O
        94EbKtLSMupZBFbaw1PpR1tkRk8/kriLcBrvzQj9xIpF5wfI2Mssy5gSGWOMXY19zGqNFGOKnnmvO
    
Content-Disposition: inline
In-Reply-To: <CAJuCfpGUWs0E9oPUjPTNm=WhPJcE_DBjZCtCiaVu5WXabKRW6A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Mon, Jan 14, 2019 at 11:30:12AM -0800, Suren Baghdasaryan wrote:
> For memory ordering (which Johannes also pointed out) the critical point is:
> 
> times[cpu] += delta           | if g->polling:
> smp_wmb()                     |   g->polling = polling = 0
> cmpxchg(g->polling, 0, 1)     |   smp_rmb()
>                               |   delta = times[*] (through goto SLOWPATH)
> 
> So that hotpath writes to times[] then g->polling and slowpath reads
> g->polling then times[]. cmpxchg() implies a full barrier, so we can
> drop smp_wmb(). Something like this:
> 
> times[cpu] += delta           | if g->polling:
> cmpxchg(g->polling, 0, 1)     |   g->polling = polling = 0
>                               |   smp_rmb()
>                               |   delta = times[*] (through goto SLOWPATH)
> 
> Would that address your concern about ordering?

cmpxchg() implies smp_mb() before and after, so the smp_wmb() on the
left column is superfluous.

The right hand column is actively wrong; because that reads like it
wants to order a store (g->polling = 0) and a load (d = times[]), and
therefore requires smp_mb().

Also, you probably want to use atomic_t for g->polling, because we
(sadly) have architectures where regular stores and atomic ops don't
work 'right'.
