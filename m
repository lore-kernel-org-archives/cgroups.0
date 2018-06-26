From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 1/2] fs: fsnotify: account fsnotify metadata to kmemcg
Date: Tue, 26 Jun 2018 11:00:53 -0700
Message-ID: <CALvZod5ARMZL+eD8-mrxeBvxJcuVPXaCwWEgUyQw85xXWxHauA@mail.gmail.com>
References: <20180625230659.139822-1-shakeelb@google.com> <20180625230659.139822-2-shakeelb@google.com>
 <CAOQ4uxiV75+X3dMLS93iXqwmSU6eKPOUocdkXiR7MQZhEjotQg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=heX1f2CgGl3o496OINg/xkciw0CIxICRoeLjeNzNB8I=;
        b=blCmN+rB92ggkg97DX3WhoaU2AbUmshLBzwVLHRQPN/+/M8ilEObphnd1xr8/J+zsV
         AW8Rj8yOHxWnEljCjolT+El7uduYY88Bq/h3d9VPTmWkOFAjoNRLpYOhC+crvQOSq3RE
         zjr7sCZ1q7GwgVNlyasCg13F+XbWQC164E3byLPkx3e225YSUEyvyBtCaKwH94mf3RsC
         KGHvnm+EZD7rAIw25s4FMR6mNVRo9ZCZx9BnMndbPSoLmURDogisyU5aCIhf1YnqNnul
         84JWydFmIQQQYg+sq28n8zfcQeDlFu8U9for7PNm3+cB3LitFoPjxhyqtpDrKm6MRnUI
         c/VQ==
In-Reply-To: <CAOQ4uxiV75+X3dMLS93iXqwmSU6eKPOUocdkXiR7MQZhEjotQg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Jan Kara <jack@suse.cz>

On Mon, Jun 25, 2018 at 10:49 PM Amir Goldstein <amir73il@gmail.com> wrote:
>
...
>
> The verb 'unuse' takes an argument memcg and 'uses' it - too weird.
> You can use 'override'/'revert' verbs like override_creds or just call
> memalloc_use_memcg(old_memcg) since there is no reference taken
> anyway in use_memcg and no reference released in unuse_memcg.
>
> Otherwise looks good to me.
>

Thanks for your feedback. Just using memalloc_use_memcg(old_memcg) and
ignoring the return seems more simple. I will wait for feedback from
other before changing anything.

thanks,
Shakeel
