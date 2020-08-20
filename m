From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 1/3] mm/memcg: Clean up obsolete enum charge_type
Date: Thu, 20 Aug 2020 13:27:26 -0400
Message-ID: <20200820172726.GA912520@cmpxchg.org>
References: <20200820130350.3211-1-longman@redhat.com>
 <20200820130350.3211-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BGSTy2S11pQaFof1yGnLyVAv1YOvYkkwg2xvJjtqeUQ=;
        b=B0zXn8r/1mchT7VpWpZ+mN4JB+LQTOAcThKwvNYAguEIUDOZHwwTrdR6gzmQZ5tubZ
         nadwJJP0FhhTUc6qtozlaIcQuD/FFdRoOqCSSFPC20808u50MokVC+zzcj74bSNK3564
         K2rPaPV6/LqFSt2EYvyidWPeBNnkH5k+UUHnDDp7LsHM+QUZl4RIfl0sMDasq2fgoDTh
         aEiFbkQ9IhmoLjkYAaQc2VPQYaxtLY7ONExn+cDWgW0LH7qwa/cgM2WtSkYRhS29jGEn
         +HZQ+jI+GqR+PBIfIjicJ0wnOj2ML6oSYHPVNMYabbRVYTlqLboSPlY8YiNQkmtdg/2E
         7wZg==
Content-Disposition: inline
In-Reply-To: <20200820130350.3211-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Thu, Aug 20, 2020 at 09:03:48AM -0400, Waiman Long wrote:
> Since commit 0a31bc97c80c ("mm: memcontrol: rewrite uncharge API") and
> commit 00501b531c47 ("mm: memcontrol: rewrite charge API") in v3.17, the
> enum charge_type was no longer used anywhere. However, the enum itself
> was not removed at that time. Remove the obsolete enum charge_type now.
> 
> Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
