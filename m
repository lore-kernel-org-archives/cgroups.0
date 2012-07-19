From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm/memcg: use exist interface to get css from memcg
Date: Thu, 19 Jul 2012 05:55:15 -0700 (PDT)
Message-ID: <alpine.LSU.2.00.1207190552440.4949@eggly.anvils>
References: <1342609734-22437-1-git-send-email-liwanp@linux.vnet.ibm.com> <20120719092928.GA2864@tiehlicka.suse.cz> <5007E00B.6000802@jp.fujitsu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=uZpRDpnAedcgbDz43BpvWP+vYlXNK0yduBiu1wMe4GE=;
        b=GjDomB4z0xnvT34TQhIJvQeUllk3c5xJNdaquO4TAmeH9JjK0p/yGTMFIn+3/naw7r
         vVyyrLTkG3D92EyXj8dEVDy43wj62aAGrzLV+4abC06a2eTQqEyCvVSeieyL9tB5jWAy
         fkg/iGEjvQktctAtkxV+wcw3kc+odFiHaNfKDtpiLYouY7P+Bfexrj4fFEht2mTUTyWj
         JOGZ6fzdIqNAqh5cCluFNWOAOgDQtYXBTI39njO/Hc7vOyNEfY/TbxbySPNqdNKe8Uur
         sW/Yjok5+MQUm3F7NGWgK1Sal0s+OD/KC3aezRoiq1M4CDxmL+NT0MbrKwD+JJpajIKv
         RvZw==
In-Reply-To: <5007E00B.6000802-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Wanpeng Li <liwanp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Bob Liu <lliubbo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, 19 Jul 2012, Kamezawa Hiroyuki wrote:
> (2012/07/19 18:29), Michal Hocko wrote:
> > On Wed 18-07-12 19:08:54, Wanpeng Li wrote:
> > > use exist interface mem_cgroup_css instead of &mem->css.
> > 
> > This interface has been added to enable mem->css outside of
> > mm/memcontrol.c (where we define struct mem_cgroup). There is one user
> > left (hwpoison_filter_task) after recent clean ups.
> > 
> > I think we shouldn't spread the usage inside the mm/memcontrol.c. The
> > compiler inlines the function for all callers added by this patch but I
> > wouldn't rely on it. It is also unfortunate that we cannot convert all
> > dereferences (e.g. const mem_cgroup).
> > Moreover it doesn't add any additional type safety. So I would vote for
> > not taking the patch but if others like it I will not block it.
> > 
> 
> Agreed.

Very strongly agreed: I found it hard to be as polite as you have been.

Hugh
