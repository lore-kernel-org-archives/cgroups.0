From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Thu, 23 Feb 2023 08:15:17 -1000
Message-ID: <Y/etNfwxHv8XO3iC@slm.duckdns.org>
References: <Y/UfS8TDIXhUlJ/I@slm.duckdns.org>
 <Y/UiQmuVwh2eqrfA@nvidia.com>
 <87o7pmnd0p.fsf@nvidia.com>
 <Y/YRJNwwvqp7nKKt@nvidia.com>
 <87k009nvnr.fsf@nvidia.com>
 <Y/bHNO7A8T3QQ5T+@nvidia.com>
 <CABdmKX18MY19bnsxN5W38Z9zmoaZx+S4+zzN_5XCYDBruwPrLg@mail.gmail.com>
 <Y/eiLBo88pgr2IUm@nvidia.com>
 <CAJD7tkadBRP22qP63-SjKSch1im9sHLoMzc6c2h10+ggbuxqMg@mail.gmail.com>
 <Y/esMBOyTaJnv5CW@nvidia.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8d7vX3E+ECjlUByBWqhgNH3zgRhrlRHARhFD6gKgnHo=;
        b=YsUR1lwIJ38Ov5JOW2ShHLFcBQ/c0Vk2KqH2W0Jbc/vG+sGRZc6BBQOQvLelLNYW9p
         HlXLF2BaPoW97W+6oRtYzKixKIWsdLn1O4atcHCtUkFSZkrW/ywq4NrVSiYjzr5O0oSP
         yeLzDepp1Ce0bM0ax7IUdduGgc7iSL9s+A/Wqr7H45ViOiAKPZqB5YQRXPcfcH4wVMb1
         1LtR3S9wkcNzbCNjHi3fGXtM673CohikPkEs62vny/l91HxSYv96VsXIXV8EIzcXpjj6
         SrJU6gdUPUwmLQbG9k3TwoZ9mF0ghAK2EUTzLiuT2Uao4ILwH/F9Ca4ud03lzsZVNJdr
         Rtng==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <Y/esMBOyTaJnv5CW@nvidia.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, "T.J. Mercier" <tjmercier@google.com>, Alistair Popple <apopple@nvidia.com>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jhubbard@nvidia.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Thu, Feb 23, 2023 at 02:10:56PM -0400, Jason Gunthorpe wrote:
> > I am not familiar with memfd, but based on
> > mem_cgroup_swapin_charge_folio() it seems like if cgroup B swapped in
> > the pages they will remain charged to cgroup A, unless cgroup A is
> > removed/offlined. Am I missing something?
> 
> Ah, I don't know, Tejun said:
> 
> "but it can converge when page usage transfers across cgroups
> if needed."
> 
> Which I assumed was swap related but I don't know how convergence
> works.

That'd work for pagecache. For swap-backed, I think Yosry is right. Is
MAP_SHARED | MAP_ANONYMOUS a concern? Such mappings can only be shared
through forking, so it's not a common thing to be shared across different
resource domains.

Thanks.

-- 
tejun
