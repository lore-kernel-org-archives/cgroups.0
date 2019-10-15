From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH] mm/memcontrol: update lruvec counters in
 mem_cgroup_move_account
Date: Tue, 15 Oct 2019 17:04:44 +0300
Message-ID: <89171a94-8b6f-e949-0078-10fa8fd26dfc@yandex-team.ru>
References: <157112699975.7360.1062614888388489788.stgit@buzz>
 <20191015135348.GA139269@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1571148285; bh=gapCxVyFjCKK96iTj5+/HTSHg4pVE+p4wO6AeL1O5js=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=iexJ4OXOHRyfvZOijhnDLG/OTy9p46fATNnCRuDS3uURs4zONzQOCug4kegm8PrUp
         r7YEtJsOfu0s8iXkRLCF4KwchV8t6Db1ylKADx0+jrNc/0CO6Pt0LvfyXyw82hKy5R
         vhqiRKrwvDQqEd2HUE6UbUXWLI2/HLIwQLMBxmbQ=
In-Reply-To: <20191015135348.GA139269@cmpxchg.org>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>

On 15/10/2019 16.53, Johannes Weiner wrote:
> On Tue, Oct 15, 2019 at 11:09:59AM +0300, Konstantin Khlebnikov wrote:
>> Mapped, dirty and writeback pages are also counted in per-lruvec stats.
>> These counters needs update when page is moved between cgroups.
>>
>> Fixes: 00f3ca2c2d66 ("mm: memcontrol: per-lruvec stats infrastructure")
>> Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
> 
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Please mention in the changelog that currently is nobody *consuming*
> the lruvec versions of these counters and that there is no
> user-visible effect. Thanks
> 

Maybe just kill all these per-lruvec counters?
I see only one user which have no alternative data source: WORKINGSET_ACTIVATE.

This will save some memory: 32 * sizeof(long) * nr_nodes * nr_cpus bytes
