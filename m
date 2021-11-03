From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] cgroup: rstat: Mark benign data race to silence KCSAN
Date: Wed, 3 Nov 2021 10:39:04 -0700
Message-ID: <CALvZod5yLyuagfmG4LpAkNihMhisioYXnruKL7GA3owOTSvy-g@mail.gmail.com>
References: <20211103165845.38226-1-mkoutny@suse.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8w2VytewPeRX4QkQuUg/BDVtpcxVWCV69c3Z6Wv2sj4=;
        b=kWIx5CS8nvY10TsruGTm4C3fKrM9wXsuvooi2CRs+RYshqzqTzNF0+zH+R36YM1KlG
         SXfOVbgb6TD5u3JxH7olKllrHzG6It7/DWNDjtiH6i7IGeC8VO26drKULHHoTboLtZqr
         qt6acogm5Cw/YIO1D0fm+BHOtNKGbrIkhMajJNiNOM0CHv3OUXeA/JAyXansys5U55At
         D5CyNObB1Mxv4G39O+PuDZVtGKecvzxA0M5Hd3/Weo/TEztQZP5T57VuPaX/aGBBGdHw
         VMOGod5Y4HRwZSVvrWpcFL9AePxL6Vmq4JCuYYm2vgg9x9JX2Ecxpqz7znCnzZDjLfYT
         QOEw==
In-Reply-To: <20211103165845.38226-1-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Hao Sun <sunhao.th@gmail.com>, linux-kernel@vger.kernel.org

On Wed, Nov 3, 2021 at 9:59 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> There is a race between updaters and flushers (flush can possibly miss
> the latest update(s)). This is expected as explained in
> cgroup_rstat_updated() comment, add also machine readable annotation so
> that KCSAN results aren't noisy.
>
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Link: https://lore.kernel.org/r/CACkBjsbPVdkub=3De-E-p1WBOLxS515ith-53SFd=
mFHWV_QMo40w@mail.gmail.com
> Suggested-by: Hao Sun <sunhao.th@gmail.com>
>
> Signed-off-by: Michal Koutn=C3=BD <mkoutny@suse.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
