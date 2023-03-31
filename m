From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC PATCH 1/7] cgroup: rstat: only disable interrupts for the
 percpu lock
Date: Thu, 30 Mar 2023 15:51:35 -1000
Message-ID: <ZCY8p/i6DR2tXPLP@slm.duckdns.org>
References: <ZB5UalkjGngcBDEJ@slm.duckdns.org>
 <CAJD7tkYhyMkD8SFf8b8L1W9QUrLOdw-HJ2NUbENjw5dgFnH3Aw@mail.gmail.com>
 <CALvZod6rF0D21hcV7xnqD+oRkn=x5NLi5GOkPpyaPa859uDH+Q@mail.gmail.com>
 <CAJD7tkY_ESpMYMw72bsATpp6tPphv8qS6VbfEUjpKZW6vUqQSQ@mail.gmail.com>
 <CALvZod41ecuCKmuFBNtAjoKJjQgWYzoe4_B8zRK37HYk-rYDkA@mail.gmail.com>
 <CAJD7tkZrp=4zWvjE9_010TAG1T_crCbf9P64UzJABspgcrGPKg@mail.gmail.com>
 <ZCSJDpPPOVvBYfOy@slm.duckdns.org>
 <f9b6410-ee17-635f-a35d-559fa0191dc3@google.com>
 <ZCSY8l/jVwszF6iA@slm.duckdns.org>
 <98cb3ce-7ed9-3d17-9015-ef7193d6627@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680227498; x=1682819498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6XM31ZrRumkictGFOXR0ExRhhRTlkDKTwiG7dCR1Fgc=;
        b=JBYKiS094xTcv4zZS7qtqmMLeJJI3CBby4kLAUuMziXHD4GQX8kl0rVXktvDBOeoyg
         kE039cqtRpT4ykTduffb4U40BvtNgW7zV0FAZz2WV0BqlSt5QYJpN8xupFHalEgYBWe2
         Mcsh414OYAuBY4FJEwUvve3aBfy2EszbwJEObj//xKUmnHYc/UwK6WW03t6iLjufAyn2
         ssTRNhrXIek059u92KiSZc+dkINIxwv0V3n+b0U3qPZgOYecnTJr8KDPd568UBe+Om+Y
         JRzenMRK0Ov48J93rRexsFGKtXgwJ4lg877M0D9vxz9Zn9cUrB6aoYizchAGUP6OU+k8
         mySQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <98cb3ce-7ed9-3d17-9015-ef7193d6627-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Hugh.

On Wed, Mar 29, 2023 at 01:38:48PM -0700, Hugh Dickins wrote:
> > So, in general, there's a trade off between local irq service latency and
> > inducing global lock contention when using unprotected locks. With more and
> > more CPUs, the balance keeps shifting. The balance still very much depends
> > on the specifics of a given lock but yeah I think it's something we need to
> > be a lot more careful about now.
> 
> And this looks a very plausible argument to me: I'll let it sink in.

Another somewhat relevant change is that flipping irq on/off used to be
relatively expensive on older x86 cpus. I forget all details about when and
how much but they should be a lot cheaper now. No idea about !x86 cpus tho.

> But I hadn't heard that the RT folks were clamouring for more irq disabling:
> perhaps they partition their machines with more care, and are not devotees
> of high CPU counts.

I think RT folks care a lot more about raw IRQ disables. These shouldn't
actually disable IRQs on RT kernels.

Thanks.

-- 
tejun
