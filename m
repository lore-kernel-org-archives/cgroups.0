From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Subject: Re: [PATCH] mm: memcontrol.c: Cleaning up function that are not used anywhere
Date: Wed, 3 Dec 2014 18:04:18 +0100
Message-ID: <CAFo99gbCJzErKz2o3WHa8C8OKTaqPq-+iiJhAZOq41F6W5+8YA@mail.gmail.com>
References: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141203152231.GA2822@phnom.home.cmpxchg.org> <20141203155451.GI23236@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20141203155451.GI23236@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

2014-12-03 16:54 GMT+01:00 Michal Hocko <mhocko@suse.cz>:
> On Wed 03-12-14 10:22:31, Johannes Weiner wrote:
>> On Tue, Dec 02, 2014 at 11:41:23PM +0100, Rickard Strandqvist wrote:
>> > Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
>> >
>> > This was partially found by using a static code analysis program called cppcheck.
>> >
>> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
>> > ---
>> >  mm/memcontrol.c |    5 -----
>> >  1 file changed, 5 deletions(-)
>> >
>> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
>> > index d6ac0e3..5edd1fe 100644
>> > --- a/mm/memcontrol.c
>> > +++ b/mm/memcontrol.c
>> > @@ -4379,11 +4379,6 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
>> >  }
>> >  #endif /* CONFIG_NUMA */
>> >
>> > -static inline void mem_cgroup_lru_names_not_uptodate(void)
>> > -{
>> > -   BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
>> > -}
>>
>> That assertion doesn't work in an unused function, but we still want
>> this check.  Please move the BUILD_BUG_ON() to the beginning of
>> memcg_stat_show() instead.
>
> Ohh. I have completely missed the point of the check! Moving the check
> to memcg_stat_show sounds like a good idea.
>
> --
> Michal Hocko
> SUSE Labs

Hi

Ok, sure I'll fix that!

It will take a few days before I will have access to my workstation,
however, but the new patch on the way...

Kind regards
Rickard Strandqvist

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
