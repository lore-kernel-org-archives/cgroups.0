From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/5] docs/cgroup: add entry for cgroup.kill
Date: Wed, 5 May 2021 09:29:42 -0700
Message-ID: <CALvZod5H4Gsm+KFyd5NtCvZL8xYfYDU2qDsvDr+-xnqoNgog=A@mail.gmail.com>
References: <20210503143922.3093755-1-brauner@kernel.org> <20210503143922.3093755-2-brauner@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sfw/1w27jQ+1kd1/o/ZKaoNFZdw2wrWkGNYntufubLI=;
        b=p2YSe1DV6VXC/+ln1rLPRfAlfTm62ZNdRtOCU0nslBEclFn5Fp/bYbHR/nXYzbreux
         mv/IKUSDCqW7kj8vpqfqNBnpkrv9R4J5YCwH8ZXd6/y18H6i9aByJpnFYGeqKGYaEsQn
         SRkvZgT0AKMy6fH8YDFi9j6ILxrgb8r1DYabgBm+Bl59frUOIGeHb5Hh/2uXfMknazDY
         bmofNuYL58HukPXDiTfHiRXcN5byb632bh3fmfcHwEAbimoddGeo5oF5yXnkOe0IoTEW
         IYZviC7CHHZP9VeRDm0QLIYQsVut+8uxSeslIel/nP6p9rH6w722p7iD+UVV608St+2O
         KbSQ==
In-Reply-To: <20210503143922.3093755-2-brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, containers-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Mon, May 3, 2021 at 7:40 AM Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> From: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
>
> Give a brief overview of the cgroup.kill functionality.
>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Signed-off-by: Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
