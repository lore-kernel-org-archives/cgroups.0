From: Suleiman Souhlal <suleiman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Memcg Kernel Memory Tracking.
Date: Fri, 9 Mar 2012 22:25:58 -0800
Message-ID: <CABCjUKBZ_DLJC6Z4s33cFAmCYJW7uiee+ziwDydDZ7tYdWgM0A@mail.gmail.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:x-system-of-record;
        bh=FMwiIiY4gkQAtRmfF9jiBPIFVxcygempnhKphssynHo=;
        b=XyFoFFIE4ikRI/0EYY4OUlaq53wMHo7aCtiROILje/N2T4O+dHNYf3CtR1puDPr4pp
         DXCbniEtq0pLVx4t0Z+yY4O4IM/+gGB6NWfrYsXQyhP/CznEYtDoxVgekI+tD6YREmTM
         dGaogLblSXvvC2QpcBdoliikQm9GZaCAhgiriVjnK7/XiSroD8sXbrSBSotwnQLXbtTl
         IfU99YF8aoRdOG/vTHjCoF+K6EOTv1Z+LH+32/RkenWHXR9j/QGGCMvQDJxfr+xOX8kl
         dLU+Q5+nK+6dmNUjQdGEg7FZp+HDTsvh0TkXHwRd7ESUYfFjSWB/VSYEjwDK0JejC2Qd
         GSRg==
In-Reply-To: <1331325556-16447-1-git-send-email-ssouhlal-HZy0K5TPuP5AfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, dan.magenheimer-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Mar 9, 2012 at 12:39 PM, Suleiman Souhlal <ssouhlal-h+KGxgPPiopAfugRpC6u6w@public.gmane.org> wrote:
> This is v2 of my kernel memory tracking patchset for memcg.

I just realized that I forgot to test without the config option
enabled, so that doesn't compile. :-(

I will make sure to fix this in v3 and test more thoroughly.

Hopefully this shouldn't impede discussion on the patchset.

Sorry about that.
-- Suleiman
