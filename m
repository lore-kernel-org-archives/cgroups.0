From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 2/2] mm, memcg: Throttle allocators based on ancestral
 memory.high
Date: Mon, 16 Mar 2020 12:21:28 -0400
Message-ID: <20200316162128.GF67986@cmpxchg.org>
References: <80780887060514967d414b3cd91f9a316a16ab98.1584036142.git.chris@chrisdown.name>
 <8cd132f84bd7e16cdb8fde3378cdbf05ba00d387.1584036142.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9klmvsCDbXb5UYRZlQllkDdUD0lGfzdSvUkSWWRacQo=;
        b=BIdRz1p8gE7zQuk9C9oV2HUNArw5x43uMFazoWlkrlXCvsSeUsivCaSdXGEbbFTYjy
         nVHA9sJZ7eETinHItrBU4wkyITu/QJh0Hk7+Zg4PL5xep7s0jQVsZRD4ZWsnd5ipJD9v
         sapWytPkQe7cpFo/rwKJ+7zg+T6UXo8doO5npkHb/HZMK7ZCgLKDLWa4AJ94FFjM+cx2
         RbztSybf9OHQoAu+GbPdpNc0d7bgoYECl7ZfwdX1uisQIF3JKgd5exWrQzIH8FwYxLvK
         7LoFUX9bkY1j/teBAy37KVGtZTsTa3q/X6cjYnD7zY79l6KnHy70ahkT8I/rVjcAcc1z
         pwiw==
Content-Disposition: inline
In-Reply-To: <8cd132f84bd7e16cdb8fde3378cdbf05ba00d387.1584036142.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Thu, Mar 12, 2020 at 06:03:04PM +0000, Chris Down wrote:
> Prior to this commit, we only directly check the affected cgroup's
> memory.high against its usage. However, it's possible that we are being
> reclaimed as a result of hitting an ancestor memory.high and should be
> penalised based on that, instead.
> 
> This patch changes memory.high overage throttling to use the largest
> overage in its ancestors when considering how many penalty jiffies to
> charge. This makes sure that we penalise poorly behaving cgroups in the
> same way regardless of at what level of the hierarchy memory.high was
> breached.
> 
> Fixes: 0e4b01df8659 ("mm, memcg: throttle allocators when failing reclaim over memory.high")
> Reported-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Cc: kernel-team-b10kYP2dOMg@public.gmane.org
> Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org # 5.4.x

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
