From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH REBASED] mm, memcg: Make scan aggression always exclude
 protection
Date: Fri, 22 Mar 2019 22:51:05 +0000
Message-ID: <20190322225105.GA21729@chrisdown.name>
References: <20190228213050.GA28211@chrisdown.name>
 <20190322160307.GA3316@chrisdown.name>
 <20190322222907.GA17496@tower.DHCP.thefacebook.com>
 <20190322224922.GA7729@tower.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=losYwk/KnyYBXmqLLyIEJufi/8wg0iZYh/lFm2rrato=;
        b=vrapgFdTIfpT8XWFnIH1/GLXnuTAw40ZeVke3Yc0Z7QMZ5/Lb0zs8qCSPqghWJK9Qs
         GpkaCsqzi3mLS8zOASlqm0nzs2tmmRmILYWDayt/SwE2+swwnX0taFqcD+9XuGJvSE8G
         OfR8xGLbN93EsKI3jxWaNQkOCWDePK32gNlLQ=
Content-Disposition: inline
In-Reply-To: <20190322224922.GA7729@tower.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

Roman Gushchin writes:
>However, we can race with the emin/elow update and end up with negative scan,
>especially if cgroup_size is about the effective protection size

Yeah, it's possible but unlikely, hence the TOCTOU check. :-)
