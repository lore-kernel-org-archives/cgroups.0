From: KOSAKI Motohiro <kosaki.motohiro-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/3] make clone_children a flag
Date: Sun, 11 Dec 2011 13:58:49 -0500
Message-ID: <4EE4FD69.1080609@gmail.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-4-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=aBiwgK+eJk6pTMIO2DMU+X4Q7eYcM4LDL+uanlYCiy8=;
        b=SVfCWf6SRgRvynhKwbLPHxC6PMkZ74uWpMoUB8lUg0bhi5TtBwmlRikKy9B7QCZUNf
         X2GzJagRxzp+QI3Ddyx6NRs/zohiY3KrQEfSg9yKtO4mS1SzomnlOIV002M6uyqH9isP
         IvK5ZWsL8jClmxilJhP97jwGN/ffurnFTnsnY=
In-Reply-To: <1323614738-7405-4-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

(12/11/11 9:45 AM), Glauber Costa wrote:
> There is no reason to have a flags field, and then a separate
> bool field just to indicate if the clone_children flag is set.
> Make it a flag
> 
> Signed-off-by: Glauber Costa<glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> ---
>   kernel/cgroup.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)

Reviewed-by: KOSAKI Motohiro <kosaki.motohiro-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
