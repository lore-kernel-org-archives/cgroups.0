From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Tue, 19 May 2015 17:27:54 -0400
Message-ID: <20150519212754.GO24861@htj.duckdns.org>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
 <20150519121321.GB6203@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=1AgFkksvvMnciYCoaIrpPOPcYBxfIL2dNcH4bt0Lul0=;
        b=wfPZ5hFOfa8m1OXFzPc8oN0Ji5MBgzgYT+YvfTHropKC2J//W2y2gm30RW/BPrFfP1
         pVqXYQhi67QINUU95zblMaUIvbKrgzkVfsOeKg+n5exiOw1LMshZdCD9ACljEXnsBh+e
         CRoKvtHsKAJoh9KBOBX6OWcxnkIzyUM+nQJG5kG2xdzLUAMBPnF1r9AtoSGFcIQuDhWC
         cYj1sBEL7WQV6uKZabszV0gMO4rTrgK+oenpp4wklp3vm9RVfslFxvy0L3LQ9sqN+sF+
         ZshTHym03TO32PW1iYP/Or8NilbWv4U0o1vEMAdJHYxbYGNkxqw1nhG0X8V1rdOvTM4K
         ZFBw==
Content-Disposition: inline
In-Reply-To: <20150519121321.GB6203-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Hello, Michal.

On Tue, May 19, 2015 at 02:13:21PM +0200, Michal Hocko wrote:
> This is not true. We have:
>                 mm = get_task_mm(p);
>                 if (!mm)
>                         return 0;
>                 /* We move charges only when we move a owner of the mm */
>                 if (mm->owner == p) {

Ah, missed that part.

> So we are ignoring threads which are not owner of the mm struct and that
> should be the thread group leader AFAICS.
> 
> mm_update_next_owner is rather complex (maybe too much and it would
> deserve some attention) so there might really be some corner cases but
> the whole memcg code relies on mm->owner rather than thread group leader
> so I would keep the same logic here.
> 
> > Let's tie memory operations to the threadgroup leader so
> > that memory is migrated only when the leader is migrated.
> 
> This would lead to another strange behavior when the group leader is not
> owner (if that is possible at all) and the memory wouldn't get migrated
> at all.

Hmmm... is it guaranteed that if a threadgroup owns a mm, the mm's
owner would be the threadgroup leader?  If not, the current code is
broken too as it always takes the first member which is the
threadgroup leader and if that's not the mm owner we may skip
immigration while migrating the whole process.

I suppose the right thing to do here is iterating the taskset and find
the mm owner?

Thanks.

-- 
tejun
