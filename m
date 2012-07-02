From: Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 0/4] Proposed slab patches as basis for memcg
Date: Mon, 2 Jul 2012 13:52:38 +0300 (EEST)
Message-ID: <alpine.LFD.2.02.1207021351210.1916@tux.localdomain>
References: <1339676244-27967-1-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=DTz2aAiJfkwBT80GKK/Dbj8E0DvvXzVP7Lo5LuaVBHQ=;
        b=FzAX8+jZlm9PYYqwmBewVPELA+DJTMqfTDzuj29gS0CTABQK3AqdOTL1soe5r8Qu18
         EOu67q7c1WFZnsjbpHG4vREfWxsg07+sxUo4sajyd7evOLZE5T0u5StAsm0KwKWsU1mo
         A4TdQgPSO83CGtVINKCAhmkhIcJ4xpUZQVFgCcWYpGpwPhTJQr0/pSxThWNUrCNQEXnK
         iM3KTyrqXV7uxZA10nPSJJstXcgzAjojM+7v1r8f7ZiDra/7GIYdhMNUSKc7xyAVqOL+
         M+mVd2A2U3vR9NqscrjjMSyOFNuXf2xbZ1/TPqzgg37R8Gb0JkACcJLVXeGUfp5mrD5R
         xgpg==
In-Reply-To: <1339676244-27967-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Cristoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, 14 Jun 2012, Glauber Costa wrote:
> These four patches are sat in my tree for kmem memcg work.
> All of them are preparation patches that touch the allocators
> to make them more consistent, allowing me to later use them
> from common code.
> 
> In this current form, they are supposed to be applied after
> Cristoph's series. They are not, however, dependent on it.
> 
> Glauber Costa (4):
>   slab: rename gfpflags to allocflags
>   provide a common place for initcall processing in kmem_cache
>   slab: move FULL state transition to an initcall
>   make CFLGS_OFF_SLAB visible for all slabs
> 
>  include/linux/slab.h     |    2 ++
>  include/linux/slab_def.h |    2 +-
>  mm/slab.c                |   40 +++++++++++++++++++---------------------
>  mm/slab.h                |    1 +
>  mm/slab_common.c         |    5 +++++
>  mm/slob.c                |    5 +++++
>  mm/slub.c                |    4 +---
>  7 files changed, 34 insertions(+), 25 deletions(-)

I applied the first patch. Rest of them don't apply on top of slab/next 
branch because it's missing some of the key patches from Christoph's 
series. Did anyone fix them up while I was offline?

			Pekka
