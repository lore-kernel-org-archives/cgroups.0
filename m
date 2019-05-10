From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] psi: Expose pressure metrics on root cgroup
Date: Fri, 10 May 2019 14:23:58 -0400
Message-ID: <20190510182358.GA14027@cmpxchg.org>
References: <20190510174938.3361741-1-dschatzberg@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sKS5Fj/EEtSMbliwSHz31jl5UWhgaLLNKzcdv3HiOg8=;
        b=AgdKZn6HYNv221xca0XVSBa2lJs6g9ZN/fDhC0UKtfgh86gPpSKySDa8EHoKdAkwXh
         OPUbb6rjj/0vZD/52ALcm64YAno6w2qlc0fZjC556wrBTip/57WnH2tDAaXD5ez1ykP8
         6Bp99KZjroFrISTsE/THxKq7QrHKJtfroBoHARBah1Wh6GBCOWku+dgatZbZfhyf0eB0
         AN5ykQG4Lvlbb9jLvV1MuBig9RfA6zoMDp19p9oQcsaMcNuI8AQdk0XWpINbpniDzEs0
         wsXTfIJ2mhbB3kKPHj+HwVBWOY/vqx1LhxJRZhVqxJ7lb3HYOLWt381D0k7h8ebVtWZ9
         EfFg==
Content-Disposition: inline
In-Reply-To: <20190510174938.3361741-1-dschatzberg@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <dschatzberg@fb.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, May 10, 2019 at 10:49:34AM -0700, Dan Schatzberg wrote:
> Pressure metrics are already recorded and exposed in procfs for the
> entire system, but any tool which monitors cgroup pressure has to
> special case the root cgroup to read from procfs. This patch exposes
> the already recorded pressure metrics on the root cgroup.
> 
> Signed-off-by: Dan Schatzberg <dschatzberg@fb.com>

Looks good to me, thanks Dan!

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
