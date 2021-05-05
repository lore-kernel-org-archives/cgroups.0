From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/5] tests/cgroup: move cg_wait_for(), cg_prepare_for_wait()
Date: Wed, 5 May 2021 09:43:17 -0700
Message-ID: <CALvZod51giGe2_MsHHp=7czY0rKdXBRMi-Ug-oc5avgFwhFaVQ@mail.gmail.com>
References: <20210503143922.3093755-1-brauner@kernel.org> <20210503143922.3093755-4-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9uYZs26n/wyQy1YB8Ay0KGcQh6u0u3FYwEcGuskdOQ8=;
        b=vuuG/mWR6GfoQ9g+2kdjgPJ71W6uK0U4PA6MFirzClqWduHDBDZ0DcmKif+sj7YM5z
         r4lBFW5HF9yY7cI7fqo7GTg9eSfkPfvdWAQKOu3qwoXtRxmJBMXkAqaWmZ6jM2iWeOaF
         UBUn4Xs/LTmsVAttnxgcsqc/7YRmcioCRFI44pInVVdpYYAYeS+BGlSHNWEWbfhO3URH
         FXmRWSnutnQgkHbjOTwbc9a08CpB8HJxJOP3ntRMH8d4r8MJyBeBb6g9VOwxdF6N0BAW
         8pqDgZx3Xt0QqpiUyC8VIOn82dJTB4xsNEkTKGIFEEkuPiZloQP0G/Pt3QbfVN1TbcIU
         pDXw==
In-Reply-To: <20210503143922.3093755-4-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Mon, May 3, 2021 at 7:40 AM Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
>
> as they will be used by the tests for cgroup killing.
>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
