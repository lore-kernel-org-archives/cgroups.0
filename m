From: Daniel Jordan <daniel.m.jordan@oracle.com>
Subject: Re: [PATCH 00/14] per memcg lru_lock
Date: Wed, 21 Aug 2019 14:00:31 -0400
Message-ID: <6ba1ffb0-fce0-c590-c373-7cbc516dbebd@oracle.com>
References: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=tmRGzebsdlR9sHASmyyyKPRbTYCSfFlnVG/zj++02Y4=;
 b=HwUtvYoInfaOTd1lpkEF2lXCkMMdX8CCXLFKikiq1tJTeuhrZIHbtyZt8T8CDAj/kJ49
 VnjSul33YJvV5jf+Uj9PtxaV5/CcI73/kU9ElXuNugL621Rk0AiI1I2oL79Mvf+xi36n
 76vZRSktp24TmNIuHTXekZuGyRu1NjL3pw0YsEbJpb/vUWHsKQa9qEjZmm9AYUV4RSd2
 B/EJ0530GJxR6tkZmHGGcESAaXpcopGjSgNDdU8f26Xc2dkZ+WaruJgFG4B6bTZtEq7j
 s9K8k8QULrqN1tnEiUSa4SGco7jrEgYaenk4MeWWYscV6wZZTdubbQBpR3Nu+vQofrnT VQ== 
In-Reply-To: <1566294517-86418-1-git-send-email-alex.shi@linux.alibaba.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Alex Shi <alex.shi@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>

Hi Alex,

On 8/20/19 5:48 AM, Alex Shi wrote:
> In some data center, containers are used widely to deploy different kind
> of services, then multiple memcgs share per node pgdat->lru_lock which
> cause heavy lock contentions when doing lru operation.
> 
> On my 2 socket * 6 cores E5-2630 platform, 24 containers run aim9
> simultaneously with mmtests' config:
>          # AIM9
>          export AIM9_TESTTIME=180
>          export AIM9_TESTLIST=page_test,brk_test
> 
> perf lock report show much contentions on lru_lock in 20 second snapshot:
>                          Name   acquired  contended   avg wait (ns) total wait (ns)   max wait (ns)   min wait (ns)
>          &(ptlock_ptr(pag...         22          0               0       0               0               0
>          ...
>          &(&pgdat->lru_lo...          9          7           12728       89096           26656            1597

This is system-wide right, not per container?  Even per container, 89 usec isn't much contention over 20 seconds.  You may want to give this a try:

   https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree/case-lru-file-readtwice

It's also synthetic but it stresses lru_lock more than just anon alloc/free.  It hits the page activate path, which is where we see this lock in our database, and if enough memory is configured lru_lock also gets stressed during reclaim, similar to [1].

It'd be better though, as Michal suggests, to use the real workload that's causing problems.  Where are you seeing contention?

> With this patch series, lruvec->lru_lock show no contentions
>          &(&lruvec->lru_l...          8          0               0       0               0               0
> 
> and aim9 page_test/brk_test performance increased 5%~50%.

Where does the 50% number come in?  The numbers below seem to only show ~4% boost.

> BTW, Detailed results in aim9-pft.compare.log if needed,
> All containers data are increased and pretty steady.
> 
> $for i in Max Min Hmean Stddev CoeffVar BHmean-50 BHmean-95 BHmean-99; do echo "========= $i page_test ============"; cat aim9-pft.compare.log | grep "^$i.*page_test" | awk 'BEGIN {a=b=0;}  { a+=$3; b+=$6 } END { print "5.3-rc4          " a/24; print "5.3-rc4+lru_lock " b/24}' ; done
> ========= Max page_test ============
> 5.3-rc4          34729.6
> 5.3-rc4+lru_lock 36128.3
> ========= Min page_test ============
> 5.3-rc4          33644.2
> 5.3-rc4+lru_lock 35349.7
> ========= Hmean page_test ============
> 5.3-rc4          34355.4
> 5.3-rc4+lru_lock 35810.9
> ========= Stddev page_test ============
> 5.3-rc4          319.757
> 5.3-rc4+lru_lock 223.324
> ========= CoeffVar page_test ============
> 5.3-rc4          0.93125
> 5.3-rc4+lru_lock 0.623333
> ========= BHmean-50 page_test ============
> 5.3-rc4          34579.2
> 5.3-rc4+lru_lock 35977.1
> ========= BHmean-95 page_test ============
> 5.3-rc4          34421.7
> 5.3-rc4+lru_lock 35853.6
> ========= BHmean-99 page_test ============
> 5.3-rc4          34421.7
> 5.3-rc4+lru_lock 35853.6
> 
> $for i in Max Min Hmean Stddev CoeffVar BHmean-50 BHmean-95 BHmean-99; do echo "========= $i brk_test ============"; cat aim9-pft.compare.log | grep "^$i.*brk_test" | awk 'BEGIN {a=b=0;}  { a+=$3; b+=$6 } END { print "5.3-rc4          " a/24; print "5.3-rc4+lru_lock " b/24}' ; done
> ========= Max brk_test ============
> 5.3-rc4          96647.7
> 5.3-rc4+lru_lock 98960.3
> ========= Min brk_test ============
> 5.3-rc4          91800.8
> 5.3-rc4+lru_lock 96817.6
> ========= Hmean brk_test ============
> 5.3-rc4          95470
> 5.3-rc4+lru_lock 97769.6
> ========= Stddev brk_test ============
> 5.3-rc4          1253.52
> 5.3-rc4+lru_lock 596.593
> ========= CoeffVar brk_test ============
> 5.3-rc4          1.31375
> 5.3-rc4+lru_lock 0.609583
> ========= BHmean-50 brk_test ============
> 5.3-rc4          96141.4
> 5.3-rc4+lru_lock 98194
> ========= BHmean-95 brk_test ============
> 5.3-rc4          95818.5
> 5.3-rc4+lru_lock 97857.2
> ========= BHmean-99 brk_test ============
> 5.3-rc4          95818.5
> 5.3-rc4+lru_lock 97857.2

[1] https://lore.kernel.org/linux-mm/CABdVr8R2y9B+2zzSAT_Ve=BQCa+F+E9_kVH+C28DGpkeQitiog@mail.gmail.com/
