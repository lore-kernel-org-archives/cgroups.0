From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2] mm: fix oom_kill event handling
Date: Tue, 8 May 2018 13:16:10 -0400
Message-ID: <20180508171610.GA24175@cmpxchg.org>
References: <20180508124637.29984-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0gHY3fHSXBCZyPC2XXFyN1WpgiS312/pyHsr4QVe4DI=; b=obZmPf+Vdtqcn8aEyvNkJTXXCN
        4eEpJgOzLU2fs750JYdICQbsWXl6r8UYvake74T3l2BCz81uaz8QJDbFC3RDXZaYXg7ZPgjAzZVVg
        qFNqJPBw7Q5bnkh576oYYvScTLFDTRfnrLrWKD5RBRgJqe3cqKdO6BIyiBM1QjURgTWg=;
Content-Disposition: inline
In-Reply-To: <20180508124637.29984-1-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: kernel-team@fb.com, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Tue, May 08, 2018 at 01:46:37PM +0100, Roman Gushchin wrote:
> Commit e27be240df53 ("mm: memcg: make sure memory.events is
> uptodate when waking pollers") converted most of memcg event
> counters to per-memcg atomics, which made them less confusing
> for a user. The "oom_kill" counter remained untouched, so now
> it behaves differently than other counters (including "oom").
> This adds nothing but confusion.
> 
> Let's fix this by adding the MEMCG_OOM_KILL event, and follow
> the MEMCG_OOM approach. This also removes a hack from
> count_memcg_event_mm(), introduced earlier specially for the
> OOM_KILL counter.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
