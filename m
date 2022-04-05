From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm/memcg: non-hierarchical mode is deprecated
Date: Tue, 5 Apr 2022 18:20:53 +0000
Message-ID: <20220405182053.wvcewrm5ovi3qeev@google.com>
References: <20220403020833.26164-1-richard.weiyang@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=FMzoEUuR7kMFf/p41WoCKSGPV5DJJawQawoS8VMfGf8=;
        b=jYIKh2vp9qzfZy+6UQTsSiswFuPf0yt2j5lgrCOf9U4Asuhj5voE7FXq3/eWuXqgvw
         ULBXZRop2ngkb2O9nMzY1uLHvP1LWd/x8fzu2w61irvv5uKNhUem37HnvK9XEO/Y4aBx
         9b7Wyk5tsV19GACNlZAkOIEnABxxWmf+iLah22Nnlus35H6foWOxb5WxSZkRlsXquc4z
         1+6aMH0AAQnFuIURELqM35d6UqL9WtphobKOT1uGSXpTe1a2gueSkkSlLq6xTc0yD7kQ
         l8K9Xu5eI3oEOggGCqayqCvc3ltRZ/okdmXjE7CFxYGUXTnqxiLonOjPprzJPBS9ijEI
         V/Wg==
In-Reply-To: <20220403020833.26164-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Sun, Apr 03, 2022 at 02:08:33AM +0000, Wei Yang wrote:
> After commit bef8620cd8e0 ("mm: memcg: deprecate the non-hierarchical
> mode"), we won't have a NULL parent except root_mem_cgroup. And this
> case is handled when (memcg == root).
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> CC: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
> CC: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
