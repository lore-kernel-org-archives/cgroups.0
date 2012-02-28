From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/10] memcg: Kernel Memory Accounting.
Date: Tue, 28 Feb 2012 10:49:46 +0200 (EET)
Message-ID: <alpine.LFD.2.02.1202281043420.4106@tux.localdomain>
References: <1330383533-20711-1-git-send-email-ssouhlal@FreeBSD.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=I0HjgLJ3ZIMfi+W94CxHyHXSSxzrBtbNJ4k5Pp+CaLg=;
        b=qWA+Dk66/EA/5GPV3frll6QXU9q+ZZqi3nxVDlWct00dt40Jb/BGEgJxcO5acndhJT
         85ZLrK60vLyX3tXHwBzY7esMWXFsayV877MRJsIJEBq1L+6dTQSTL0wCCgOOHKuq9YJ2
         /eszWXeKM9kUBvaETe9jnHGDAVsJLDbOXAkAQ=
In-Reply-To: <1330383533-20711-1-git-send-email-ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suleiman Souhlal <ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, 27 Feb 2012, Suleiman Souhlal wrote:
> The main difference with Glauber's patches is here: We try to
> track all the slab allocations, while Glauber only tracks ones
> that are explicitly marked.
> We feel that it's important to track everything, because there
> are a lot of different slab allocations that may use significant
> amounts of memory, that we may not know of ahead of time.
> This is also the main source of complexity in the patchset.

Well, what are the performance implications of your patches? Can we 
reasonably expect distributions to be able to enable this thing on 
generic kernels and leave the feature disabled by default? Can we 
accommodate your patches to support Glauber's use case?

			Pekka
