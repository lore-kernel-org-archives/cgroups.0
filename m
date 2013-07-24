From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Date: Wed, 24 Jul 2013 12:14:07 -0400
Message-ID: <20130724161407.GD20377@mtj.dyndns.org>
References: <51EFA554.6080801@huawei.com>
 <20130724143214.GL2540@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=liGKmAqwC84UPsiWqaG0jvfBtRa5akkjfSvsqLAjQJg=;
        b=J1vGUCsR+QLpFzluPqthI7EpFPY0Fbh8XasSiKGM83TJ5Mus0Ta3NF+6UYuoJNQ1iI
         aXU4ntSmS19lN8HySLmFlp237iIK47orMlKLk/mIITzIisj4JdGEYy1YDw5/jzPo4HaI
         mfxu3fii33bQtKMfCZXKIgRWsoaEry4RaJQIJgKgPhBNnVBdCGStHeuoy7S9zkn4yVop
         AO57K50MPX56T0KydFUPZyAoinyAgiRkpRuM8NG8J+olKsnnuoa+R2SQGjg9ObXnkdj9
         qpQQJNq2YPPp8Zm3tUU62wwgrxKzbl3maHQ6AE2N9Qr/s+WMnRiFa+dQu+JVaf9+AXh7
         UPhA==
Content-Disposition: inline
In-Reply-To: <20130724143214.GL2540@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: Li Zefan <lizefan@huawei.com>, Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Wed, Jul 24, 2013 at 04:32:14PM +0200, Michal Hocko wrote:
> On Wed 24-07-13 17:58:44, Li Zefan wrote:
> > This patchset converts memcg to use cgroup->id, and then we can remove
> > cgroup css_id.
> > 
> > As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> > is very straight-forward.
> > 
> > The patchset is based on Tejun's cgroup tree.
> 
> Does it depend on any particular patches? I am asking because I would
> need to cherry pick those and apply them into my -mm git tree before
> these.

I'll set up a branch with the prep cgroup patches bsaed on top of
v3.10 which you can pull into your tree (let's please not cherry-pick)
and the memcg part and actual css_id removal can be carried through
-mm.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
