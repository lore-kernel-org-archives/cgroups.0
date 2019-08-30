From: Yizhuo Zhai <yzhai003@ucr.edu>
Subject: Re: [PATCH] mm/memcg: return value of the function
 mem_cgroup_from_css() is not checked
Date: Fri, 30 Aug 2019 15:27:50 -0700
Message-ID: <CABvMjLRFm5ghgXJYuuNOOSzg01EgE1MazAY7c6HXZaa6wogF8g@mail.gmail.com>
References: <20190822062210.18649-1-yzhai003@ucr.edu> <20190822070550.GA12785@dhcp22.suse.cz>
 <CABvMjLRCt4gC3GKzBehGppxfyMOb6OGQwW-6Yu_+MbMp5tN3tg@mail.gmail.com> <20190822201200.GP12785@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1567204042; x=1598740042;
  h=mime-version:references:in-reply-to:from:date:message-id:
   subject:to:cc;
  bh=+AxKleiBOotn72mRXxY/KudOmnLMJMiIcrvaqwrtHdw=;
  b=OzpFioaXHjOs1ZkOfgehhLN6JksrEiWwHw4FAr5GnMYaegARhvBpoG3L
   96Nvl7QtXZrxM4C/sHmjvQKJnPQWswqJ7G1wVFmvs9wjYWtmv2qVQLLvc
   4XcnLYIwmQr6mSXEY1PscQUoBjGOssX6kfUFvFI9Ho/XZw9eNDRlp2nGz
   3wHZwDiLvKnRFKoasyD+sHLuKxp/+psLpqYaFC+ohNQx4zDfmrzxxHNuP
   kJ73TP+V7K6scPeAfcf33oJbV5bbNUv4FQxHzPOTetin46Oy6oxFQLME6
   o9y8H7fAxY873hkMBbZWjp4FHUIbHD9MR7FxKq8dsmEnwd68t+DXfwGoE
   g==;
In-Reply-To: <20190822201200.GP12785@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Chengyu Song <csong@cs.ucr.edu>, Zhiyun Qian <zhiyunq@cs.ucr.edu>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Our tool did not trace back the whole path, so, now we could say it
might happen.

On Thu, Aug 22, 2019 at 1:12 PM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Thu 22-08-19 13:07:17, Yizhuo Zhai wrote:
> > This will happen if variable "wb->memcg_css" is NULL. This case is reported
> > by our analysis tool.
>
> Does your tool report the particular call path and conditions when that
> happen? Or is it just a "it mignt happen" kinda thing?
>
> > Since the function mem_cgroup_wb_domain() is visible to the global, we
> > cannot control caller's behavior.
>
> I am sorry but I do not understand what is this supposed to mean.
> --
> Michal Hocko
> SUSE Labs



-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
