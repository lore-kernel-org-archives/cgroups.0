From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/3] mm, memcg: add mem_cgroup_disabled checks in
 vmpressure and swap-related functions
Date: Fri, 9 Jul 2021 10:41:00 -0400
Message-ID: <YOhf/DhU3ATIrblp@cmpxchg.org>
References: <20210709000509.2618345-1-surenb@google.com>
 <20210709000509.2618345-2-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3JgiNUXxlzmxCCmJFKLX2XQrMvSQ47grP8G7croHJv8=;
        b=E+KAr3tVzEE4YSt4qtQihiuI/V1XaVI9rO+GadU0W08b/nvVmYmGZ9ZBJmNFkZ/bXl
         wgEZIJFjJELuTAVJkuZs8tufYgT0F9q2l/UPn3QL0cgzR6cBf8FpZVfLGyGEWksF5YxZ
         QeloOh2VDkyQlP07XgJcq+onfh235/pkW7Li5qF5XBfONUM3Twy0woET+2bDuWdEdCwC
         fqBC6Hrh3GtA3LcpaZA9/BI58nJ7W2aPE+mzke3dN8OYqJVxx1yAgWjeUzJVE7cALPiI
         keJuVKb3Vmd7G6dLETjobK64Rb1aMdec8GKSfLXaXtpueWgs5IqyTEARZr1Px0Q28TaC
         yjMw==
Content-Disposition: inline
In-Reply-To: <20210709000509.2618345-2-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: tj@kernel.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, songmuchun@bytedance.com, shy828301@gmail.com, alexs@kernel.org, alexander.h.duyck@linux.intel.com, richard.weiyang@gmail.com, vbabka@suse.cz, axboe@kernel.dk, iamjoonsoo.kim@lge.com, david@redhat.com, willy@infradead.org, apopple@nvidia.com, minchan@kernel.org, linmiaohe@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@android.com

On Thu, Jul 08, 2021 at 05:05:07PM -0700, Suren Baghdasaryan wrote:
> Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap and
> cgroup_throttle_swaprate functions. This minimizes the memcg overhead in
> the pagefault and exit_mmap paths when memcgs are disabled using
> cgroup_disable=memory command-line option.
> This change results in ~2.1% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n, CONFIG_MEMCG_SWAP=n} against {CONFIG_MEMCG=y,
> CONFIG_MEMCG_SWAP=y, cgroup_disable=memory} configuration on an 8-core
> ARM64 Android device.
> 
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
