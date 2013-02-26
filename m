From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/3] cgroup: add cgroup_name() API
Date: Tue, 26 Feb 2013 05:26:08 -0800
Message-ID: <CAOS58YMb7HRQ3X+Z92vi3+jKr4DuNmAgxtc5e3Jkhy-s-7Os-g@mail.gmail.com>
References: <512B01FA.5020506@huawei.com>
	<512B020D.9040504@huawei.com>
	<20130226022703.GA13837@htj.dyndns.org>
	<512C8D84.7090707@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:x-received:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=vnKPVffm1W0Y7oxHMAvzxSyGUt8ML/JrKyGLMB4XeoM=;
        b=CKM63ZRJXIzq+fcbipilszhTm5B9nJo4HjQweSjiwANR0/b2CjKbm5tqa9HwJlaxCJ
         Ll/sAbjE4kSCKczB4CHOCTMQqD6sUNT56vBLH2E0LEKz8HbZCMc8nJtB+/yGGALo/eMS
         hHStQZ+mjxoW/rR+EvkOeCJqGwz34tTtz6c0Bg2zjJ2sBHUHbd+uarYg/AMOekdeCM17
         H8qS4BiJjGG7QtIKRJ6V9o+P2j/hr9dBpTWsbKJLHnlLyno9LGaiXODwt11olO/RkBbQ
         yHoPXUvIv6+1GdKMcnG35kUocmFQJKURrbtsABz+vk8xSmJn11CrikmiBp5cgprwkj6a
         bohA==
In-Reply-To: <512C8D84.7090707@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

Hello,

On Tue, Feb 26, 2013 at 2:25 AM, Li Zefan <lizefan@huawei.com> wrote:
> Sure we can. We'll have to allocate cgrp->name in cgroup_remount() and
> cgroup_init(), and free cgrp->name in cgroup_kill_sb(). It looks to me
> the current version is a bit simpler.

Can't we just set it to constant "/"?  Root cgroup init is a separate
path anyway.

Thanks.

-- 
tejun
