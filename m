From: yong w <yongw.pur-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] vmpressure: wake up work only when there is
 registration event
Date: Mon, 27 Sep 2021 23:43:04 +0800
Message-ID: <CAOH5QeBA7+W3Pc6z50mExv_3Zoh+v_4wrxweiRBsnsXN66gOmg@mail.gmail.com>
References: <1632491065-10785-1-git-send-email-wang.yong12@zte.com.cn> <YU3ciRm7L2p9lJo6@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qlcc/wRWjVCOzhNQn26TjPzzhllhlD0uZ0dcQsuvCOI=;
        b=Lghy197Op89Rz0QE1V1paJ2AHKVKbUHzvBosZt1g8cXNl6MJHK/V6ghe98wvxn63o/
         QLFPsjs2Mpgd2/ucdkJCvIpCb7tOi6ANPHQhn+Q1WQ3Eg7KjVHjdV2VQf1v3Npw37rMT
         q+d0a0jEsyDpdCoZ4DYaBU2FXVCjOI594qb1W28eeDT+KLiD0l2TTubBJhPClZYoUkv0
         ISc8vfyS/oLmUOEoRzsJbMpRNO1rH5XkT2MomxVAQIVrtiAsPP7AxytwknXsXSyqSCTp
         iXLaOBDiqnxtr+93ZrB4eBoZMqhaTFy683byNwuqRZdHmvsn4a+dNmf1ZHYXER0zA/z1
         EiZQ==
In-Reply-To: <YU3ciRm7L2p9lJo6-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, wang.yong12-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, yang.yang29-Th6q7B73Y6EnDS1+zs4M5A@public.gmane.org

> Your data still doesn't make any sense. I have asked about that in the
> previous submission and you haven't really clarified anything. How come
> your task-clock has almost doubled. You are likely not not comparing
> apples to apples or something weird is going on.
>
> This patch is not going to fly without a sensible data and analysis of
> that data.
I see. I'll try to test the optimization again.
Thanks a lot!
