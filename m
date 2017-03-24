From: "Kirill A. Shutemov" <kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org>
Subject: Re: [PATCH] mm: rmap: fix huge file mmap accounting in the memcg
 stats
Date: Fri, 24 Mar 2017 14:07:55 +0300
Message-ID: <20170324110755.evvbeetf44h72p43@node.shutemov.name>
References: <20170322005111.3156-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shutemov-name.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Dx1TLzTRuUJQAPuhToJ1sAX/8x1qtCBJiQM4OWeb8Tk=;
        b=C9yFH/Sef6VcfFqezW1pLaNTcMjOPPBbSdFcSpjOxHnX2Z4j9uLvRmP+N05+ntu94r
         Y5uBU9R91zgj2mtubcrFPR++X5y1q/mhM1XKDQqkuC05xh0ntH4ebyBnAdTTX4xAaklx
         +9oratlOyh9svTNzomuny4QzmMy086XxhVqVnkLN7baSdrT3fuJacfYRFXLECmYWbI2T
         1cx73wHq7oPajDnXXvqxf9f4lhsJ57SDtr1PPb7lUZXWtoBnApaAvgA276qNmBDmofwv
         Zbsl6J6GKJAYdT/8emWxi+DpZW2UZN1VeB6t6J8Vn2tILKLwJ0eSJZY4RB8+hO8C5Lg1
         dDxQ==
Content-Disposition: inline
In-Reply-To: <20170322005111.3156-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Tue, Mar 21, 2017 at 08:51:11PM -0400, Johannes Weiner wrote:
> Huge pages are accounted as single units in the memcg's "file_mapped"
> counter. Account the correct number of base pages, like we do in the
> corresponding node counter.
> 
> Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Sorry for missing that:

Reviewed-by: Kirill A. Shutemov <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>

Do we want it into stable?

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>	[4.8+]

-- 
 Kirill A. Shutemov
