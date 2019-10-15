From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Tue, 15 Oct 2019 11:24:17 -0400
Message-ID: <20191015152417.GA141964@cmpxchg.org>
References: <157112699975.7360.1062614888388489788.stgit@buzz>
 <20191015135348.GA139269@cmpxchg.org>
 <89171a94-8b6f-e949-0078-10fa8fd26dfc@yandex-team.ru>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=aermn/Dt4ttLuAv+N2gyIczaxg1Onw7W29ecU8QQsuU=;
        b=Bq+rgeAkSV5v5wBQys2jjm4AZ0pYPa9/XbKBRpPOlBLfNDsDFE7Dkh3DWGe5g3gYls
         zokIj7GljcQdnKbVJYMiZaAgA6lYP1V007kxefUS5Z05OPBHVY3QjDFfkCz+ZM5xOtu8
         wZJwkm+DfQFAhfxaeYMaVMjY+5+ktdnUTtgoso6V8kcvdkmwLIVvazOVBh8rZU3eGh9t
         ciq6ne/xZOvY6PRQN2KQURHwfAr+9mnyxTCn1TNChxdpraybhn9Ecd9kueZeDRQ50fSp
         jgJ9IA47gzBVwjrnrK2s5e5Fhi13NdWivrn/Rt/tEWPlxR8UVm+zjL/dMtWsXFZnJ6I1
         IrCQ==
Content-Disposition: inline
In-Reply-To: <89171a94-8b6f-e949-0078-10fa8fd26dfc@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On Tue, Oct 15, 2019 at 05:04:44PM +0300, Konstantin Khlebnikov wrote:
> On 15/10/2019 16.53, Johannes Weiner wrote:
> > On Tue, Oct 15, 2019 at 11:09:59AM +0300, Konstantin Khlebnikov wrote:
> > > Mapped, dirty and writeback pages are also counted in per-lruvec stats.
> > > These counters needs update when page is moved between cgroups.
> > > 
> > > Fixes: 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats infrastructure")
> > > Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> > 
> > Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > Please mention in the changelog that currently is nobody *consuming*
> > the lruvec versions of these counters and that there is no
> > user-visible effect. Thanks
> > 
> 
> Maybe just kill all these per-lruvec counters?
> I see only one user which have no alternative data source: WORKINGSET_ACTIVATE.
> 
> This will save some memory: 32 * sizeof(long) * nr_nodes * nr_cpus bytes

This is backwards, see my reply to Michal, as well as the patches at
https://lore.kernel.org/linux-mm/20190603210746.15800-1-hannes@cmpxchg.org/

We're not using the lruvec counters in all places where we should.
