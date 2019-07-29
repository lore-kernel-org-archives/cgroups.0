From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Mon, 29 Jul 2019 12:40:29 +0300
Message-ID: <3d6fc779-2081-ba4b-22cf-be701d617bb4@yandex-team.ru>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
 <20190729091738.GF9330@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1564393231; bh=7/tBJ4/qqqj7+TYSG8WJ1dkQnz6GbGSbSQMPTnlbeZw=;
        h=In-Reply-To:Message-ID:From:Date:References:To:Subject:Cc;
        b=LUvQwL/QlD6Pg9qp202MGi9db0D1vc9D2+yRRANkR7RNSkFzvu6mMu9rnOq3s/Z7g
         9LobH066Mj6J048YjrUosIn/5LmhCs5N3ausLHyF+VaQpKLpjS4ngZ1UJ3lPHqZRbl
         MkWJ2c9sBwf1N7xBB6VRESXglZ55Hw81Vcb+43Zo=
In-Reply-To: <20190729091738.GF9330@dhcp22.suse.cz>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Michal Hocko <mhocko@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On 29.07.2019 12:17, Michal Hocko wrote:
> On Sun 28-07-19 15:29:38, Konstantin Khlebnikov wrote:
>> High memory limit in memory cgroup allows to batch memory reclaiming and
>> defer it until returning into userland. This moves it out of any locks.
>>
>> Fixed gap between high and max limit works pretty well (we are using
>> 64 * NR_CPUS pages) except cases when one syscall allocates tons of
>> memory. This affects all other tasks in cgroup because they might hit
>> max memory limit in unhandy places and\or under hot locks.
>>
>> For example mmap with MAP_POPULATE or MAP_LOCKED might allocate a lot
>> of pages and push memory cgroup usage far ahead high memory limit.
>>
>> This patch uses halfway between high and max limits as threshold and
>> in this case starts memory reclaiming if mem_cgroup_handle_over_high()
>> called with argument only_severe = true, otherwise reclaim is deferred
>> till returning into userland. If high limits isn't set nothing changes.
>>
>> Now long running get_user_pages will periodically reclaim cgroup memory.
>> Other possible targets are generic file read/write iter loops.
> 
> I do see how gup can lead to a large high limit excess, but could you be
> more specific why is that a problem? We should be reclaiming the similar
> number of pages cumulatively.
> 

Large gup might push usage close to limit and keep it here for a some time.
As a result concurrent allocations will enter direct reclaim right at
charging much more frequently.


Right now deferred recalaim after passing high limit works like distributed
memcg kswapd which reclaims memory in "background" and prevents completely
synchronous direct reclaim.

Maybe somebody have any plans for real kswapd for memcg?


I've put mem_cgroup_handle_over_high in gup next to cond_resched() and
later that gave me idea that this is good place for running any
deferred works, like bottom half for tasks. Right now this happens
only at switching into userspace.
