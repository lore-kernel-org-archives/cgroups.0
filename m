From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 01/11] mm: vmscan: move inactive_list_is_low() swap
 check to the caller
Date: Thu, 7 Nov 2019 19:43:55 -0800
Message-ID: <20191107194355.c1a511b6b4da4cbbafbf0188@linux-foundation.org>
References: <20190603210746.15800-1-hannes@cmpxchg.org>
        <20190603210746.15800-2-hannes@cmpxchg.org>
        <CALvZod64t1OGuhrvB1QChUYvUs2yQF-qAi5F=gcntHN84rr=sQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573184635;
        bh=UyFRcER2CU7b2usXRZ6M6BFrcXtS8XVut2oA/vpT6MI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HgC8I55B+cni+z12bFD6e03F5aFRtA2tUpkdkxKQNIlacFiy9Zp3Qsie5vE9DmM53
         q2IfB5TrMpKZKTjkgDaak4c0JtjtPPwmoAsa814d6y8Sh68Chxg8GcTnxXdg2cwC+p
         mz4fe2CxlG4yNvRG2EpaoQEEUGoLNH9tLeqnBbTs=
In-Reply-To: <CALvZod64t1OGuhrvB1QChUYvUs2yQF-qAi5F=gcntHN84rr=sQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Team <kernel-team@fb.com>

On Wed, 6 Nov 2019 18:50:37 -0800 Shakeel Butt <shakeelb@google.com> wrote:

> On Mon, Jun 3, 2019 at 3:05 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >
> ...
>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>

hm, you appear to have reviewed a five month old version.  Hoping that
nothing changed too much, I added your review tags to the one week old
version ;)

