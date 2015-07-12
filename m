From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2 block/for-4.2/writeback] ext4: implement cgroup
 writeback support
Date: Sun, 12 Jul 2015 14:05:20 -0400
Message-ID: <20150712180520.GE18734@mtj.duckdns.org>
References: <1434495193-31182-1-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=dSbM0e60g27z/vuzbVj82cAGkvm9cZ3Wvrzt+wub5CQ=;
        b=M/OYsljawbYxBebWf0Um9rjuqJ3Lq1srnYoffqNm1Hm6rvAaIW1c9I489UE7IPGHVZ
         zFIgYOu9OJL5jvxeU4eLxPu6LFkmBcPombJKF7tJMaVKeRSpwOIoveieNV9G6WBK+MWX
         ZJ28iAfynB2gTjzmgwhRivTmq3q1FDk//JjZFLnoxKpyV2M2t0nHjwB2C2jBbf/TmJ0X
         NH+9F5LVFZdkLm78VnUZ4M0MM5xxutDLDRo78nWMZocC0ffMzfCI804yzDSinDwf/1P/
         EyVVAvYPR4yYmi2UW/T9YSraBLISQN1dOe32cYVfZZjb2lmcyXIBxYiCz+PbBdKcXmXG
         4kdQ==
Content-Disposition: inline
In-Reply-To: <1434495193-31182-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org

Hello,

On Tue, Jun 16, 2015 at 06:53:11PM -0400, Tejun Heo wrote:
> This is v2.  The only change from the last take[L] is
> 
> * Updated to reflect the earlier MS_CGROUPWB -> SB_I_CGROUPWB change.
> 
> This patchset implements cgroup writeback support for ext4, which is
> enabled for writeback and ordered data modes.  This patchset contains
> the following two patches.

Ted, these two patches apply cleanly on top of the current mainline
and thus can be routed either through ext4 or block tree.  What do you
think?

Thanks.

-- 
tejun
