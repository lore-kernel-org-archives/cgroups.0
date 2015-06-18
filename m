From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 3/4] cgroup: require write perm on common ancestor when
 moving processes on the default hierarchy
Date: Thu, 18 Jun 2015 13:59:44 -0400
Message-ID: <20150618175944.GE12934@mtj.duckdns.org>
References: <1434481817-32001-1-git-send-email-tj@kernel.org>
 <1434481817-32001-4-git-send-email-tj@kernel.org>
 <5582379E.1050508@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=GHuGAA9MYYnPlsd8WX5nf5yAz/yDBSGEmx710t21GVk=;
        b=DViAVDAiueKBqpF2WtyyzECUHJ/PKISJTxRWK1sombcYrHdh/ze/pe+cWhOpancffT
         VxvO1JJo+v6nrS8g0X7P/vppJbOCNUs65Xgfka/G3WFuEMVgsFi5lUAbgynPEqasSWra
         1hvgUoMo2+85CKssgPL1XTnpcFh+f8qSzHWwyL/5dLqrMPLKMP7LIV4ryAfdk+U3iubN
         33p/khK3lSwxzXbbsQ3uBWnOTwc0wKGw9XOWYUC/+iXp1nKLuHKq7YIjFjrHvKIzTeh7
         kAXzM0khWnK2xoe/6cuTEOoy+TmEHSuBPrOlJTXlo1z/Nurm4FYQQpNfrA4BbUdAGheC
         clzg==
Content-Disposition: inline
In-Reply-To: <5582379E.1050508@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jun 18, 2015 at 11:14:38AM +0800, Zefan Li wrote:
> > +	if (cgroup_on_dfl(dst_cgrp)) {
> 
> if (!ret && cgroup_on_dfl(dst_cgrp))

Oops, thanks a lot for spotting it. :)

-- 
tejun
