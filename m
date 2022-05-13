From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] block,iocost: fix potential kernel NULL
Date: Fri, 13 May 2022 06:28:41 -1000
Message-ID: <Yn6HOSAE/aAeMGLU@slm.duckdns.org>
References: <20220513145928.29766-1-gaoyahu19@gmail.com>
 <20220513145928.29766-2-gaoyahu19@gmail.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ewPlolLGmE/a959g4ZA9emiwMLzM/HuRgbAmtM/bKKM=;
        b=hBiN6IheDSJjCVGBGxNiJqN1NO8KxR5odY3itzDXivs7PJf8NZMHpFBtiOwWS44KpC
         5QByrr9xl4phn4Ex2VvkCcHFs7vkuwG83TbENksSTbJdRJfDqAyJoFkeIWC0OmVnNYwJ
         anTAfEIj0J+TXXUq8DOCMGeeJy4GwiDk5eMQlqXmvBI1ciYLvFqOREiudh/miO3Ug2lp
         Sem0FDhxzNBnr8WKZmCbmJ+xgk0k0Z/+JmJLa3zxOnDTJfwDMn4qRo3ynvCG1rJk3rqz
         UONgy6PF+YxDv4fwpfWtlrwBWekAQfPxtH74R5/TdAENGRNc44h2zM8/RoYnOpGYnYSm
         qKoA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220513145928.29766-2-gaoyahu19@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yahu Gao <gaoyahu19@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, Yahu Gao <yahugao@didiglobal.com>, Kunhai Dai <daikunhai@didiglobal.com>

Hello,

On Fri, May 13, 2022 at 10:59:28PM +0800, Yahu Gao wrote:
> From: Yahu Gao <yahugao@didiglobal.com>
> 
> Some inode pinned dying memory cgroup and its parent destroyed at first.
> The parent's pd of iocost won't be allocated during function
> blkcg_activate_policy.
> Ignore the DYING CSS to avoid kernel NULL during iocost policy data init.

Thanks for the analysis and patch but I'm not quite sure the analysis is
correct. When a cgroup goes down, its blkgs are destroyed
blkcg_destroy_blkgs() which is invoked by blkcg_unpin_online() when its
online_pin reaches zero which is incremented and decremented recursively, so
an ancestor's blkgs should be destroyed before a descendant's if the code is
working as intended. Can you guys dig a bit deeper and why we're losing
ancestor blkgs before descendants?

Thanks.

-- 
tejun
