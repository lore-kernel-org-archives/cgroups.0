From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/debug: Fix lockdep splat with "%pK" format
 specifier
Date: Mon, 27 Sep 2021 06:43:36 -1000
Message-ID: <YVH0uKGGmRjrIlFy@slm.duckdns.org>
References: <20210927025807.26918-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Mpp3yt5UlhJzcT0WXNiNQ5zDVt3UnhzU5xESPpUlLrY=;
        b=N6U4tHO7NsJPCAI0pl2qLjHILOWVWb0tMyq2HluBHcliYns5+8xvPinnRPTqZLH0Vp
         mjDwUGERqM+OLJEABbwAol4NPWVJezO6I0MZVTKNORmd/B+h34NEDOcb68rAv0YmupuZ
         8bkK3aG6reOpZDr0tyJ84dzBfEbp0AIADBf+YFz/B8Xh37dd+8jayjQ++afsnikievA0
         hyvk7st00zP25LRpCvBlwq0w0Of4Sop9JeO9VLHlA21sz70pV4PKeb1VbDW6QVCFsBW/
         aU+qGeKRdcYyDOavIovSgSbh4pdi9nQFhqQMkv5AQdDHphByKFQ2pvBbQxKAG4mdMzWO
         aPpg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210927025807.26918-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sun, Sep 26, 2021 at 10:58:07PM -0400, Waiman Long wrote:
> The lockdep splat is caused by the fact that the debug controller use the
> "%pK" format specifier to print out address of cset's with css_set_lock
> held. Under some circumstances, the use of "%pK" format specifier may
> acquire the selinux_ss.policy_rwlock.
> 
> To avoid this possible deadlock scenario, we have to abandon the use of
> the "%pK" format specifier and just use "%p" to always hash the cset
> addresses. The actual cset addresses aren't that important as long as
> they are unique for matching purpose.

Isn't the right thing to do here making the selinux rwlock an irqsafe one?
It's a bit crazy to have printf specifier to have restrictive locking
requirements.

Thanks.

-- 
tejun
