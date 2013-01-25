From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/6] replace cgroup_lock with memcg specific locking
Date: Fri, 25 Jan 2013 09:37:01 -0800
Message-ID: <20130125173701.GH3081@htj.dyndns.org>
References: <1358862461-18046-1-git-send-email-glommer@parallels.com>
 <510258D0.6060407@parallels.com>
 <20130125101854.GC8876@dhcp22.suse.cz>
 <51025E2B.4080105@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=nY2E/VpkMUpcF3+d0ockDV73mIQwkErzWPKWIu1dExc=;
        b=hXrAZypftHT0IFRAeMfem24+nhbDj6cuEKgcCq/IwyvWqJpmyEwbjnTZnWKQ19+5iX
         jYVYg0R54KH5VJWUzVjc9e1zZQ7hmL0WA0yhUBUni6bk0d9y9Bh366h+2Iybau/0RMN0
         nGOiPrapk4l9SukU0f2xxYgtNiseU0fGLqb/j7/2HvsriTgQahhzLhERIgi3d8dzf+UJ
         Zt3EIMK4tCY8f8iQR+r8VBn7RNdBn+K7iJiRk46faynlgh5Bi0R2bDHy6wJDRvLghbeE
         tzjvLNCZIFtsdwFt2SphqAuSPCSdZEh5MvRuTdAkXbgnhLEZqPVlCxtfQVQ4C/AHm0tK
         9f3g==
Content-Disposition: inline
In-Reply-To: <51025E2B.4080105@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lord Glauber Costa of Sealand <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com, Andrew Morton <akpm@linux-foundation.org>

Hey,

On Fri, Jan 25, 2013 at 02:27:55PM +0400, Lord Glauber Costa of Sealand wrote:
> > I would vote to -mm. Or is there any specific reason to have it in
> > cgroup tree? It doesn't touch any cgroup core parts, does it?
> > 
> Copying Andrew (retroactively sorry you weren't directly CCd on this one
> as well).
> 
> I depend on css_online and the cgroup generic iterator. If they are
> already present @ -mm, then fine.
> (looking now, they seem to be...)

Yeah, they're all in cgroup/for-next so should be available in -mm, so
I think -mm probably is the better tree to route these.

Thanks!

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
