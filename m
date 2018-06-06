From: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] cgroup changes for v4.18-rc1
Date: Wed, 6 Jun 2018 08:04:38 -0700
Message-ID: <20180606150438.GM1351649@devbig577.frc2.facebook.com>
References: <20180605192157.GG1351649@devbig577.frc2.facebook.com>
 <CA+55aFzWdPavAPC--MY15RgwvU1QYgF+Uy7rMJmx2Dr3ddJdsQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=FJ0jGPDlz7OSwhJrrQRyksieajjAYhld+bCTfFQ1sXE=;
        b=q99Vup58WxcHqxRKaVyfTYQi2id6tZkbVoUH80OCSTPFp1MTIJEnEI/GSQuyk+Melw
         YVeSc8lm6O8uzAqIhpdwZNKw0PKvUPomQptp+p4Egfb2If8wLtM5GmxSQo49zRTW4Q/r
         VomZy1TZ4PHLOUbMia/CTwwBUo5LkpBv7chE43F3x8JJ84lWD4jcIkYinJCPCN6qQCgl
         vnDsoeJceLpS3PSzMa+K1R6ReKodIfV+uNDZhqJ8qWbHlpsIckVTdA0v5QWnDuTP5Kzo
         wptCHCny3UhAJuJsivnHYj+vwCZqJlFKlmc3AjnsviG5nlsFH+4QRl3Zh0uYGq7yv1a7
         o1+g==
Content-Disposition: inline
In-Reply-To: <CA+55aFzWdPavAPC--MY15RgwvU1QYgF+Uy7rMJmx2Dr3ddJdsQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>

Hello, Linus.

On Tue, Jun 05, 2018 at 05:13:55PM -0700, Linus Torvalds wrote:
> On Tue, Jun 5, 2018 at 12:22 PM Tejun Heo <tj@kernel.org> wrote:
> >
> > * cgroup uses file modified events to notify certain events.  A rate
> >   limiting mechanism is added.
> 
> This "explanation" didn't really parse for me at all.
>
> I edited the merge message to something that I think is correct and
> made more sense to me.

Heh, yeah, yours reads a lot better.  Sorry about that.  The
background is that the mechanism was first added to generate
notifications on events like cgroup becoming empty, which is very low
frequency.  Since then, we've expanded its usage to cover things like
memory.high breached events which can be a lot higher frequency.

The notification implementation isn't super light weight, so the patch
ratelimits the notifications by capping minimum notification interval
interval to 10ms.

Thanks.

-- 
tejun
