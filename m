From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH RFC 1/3] cgroup: list all subsystem states in debugfs
 files
Date: Mon, 13 Aug 2018 06:48:42 -0700
Message-ID: <20180813134842.GF3978217@devbig004.ftw2.facebook.com>
References: <153414348591.737150.14229960913953276515.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3fY520pK3MVFPuA8Ln4OHGZP00waF5d15Pwyeg+Ytn8=;
        b=hUYQkC3/S6+l5kvwBkMQDaPxUkwku2LiPeZqhpuv27PCvmRd/HvWPkoNCPx3mlaaRn
         7kkcZ6y1BMtfKlLGxjbJhKkpMwMio50GAcDr1K6lVdYStKqRCeLBG37psUDU++4ukXaY
         aF0nvgCvh42hC5SQQlzl8p7SdSQdTflDV73lrNI1MnFK0pJHgHNI0ob3MPjkozhatKgG
         pMg6KmmuveUEn91JRzGLcyocX7JG8rGRf9PDNup5E+FedYFigwatgPook4jRvRNCiZff
         lPYSZSLEIOAiDgD1x2nunW59dJPmnnh9NO54bEnEO5aYaaBiXzVyu0Z4Qo0P3j81eaiN
         UzcQ==
Content-Disposition: inline
In-Reply-To: <153414348591.737150.14229960913953276515.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Johannes Weiner <hannes@cmpxchg.org>

Hello, Konstantin.

On Mon, Aug 13, 2018 at 09:58:05AM +0300, Konstantin Khlebnikov wrote:
> After removing cgroup subsystem state could leak or live in background
> forever because it is pinned by some reference. For example memory cgroup
> could be pinned by pages in cache or tmpfs.
> 
> This patch adds common debugfs interface for listing basic state for each
> controller. Controller could define callback for dumping own attributes.
> 
> In file /sys/kernel/debug/cgroup/<controller> each line shows state in
> format: <common_attr>=<value>... [-- <controller_attr>=<value>... ]

Seems pretty useful to me.  Roman, Johannes, what do you guys think?

Thanks.

-- 
tejun
