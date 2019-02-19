From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: remove unused task_has_mempolicy()
Date: Tue, 19 Feb 2019 06:27:44 -0800
Message-ID: <20190219142744.GV50184@devbig004.ftw2.facebook.com>
References: <1550471291-4327-1-git-send-email-yamada.masahiro@socionext.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HlWDL69fGUB2hXNN5vwXu3zttVL9vpZ9zstLdQC687k=;
        b=oKzmVeCLjaHjrMjixMvB/v4ZX6hjRdcSXQSiY87El836UYu1WQlQSirC6kQ1Gx+W51
         BAsoUGV/6aUNgh6xtwafYsKRhMVZdlJJWvZjVCdUrSSyBjFZPx+Gm34QL/lOcBafA+n9
         oqJ9s6EzddGWbwRgtBEdcoEXkBLQyPTqIHQmTQUK0hwDW7EoWprBg/8RD+KtyUv2u8Sx
         Kaeeqwhnp7hLID7HrrxssxeMLbhFrYryDiEO11OidwzdtXkd96v450Ouqo94gGTtxCJE
         k0SguYPcXboULDKlgi/9LpuqbnTnqeYaM2s1ndthbw1pA8/eaCa09/6V/+zlE0agtB0s
         o0rw==
Content-Disposition: inline
In-Reply-To: <1550471291-4327-1-git-send-email-yamada.masahiro@socionext.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Feb 18, 2019 at 03:28:11PM +0900, Masahiro Yamada wrote:
> This is a remnant of commit 5f155f27cb7f ("mm, cpuset: always use
> seqlock when changing task's nodemask").
> 
> Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Applied to cgroup/for-5.0.

Thanks.

-- 
tejun
