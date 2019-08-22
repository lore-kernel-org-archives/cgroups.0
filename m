From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcg: return value of the function
 mem_cgroup_from_css() is not checked
Date: Thu, 22 Aug 2019 22:12:00 +0200
Message-ID: <20190822201200.GP12785@dhcp22.suse.cz>
References: <20190822062210.18649-1-yzhai003@ucr.edu>
 <20190822070550.GA12785@dhcp22.suse.cz>
 <CABvMjLRCt4gC3GKzBehGppxfyMOb6OGQwW-6Yu_+MbMp5tN3tg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABvMjLRCt4gC3GKzBehGppxfyMOb6OGQwW-6Yu_+MbMp5tN3tg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yizhuo Zhai <yzhai003@ucr.edu>
Cc: Chengyu Song <csong@cs.ucr.edu>, Zhiyun Qian <zhiyunq@cs.ucr.edu>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Thu 22-08-19 13:07:17, Yizhuo Zhai wrote:
> This will happen if variable "wb->memcg_css" is NULL. This case is reported
> by our analysis tool.

Does your tool report the particular call path and conditions when that
happen? Or is it just a "it mignt happen" kinda thing?

> Since the function mem_cgroup_wb_domain() is visible to the global, we
> cannot control caller's behavior.

I am sorry but I do not understand what is this supposed to mean.
-- 
Michal Hocko
SUSE Labs
