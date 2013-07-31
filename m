From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] cgroup: more naming cleanups
Date: Wed, 31 Jul 2013 07:39:12 -0400
Message-ID: <20130731113912.GN2810@htj.dyndns.org>
References: <51F8C7C5.9040608@huawei.com>
 <51F8C85C.1050206@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=925SS9Yaq30rHQzvSSK52sqn8077MnrvnQiMMY50DBk=;
        b=i8z3ojDmf410InQeZH1iIH4MZlOzldhOw/j6SldREcW9m3jtIRt2yrfbYZhqZ9xKpv
         Ob4xbZcWOhAuoC45V+4KtwnPzF11lefWITGy5QN0oZQn9M+GcPZeiRblk29Zsnh02pZD
         D2W6uppXd3Z6TbUPTEx0a2c/97oC+dUqa8inZjyhM4bqLaEYjuUe0Y9xgUgtPtj8bQAE
         a3WrA0QSonBKsio9xO0FB/V1fqkASmAvWYbkgWpl97s/D9eyNrO0F4brxfFvpay0Schp
         +goAfs0Fz8fihjTS0xesDbF4l3K22+odNjM/bWXPfUPtaEupHNQoy1Po7uNnw/xOvrQG
         NdZA==
Content-Disposition: inline
In-Reply-To: <51F8C85C.1050206@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, Jul 31, 2013 at 04:18:36PM +0800, Li Zefan wrote:
> Constantly use @cset for css_set varabbles and use @cgrp as cgroup
> variables.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Applied to cgroup/for-3.12.

Thanks.

-- 
tejun
