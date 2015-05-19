From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 3/7] memcg: immigrate charges only when a threadgroup
 leader is moved
Date: Tue, 19 May 2015 15:10:42 +0200
Message-ID: <20150519131042.GF6203@dhcp22.suse.cz>
References: <1431978595-12176-1-git-send-email-tj@kernel.org>
 <1431978595-12176-4-git-send-email-tj@kernel.org>
 <20150519121321.GB6203@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=owlL7I71X8i0ht7QJ5fXz6Cz6b4DSJl4wfP4unwpp5A=;
        b=GqqNDCzlLyNf7kdPRjwY9AAXJO5iCsd7D8JbDuFuWPXR3tfQyGhjRWvuAwA7fJDRrx
         tLAtigQq8JdCO/Gs2MWoT1/Iunwc+EyqmrVNYHKjuQDiROKKnLoz+RYkWSzX9FUIQdt/
         uikpUEwESSCZAP+wjN/XDw4RGe7Ka5Y7aa8DkPS+qeDfPeFiVUZ67/Q4SsRnfCHHe31P
         KKWlEKti+dLJZkrkC0bkZVdeRoFOJQ9BbDmE6zQyEpcAwif4vcqUZcjYsuKxOgHBYTFS
         JBAFS1PDNW/N+htmfIMmXeJLFKW1kJuTKJ39LBIikJ2SZW/wTfbqiWhsf+rrZUmo9mby
         8wEw==
Content-Disposition: inline
In-Reply-To: <20150519121321.GB6203-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Tue 19-05-15 14:13:21, Michal Hocko wrote:
> On Mon 18-05-15 15:49:51, Tejun Heo wrote:
> > If move_charge flag is set, memcg tries to move memory charges to the
> > destnation css.  The current implementation migrates memory whenever
> > any thread of a process is migrated making the behavior somewhat
> > arbitrary. 
> 
> This is not true. We have:
>                 mm = get_task_mm(p);
>                 if (!mm)
>                         return 0;
>                 /* We move charges only when we move a owner of the mm */
>                 if (mm->owner == p) {
> 
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
> 
> I am trying to wrap my head around mm_update_next_owner and maybe we can
> change it to use the thread group leader but this needs more thinking...

OK, I guess I see the reason now. CLONE_VM doesn't imply CLONE_THREAD
so we can have a separate task (with it's own group leader) which
handles its own signals while it still shares the address space. So we
cannot really use the group leader here.
-- 
Michal Hocko
SUSE Labs
