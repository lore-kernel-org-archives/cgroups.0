From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [RFC PATCH 1/3] misc_cgroup: introduce misc.events and misc_events.local
Date: Thu, 9 Sep 2021 10:08:39 -0700
Message-ID: <CAHVum0eGN=v1kLqHQg7HBESp8Kg4aGZFNd4XTpxfeyToXPmPVg@mail.gmail.com>
References: <988f340462a1a3c62b7dc2c64ceb89a4c0a00552.1631077837.git.brookxu@tencent.com>
 <20210909143702.GA13761@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4R55HGCX5kPiIdGourKYRqDLwJwF8WpWPhWp89wjZ2A=;
        b=WFfYj9RQ/+CHwxP1EKydAwy0xyGRTKUWvF0EFylgCw0ummpVqqR+qlnHE+s3nGMV6H
         wNaPrKSGu0kuhKvxKWfgzSkrzk0UxkNFJozak3jVIUxe2Y+3X/V8L7sXP97u9eLsXyLr
         RnbvRWT28a4GkgJpXu/dG/sxpesgDHNLad6n4bn62ObFCt2BXe6Ivcx+AEBCTzI73F3f
         r4kknqIged7tVjFk6Q1n70H111zzqGzXRwWg55hm6vsEgYhXV8qsi04oNyVtONp8Wljt
         ee2XR2txI//CcTYgL+xIqkSHWzf2bT/xRXsQ89LxaL6nRIg9rI871PPoK25LrT6GnC3U
         lRpA==
In-Reply-To: <20210909143702.GA13761@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: brookxu <brookxu.cn@gmail.com>, tj@kernel.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Thu, Sep 9, 2021 at 7:37 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrote:
>
> Hello Chunguang.
>
> The new version looks like a good step generally.
>
> My main remark is that I wouldn't make a distinct v1 and v2 interface,
> it's a new controller so I think the v2 could be exposed in both cases
> (or in other words, don't create new v1-specific features).

I agree with Michal. We can have the same interface for v1 otherwise
there will not be any form of feedback in v1 for failures.

>
> On Wed, Sep 08, 2021 at 01:24:34PM +0800, brookxu <brookxu.cn@gmail.com> =
wrote:
> > +static int misc_events_show(struct seq_file *sf, void *v)
> > +{
> > +     struct misc_cg *cg =3D css_misc(seq_css(sf));
> > +     unsigned long count, i;
> > +
> > +     for (i =3D 0; i < MISC_CG_RES_TYPES; i++) {
> > +             count =3D atomic_long_read(&cg->events[i]);
> > +             if (READ_ONCE(misc_res_capacity[i]) || count)
> > +                     seq_printf(sf, "%s %lu\n", misc_res_name[i], coun=
t);
>
> More future-proof key would be
>                         seq_printf(sf, "%s.max %lu\n", misc_res_name[i], =
count);
> or
>                         seq_printf(sf, "max.%s %lu\n", misc_res_name[i], =
count);
>
> (Which one is a judgement call but I'd include the "name" of event type t=
oo.)
>
I am inclined more towards "%s.max", it looks nice to see the resource
name before its corresponding events.
