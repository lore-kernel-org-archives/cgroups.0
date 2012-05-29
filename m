From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 13/28] slub: create duplicate cache
Date: Tue, 29 May 2012 14:55:49 -0500 (CDT)
Message-ID: <alpine.DEB.2.00.1205291454030.2504@router.home>
References: <1337951028-3427-1-git-send-email-glommer@parallels.com> <1337951028-3427-14-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205290932530.4666@router.home> <4FC4F1A7.2010206@parallels.com> <alpine.DEB.2.00.1205291101580.6723@router.home>
 <4FC501E9.60607@parallels.com> <alpine.DEB.2.00.1205291222360.8495@router.home> <4FC506E6.8030108@parallels.com> <alpine.DEB.2.00.1205291424130.8495@router.home> <4FC52612.5060006@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s1024; t=1338321353; bh=7JEAgcbSYY69IKovl401rkA0bt2ozfocsI5NWeMXNmM=; h=X-Yahoo-Newman-Property:X-YMail-OSG:X-Yahoo-SMTP:Received:Received:Date:From:X-X-Sender:To:cc:Subject:In-Reply-To:Message-ID:References:User-Agent:MIME-Version:Content-Type; b=ijnfTuXLgUnK+drmlcq08cQqHIUEj+UiD7uFrj0atg1/cPC2audZZ7llN+gm+pdrj3XcDzzoAoWrKY2Fnj5DVBPmvObvy27HyZu8WYaVEVs/8DJ40cWXq1i5Ewdt9buXfzf5/0iA+aau/eboBv4wZV+Kbp7b65Bh45F7QuW3puA=
In-Reply-To: <4FC52612.5060006-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pekka Enberg <penberg-bbCR+/B0CizivPeTLB3BmA@public.gmane.org>

On Tue, 29 May 2012, Glauber Costa wrote:

> I don't know about cpusets in details, but at least with NUMA, this is not an
> apple-to-apple comparison. a NUMA node is not meant to contain you. A
> container is, and that is why it is called a container.

Cpusets contains sets of nodes. A cpusets "contains" nodes. These sets are
associated with applications.

> NUMA just means what is the *best* node to put my memory.
> Now, if you actually say, through you syscalls "this is the node it should
> live in", then you have a constraint, that to the best of my knowledge is
> respected.

Eith cpusets it means that memory needs to come from an assigned set of
nodes.

> Now isolation here, is done in the container boundary. (cgroups, to be
> generic).

Yes and with cpusets it is done at the cpuset boundary. Very much the
same.
