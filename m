From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 14/19] mm: Introduce a cgroup for pinned memory
Date: Mon, 6 Feb 2023 12:36:25 -1000
Message-ID: <Y+GA6Y7SVhAW5Xm9@slm.duckdns.org>
References: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
 <c7b5e502d1a3b9b8f6e96cbf9ca553b143c327e0.1675669136.git-series.apopple@nvidia.com>
 <Y+Fttp1ozejoSQzl@slm.duckdns.org>
 <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EXMYbgDcLP+C7eZB1xaeoXCjWryL7Y0FGjQjkRAiPu4=;
        b=U3uz6QlenYSTx7+7wwZviiGVhFRBlwg5tFwn64kb40PHnHGQnn/KtLilsb4KmtJFEM
         1F7WGWkCvOoZrZe6y57NVcbBRfCN1uRku07igB1HQl+GMBr1mewsK7it+dFTVC/9zTTb
         cVlZ/OBVzAUc0bPSunWog7ZMHamtfvzHk/w+emTTdMFV3hw5cyfja3jrmLyMgUK8yikM
         0dPQ0t72FMRAN02L3kCZvh0eAulsoHbV5zNGX6aYEAW/7PfOZ2ZO9ihdMgNAtUSAbjk+
         dV4BZM7g6zv7iYyFX9x5Ku14OsRm5or1ENmCm3E4RYcNlo1dO1fvlFbmY+2NejXznhOk
         +ymg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <CAJD7tkb_Cr7rTTpKc1VBpS8h=n3Hu+nGiV8dkLH-NdC1bSG9mg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, jgg@nvidia.com, jhubbard@nvidia.com, tjmercier@google.com, hannes@cmpxchg.org, surenb@google.com, mkoutny@suse.com, daniel@ffwll.ch, "Daniel P . Berrange" <berrange@redhat.com>, Alex Williamson <alex.williamson@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>

On Mon, Feb 06, 2023 at 02:32:10PM -0800, Yosry Ahmed wrote:
> I guess it boils down to which we want:
> (a) Limit the amount of memory processes in a cgroup can be pinned/locked.
> (b) Limit the amount of memory charged to a cgroup that can be pinned/locked.
> 
> The proposal is doing (a), I suppose if this was part of memcg it
> would be (b), right?
> 
> I am not saying it should be one or the other, I am just making sure
> my understanding is clear.

I don't quite understand what the distinction would mean in practice. It's
just odd to put locked memory in a separate controller from interface POV.

Thanks.

-- 
tejun
