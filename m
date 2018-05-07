From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: memcontrol: drain stocks on resize limit
Date: Mon, 7 May 2018 10:48:35 -0400
Message-ID: <20180507144835.GA5163@cmpxchg.org>
References: <20180504205548.110696-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=L6HTJmiDynKQpG0v0Bzt4OzZY1X6/KqVLxvajjEo9dk=; b=aIPQ/iVsu42d7/RHDX90+U68kj
        fckLdqaAapvuuh8J91iMSxfSTCCkTqITPUMs5AIDkQLhkUJtqbS4ss4jXJwWMIpCadCBU0Qh7/fvw
        IB5NyKSadWRdK3XH6qKWhsPlyffU4+nyg4YrbQ+kti9dB0IWM+FL79Dy9lQnYFOAfZDs=;
Content-Disposition: inline
In-Reply-To: <20180504205548.110696-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Vladimir Davydov <vdavydov.dev@gmail.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

On Fri, May 04, 2018 at 01:55:48PM -0700, Shakeel Butt wrote:
> Resizing the memcg limit for cgroup-v2 drains the stocks before
> triggering the memcg reclaim. Do the same for cgroup-v1 to make the
> behavior consistent.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
