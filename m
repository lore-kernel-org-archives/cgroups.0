From: Tejun Heo <tj@kernel.org>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 09:45:22 -0800
Message-ID: <20180110174522.GJ3668920@devbig577.frc2.facebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
 <20180110124407.GA26913@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=0LzizYxfK6rJFvLhi0m8C6tnjwr7VFK6OP9uA/EScyk=;
        b=aqdWreFXw69Bbq+FpJu49PLtc0X0WM0BoS2zFF/SD6mCo8UnL2GWX3ISmAGjYHuDTG
         6GbKV4cwOPS9nsJoxR2y+aNMB4dnucZQShbhJhNJN0jT0fEcorflmR5CbGKvLFDGseoA
         quY9oFcv3xVO/NPJezZlGKbMlBD4us9Yd8q0fn0WWVZ/W3uMT1iuW5emcJd87Zm9+EVt
         IqP6zDPLYdb+ihCMpIjS8xg/UMCxogERBtqcv3wdt1hT9HfseBCoaO1Vc5V7JRzuDJ6D
         WbtXJTRBiaZbHc8hhBqn2Ht7MBIrWcyFI76y6Ne3/c0hYTO7XTlxWD2UuqHp+cgHAzDZ
         mFMA==
Content-Disposition: inline
In-Reply-To: <20180110124407.GA26913@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

On Wed, Jan 10, 2018 at 04:44:14AM -0800, Roman Gushchin wrote:
> From fdf19edb6e9594e48e89d4510767b9eb6ca2d9dd Mon Sep 17 00:00:00 2001
> From: Roman Gushchin <guro@fb.com>
> Date: Wed, 10 Jan 2018 04:35:12 -0800
> Subject: [PATCH] cgroup: make cgroup.threads delegatable
> 
> Make cgroup.threads file delegatable.
> The behavior of cgroup.threads should follow the behavior of cgroup.procs.
> 
> Signed-off-by: Roman Gushchin <guro@fb.com>
> Discovered-by: Michael Kerrisk <mtk.manpages@gmail.com>
> Cc: Tejun Heo <tj@kernel.org>

Applied to cgroup/for-4.15-fixes.

Thanks.

-- 
tejun
