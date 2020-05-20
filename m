From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH mm v4 1/4] mm: prepare for swap over-high accounting and
 penalty calculation
Date: Tue, 19 May 2020 18:38:24 -0700
Message-ID: <CALvZod66pJ0iP40n+-N3wZCRiM7AuwcrMWx5nu5-ZEqhWzfoTA@mail.gmail.com>
References: <20200519171938.3569605-1-kuba@kernel.org> <20200519171938.3569605-2-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wp6yM374SAibTrarxPnW2QuRcQ8ZTv0Nb2h0Ye6/kEg=;
        b=uulinYLhsvfZVnTYwjEQphJFr342xI5I6a3rn5kvcU02c0T5EWd7KeyG1taB59rcr6
         lHLtdaknZUCThMfwoFb2bMFBouixn/8lQNcbXD16mvPEVfH3DZzrzR3fnNcyBL4NZZu4
         cClnAC67SoFzH87oGdTZPYEP3qjp/5J/A2acf+DUFBKb0Q75h7TH0DyG3eP5iku/AvY6
         MC9zgb4pC5wLyacw+AMwF98uyNJm/JlIDrRGrARSbZghkGeS2E9t77kSYLAHpQcCsZMi
         MzK8fk2Yp9h/SiCWzBAW1hvRLZaO4MPgofxbKTj8zA2CQ6XZlj2Amdcl0cP1Vwq/nL3k
         vnvw==
In-Reply-To: <20200519171938.3569605-2-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Kernel Team <kernel-team-b10kYP2dOMg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Tue, May 19, 2020 at 10:19 AM Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Slice the memory overage calculation logic a little bit so we can
> reuse it to apply a similar penalty to the swap. The logic which
> accesses the memory-specific fields (use and high values) has to
> be taken out of calculate_high_delay().
>
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
