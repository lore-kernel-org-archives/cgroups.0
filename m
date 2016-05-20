From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Fri, 20 May 2016 09:03:52 -0700
Message-ID: <20160520160352.GC5632@htj.duckdns.org>
References: <1463196000-13900-1-git-send-email-asarai@suse.de>
 <573F23D0.2030500@suse.de>
 <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=U6RetO8HLZ1OWI8PL6V6A428tuDSky1XxErGsTEtpdo=;
        b=CCqsYm4DW4lZTdV8QKl8bqIQ2sWtIVcEqXnY8l6DUDovPAWhEYx8Gv4/Qg0g8l+d7P
         5Vip34uiVMhx8o49c9XPM/G7oWA096leXocaC8ZO0VuvIzIIZDHEVCZPg+3e9hW0YdLw
         RQ9YgaKmsmIbcik9xrTXsABw5nRfBrgF9xOlDVUhaQP7JuiYuDRyEqoTVW/SCtpeMTJa
         W08yMNXufjK/2jie2PihHO9jK+oM6zaGYVX8H35sj19gSvRG9wY4hI/d7SSIN16eDJ07
         yVfstN8WCeQVEdvatTH4u5+7RffwkRrr2nK3KizMqWQ6McxJRpVMaINseLDxX9tbOGuO
         s0Qw==
Content-Disposition: inline
In-Reply-To: <1463758258.8091.3.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org

Hello, James.

On Fri, May 20, 2016 at 11:30:58AM -0400, James Bottomley wrote:
> Given it's merge window time, I haven't yet had time to look at the
> patch, but I can tell you why it (or something like it) is necessary:
> unprivileged containers need to be able to set up cgroups as well as
> namespaces, so we do need a way for the user ns owner to modify cgroups
> in their default configuration otherwise cgroups just won't fit into
> the unprivileged model.  Whether this should be through the cgroup ns

That can be allowed by delegating a cgroup sub-hierarchy to the
unpriviledged user.  Sub-cgroups created by that user will be owned by
that user.  IOW, if the owner of the cgroup hierarchy doesn't
explicitly delegate the subtree, the unpriv user can't have the
subtree.  This is true for regular use cases and shouldn't be
different for namespaces.

> is up for debate, as is how we should actually allow this to happen and
> what we should present to the user ns owner, but we do need a way to do
> this.
> 
> Delegation can't be through chmodding in this case because the user ns
> owner can't chmod something owned by init_user_ns root.

I still don't see why the existing mechanisms (including userns if
delegation from inside a ns is necessary) aren't enough.  And even if
we need something, I'd much prefer not to add a behavior which wildly
deviates from the usual rules.

Thanks.

-- 
tejun
