From: chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org (Laurent Chavey)
Subject: Re: [PATCH] net: fix sock_clone reference mismatch with tcp memcontrol
Date: Fri,  6 Jan 2012 13:14:23 -0800 (PST)
Message-ID: <20120106211423.967A716F64A@chavey.mtv.corp.google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=to:cc:subject:message-id:date:from;
        bh=oNUdtEPZOgai0RYyo4cTjVPGYxXdPS8ysnD0t8b4lhA=;
        b=nQ+bw17ggUH5XUJbxDvehqlFEpCPZXtRZGghbuHnIinKpZI94J5T7yJR07O55jWaT5
         eji7FUMagP7pFMD9zAXwQgih/fMkO0KjMn+wXzV8Wo2kMBsyIn9Rma3lqqO1MrabIKVR
         uEgn7tojJZhf3Q5jUlpxnV/3tyoQ/AErKtxwo=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Laurent Chavey <chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

> Sockets can also be created through sock_clone. Because it copies
> all data in the sock structure, it also copies the memcg-related pointer,
> and all should be fine. However, since we now use reference counts in
> socket creation, we are left with some sockets that have no reference
> counts. It matters when we destroy them, since it leads to a mismatch.
>
> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> CC: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
> CC: Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> CC: Hiroyouki Kamezawa <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
> CC: Laurent Chavey <chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
>
> ---

Tested-by: Laurent Chavey <chavey-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
