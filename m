From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH mm v5 RESEND 3/4] mm: move cgroup high memory limit
 setting into struct page_counter
Date: Tue, 26 May 2020 10:42:20 -0400
Message-ID: <20200526144220.GC848026@cmpxchg.org>
References: <20200521002411.3963032-1-kuba@kernel.org>
 <20200521002411.3963032-4-kuba@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=09NkzIHZAJnaabNzltJNpHqTja29HfRyqZxJgoASsis=;
        b=vI9pk3mv7VAhL8kvPHHXxJTQQGYcJUu5GTZZ6y4YiwW3Y1Avrv5r6XHrvcwie4PK4c
         7KR2HeHdQ626DnC+KI0hNsNedItJfqKaOr0YxxXKy219Pw9WtoVWw4dx+VD68JzvD8Cq
         g8OGFYLtvNGHCUhid3aoNQpxdXhUSSaaFHXRBicYB4SMaqFvgoZ2tej3Y6M3crYF7fkJ
         3gQZ3YZp0OIlp06GtfIqbVaEh+qHRIhcsNntKn7umQzLl594/L67uSCsIjzgYz4a5vWM
         Yld7CRzSE4YOnxonpfPnd+Im85yT+W8HxHx81wzUq7GlVpc/6ZLUlxe3Mr4xtAz41XVn
         mdTg==
Content-Disposition: inline
In-Reply-To: <20200521002411.3963032-4-kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

On Wed, May 20, 2020 at 05:24:10PM -0700, Jakub Kicinski wrote:
> High memory limit is currently recorded directly in
> struct mem_cgroup. We are about to add a high limit
> for swap, move the field to struct page_counter and
> add some helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

This move is overdue and should make it easier to integrate high
reclaim better into the existing max reclaim flow as well. Thanks!
