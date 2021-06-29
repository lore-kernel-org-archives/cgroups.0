From: Dan Schatzberg <schatzberg.dan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 3/3] loop: Charge i/o to mem and blk cg
Date: Tue, 29 Jun 2021 10:03:33 -0400
Message-ID: <YNsoNeQNMmdplmtp@dschatzberg-fedora-PC0Y6AEN>
References: <20210610173944.1203706-1-schatzberg.dan@gmail.com>
 <20210610173944.1203706-4-schatzberg.dan@gmail.com>
 <YNXvr81YFzbaTxCb@blackbook>
 <YNnZ7hIRIk9dJDry@dschatzberg-fedora-PC0Y6AEN>
 <YNr1TYfBwR/tEpEJ@blackbook>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=epo3zKiTfhS1s7uCWxNYZiOm+vo3zbXKhTVM1Kqzmbg=;
        b=BvAsn6V+lEebL9543XNZN8ZgjQb+osEKHPTuXHALEL19Dqb6/zJ1xRDLLweEL6wFZe
         nCCZ9qgxxMvqfBg0PIRP27jmbc8ViBnRr2O1g5R9fD2B8DKZbSkVH6hdzgMoPIUWzHeV
         u9B76ZOBRd9zRYeaOAP24ARezCGz/5LgXUOcEzlvE1OffxKOhgMBdA+uNkK66LNl3be2
         4qSEXMtzyF67GlNoC0wg7jZ+nuozmqOqplCuU3fIEYFxurWmsax7mrIOp7Vt3dLHEqxZ
         NEM5Qmqlf4GdsA+ghm9u58I4sopLY1RF+S0SNXXwMWYDVwaevKsyyuATbPEouicRln0n
         JZow==
Content-Disposition: inline
In-Reply-To: <YNr1TYfBwR/tEpEJ@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:MEMORY MANAGEMENT" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

> Non-inlining in the loop module doesn't seem like a big trouble. OTOH,
> other callers may be more sensitive and would need to rely on inlining.

Yes, this is my concern as well.

> I can't currently think of a nice way to have both the exported and the
> exlicitly inlined variant at once. It seems it's either API or perf
> craft in the end but both are uncertain, so I guess the current approach
> is fine in the end.
> 
> > Yes it is intentional. All requests (not just aio) go through the loop
> > worker which grabs the blkcg reference in loop_queue_work() on
> > construction. So I believe grabbing a reference per request is
> > unnecessary.
> 
> Isn't there a window without the reference between loop_queue_rq and
> loop_queue_work?

Hmm, perhaps I'm not understanding how the reference counting works,
but my understanding is that we enter loop_queue_rq with presumably
some code earlier holding a reference to the blkcg, we only need to
acquire a reference sometime before returning from loop_queue_rq. The
"window" between loop_queue_rq and loop_queue_work is all
straight-line code so there's no possibility for the earlier code to
get control back and drop the reference.

> I don't know, you seem to know better, so I'd suggest
> dropping a comment line into the code explaining this.

I wouldn't be so sure that I know any better here :D - I'm fairly
inexperienced in this domain.

Where would you suggest putting such a comment? The change in question
removed a particular case where we explicitly grab a reference to the
blkcg because now we do it uniformly in one place. Would you like a
comment explaining why we acquire a reference for all loop workers or
one explaining specifically why we don't need to acquire one for aio?
