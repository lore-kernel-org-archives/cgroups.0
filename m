From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] sched/core: check format and overflows in cgroup2 cpu.max
Date: Tue, 5 Mar 2019 07:57:41 -0800
Message-ID: <20190305155741.GD50184@devbig004.ftw2.facebook.com>
References: <155125520155.293746.7017401430432481979.stgit@buzz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=syRrJyrzdH1UYbfxWfOIJvjLptgRVfLhLRUPUjg3L7s=;
        b=EQsCqpfidQxapqW9s4jBSno94ibaGoIcfxQ5cPy/5iS4QNTEI2HUd3D+HdCouw7hv3
         WQv+F3V3L9PfVu3e+0GY/cSN6HwnORmgD1+Kvze28M2njyJKa4UigfWN/dRXIU/jiuQg
         5sjH67N5QCuJ7SiOj4JgN44LJk9d338uIU0NjJpRUiIG3UOfP11HClkH8X3ztHLmDlZQ
         BRBVH69Xh+rPxNcQdzj7Qg5kmdF3/flssNQei9Dr6KAfQzfKFHR5dfzNzRI9O4MhRZ/w
         OixLjBtmcDMVU+y1NzeNYZ0XaH1EpwSJzjPoJYN0iEUqQw6GI+WbDboLBpMZqnLAb4Rx
         NGOQ==
Content-Disposition: inline
In-Reply-To: <155125520155.293746.7017401430432481979.stgit@buzz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, Ingo Molnar <mingo@redhat.com>

Hello,

On Wed, Feb 27, 2019 at 11:13:21AM +0300, Konstantin Khlebnikov wrote:
> Cgroup2 interface for cpu bandwidth limit has some flaws:
> 
> - on stack buffer overflow
> - no checks for valid format or trailing garbage
> - no checks for integer overflows
> 
> This patch fixes all these flaws.

Ditto as the blkio patch.  Unless there is a correctness problem, my
preference is towards keeping the parsing functions simple and I don't
think the kernel needs to play the role of strict input verifier here
as long as the only foot getting shot is the user's own.

Thanks.

-- 
tejun
