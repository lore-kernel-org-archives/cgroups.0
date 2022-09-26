From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/4] mm: memcontrol: use do_memsw_account() in a few more places
Date: Mon, 26 Sep 2022 08:20:38 -0700
Message-ID: <CALvZod5BPO20mf2taEwGuF18e9tR3u=P7LMOAJJT5iuRjEJh=w@mail.gmail.com>
References: <20220926135704.400818-1-hannes@cmpxchg.org> <20220926135704.400818-4-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=Fddt9wdq/J6CWGu90+cFZ6uqg+vju1ZgOwGknKQrGms=;
        b=TgMFdscVjGqwG6aw8YINYC6hut/9EoC0pUZ1CZ/6dDVVoxWEhmoXyjgdSPeBA+iscl
         SM68MDTHPhtCbdHqyQXgP2dQJfYqYFonvFpgJG5iD9pVtQtutMoCCC5RjWuP8ouzDhDF
         ZF5/m2ejMr8gdSODmlJAColLtiUNdNji6QKIvP21zqnsbhsp6llxe1A1cNawNk7J4HAI
         77HMYtxhvL5R0utZmPF/o+c1nllwoOid2lDgktWsVDzjxASpyoJLFSyZxhTq3giIH1BT
         yGWDMoLuhS+dLb8ZQbvXS6bWU7eIbcIfqBV622xZRa19fnVpxcnyNRxg9onMkwGSs5Y3
         cfUg==
In-Reply-To: <20220926135704.400818-4-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, Sep 26, 2022 at 6:57 AM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org> wrote:
>
> It's slightly more descriptive and consistent with other places that
> distinguish cgroup1's combined memory+swap accounting scheme from
> cgroup2's dedicated swap accounting.
>
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
