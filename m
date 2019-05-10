From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] psi: Expose pressure metrics on root cgroup
Date: Fri, 10 May 2019 14:16:59 -0700
Message-ID: <20190510141659.08f58679c2eb3d321092dc23@linux-foundation.org>
References: <20190510174938.3361741-1-dschatzberg@fb.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557523020;
        bh=WrSi5jHV6SOltHTRjAOARni7OmFLSEe0K6ep9p6h53s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YNxRIaYgHUo1dWlD85ZFCIL5YSk3Cha+eYCoGs5AgoCUDVCBzesDOqhW3oY60AP1O
         ARNXJwykVG2EbSSoceQDX3qlwp0wm3LhS+fgUA3xdDskZL1P1OY/wToCjOfz7XYwk9
         n4L/v528+OlY1WjeYvlQLjXiYKlFWEp6Kr2gzaJs=
In-Reply-To: <20190510174938.3361741-1-dschatzberg@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Dan Schatzberg <dschatzberg@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, 10 May 2019 10:49:34 -0700 Dan Schatzberg <dschatzberg@fb.com> wrote:

> Pressure metrics are already recorded and exposed in procfs for the
> entire system, but any tool which monitors cgroup pressure has to
> special case the root cgroup to read from procfs. This patch exposes
> the already recorded pressure metrics on the root cgroup.
> 

Documentation/admin-guide/cgroup-v2.rst says "A read-only nested-key
file which exists on non-root cgroups". 
Documentation/accounting/psi.txt could do woth some clarification as
well.

