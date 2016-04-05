From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHv10 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 5 Apr 2016 10:07:04 -0400
Message-ID: <20160405140704.GC7822@mtj.duckdns.org>
References: <1458850962-16057-1-git-send-email-pandit.parav@gmail.com>
 <1458850962-16057-2-git-send-email-pandit.parav@gmail.com>
 <20160404193640.GA7822@mtj.duckdns.org>
 <CAG53R5UgDeFxqvOOJb=r1DH2yFmboQZPM=-_atGrOCvK=XYU=A@mail.gmail.com>
 <20160405012504.GG24661@htj.duckdns.org>
 <CAG53R5Xs9nB_g7pDu6G260EY+iu6hi=fs6eV1ggyk=NwO32oRg@mail.gmail.com>
 <20160405140107.GB7822@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1MfIIHt8ps+5L1PSaH4gSu63OHZ6lFesoSsAs7vVC+U=;
        b=b56sluV20EZNYw7DBmYNNxFM82BLHK+/d5lNSkcUXlBXecidTTk+0DALZ7YE1O/qIy
         YZclZCandlz6D3Q+IlRKrdssniye+1LDQYcpILlMLxz8F3rDjxecvTwe8uLx/z80Mnu+
         4rJ+MX6rHLnQLYDKu/B311sg/XkbekmXNaH8j+Nc7a8eMZp5P11fWP7z1GtOhA4Jz868
         4SM5Kf23Qr2DIJAtNITcr6zzfLhCvETqovysntG9wN1tlvKe6WAPJJLEfAhafqn2ULYm
         zCmF0u1LxTQ13GtYk9Kb4IN4eQxxEuW3mcgCMoe/eh7NaYRTW4CqOkMrnYGydUr5OjT0
         SUGw==
Content-Disposition: inline
In-Reply-To: <20160405140107.GB7822@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Parav Pandit <pandit.parav@gmail.com>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, lizefan@huawei.com, Johannes Weiner <hannes@cmpxchg.org>, Doug Ledford <dledford@redhat.com>, Liran Liss <liranl@mellanox.com>, "Hefty, Sean" <sean.hefty@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Haggai Eran <haggaie@mellanox.com>, Jonathan Corbet <corbet@lwn.net>, james.l.morris@oracle.com, serge@hallyn.com, Or Gerlitz <ogerlitz@mellanox.com>, Matan Barak <matanb@mellanox.com>, akpm@linux-foundation.org, linux-security-module@vger.kernel.org

Just one more thing.

On Tue, Apr 05, 2016 at 10:01:07AM -0400, Tejun Heo wrote:
...
> > pool_info in spin lock context, made me allocate memory to get all
> > values upfront through allocation.
> > Now that the lock is going away, I can do what you have described above.

So, this might be okay depending on the use case but it often becomes
painful to require sleeping context for freeing resources.  If you're
certain that requiring sleeping context is okay for all paths, using a
single mutex is fine but *usually* it isn't a great idea.

Thanks.

-- 
tejun
