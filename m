From: Rami Rosen <roszenrami-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v9 2/6] cgroup: add support for eBPF programs
Date: Thu, 24 Nov 2016 00:46:46 +0200
Message-ID: <CAKoUArnq-DpwMJPdUutyR7fAhEN_6Spkw3NXkK5O=jZOQR8BXA@mail.gmail.com>
References: <1479916350-28462-1-git-send-email-daniel@zonque.org> <1479916350-28462-3-git-send-email-daniel@zonque.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=iXZoRCzg511e8D4cbH9KCkK6Gq6uKb71O/WMmRnYlrA=;
        b=DBZE4KZyZ1xcRj0QGfisOEZ27gH5qqLuzCZHQ6JNS03BLvYpHBrykyWk/wdGhhAUuB
         Dahw6BS1B86COMgdHfOSS6wSArk+dBTVxtWbfRFBsXc6g7BIhTe+APeC/AVFJoZyRK+6
         iuLvoj8d4Ef1hmG1G72AoHjN7Gn14sxXpWFPmfGRgIyhE4m7KgybZBgDzIYnNh9E8ySw
         EsmW4cUx0tJY0D3Y2gZ20xFUFPvdSmxs4PBBhkE8qB6RSj1a3eu/KnJq69gmLcQakXHv
         veTGaAHAh1/2clkg+kPpdgBng3lWBcpPon/Ce32AlBHjcxkgkXzCCwToEhNzNijlmpW2
         VgoA==
In-Reply-To: <1479916350-28462-3-git-send-email-daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Mack <daniel-cYrQPVfZoowdnm+yROfE0A@public.gmane.org>
Cc: htejun-b10kYP2dOMg@public.gmane.org, daniel-FeC+5ew28dpmcu3hnIyYJQ@public.gmane.org, ast-b10kYP2dOMg@public.gmane.org, David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, kafai-b10kYP2dOMg@public.gmane.org, fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org, pablo-Cap9r6Oaw4JrovVCs/uTlw@public.gmane.org, harald-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sargun Dhillon <sargun-GaZTRHToo+CzQB+pC5nmwQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Daniel,

A minor comment:

> +/**
> + * __cgroup_bpf_update() - Update the pinned program of a cgroup, and
> + *                         propagate the change to descendants
> + * @cgrp: The cgroup which descendants to traverse
> + * @parent: The parent of @cgrp, or %NULL if @cgrp is the root
> + * @prog: A new program to pin
> + * @type: Type of pinning operation (ingress/egress)
> + *
> + * Each cgroup has a set of two pointers for bpf programs; one for eBPF
> + * programs it owns, and which is effective for execution.
> + *
You have in the following section twice identical checks, for If @prog
is %NULL".
Shouldn't it be here (in the first case only) "If @prog is not %NULL"
instead "If @prog is %NULL"?

> + * If @prog is %NULL, this function attaches a new program to the cgroup and
> + * releases the one that is currently attached, if any. @prog is then made
> + * the effective program of type @type in that cgroup.
> + *
> + * If @prog is %NULL, the currently attached program of type @type is released,
> + * and the effective program of the parent cgroup (if any) is inherited to
> + * @cgrp.
> + *


Regard,
Rami Rosen
