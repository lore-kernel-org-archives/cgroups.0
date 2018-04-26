From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] cgroup/for-4.17: Make cgroup_rstat available to
 controllers
Date: Thu, 26 Apr 2018 14:35:33 -0700
Message-ID: <20180426213533.GW1911913@devbig577.frc2.facebook.com>
References: <20180323231313.1254142-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nNNxkHwrOTuLcVh0bR6D1LlBdNl/pfD6BNbilPT4aKk=;
        b=AbE1cVlhmLd3mRJwG+VtuGfhAcBCHchwVLf1Hm68qrx3HYUlvfSHqCXLoZS99xk34F
         oepZEbbtn2vOvtyiwQbS6ulyF9uOivS1uWUvd9zh686LVK63xQgU9NHBPF3bSwSrrRdu
         KFJa+2JvSeIUZEXNn7hdmSKbyVvSNKmtvPVRe1YYy5unbVFPGv94ZYj8ouAPKljpffWl
         6qZd+GXdHNe2AiGMQlCxpexRmGHWuEvv8vMt+ahr+27Mff1aveu8wuuI2sh9MMfmcBbF
         uRO1CJRSJmfFBsBfSZdJ/zo/X/hXRElOdJVMz/Po2j3H7waEuFEZeuf8RQ8qiOeHCHAo
         Y5nA==
Content-Disposition: inline
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com

On Fri, Mar 23, 2018 at 04:13:05PM -0700, Tejun Heo wrote:
> Hello,
> 
> cgroup has scalable recursive stat mechanism implemented in
> kernel/stat.c.  It's currently only used to track cpu consumptions and
> difficult to use outside of cgroup core.  This patchset generalizes
> the mechanism and exposes it as cgroup_rstat so that controllers can
> use it.
> 
> This patchset contains the following eight patches.  A follow-up
> patchset will add usages.
> 
>  0001-cgroup-Rename-kernel-cgroup-stat.c-to-kernel-cgroup-.patch
>  0002-cgroup-Rename-stat-to-rstat.patch
>  0003-cgroup-Distinguish-base-resource-stat-implementation.patch
>  0004-cgroup-Reorganize-kernel-cgroup-rstat.c.patch
>  0005-cgroup-Factor-out-and-expose-cgroup_rstat_-interface.patch
>  0006-cgroup-Replace-cgroup_rstat_mutex-with-a-spinlock.patch
>  0007-cgroup-Add-cgroup_subsys-css_rstat_flush.patch
>  0008-cgroup-Add-memory-barriers-to-plug-cgroup_rstat_upda.patch

Applied 1-8 to cgroup/for-4.18.

Thanks.

-- 
tejun
