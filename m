From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: rstat: optimize flush through speculative test
Date: Mon, 4 Oct 2021 11:35:12 -0700
Message-ID: <CALvZod6fwur--Q6Kh6GSPRR_16DQdrNDyuZgYjgncDpPUENWVg@mail.gmail.com>
References: <20210929235936.2859271-1-shakeelb@google.com> <YVszNI97NAAYpHpm@slm.duckdns.org>
 <CALvZod5OKz=7pFpxCt1CONPyJO4wR5t+PH0nzdbFBT1SYpjrsg@mail.gmail.com>
 <YVs9eJnNJYwF/3f3@slm.duckdns.org> <CALvZod47r=9j_MhZz9ngWv_JE4oqF1CrXTOQ2GpSSNFftZAsVA@mail.gmail.com>
 <YVtGHoboSix3rexr@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=q3rtjAMF0s155PLuGLifQ498nM8uqHQjjd2W39f9bKM=;
        b=dNO+T06bp6n0e4wCqt2yTEMB3F80fM9Vgzh5jpZIO6mwe3DQMRXOaOdLXC2M1lh9Dq
         mE8zj3N4kaJpFMlMmObQxrMYzYFijF3w/RodiCCzivMxJEkMGTHT9reE2Z2XmAQUHNUB
         qBSFXy+3wiqJxSgNsmPxHifuceiJzF4H8lZLVfvrvY1Xk8lF8SdxcV9M8EtOmN0tT0c6
         LSwA2ZHu9+qtrj9c/MDnNYT3a/aS6l3z3CvSBMjGEDRnzK9LjpdHqL57qmotS9zmJekZ
         zyiWkTFDoth+KvmXIYzXgu+DnWmUElPhq7/W47WaMfHA7Sj87eZwJEUkCSy+IPjbnlDL
         ud5Q==
In-Reply-To: <YVtGHoboSix3rexr-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Oct 4, 2021 at 11:21 AM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>
[...]
> What do you think about that approach? While the proposed patch looks fine,
> it kinda bothers me that it's a very partial optimization - ie. if flush
> frequency is high enough for this to matter, that for_each_possible_cpu()
> scanning loop really isn't appropriate.
>

Makes sense. I will take a stab at that.
