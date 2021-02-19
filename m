From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: charge before adding to swapcache on swapin
Date: Fri, 19 Feb 2021 14:49:09 -0800
Message-ID: <CALvZod5-wiSX8BkUAxNAOU-61e+0KNWm0hdQKhe+qtrFgPsb1g@mail.gmail.com>
References: <20210219224405.1544597-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H1+QL0ZJy98i2Loy47lzBuvz+WCAjo4otcQSOPkGKDA=;
        b=RBW0QcSz6mlJhrzmI044HVf7H33xiie7VtzMqoPyUVPUiCzWMDQlVd+JAdD4kCeq8E
         uCfrpsfg9/5IaESjoFjbMc7Dh2FA52tNPJgq8D+hfk8e2j6UptbbK1+yVtlABlPBTJvO
         hLA6qmg4uxx8NEq1MkKiLPMcBd0MbSt97SKQgU8UP710+LCCkKHNeEFwhLvmFSOvSFBd
         RcWplb3E9ycnwIszyXRY+ynXKuCvanhLGgsAYYN5OubASSVn7DlAfsf1HD/h9j3D4Hme
         nLdx+H4S3kDYJ1gVVEHElHZg4/JXwWbspaMQpkdIo46ruSd+SyMMT13vFr0BiPhQMVRa
         LSsA==
In-Reply-To: <20210219224405.1544597-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 19, 2021 at 2:44 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
[snip]
>  mode change 100644 => 100755 scripts/cc-version.sh
[snip
> diff --git a/scripts/cc-version.sh b/scripts/cc-version.sh
> old mode 100644
> new mode 100755

Please ignore these unintended mode changes. I will remove these in
the next version.
