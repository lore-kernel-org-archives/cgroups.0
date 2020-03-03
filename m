From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH 0/2] Support user xattrs in cgroupfs
Date: Tue, 3 Mar 2020 08:50:54 -0800
Message-ID: <CALvZod5m3otRRqcLBebbgiZbhoYWAMbMg+ESkacJuj64OP=H4Q@mail.gmail.com>
References: <20200303013901.32150-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qHOn5vqQErDHAkJzL6biRHoTSOSlgdzSHmMDR1rwOSw=;
        b=PrhC/74bze2iem1KsYtIHMvUu/v2Av2MYk8EydsyRsT6ErJ1YQjmNh0R/wDKNLwWyQ
         giq1Pswj3xm3xsbBxVlb00LD6jgh8VspNAcUdojVVHgzs6YNMORKfgfiLcxXKihiD2U4
         VPumlwmRJK94sUJBBlqZZYGZUQDwIbA2T5iHVgWPvH96kjWeV0LugsEESIk6ALCIRDQm
         RBXbpHeIFbrG+TdqIZuAbNbugBhyCIMZGQaFYAf3mlAz6FH7d7jAZcPCS1yweB7G38bo
         a3New9pxIAHaKb1Yr5Al4Jz6nhSG737F7DafcGI95pWkYx4GRRGQsLd7Cs4k3E6agMnj
         8xSg==
In-Reply-To: <20200303013901.32150-1-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu@dxuuu.xyz>
Cc: Cgroups <cgroups@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Kernel Team <kernel-team@fb.com>

Hi Daniel,

On Mon, Mar 2, 2020 at 5:42 PM Daniel Xu <dxu@dxuuu.xyz> wrote:
>
> User extended attributes are useful as metadata storage for kernfs
> consumers like cgroups. Especially in the case of cgroups, it is useful
> to have a central metadata store that multiple processes/services can
> use to coordinate actions.
>
> A concrete example is for userspace out of memory killers. We want to
> let delegated cgroup subtree owners (running as non-root) to be able to
> say "please avoid killing this cgroup". In server environments this is
> less important as everyone is running as root.

I would recommend removing the "everyone is running as root" statement
as it is not generally true.

Shakeel
