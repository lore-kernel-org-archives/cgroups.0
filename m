From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4/6] psi: introduce state_mask to represent stalled psi
 states
Date: Tue, 18 Dec 2018 11:17:27 +0100
Message-ID: <20181218101727.GA15430@hirez.programming.kicks-ass.net>
References: <20181214171508.7791-1-surenb@google.com>
 <20181214171508.7791-5-surenb@google.com>
 <20181217155525.GC2218@hirez.programming.kicks-ass.net>
 <CAJuCfpHrQB7OtEC535=s4iJqwan17nAc-mbycV1aJ3RUQTWCPA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=npocvrWTM5VM1Ou07JEzt+r0Ck5x6NKw6E5HKl5iEQ4=; b=b5Kbrb2JdSoQQyVzmq+c1RngP
        6TsFwi3SpZsjXqufi7bz6U1e8Ebb4Ck5zaQ+Bq35klosTTnCC3/GzLjztkiwiVOySROu6PIgaNeRl
        +Zljrzmwp4WvwheBPlaJQpUSJRN3xB0RGuvOWMShYxSQQuPiw01nsMgxSBjQGcpnvB3xDYWQr3tb+
        kYXL01lDr0QRJsC4iC5BfVfjNPt2TvEqNqeqIo4w6daB7+u6SKJq34wOEcJeKqZlhN1zb+OtMqoZS
        EsP45cujoQ1C7cG8R+97Zp1VNiQjg/7YJtZPfRJvHbRMwIzAXATYfRbq4tiUgBnjyHBO1ePBwVk5e
      
Content-Disposition: inline
In-Reply-To: <CAJuCfpHrQB7OtEC535=s4iJqwan17nAc-mbycV1aJ3RUQTWCPA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, axboe@kernel.dk, dennis@kernel.org, Dennis Zhou <dennisszhou@gmail.com>, Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, cgroups@vger.kernel.org, linux-mm <linux-mm@kvack.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, kernel-team@android.com

On Mon, Dec 17, 2018 at 05:14:53PM -0800, Suren Baghdasaryan wrote:
> On Mon, Dec 17, 2018 at 7:55 AM Peter Zijlstra <peterz@infradead.org> wrote:
> > > +             if (state_mask & (1 << s))
> >
> > We have the BIT() macro, but I'm honestly not sure that will improve
> > things.
> 
> I was mimicking the rest of the code in psi.c that uses this kind of
> bit masking. Can change if you think that would be better.

Yeah, I really don't know.. keep it as is I suppose.
