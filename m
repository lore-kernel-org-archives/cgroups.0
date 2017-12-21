From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [RFC PATCH] mm: memcontrol: memory+swap accounting for cgroup-v2
Date: Thu, 21 Dec 2017 07:33:03 -0800
Message-ID: <CALvZod59K7ZoM3jAGQih7HjVNJQBAgrTwZAxsSHqX1kHT6RYOA@mail.gmail.com>
References: <20171219152444.GP3919388@devbig577.frc2.facebook.com>
 <CALvZod5sWWBX69QovOeLBSx9vij7=5cmoSocdTUvh2Uq8=noyQ@mail.gmail.com>
 <20171219173354.GQ3919388@devbig577.frc2.facebook.com> <CALvZod7pbp0fFUPRnC68qdzkCEUg2YTavq6C6OLxqooCU5VeyQ@mail.gmail.com>
 <20171219214107.GR3919388@devbig577.frc2.facebook.com> <CALvZod5XRhXc3XrQw50Jw_OpRQB2iCCbgG-NMDCa8xRmGNdLrw@mail.gmail.com>
 <20171220193741.GD3413940@devbig577.frc2.facebook.com> <CALvZod7Z1Yh+ZhU8qxzSiN0Pph2R7O4Mki5E23FbJFAzhyCH8g@mail.gmail.com>
 <20171220233658.GB1084507@devbig577.frc2.facebook.com> <CALvZod7eQWrD6LgbUrOvuhf5A1KKxBaK5t-U61gdFqvMeWXuzQ@mail.gmail.com>
 <20171221133726.GD1084507@devbig577.frc2.facebook.com> <CALvZod432hzxPZgAypjPsZ33Z==0MxmMdPM3bEBZMea-7GFAVw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=xdORNI/wgaavozT2iSeqRMaUhuXhoi3UOfwVIWVaSoA=;
        b=cdtNqJX+pZVgKRlufQ+L6K596+1RMqd3FwzF2pCEC8bK6Pxl8okZ1yZTTwE+C3Wvdo
         JLEv2ClPXLWcJ9iMmZTxuPiEki5ApI0ZMLS0q4Xk6qiIyyM9/hht5ZEGFiXI0q3DEMUb
         uBdhddIWWWS3z2t23eaIfq+3/cKaRjGIYqwZVk35VrpK3PxJ/1oe0icl5YQA4CyFOAhe
         +tOnRSJ6eTQuT+5mObCVCZA/y68xbS4+WihMKhOTCJMlwB8H8DeWceVq1tFYWY5ufEyX
         4wvlQ48uj2T3c0R2miorqk/gVYlfS6yA+xj6gtRmswz51gjnpDrDFKe2k12pLkPFoIG7
         TAQg==
In-Reply-To: <CALvZod432hzxPZgAypjPsZ33Z==0MxmMdPM3bEBZMea-7GFAVw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, Li Zefan <lizefan@huawei.com>, Roman Gushchin <guro@fb.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org

> The swap (and its performance) is and should be transparent
> to the job owners.

Please ignore this statement, I didn't mean to claim on the
independence of job performance and underlying swap performance, sorry
about that.

I meant to say that the amount of anon memory a job can allocate
should be independent to the underlying swap.
