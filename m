From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [patch v3 -mm 1/3] memcg: integrate soft reclaim tighter with
 zone shrinking code
Date: Thu, 16 May 2013 15:12:00 -0700
Message-ID: <20130516221200.GF7171@mtj.dyndns.org>
References: <1368431172-6844-1-git-send-email-mhocko@suse.cz>
 <1368431172-6844-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=a57u+pV2kYOYAZWOjWXc/D0kmVfQszNo3FuIaDjM9u8=;
        b=S2ME946ROFyUflKLfc0tkQWAhF21NbstmBEP28YqEv9aiLu3+LqD61LRRfSrJSuMNb
         xFDJgAG/Ryqj9OzSTMberjWjL7jG0dyXjo2c4G6GcTd/Ixz6mo7YkXlQkU2TuXsGGnKl
         ZY2BOYmQ9746CpaLrsmOqUqSFJ4vrsW69ysYVDWz7gforxJ1WdYcipwhz9Kg0ubxQMpM
         KM3gi/cbD3G/uhT+/PX0/uLbvvVRV+SKDplyijNQlECeS+liTDYmGc7R0+mmQ/W6YvaL
         fyFGmxrlz5IPQYWbFU9lxkLEQQSvPVRveUYBPNGr4tfgZk2AZC0IFNOp1ytxFrQm8vAE
         1RWA==
Content-Disposition: inline
In-Reply-To: <1368431172-6844-2-git-send-email-mhocko-AlSwsSmVLrQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ying Han <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michel Lespinasse <walken-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Sorry about the delay.  Just getting back to memcg.

On Mon, May 13, 2013 at 09:46:10AM +0200, Michal Hocko wrote:
...
> during the first pass. Only groups which are over their soft limit or
> any of their parents up the hierarchy is over the limit are considered

ancestors?

> +static void shrink_zone(struct zone *zone, struct scan_control *sc)
> +{
> +	bool do_soft_reclaim = mem_cgroup_should_soft_reclaim(sc);
> +	unsigned long nr_scanned = sc->nr_scanned;
> +
> +	__shrink_zone(zone, sc, do_soft_reclaim);
> +
> +	/*
> +	 * No group is over the soft limit or those that are do not have
> +	 * pages in the zone we are reclaiming so we have to reclaim everybody
> +	 */
> +	if (do_soft_reclaim && (sc->nr_scanned == nr_scanned)) {
> +		__shrink_zone(zone, sc, false);
> +		return;
> +	}
> +}

Maybe the following is easier to follow?

	if (mem_cgroup_should_soft_reclaim(sc)) {
		__shrink_zone(zone, sc, true);
		if (sc->nr_scanned == nr_scanned)
			__shrink_zone(zone, sc, false);
	} else {
		__shrink_zone(zone, sc, false);
	}

But it's a minor point, please feel free to ignore.

  Reviewed-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Thanks.

-- 
tejun
