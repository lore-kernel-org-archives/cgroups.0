From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: Add memory.transparent_hugepage_disabled
Date: Tue, 24 Mar 2020 13:23:50 +0000
Message-ID: <20200324132350.GA7528@chrisdown.name>
References: <1585045916-27339-1-git-send-email-teawater@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=16WGU3cNB1gezVOdWiJDOY/jwLM7wxW+VZ4bxA/PHPk=;
        b=bWlSVSaAkOrITpOQwvrWt1U9KbT9mbpxsTyfS70Bdu05BJ1bpQu2yaT81q91QdmG8m
         b2iC6Eyj1qy/xakWe9eSTS+HImwFRVl0AESSqhQrw9NqXo0VwH0qp2T3zTae9TqhsZf/
         n/Lgm424ZcP3W7ZZ2bRqCxOKpCo5Nk/adFez4=
Content-Disposition: inline
In-Reply-To: <1585045916-27339-1-git-send-email-teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Hui Zhu <teawater-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, sean.j.christopherson-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, thellstrom-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hui Zhu <teawaterz-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Hui Zhu writes:
>/sys/kernel/mm/transparent_hugepage/enabled is the only interface to
>control if the application can use THP in system level.
>Sometime, we would not want an application use THP even if
>transparent_hugepage/enabled is set to "always" or "madvise" because
>thp may need more cpu and memory resources in some cases.
>
>This commit add a new interface memory.transparent_hugepage_disabled
>in memcg.
>When it set to 1, the application inside the cgroup cannot use THP
>except dax.

I'm against this patch even in the abstract -- this adds an extremely niche use 
case to a general interface, and there are plenty of ways to already indicate 
THP preference.

Perhaps there is some new interface desirable for your use case, but adding a 
new global file to memcg certainly isn't it.
