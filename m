From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] mm: memcontrol.c:  Cleaning up function that are not
 used anywhere
Date: Wed, 3 Dec 2014 16:54:51 +0100
Message-ID: <20141203155451.GI23236@dhcp22.suse.cz>
References: <1417560083-27157-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <20141203152231.GA2822@phnom.home.cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=DDRTMf4sz3XTo2Jr5fjibOjOWowZuDZUq72M8m9UDuo=;
        b=z13BP8c3K+8EKt4oBaFPgUo9un4HW6G+w3KRwZGzx7RYEJSJY8imh0JRdBMItqmgH3
         VGulDxa7aPXs6HPVLRenPcUqVYXppNFk6rwIAyznZo//myXQSsHyK3og5WwcId1Hrfw1
         1tI0Zt0Mg1ow4MSZ3MD0lWFtiyRK5jBhYClnUl0GylUnVvm+v6cv9t2q+m7+mr2Jp4rz
         QDnHYEfadvfZOCAqafE5HX/hIHiEfAubya/mktpR+1AE1kVZLpetYsKmnj0rHJtWqj4a
         DlBBtvpCrkX8wPm8T7qzBXayTnoEwewOF+EWtUMbDAcUSTxGebCcufTgfJS+TQJNdxZV
         qjhA==
Content-Disposition: inline
In-Reply-To: <20141203152231.GA2822@phnom.home.cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Wed 03-12-14 10:22:31, Johannes Weiner wrote:
> On Tue, Dec 02, 2014 at 11:41:23PM +0100, Rickard Strandqvist wrote:
> > Remove function mem_cgroup_lru_names_not_uptodate() that is not used anywhere.
> > 
> > This was partially found by using a static code analysis program called cppcheck.
> > 
> > Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> > ---
> >  mm/memcontrol.c |    5 -----
> >  1 file changed, 5 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index d6ac0e3..5edd1fe 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4379,11 +4379,6 @@ static int memcg_numa_stat_show(struct seq_file *m, void *v)
> >  }
> >  #endif /* CONFIG_NUMA */
> >  
> > -static inline void mem_cgroup_lru_names_not_uptodate(void)
> > -{
> > -	BUILD_BUG_ON(ARRAY_SIZE(mem_cgroup_lru_names) != NR_LRU_LISTS);
> > -}
> 
> That assertion doesn't work in an unused function, but we still want
> this check.  Please move the BUILD_BUG_ON() to the beginning of
> memcg_stat_show() instead.

Ohh. I have completely missed the point of the check! Moving the check
to memcg_stat_show sounds like a good idea.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
