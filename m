From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 02/18] mm/memcg: Remove 'page' parameter to
 mem_cgroup_charge_statistics()
Date: Wed, 30 Jun 2021 10:17:35 -0400
Message-ID: <YNx8/3FmctUIMR5x@cmpxchg.org>
References: <20210630040034.1155892-1-willy@infradead.org>
 <20210630040034.1155892-3-willy@infradead.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5fNIFXYQI7TvZny7BzFwsgeK80xRoPJ6rxa13naW5Mw=;
        b=teRsrW5ftbOQTTpZQ41lXoQW13k4U4jqQtusMwiMeetCR789nTMf35ZMVYuJ9tM3Y8
         N56uC5ewiwmRYwx+5eL+p9qBD+COF/anx6cWOGGXH3c9nrX0mzSVaYqNSXq+MtFXBZX7
         Z976/QYHRm0yqG7OBoqy3GA/HlQTwBSl8OBP0Xwdaph3qaRkFNKnspVn2x2R0LAgpu1F
         NXZ+HZ5bHUHdC8JbIawg0O8PHZq2AgDmTbnkP9E60CAqfncly+gxWmRiUpzWMOnNny9+
         Qe99mN+f99wA9XkJv6R6jqXLU+64iSnRjyROE7EQABE2ql6yB9w1KNJMvkE4KWtbB/zP
         pbxw==
Content-Disposition: inline
In-Reply-To: <20210630040034.1155892-3-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

On Wed, Jun 30, 2021 at 05:00:18AM +0100, Matthew Wilcox (Oracle) wrote:
> The last use of 'page' was removed by commit 468c398233da ("mm:
> memcontrol: switch to native NR_ANON_THPS counter"), so we can now remove
> the parameter from the function.
> 
> Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
