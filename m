From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: speedup memory cgroup resize
Date: Mon, 5 Dec 2022 08:32:41 -0800
Message-ID: <CALvZod7_1oq1D73EKJHG1zQpeUp+QTPHmMRsL3Ka0f6XUfO4Eg@mail.gmail.com>
References: <1670240992-28563-1-git-send-email-lirongqing@baidu.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0PmNCTsJvxvDZkgjesfJCZeYmU+d2L5HAvI1G9E1wU0=;
        b=hzi9C2SeIoAe+8utJLZkRl5OJn8tSGX5qRPD5dh4gB67VBShqwIDTtup25L/ShHWq4
         qE99izmvwdghDESkJxAEZVDQqVAUXiGaOg+BVzXwAkOozxt05+d6ov0t8NR89LqGpHJs
         sT/jcL0n+bxPA6MtVxnvQqAmqaCYBGCRxm7RP9wQ2vRvrjVQw5bWZ2kfj9zp4ynkX0hF
         Z2rwttKysXQ9yS6wDqKBrbxtBtNhQQnKRpt9wCxXC46S8KCE0rTYBJ7+2tiadJK9I2lL
         wMkz3XnzixqIWhd+TYYxxy3EimRctwyVS5KqOwqMx7COrCbXii8SmsLtiTdmAtSebfDH
         uZDQ==
In-Reply-To: <1670240992-28563-1-git-send-email-lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

On Mon, Dec 5, 2022 at 3:49 AM <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org> wrote:
>
> From: Li RongQing <lirongqing-h1bp6feCCZcAvxtiuMwx3w@public.gmane.org>
>
> when resize memory cgroup, avoid to free memory cgroup page
> one by one, and try to free needed number pages once
>

It's not really one by one but SWAP_CLUSTER_MAX. Also can you share
some experiment results on how much this patch is improving setting
limits?
