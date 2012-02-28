From: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 08/10] memcg: Add
 CONFIG_CGROUP_MEM_RES_CTLR_KMEM_ACCT_ROOT.
Date: Wed, 29 Feb 2012 08:54:16 +0900
Message-ID: <20120229085416.447e6fd4.kamezawa.hiroyu@jp.fujitsu.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
	<1330383533-20711-9-git-send-email-ssouhlal@FreeBSD.org>
	<4F4CD7E7.1070901@parallels.com>
	<CABCjUKAUQZuW9hFeMJ1Oh=0UeS2Ffx4-vHpnaGpjOFu+3KktAA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CABCjUKAUQZuW9hFeMJ1Oh=0UeS2Ffx4-vHpnaGpjOFu+3KktAA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Tue, 28 Feb 2012 15:36:27 -0800
Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> On Tue, Feb 28, 2012 at 5:34 AM, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org> wrote:
> > On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
> >>
> >> This config option dictates whether or not kernel memory in the
> >> root cgroup should be accounted.
> >>
> >> This may be useful in an environment where everything is supposed to be
> >> in a cgroup and accounted for. Large amounts of kernel memory in the
> >> root cgroup would indicate problems with memory isolation or accounting.
> >
> >
> > I don't like accounting this stuff to the root memory cgroup. This causes
> > overhead for everybody, including people who couldn't care less about memcg.
> >
> > If it were up to me, we would simply not account it, and end of story.
> >
> > However, if this is terribly important for you, I think you need to at
> > least make it possible to enable it at runtime, and default it to disabled.
> 
> Yes, that is why I made it a config option. If the config option is
> disabled, that memory does not get accounted at all.
> 
> Making it configurable at runtime is not ideal, because we would
> prefer slab memory that was allocated before cgroups are created to
> still be counted toward root.
> 

I never like to do accounting in root cgroup.
If you want to do this, add config option to account _all_ memory in the root.
Accounting only slab seems very dirty hack.

Thanks,
-Kame

