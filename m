From: Aleksa Sarai <asarai-l3A5Bk7waGM@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: allow management of subtrees by new cgroup
 namespaces
Date: Mon, 2 May 2016 19:32:24 +1000
Message-ID: <57271EA8.5080104@suse.de>
References: <1462110065-4904-1-git-send-email-asarai@suse.de>
 <1462110065-4904-2-git-send-email-asarai@suse.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462110065-4904-2-git-send-email-asarai-l3A5Bk7waGM@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dev-IGmTWi+3HBZvNhPySn5qfx2eb7JE58TQ@public.gmane.org, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>

> +	 * 3. cgroup core doesn't allow tasks to be migrated by users that have
> +	 *    write access to two subtrees unless they also have write access to
> +	 *    the common ancestor of the two subtrees. Thus you cannot use a
> +	 *    complicit process in less restrictive cgroup to overcome your own
> +	 *    cgroup restriction.

It appears this restriction isn't actually being applied on cgroupv1. 
I'll send an updated patch which makes sure the cgroup.proc common 
ancestor restriction is enforced for all hierarchies.

-- 
Aleksa Sarai
Software Engineer (Containers)
SUSE Linux GmbH
https://www.cyphar.com/
