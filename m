From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH]cgroup: __cpuset_node_allowed return bool
Date: Mon, 26 Mar 2018 07:12:12 -0700
Message-ID: <20180326141212.GI2149215@devbig577.frc2.facebook.com>
References: <d2f9fe6096235032f445ab88e562560f@codeaurora.org>
 <0fee75e4a1b12f5fca30e04306a95788@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=DV0XljT+VpLgutsVJsbTAVWAPtXZsBZeEaJ0JEY4fSE=;
        b=joQIA+WDuGZFIlaYnCdrhzFhm++KlY5ZPBF62ycUv4Z8M0UbMviOEe4oNW2InsowIy
         fRgFPCo6LQLkO/6vcetv8flm+Po7U4MCPf01W3mra63/c6MSVxVqaPtoKZwt8JWSVgD/
         BWnQMDs2jBa33sTwWOj5CRaqHBFvR17/fRm0YHNtA1MCfSMDdTT1WwmxGY7fVRISpbuv
         I5a4MAG5CLQjzGdJTZOZm/euYlG6Qw2Su+4V7iWNh27VulCFELdC6JDqocWpUjiXvSyz
         0zl8n58mEqyuqsVlVeIuAoiamzmXeBKVKxBzRhDj0q2hClthJWQOzbDamK/QVf1skAOF
         E3Cg==
Content-Disposition: inline
In-Reply-To: <0fee75e4a1b12f5fca30e04306a95788@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yuankuiz@codeaurora.org
Cc: cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, pkondeti@codeaurora.org, cgroups-owner@vger.kernel.org

Hello, John.

On Sat, Mar 24, 2018 at 01:05:50PM +0800, yuankuiz@codeaurora.org wrote:
> From 304cec1cc42255fbd9e231a810f4eea20ab74b90 Mon Sep 17 00:00:00 2001
> From: John Zhao <yuankuiz@codeaurora.org>
> Date: Sat, 24 Mar 2018 13:01:32 +0800
> Subject: [PATCH] cgroup: __cpuset_node_allowed return bool
> 
> as a bool, __cpuset_node_allowed(...) return should be bool.

So, as a minor cleanup patch, this is fine but can you please soften
the commit title / description a bit?  It doesn't have to be bool.
int is fine.  bool may be marginally more readable but that's about
it, so let's please make the commit match that.

Thanks.

-- 
tejun
