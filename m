From: David Rientjes <rientjes@google.com>
Subject: Re: [patch v2] mm, memcg: do not retry precharge charges
Date: Sat, 14 Jan 2017 21:42:48 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1701142137020.8668@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1701112031250.94269@chino.kir.corp.google.com> <alpine.DEB.2.10.1701121446130.12738@chino.kir.corp.google.com> <20170113084014.GB25212@dhcp22.suse.cz> <alpine.DEB.2.10.1701130208510.69402@chino.kir.corp.google.com>
 <20170114162238.GD26139@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=rjlwL9epzpXkEn0WEbl4D38c7rlfAO/T43c3D+v0DQo=;
        b=gEnkPApfAvzw84nHUfja0lDp4W2/5C5a67KNjV/BNZzKIPtwOipS01PIlBhERoiQQe
         gJ/chinkXTQPOXdb7yIPm5b6qHcYi/hTyrF+Mj/f5aDEWZC4tvIg9kcDiyrNaOj9QhLt
         rLeXroH7d9fB0Xe3zGageYKJX+iFn2pZBAaAx4v9+7gSe2zK3vmrvEYP+yU6lyJfsQhR
         zPSWMqXRSjL7dBowxPcJl/uqdNFzAm1tLrgiZdECS8kOkRWwJuQ0YzmGuN4W+bpRUY7l
         g6/hwLlu36pGgz14lwBcMCkpcBHsYZ53qSvk5kiv0dT3K9ph7iDxzpY4fnGt2P+IslC6
         idJg==
In-Reply-To: <20170114162238.GD26139@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Sat, 14 Jan 2017, Johannes Weiner wrote:

> The OOM killer livelock was the motivation for this patch. With that
> ruled out, what's the point of this patch? Try a bit less hard to move
> charges during task migration?
> 

Most important part is to fail ->can_attach() instead of oom killing 
processes when attaching a process to a memcg hierarchy.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
