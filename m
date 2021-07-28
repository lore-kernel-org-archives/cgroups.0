From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: cleanup racy sum avoidance code
Date: Tue, 27 Jul 2021 19:36:01 -0700
Message-ID: <YQDCkeFxSnh2GR7I@carbon.dhcp.thefacebook.com>
References: <20210728012243.3369123-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=kHzxSIG1kXwazlMs5QTdLmJpjwkb8TVxu0YndxzDXf4=;
 b=C3sZLL54CAef15Jvxk9En260/fUmh2Pp/EB84NlrAP6N1ADBccrD/ExTe4Noc9aCZwew
 pH5H0UHM0f4qJTMscasLzVQ2K99DnozOe6BwMwrpsoKpXTqjIs5eXEPYY4/PfLVVW9wE
 9jyTMQsoS17X8HPsGU5TLhx3MfpuQi12kQw= 
Content-Disposition: inline
In-Reply-To: <20210728012243.3369123-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 27, 2021 at 06:22:43PM -0700, Shakeel Butt wrote:
> We used to have per-cpu memcg and lruvec stats and the readers have to
> traverse and sum the stats from each cpu. This summing was racy and may
> expose transient negative values. So, an explicit check was added to
> avoid such scenarios. Now these stats are moved to rstat infrastructure
> and are no more per-cpu, so we can remove the fixup for transient
> negative values.
> 
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Thanks!
