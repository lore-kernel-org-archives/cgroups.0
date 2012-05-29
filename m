From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 18/28] slub: charge allocation to a memcg
Date: Tue, 29 May 2012 09:51:20 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205290948250.4666@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-19-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338303084; bh=B58hbctrkFp29U+Hq74KxrdE09U7bukJAmiPIYIxtMU=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=uPgleiFibg/neLh2lc1cI0zhfitLhwMDrNOPum7pEK4cDHiiZYo8nvxAn9QenK0AgwLDN6wf6Jo5X8twOCoXjU/tIAnqisGGVZMOK6x4RoF6R2zm2nHbFT4qJmj74TjLjjXFyhwzPgg3Z0j/j7kF3PpKmWhoNhrzhuep9Rw+69A=
In-Reply-To: <1337951028-3427-19-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Fri, 25 May 2012, Glauber Costa wrote:

> This patch charges allocation of a slab object to a particular
> memcg.

I am wondering why you need all the other patches. The simplest approach
would just to hook into page allocation and freeing from the slab
allocators as done here and charge to the currently active cgroup. This
avoids all the duplication of slab caches and per node as well as per cpu
structures. A certain degree of fuzziness cannot be avoided given that
objects are cached and may be served to multiple cgroups. If that can be
tolerated then the rest would be just like this patch which could be made
more simple and non intrusive.
