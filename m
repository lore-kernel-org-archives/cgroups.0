From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 04/18] mm/memcg: Remove soft_limit_tree_node()
Date: Wed, 30 Jun 2021 10:19:28 -0400
Message-ID: <YNx9cLxvtSzOLVaa@cmpxchg.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-5-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j73ye2WfDEOMrwygrtYKVavEV7MVpq0JpTssNG054oM=;
        b=TmYzzLVMVTiuZjmxW/NiL2ZvKpXBRPYJcaRo+gszw0wIOZEv/DRCpgUu/oveFuve7S
         G1Qqm0VaS61KoUtXiHD36mktGAHBs9/huGR69H2CWL1Sq1/NHjZQ00163ZhFxuGQeKBV
         QutXoKt5uzRuz0fU2ExIYwV8uJ3Cfh4VM7qwOKHnKtvGr8ZTockdHbIYtXrAFJorsYjd
         bL0EVeyijJG0tXfzhNhDzx72EMZXpb+FxYUDEG1RnVUEb5WLIOY/oEXdAPwARnM6bJQo
         plcyRl5t02gHnefVOSavYpjGZlDQ+biPKHOQMnui9AJS14ZATuU+Ik7tb69RGlyi3Ygw
         uprQ==
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-5-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:20AM +0100, Matthew Wilcox (Oracle) wrote:
> Opencode this one-line function in its three callers.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
