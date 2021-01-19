From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: skip propagate percpu vmstat values to
 current memcg
Date: Tue, 19 Jan 2021 11:58:42 -0500
Message-ID: <YAcPwhl//jF/WpHu@cmpxchg.org>
References: <20210119052744.96765-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZrHO+yIyrdnmaVFMwMvHwDYxfdcxIe8NtcCENOohqSk=;
        b=IjO3yV9X3nKmpNx8G+WcMwGh4WEgM94OpZUe3C4BCxS9AKRrGEhbWZO7OTjbH7Ne3x
         hBn/tqmq9p/SRMGTavW8121ebd0zIeiAp/LuvwT6FMfCYkBE04QBVr87DOd2YF1dJ5XU
         VGAQcehIYy7JkkebnKqVX9kRX0Qn0F76T8Y/cDI+QGt0gljuxp0EF85EX96ntV+03wOk
         7KbKWoG2E/FhQykR4/gb9nAj7FAsU+Ia39sjuA/EFf/99riTedyctkT0L4TZQXUZwWmk
         JAQBPrNevBWhtXC2xw3srAkrdbawiF+K0gCtNuEOPdxq0l1YTimU5KpCR879RCLBNVad
         7RkQ==
Content-Disposition: inline
In-Reply-To: <20210119052744.96765-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jan 19, 2021 at 01:27:44PM +0800, Muchun Song wrote:
> The current memcg will be freed soon, so updating it's vmstat and
> vmevent values is pointless. Just skip updating it.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Oof, that's pretty subtle! Somebody trying to refactor that code for
other purposes may not immediately notice that optimization and add
potentially tedious bugs.

How much does this save? Cgroup creation and deletion isn't really
considered a hot path. It takes global locks and such...
