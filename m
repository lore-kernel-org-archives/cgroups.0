From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: skip propagate percpu vmstat values to
 current memcg
Date: Wed, 20 Jan 2021 08:49:56 +0100
Message-ID: <20210120074956.GB9371@dhcp22.suse.cz>
References: <20210119052744.96765-1-songmuchun@bytedance.com>
 <YAcPwhl//jF/WpHu@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1611128997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QeFIPCKf1lzYZ5NNZ/UyihM0FPQ4ig48O6bHj3KSVc0=;
        b=pjKh/cmX3L7lWbEKaS4FMhCZzGKLMOMKo9InQl9tWIyGjOGZkXfH3nRZUV7+XPf5Fka8W1
        7ADICESjNintsIualGfn3VWpnmRIbn34rk7Jd14bymn6XA42bxGdXyDDCwgjLrm0qKf4pG
        8jKoVVesER20mZI+dx71Qxm8MDXlZ4U=
Content-Disposition: inline
In-Reply-To: <YAcPwhl//jF/WpHu-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 19-01-21 11:58:42, Johannes Weiner wrote:
> On Tue, Jan 19, 2021 at 01:27:44PM +0800, Muchun Song wrote:
> > The current memcg will be freed soon, so updating it's vmstat and
> > vmevent values is pointless. Just skip updating it.
> > 
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
> 
> Oof, that's pretty subtle! Somebody trying to refactor that code for
> other purposes may not immediately notice that optimization and add
> potentially tedious bugs.

Absolutely agreed!

> How much does this save? Cgroup creation and deletion isn't really
> considered a hot path. It takes global locks and such...

This is not the first time when an (micro)optimization is posted without
any data showing benefit or otherwise appealing justification. Sigh.

-- 
Michal Hocko
SUSE Labs
