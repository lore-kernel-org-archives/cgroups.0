From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v1 3/3] cgroup: relax common ancestor restriction for
 direct descendants
Date: Wed, 20 Jul 2016 19:02:28 -0400
Message-ID: <20160720230228.GA19588@mtj.duckdns.org>
References: <20160718161816.13040-1-asarai@suse.de>
 <20160718161816.13040-4-asarai@suse.de>
 <20160720155147.GG4574@htj.duckdns.org>
 <6e975d80-4077-fb8b-ec84-708e37c8e149@suse.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F9E9NHPhoezFVgOUbAZiinlU69PTndE4fIcN1+kSOvs=;
        b=nlZxW4f3ITQHbL8zxoOIdPr7WwyFrTAvu+pYfoQg800m36OqFb7U7HpjQ4ANMhEP5e
         Daos8uZeu8Ob5obYyZh+iqWl1OvWCHA1l5zhdWrVqFUXkztYzdnZeTiz80lLVD2W5dHs
         9c8MS4Eec1tS7RNTLHUjOOxvf9eJnbFxwSYgIusZGOaIK19d7GfJsC/sYuV5mfDEGkF/
         dYfnHkM9amYVGfVt77gn9qc2g5G2KJb2btan4eExi4d0DLspsiFKZduYXE6JOuAIj1OA
         RrUhf//SFk/ZnZbWtMPvR8GVCU2T6GzzMoKTwn0j1K+irHo6JqymRqMoLNu1isPE5l8I
         cEZA==
Content-Disposition: inline
In-Reply-To: <6e975d80-4077-fb8b-ec84-708e37c8e149-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Serge E. Hallyn" <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Wilson <chris-Y6uKTt2uX1cEflXRtASbqLVCufUGDwFn@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christian Brauner <cbrauner-l3A5Bk7waGM@public.gmane.org>, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>

Hello, Aleksa.

On Thu, Jul 21, 2016 at 08:58:32AM +1000, Aleksa Sarai wrote:
> I'm not sure what you mean by "steal". The user doing the migration owns the

In the sense that the ancestor cgroup can be modified by one of its
descendants even when that descendant doesn't have enough permission
to modify the ancestor.

> process, so I would argue that they aren't "stealing" anything. While a
> higher level process might not know where precisely in the hierarchy the
> process is, they'll know it that it must be a sub-cgroup of the one they
> were put in (meaning the parent can still impose restrictions without any
> issue).

Hmmm... it's not just about the ownership of the process itself.  If
it had been, we wouldn't have bothered with permission model on cgroup
hierarchy itself.  It's also about who is allowed to modify a given
cgroup and what you're proposing violates that.

> If you want, we can make it so that an unprivileged user migrating processes
> to a child cgroup only works if you're in the same cgroup namespace (and
> have CAP_SYS_ADMIN in the pinned user namespace, etc). The current setup
> would obviously still work, but you'd add a permission for users that just
> want to be able to limit their own processes. IIRC we need to update
> cgroup_procs_write_permission() anyway. By having the cgroup namespace
> requirement, you'd definitely have to "own" the process in every sense of
> the word I can imagine.

Maybe I'm misunderstanding but I can't see how that would change the
situation in a significant way.

Thanks.

-- 
tejun
