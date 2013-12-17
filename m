From: Hugh Dickins <hughd@google.com>
Subject: Re: 3.13-rc breaks MEMCG_SWAP
Date: Mon, 16 Dec 2013 17:41:38 -0800 (PST)
Message-ID: <alpine.LNX.2.00.1312161718001.2037@eggly.anvils>
References: <alpine.LNX.2.00.1312160025200.2785@eggly.anvils> <52AEC989.4080509@huawei.com> <20131216095345.GB23582@dhcp22.suse.cz> <20131216104042.GC23582@dhcp22.suse.cz> <20131216163530.GH32509@htj.dyndns.org> <20131216171937.GG26797@dhcp22.suse.cz>
 <20131216172143.GJ32509@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-type;
        bh=56azl0ncJk4Vk9W3A5Z2rHOrOsV45i/f4HKrEA2JZ1E=;
        b=MZzX6r5XpOo4d8JD0A8bWqhx1HHhv/XiUm53Piswm11/LkMvQpes4UBs8hoez8Wwzr
         SeAH2Lr774YR+gk3zTnpCXua/PUcxSftzihmOuyAqzrehsQxtjRUu2xq49lP82LSiRWF
         DhNHeFNs3RuYGQynFqftNdUVL50Npw33U9mOLarX/XN9IPX1n79DV2RfWkhsY6zvFOHc
         +l4Gz9SWz2LMj3pIM7SHSbM/tKByx9C0u2a6J/NQwHln3fmxF739+RPM2FKCONrIYPAg
         G8BSfKx+A9drlpP2vwi0KRgFev7+k5Dklz+fyp1i+H7QfwrUrE5pBESsP4NdideKsiDr
         WSTQ==
In-Reply-To: <20131216172143.GJ32509@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013, Tejun Heo wrote:
> On Mon, Dec 16, 2013 at 06:19:37PM +0100, Michal Hocko wrote:
> > I have to think about it some more (the brain is not working anymore
> > today). But what we really need is that nobody gets the same id while
> > the css is alive. So css_from_id returning NULL doesn't seem to be
> > enough.
> 
> Oh, I meant whether it's necessary to keep css_from_id() working
> (ie. doing successful lookups) between offline and release, because
> that's where lifetimes are coupled.  IOW, if it's enough for cgroup to
> not recycle the ID until all css's are released && fail css_from_id()
> lookup after the css is offlined, I can make a five liner quick fix.

Don't take my word on it, I'm too fuzzy on this: but although it would
be good to refrain from recycling the ID until all css's are released,
I believe that it would not be good enough to fail css_from_id() once
the css is offlined - mem_cgroup_uncharge_swap() needs to uncharge the
hierarchy of the dead memcg (for example, when tmpfs file is removed).

Uncharging the dead memcg itself is presumably irrelevant, but it does
need to locate the right parent to uncharge, and NULL css_from_id()
would make that impossible.  It would be easy if we said those charges
migrate to root rather than to parent, but that's inconsistent with
what we have happily converged upon doing elsewhere (in the preferred
use_hierarchy case), and it would be a change in behaviour.

I'm not nearly as enthusiastic for my patch as Michal is: I really
would prefer a five-liner from you or from Zefan.  I do think (and
this is probably what Michal likes) that my patch leaves MEMCG_SWAP
less surprising, and less likely to cause similar trouble in future;
but it's not how Kame chose to implement it, and it has those nasty
swap_cgroup array scans adding to the overhead of memcg removal -
we can layer on several different hacks/optimizations to reduce that
overhead, but I think it's debatable whether that will end up as an
improvement over what we have had until now.

Hugh

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
