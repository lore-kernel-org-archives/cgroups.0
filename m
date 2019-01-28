From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3] oom, oom_reaper: do not enqueue same task twice
Date: Mon, 28 Jan 2019 16:53:15 -0500
Message-ID: <20190128215315.GA2011@cmpxchg.org>
References: <6da6ca69-5a6e-a9f6-d091-f89a8488982a@gmail.com>
 <72aa8863-a534-b8df-6b9e-f69cf4dd5c4d@i-love.sakura.ne.jp>
 <33a07810-6dbc-36be-5bb6-a279773ccf69@i-love.sakura.ne.jp>
 <34e97b46-0792-cc66-e0f2-d72576cdec59@i-love.sakura.ne.jp>
 <2b0c7d6c-c58a-da7d-6f0a-4900694ec2d3@gmail.com>
 <1d161137-55a5-126f-b47e-b2625bd798ca@i-love.sakura.ne.jp>
 <20190127083724.GA18811@dhcp22.suse.cz>
 <ec0d0580-a2dd-f329-9707-0cb91205a216@i-love.sakura.ne.jp>
 <20190127114021.GB18811@dhcp22.suse.cz>
 <e865a044-2c10-9858-f4ef-254bc71d6cc2@i-love.sakura.ne.jp>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6fUmvSDmEjz08XKF0ToKqbVBrxXVRyHjyqapg2MBg6Q=;
        b=vc03nv96i0HISo7x2YIJjRidr5L5AP2IUQx6QxFgZmkIVUMJsMRy0c7TK3FrcHSURc
         aDa2L0TK5Pw30lt66CwIUbIRFXTIeZOeR5wYH0y3ZSoefARez89tTF1w08/hIiX/5Rlh
         GJjqcQ7j7h3kqaYtO+gCx58GfCaJU3ZPM0wKth+exXBNTulSBbeSLUaDHI0Ec3OnAg4g
         dByNON9C53Fc1E24EfHoaYt9+4l+UintuPdprpmzY+UswWd8CDo6bAtldH5kxOeofiZ1
         YBz7LQltzMI/JmZH1RSxBWnMzbc62P4Qaj5+NnVugVBXwh5S9CL0bDhvujlyxrbRU3I4
         LuFw==
Content-Disposition: inline
In-Reply-To: <e865a044-2c10-9858-f4ef-254bc71d6cc2@i-love.sakura.ne.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: Michal Hocko <mhocko@kernel.org>, Arkadiusz =?utf-8?Q?Mi=C5=9Bkiewicz?= <a.miskiewicz@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Aleksa Sarai <asarai@suse.de>, Jay Kamat <jgkamat@fb.com>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, linux-mm <linux-mm@kvack.org>

Hi Tetsuo,

On Sun, Jan 27, 2019 at 11:57:38PM +0900, Tetsuo Handa wrote:
> From 9c9e935fc038342c48461aabca666f1b544e32b1 Mon Sep 17 00:00:00 2001
> From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
> Date: Sun, 27 Jan 2019 23:51:37 +0900
> Subject: [PATCH v3] oom, oom_reaper: do not enqueue same task twice
> 
> Arkadiusz reported that enabling memcg's group oom killing causes
> strange memcg statistics where there is no task in a memcg despite
> the number of tasks in that memcg is not 0. It turned out that there
> is a bug in wake_oom_reaper() which allows enqueuing same task twice
> which makes impossible to decrease the number of tasks in that memcg
> due to a refcount leak.
> 
> This bug existed since the OOM reaper became invokable from
> task_will_free_mem(current) path in out_of_memory() in Linux 4.7,
> but memcg's group oom killing made it easier to trigger this bug by
> calling wake_oom_reaper() on the same task from one out_of_memory()
> request.

This changelog seems a little terse compared to how tricky this is.

Can you please include an explanation here *how* this bug is possible?
I.e. the race condition that causes the function te be entered twice
and the existing re-entrance check in there to fail.

> Fix this bug using an approach used by commit 855b018325737f76
> ("oom, oom_reaper: disable oom_reaper for oom_kill_allocating_task").
> As a side effect of this patch, this patch also avoids enqueuing
> multiple threads sharing memory via task_will_free_mem(current) path.
