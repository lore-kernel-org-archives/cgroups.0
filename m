From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 1/2] mm: Rename ambiguously named memory.stat counters
 and functions
Date: Mon, 11 Feb 2019 13:55:35 -0500
Message-ID: <20190211185535.GB13953@cmpxchg.org>
References: <20190123223144.GA10798@chrisdown.name>
 <20190208224319.GA23801@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/fwPQA3qU7Aku9UVL4Xj6OeW7KvutLJujKV6PtXhaFY=;
        b=KSmBfVOt//tembuNf6qv9MiwaTLSt+/d0XxrB6YxhFnrNj7Jqys5VcAp3OPQumEVZ/
         MqNLDSVZYNG1PxLrbZZsbpJcxOkt9kXzOTjxqhq2+IImeP4X2Y3sSeX/0PmGithDGw0F
         uMHmyy7dkXFRies/O/3nElxwMqp5pI5QaiAimssP6jMzVS5oq8XEHNa/fV0whvCn3yoG
         hX02Fy688V5oZdTAGvqfw7ARKSHPmaVRYE46nvOxhHfp1AMiewmMN+7RRMU5WlkLHTvj
         10aFXwRq0vbyIvETLdDorc5HSbf9fgvWlID477XFlspaTWkVLjUt97ImjVTjHCJpeZ6j
         mrmQ==
Content-Disposition: inline
In-Reply-To: <20190208224319.GA23801@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, Dennis Zhou <dennis@kernel.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Fri, Feb 08, 2019 at 10:43:19PM +0000, Chris Down wrote:
> I spent literally an hour trying to work out why an earlier version of
> my memory.events aggregation code doesn't work properly, only to find
> out I was calling memcg->events instead of memcg->memory_events, which
> is fairly confusing.
> 
> This naming seems in need of reworking, so make it harder to do the
> wrong thing by using vmevents instead of events, which makes it more
> clear that these are vm counters rather than memcg-specific counters.
> 
> There are also a few other inconsistent names in both the percpu and
> aggregated structs, so these are all cleaned up to be more coherent and
> easy to understand.
> 
> This commit contains code cleanup only: there are no logic changes.
> 
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
