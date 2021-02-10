From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH stable 4.9] mm: memcontrol: fix NULL pointer crash in
 test_clear_page_writeback()
Date: Wed, 10 Feb 2021 15:06:49 +0100
Message-ID: <YCPoeaVXuQt8oX/c@kroah.com>
References: <20210209202616.2257512-1-f.fainelli@gmail.com>
 <YCL8cnXFtpdnAAUj@cmpxchg.org>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=l5u4BR58ii0Rtlvkm1LcKTg4vDo
        3rxiz5sSs57woe04=; b=GWadpoLWa5oK1qyT9kAKnkuk4z3HMK8EyLv+f8LXr8N
        BV74nI99cnQr2yRLHCmqYtZVPQbGUaRRzcid7awA5zFdLV6grl3vI4BQIaqf4987
        xjxHfLQnZso4hvDdLxm/LQrsi6sjBKnxVV2azXxNi/Kcc7ObUupCBVefEXx91uzy
        dtbHiZ0mCLLzWGMnpPSVrr6TGHtv4MejweI00W3GjkZM58/vI2gi6awtOnoPFBoo
        9Nm7M7unF/WAg8dde/WBzioAvGJ5eg3qpG5iJcEgA43Tgj9cn366l5NRxCiED+qe
        HZmssUAZ+0YJ3XzHrKeUhMbKucZqYRd6QKXWp/m9O4g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=l5u4BR
        58ii0Rtlvkm1LcKTg4vDo3rxiz5sSs57woe04=; b=gqAmFjY+0aXFv7N7KpV6Wy
        XWmV0P2Modn9HcYWUFf4uK9XgfgCyWhP1S8uWmLBRNGtBe64NQHQkerYwQLFEMMU
        73pd79/iYaugbLtVasRuJsuYlBlOhATesE7MFKG9yuSlNUPDZg4XbCDDD/FYT2fe
        NSkIJ4uGe7/2RghrtX1LNh/XpBhju3fgA5bJTJozP1CCu1oKN05aNQZIpqOAyudd
        6O6cya6Lx49lLlb5rSqv62SAtUDYoLQ3ldwooCfppA8YRYHIFqz3yRiQjo4bcFzD
        e2HCcHAv21ZFJ5+uyM1F1pAwSjx7HUtS614pWLpkCcEQglXs0vvb+z8tZvbCKDCg
        ==
Content-Disposition: inline
In-Reply-To: <YCL8cnXFtpdnAAUj@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Florian Fainelli <f.fainelli@gmail.com>, stable@vger.kernel.org, linux-kernel@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>, Bradley Bolen <bradleybolen@gmail.com>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Prakash Gupta <guptap@codeaurora.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Tue, Feb 09, 2021 at 04:19:46PM -0500, Johannes Weiner wrote:
> On Tue, Feb 09, 2021 at 12:26:15PM -0800, Florian Fainelli wrote:
> > From: Johannes Weiner <hannes@cmpxchg.org>
> > 
> > commit 739f79fc9db1b38f96b5a5109b247a650fbebf6d upstream
> 
> ...
> 
> > This patch is present in a downstream Android tree:
> > 
> > https://source.mcwhirter.io/craige/bluecross/commit/d4a742865c6b69ef931694745ef54965d7c9966c
> > 
> > and I happened to have stumbled across the same problem too.
> > 
> > Johannes can you review it for correctness with respect to the 4.9
> > kernel? Thanks!
> 
> Looks good to me.

Applied, thanks.

greg k-h
