From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH 4/4] mm/memcg: refine
 mem_cgroup_threshold_ary->current_threshold calculation
Date: Tue, 11 Jan 2022 10:23:41 -0800
Message-ID: <Yd3LLalWzPy17PmR@carbon.dhcp.thefacebook.com>
References: <20220111010302.8864-1-richard.weiyang@gmail.com>
 <20220111010302.8864-4-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=4DkgckKu1aYww/oMAjDAT/ZhOrmTVFeQMTlbRqBXSdE=;
 b=MtiND26ytQblQnQlBy/9NXDbH+OiTgF9FJxDzJkP0iQ5yP9OI8zIWo/ZLd8FiwSOuJkq
 fxAia0dD5sn+oX561ZAaEsKaHrNJkHAekTszhBDLTy5XCnjHUsP2tEjWLNHVWJj0gWAy
 p1cqVXFAQtHZRJknupYkpuypU1iYRVetqxU= 
Content-Disposition: inline
In-Reply-To: <20220111010302.8864-4-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue, Jan 11, 2022 at 01:03:02AM +0000, Wei Yang wrote:
> mem_cgroup_threshold_ary->current_threshold points to the last entry
> who's threshold is less or equal to usage.
> 
> Instead of iterating entries to get the correct index, we can leverage
> primary->current_threshold to get it. If the threshold added is less or
> equal to usage, current_threshold should increase by one. Otherwise, it
> doesn't change.

How big is usually an array of thresholds? If it's not huge, likely
any savings won't be really noticeable (it's not a hot path and there
is an rc_synchronize() below).

So I agree with Michal that a better justification is really needed.

Thanks!
