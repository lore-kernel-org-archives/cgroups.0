From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4.15-rc9] sched, cgroup: Don't reject lower cpu.max on
 ancestors
Date: Mon, 12 Feb 2018 09:24:58 -0800
Message-ID: <20180212172458.GF695913@devbig577.frc2.facebook.com>
References: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=v+/7YXMt/NQxb2RPdHE2vctIhSMcO7cDlI0c060R0rw=;
        b=i2LNCFwLGMwndfeu65sDZvSfpUWq94GKG6Wij26PlAj1KYJTZQ6vcf8CconWs3MJHt
         UeHang6WMUyAnJmWBs4kL7HxbYqUn4Y1pQzrvGJ2ivu0bwaLj/fuLPQRtW0AgqnrO8ny
         YGEHd5sarJuUjKb041t1Mj5qaKP5mLs8DylJ8MBUQcJ3Ttx/cF9gMbC4j7vYn2DpY1TY
         t3cWOk6ixy8yVB1lv8aPpG7EyTduckHXNyRyji11ptMz61Sou95Cc3jJ0xXr4sEiOMB0
         9k15eyAWZvBTuH78m4m2xjWNkLQWd7b73EAn5yDPV/rpzfgG6XgubOp/qAZEgB6cVugp
         9+cA==
Content-Disposition: inline
In-Reply-To: <20180122192618.GA1771050@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>

On Mon, Jan 22, 2018 at 11:26:18AM -0800, Tejun Heo wrote:
> While adding cgroup2 interface for the cpu controller, 0d5936344f30
> ("sched: Implement interface for cgroup unified hierarchy") forgot to
> update input validation and left it to reject cpu.max config if any
> descendant has set a higher value.
> 
> cgroup2 officially supports delegation and a descendant must not be
> able to restrict what its ancestors can configure.  For absolute
> limits such as cpu.max and memory.max, this means that the config at
> each level should only act as the upper limit at that level and
> shouldn't interfere with what other cgroups can configure.
> 
> This patch updates config validation on cgroup2 so that the cpu
> controller follows the same convention.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Fixes: 0d5936344f30 ("sched: Implement interface for cgroup unified hierarchy")

Applied to cgroup/for-4.16-fixes.

Thanks.

-- 
tejun
