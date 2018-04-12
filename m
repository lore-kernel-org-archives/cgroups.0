From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET] mm, memcontrol: Implement memory.swap.events
Date: Thu, 12 Apr 2018 08:38:08 -0700
Message-ID: <20180412153808.GC793541@devbig577.frc2.facebook.com>
References: <20180324165127.701194-1-tj@kernel.org>
 <20180412141345.GH23400@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=JQquykhz0sfSzUB55xkTnmJRzn5dpl6FCsWPm9CGAG0=;
        b=vOqT2ODLCecSx/Ack7KqVSRNgUAl9TgakoGeQCVJul+Y0/rJQAGucvR6LaN9LkajwB
         FPA2CkzBLX4/tahUYWAurh1akVJBn7xjqESbnMzd9IRJy/z/DmiWVCD1ZEIdkoYS5flF
         YC5gYmD7jFW24xtqFCJ5rRfFTSxWoKQLjdPGNtK52lz1tVbyRHT1BehmQNVe4s9OouX8
         dt/sQNd7Cqhnl6L/nCq1SOchRBE+vNLtdcZCgm2PtOz7P2mvjqP6RCLoy1gFet/yYSnz
         OBwZcW0BstOk+4MAioFXqTohwiMqZt+DPM08lABtp/DhYwHLHZUVfya8So8/et2kk+HL
         aCSA==
Content-Disposition: inline
In-Reply-To: <20180412141345.GH23400@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, guro@fb.com, riel@surriel.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, Apr 12, 2018 at 04:13:45PM +0200, Michal Hocko wrote:
> Hi Tejun,
> sorry for the late response. Are you plannig to repost?

Yeah, will do later.

Thanks.

-- 
tejun
