From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: Re: [PATCH 02/10] memcg: Uncharge all kmem when deleting a cgroup.
Date: Tue, 28 Feb 2012 16:00:41 -0300
Message-ID: <4F4D2459.3010908@parallels.com>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org> <1330383533-20711-3-git-send-email-ssouhlal@FreeBSD.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1330383533-20711-3-git-send-email-ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On 02/27/2012 07:58 PM, Suleiman Souhlal wrote:
> A later patch will also use this to move the accounting to the root
> cgroup.
>

Suleiman,

Did you do any measurements to figure out how long does it take, 
average, for dangling caches to go away ? Under memory pressure, let's say
