From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] device_cgroup: fix RCU usage
Date: Tue, 6 Nov 2012 12:29:17 -0800
Message-ID: <20121106202917.GT30069@mtj.dyndns.org>
References: <20121106171612.GH30069@mtj.dyndns.org>
 <20121106171737.GJ30069@mtj.dyndns.org>
 <20121106174841.GB28916@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=unGxzRrVl2B+dU1H09sPZ4KTPLJ+d9NKgnuiIKsqBB0=;
        b=MvR9ws/A9YZJP1/jPqASX7U0ZM6uxQL7dFILTna6Blm+cS7BdcPuuhW/rHgxi8vF7/
         M2/7e7nBvvz+jVQzBgYTkx9vUtVtyjSHxTbPOrD0nb4wQKPCmmegQc3srDX0uywdJvT3
         kYwpg8ppEEZvq5+/ApXlOekMT/SV/ouD1n9uqCtYMBLLUxy6e/zbxtrEi4eJAwYs9Y5e
         gmzKDLOjoeZLWJO17+L3XNBKryVEwuozz+9AEf9FzZco9G1eZEUsyBR9QV59gikvUTNT
         Nka792qYEI0nXx33FjYVmlE0A/gqkoXonEB6H4XJcjKtTJzNiI/dZQNL0pCoDty9NhNl
         QJcQ==
Content-Disposition: inline
In-Reply-To: <20121106174841.GB28916@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 06, 2012 at 11:48:41AM -0600, Serge Hallyn wrote:
> Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> > dev_cgroup->exceptions is protected with devcgroup_mutex for writes
> > and RCU for reads; however, RCU usage isn't correct.
> > 
> > * dev_exception_clean() doesn't use RCU variant of list_del() and
> >   kfree().  The function can race with may_access() and may_access()
> >   may end up dereferencing already freed memory.  Use list_del_rcu()
> >   and kfree_rcu() instead.
> > 
> > * may_access() may be called only with RCU read locked but doesn't use
> >   RCU safe traversal over ->exceptions.  Use list_for_each_entry_rcu().
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > Cc: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Thanks, applied to cgroup/for-3.7-fixes.

-- 
tejun
