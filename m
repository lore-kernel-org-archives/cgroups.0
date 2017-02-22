From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: provide shmem statistics
Date: Wed, 22 Feb 2017 07:45:01 -0500
Message-ID: <20170222124501.GA9184@cmpxchg.org>
References: <20170221164343.32252-1-hannes@cmpxchg.org>
 <20170222081230.GC5753@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+q60ywkpSL9+/ayyUn8FvUZ7MkCLHZFlqR5eAU4//Rk=; b=DJuYaOQY5gg5C1CnIwnpRngU/A
        dTyxTovK839CjX2CiHKws7+yU93HO70YmwFgb9msEdvSuPk8nhSp+b/wExByrOg+EdIluCgTq+Hj3
        T4jP3JsvMlniKV0buyac6aegDiKiBhCWN3O5rv3YMxGEfc7eDhqcP12pv7jmPJYdTIFE=;
Content-Disposition: inline
In-Reply-To: <20170222081230.GC5753-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Chris Down <cdown-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Wed, Feb 22, 2017 at 09:12:31AM +0100, Michal Hocko wrote:
> On Tue 21-02-17 11:43:43, Johannes Weiner wrote:
> > Cgroups currently don't report how much shmem they use, which can be
> > useful data to have, in particular since shmem is included in the
> > cache/file item while being reclaimed like anonymous memory.
> > 
> > Add a counter to track shmem pages during charging and uncharging.
> 
> Yes this is indeed useful. Accounting shmem to the page cache was a
> mistake because this is more than confusing. Sad we cannot fix that.

Agreed, this continues to cause confusion with many Linux users :(

> I would have just one concern with this patch. You are relying on
> PageSwapBacked check but it looks like we are going to implement
> MADV_FREE by dropping this flag. I know we do not support MADV_FREE
> on shared mappings but if we ever do then the accounting will become
> subtly broken. Can/Should we rely on shmem_mapping() check instead?

Yes, right now we do MADV_FREE only on private pages, so this patch is
safe with Shaohua's changes to how we use PG_swapbacked.

Should we support MADV_FREE on shared mappings in the future, using
shmem_mapping() for memcg accounting won't work unfortunately, because
shared pages are truncated from the page cache before uncharging, and
that clears the page->mapping pointer. However, in that case we could
probably unaccount the pages from shmem at the time of MADV_FREE, when
we clear the PG_swapbacked bit.

> Other than that the patch looks good to me.

Thanks!
