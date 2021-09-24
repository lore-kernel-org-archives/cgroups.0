From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 1/2] mem_cgroup: optimize the atomic count of
 wb_completion
Date: Fri, 24 Sep 2021 11:34:25 +0200
Message-ID: <YU2boTZhfbo0h/Xi@dhcp22.suse.cz>
References: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632476066; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDntLQNLN6lkb4wP0qiiEY2Cp52Cp3JUhnteHpFO/Oo=;
        b=hNW9wJaJWv3vsI422axK/4ZwmDP3wpH8/RQnB9Yq6SGYmh8OUSzBAbB5534mN0ZXJv3PRQ
        /cQflQkkGM4y1nnJkC01BciIs/ASV5wqN2Y4u1Y6HXnQ5CpCKjEiF5yD5gNoX++lxniizk
        byWh4W+84H0up/qePINIqRBtPHfXhqA=
Content-Disposition: inline
In-Reply-To: <1632465983-30525-1-git-send-email-brookxu.cn@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri 24-09-21 14:46:22, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> In order to track inflight foreign writeback, we init
> wb_completion.cnt to 1. For normal writeback, this cause
> wb_wait_for_completion() to perform meaningless atomic
> operations. Since foreign writebacks rarely occur in most
> scenarios, we can init wb_completion.cnt to 0 and set
> frn.done.cnt to 1. In this way we can avoid unnecessary
> atomic operations.

Does this lead to any measurable differences?
-- 
Michal Hocko
SUSE Labs
