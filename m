From: Vinayak Menon <vinmenon@codeaurora.org>
Subject: Re: [RFC 0/1] add support for reclaiming priorities per mem cgroup
Date: Wed, 22 Mar 2017 17:43:57 +0530
Message-ID: <6b4f4912-6afa-e6a3-17a9-2c76c9d5ce7b@codeaurora.org>
References: <20170317231636.142311-1-timmurray@google.com>
 <20170320055930.GA30167@bbox>
 <3023449c-8012-333d-1da9-81f18d3f8540@codeaurora.org>
 <20170320152315.GA27672@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
	s=default; t=1490184845;
	bh=FutNz0I0SKGm17jaqlxuaUdR1WIB3LdmuuQ5K/5kS4w=;
	h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
	b=Vkhhxmp69/u9WCrKqL50wJHjwlxkZ2cd1eCHQCZE4GJQvAWxBtwOf1a9b05s9IBeg
	 mq3Omx/zi+ANtx7Qni1FDyGs0GLJZEKlRSkbuXtFdJPI+B6q53upEvlnj1ToQW5cgv
	 CS0Ky1LfFzDLn3aFYt/6sr/A7yd37WOnEgOiLkm0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
	s=default; t=1490184843;
	bh=FutNz0I0SKGm17jaqlxuaUdR1WIB3LdmuuQ5K/5kS4w=;
	h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
	b=akD/eeM9357BOEfgRGPJyDu9lzN+mgGjqfqdyRkh5RlcicA0XHGs8Thr23kAOVUSC
	 ec44Pz3C7/7xmvM1QbE3GYyBNTdyquwuOBcdtf6sXeoNdS/Ksu42PbodmjsOwmHiY/
	 4BUaHbPrTm6b8k39di3yHdlI6un3JVTe8/xgkzUU=
In-Reply-To: <20170320152315.GA27672@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Minchan Kim <minchan@kernel.org>, Tim Murray <timmurray@google.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, surenb@google.com, totte@google.com, kernel-team@android.com

On 3/20/2017 8:53 PM, Johannes Weiner wrote:
> On Mon, Mar 20, 2017 at 07:28:53PM +0530, Vinayak Menon wrote:
>> From the discussions @ https://lkml.org/lkml/2017/3/3/752, I assume you are trying
>> per-app memcg. We were trying to implement per app memory cgroups and were
>> encountering some issues (https://www.spinics.net/lists/linux-mm/msg121665.html) .
>> I am curious if you have seen similar issues and would like to know if the patch also
>> address some of these problems.
>>
>> The major issues were:
>> (1) Because of multiple per-app memcgs, the per memcg LRU size is so small and
>> results in kswapd priority drop. This results in sudden increase in scan at lower priorities.
>> And kswapd ends up consuming around 3 times more time.
> There shouldn't be a connection between those two things.
>
> Yes, priority levels used to dictate aggressiveness of reclaim, and we
> did add a bunch of memcg code to avoid priority drops.
>
> But nowadays the priority level should only set the LRU scan window
> and we bail out once we have reclaimed enough (see the code in
> shrink_node_memcg()).
>
> If kswapd gets stuck on smaller LRUs, we should find out why and then
> address that problem.
Hi Johannes, Thanks for your comments. I will try to explain what I have observed while debugging this
problem.
When there are multiple small LRUs and very few LRUs with considerable size (by considerable size I mean
those sizes which can result in a non-zero scan value in get_scan_count at priorities near to DEF_PRIORITY).
Since I am trying on 4.4 kernel there are more small LRUs per app (per memcg) because of further split due to per zone LRU.
Considering the case where most of the apps in the system are of this small category, the scan calculated by
get_scan_count for these memcg LRUs at around DEF_PRIORITY become zero or very less, either because of
size >> sc->priority is 0 or because of SCAN_FRACT. For these runs around DEF_PRIORITY (say till DEF_PRIORITY/2)
since sc->nr_scanned is < sc->nr_to_reclaim, the kswapd priority drops. Now say at kswapd priority less than
DEF_PRIORITY/2, the scan returned by get_scan_count gets higher slowly for all memcgs. This causes sudden
excessive scanning of most of the memcgs (because this also results in heavy scanning of memcgs which have
considerable size). As I understand, the scan priority in this case results in aggressive reclaim and not just decides the
scan window because, in the following check in shrink_node_memcg, the "nr_to_reclaim" (sc->nr_to_reclaim)
is a high value compared to the memcg LRU size. I have seen that this also causes either nr_file or nr_anon
go zero most of the time (after this check), which as I understand means that proportional scanning does not happen.

if (nr_reclaimed < nr_to_reclaim || scan_adjusted)
             continue;

I had tried making the "nr_to_reclaim" proportional to the lru size and that brings some benefits, but does not
solve the problem. Because when that is done, in some cases, the scanned pages at this priority decreases again,
resulting in further priority drop.

The priority drop and excessive scan/reclaim at lower priorities I have confirmed by keeping scanned and reclaimed
counters for each priority in vmstat. And yes, this results in kswapd being awake and running for longer time.

There was some benefit by prioritizing the memcgs similar to what Tim does in his patch and also by proportionally
reclaiming from the per-task memcgs based on their priority. But still the stats are far bad compared to having
a global LRU. One thing which was commonly seen in all these experiments is the multi fold increase in majfaults,
which I think is partly caused by poor aging of pages when the pages are distributed among a large number of tiny LRUs,
and global reclaim trying to reclaim from all of them.
>> (2) Due to kswapd taking more time in freeing up memory, allocstalls are high and for
>> similar reasons stated above direct reclaim path consumes 2.5 times more time.
>> (3) Because of multiple LRUs, the aging of pages is affected and this results in wrong
>> pages being evicted resulting in higher number of major faults.
>>
>> Since soft reclaim was not of much help in mitigating the problem, I was trying out
>> something similar to memcg priority. But what I have seen is that this aggravates the
>> above mentioned problems. I think this is because, even though the high priority tasks
>> (foreground) are having pages which are used at the moment, there are idle pages too
>> which could be reclaimed. But due to the high priority of foreground memcg, it requires
>> the kswapd priority to drop down much to reclaim these idle pages. This results in excessive
>> reclaim from background apps resulting in increased major faults, pageins and thus increased
>> launch latency when these apps are later brought back to foreground.
> This is what the soft limit *should* do, but unfortunately its
> semantics and implementation in cgroup1 are too broken for this.
>
> Have you tried configuring memory.low for the foreground groups in
> cgroup2? That protects those pages from reclaim as long as there are
> reclaimable idle pages in the memory.low==0 background groups.
I have not yet tried cgroup2. I was trying to understand it sometime back and IIUC it supports only a
single hierarchy and  a process can be part of only one cgroup, which means when we try per-task mem
cgroup, this would mean all other controllers will have to be configured per-task. No ? I would like to try
memory.low that you suggest. Let me check if I have a way to test this without disturbing other controllers,
or will try with memory cgroup alone.
>> One thing which is found to fix the above problems is to have both global LRU and the per-memcg LRU.
>> Global reclaim can use the global LRU thus fixing the above 3 issues. The memcg LRUs can then be used
>> for soft reclaim or a proactive reclaim similar to Minchan's Per process reclaim for the background or
>> low priority tasks. I have been trying this change on 4.4 kernel (yet to try the per-app
>> reclaim/soft reclaim part). One downside is the extra list_head in struct page and the memory it consumes.
> That would be a major step backwards, and I'm not entirely convinced
> that the issues you are seeing cannot be fixed by improving the way we
> do global round-robin reclaim and/or configuring memory.low.
I understand and agree that it would be better to fix the existing design if it is possible.

Thanks,
Vinayak

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
