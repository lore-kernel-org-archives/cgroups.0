From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/4] memcg: always enable kmemcg on the default hierarchy
Date: Fri, 28 Aug 2015 13:41:40 -0400
Message-ID: <20150828174140.GN26785@mtj.duckdns.org>
References: <1440775530-18630-1-git-send-email-tj@kernel.org>
 <1440775530-18630-5-git-send-email-tj@kernel.org>
 <20150828164918.GJ9610@esperanza>
 <20150828171438.GD21463@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fq64rcCCSm+vZMzYMJqs6yvpkBkW1/Jc0L8A+IPof/s=;
        b=uAcNKDuotSS5z5sH29/cTofOL/SzQw7HJ2S+GHWmCZz9akeWR6wcItvcU7g37zpFCN
         /804nHNbPzWT6w+GhlKoV+JZDU/gY1irOgnfEcc1F1wg9XIj4v0J8RcX6RQ99nKsEipE
         Af9doynmWYj177hDNjG1lz7QI/HSlBrWm54JS27guwCOHkSdin5aJdhJzcGFJeFe7nU7
         5ozeIZmhLTzDi0f/afGnva6gxHYw/DGkYrUG08Z5tuXh7cmlPHTIOJJHD7kTD5pThoCT
         kWx4OAC2PXutzCC/DeVloQTdoWv4fGbwKsLRayAPjKloXM251BpQk5HW9UJJEMi+droH
         pXEg==
Content-Disposition: inline
In-Reply-To: <20150828171438.GD21463@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@parallels.com>, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Fri, Aug 28, 2015 at 07:14:38PM +0200, Michal Hocko wrote:
> On Fri 28-08-15 19:49:18, Vladimir Davydov wrote:
> > On Fri, Aug 28, 2015 at 11:25:30AM -0400, Tejun Heo wrote:
> > > On the default hierarchy, all memory consumption will be accounted
> > > together and controlled by the same set of limits.  Always enable
> > > kmemcg on the default hierarchy.
> > 
> > IMO we should introduce a boot time knob for disabling it, because kmem
> > accounting is still not perfect, besides some users might prefer to go
> > w/o it for performance reasons.
> 
> I would even argue for opt-in rather than opt-out.

Definitely not.  We wanna put all memory consumptions under the same
roof by default.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
