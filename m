From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: don't count limit-setting reclaim as
 memory pressure
Date: Tue, 28 Jul 2020 20:44:47 +0100
Message-ID: <20200728194447.GB196042@chrisdown.name>
References: <20200728135210.379885-2-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RkoR8SRsEyrF2DTHYAGqExugDiMhFbQnq4qppceRyxQ=;
        b=T9uJ9mFokE3Rom3E92aAP07PvouUaqSFqQVv02w73ZLda3GVnG9dqeQ8A6++cuDNaG
         JhR9XROOwvBKmnM22qrgiEQ4q/UEWLMu9MpmZl+5FAbsRjf9z2a4fw5GWPmPvAaQetrb
         lpIr7cCLzsyFxEF9sP3U7dtZf6wz53vufxdjA=
Content-Disposition: inline
In-Reply-To: <20200728135210.379885-2-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Johannes Weiner writes:
>When an outside process lowers one of the memory limits of a cgroup
>(or uses the force_empty knob in cgroup1), direct reclaim is performed
>in the context of the write(), in order to directly enforce the new
>limit and have it being met by the time the write() returns.
>
>Currently, this reclaim activity is accounted as memory pressure in
>the cgroup that the writer(!) belongs to. This is unexpected. It
>specifically causes problems for senpai
>(https://github.com/facebookincubator/senpai), which is an agent that
>routinely adjusts the memory limits and performs associated reclaim
>work in tens or even hundreds of cgroups running on the host. The
>cgroup that senpai is running in itself will report elevated levels of
>memory pressure, even though it itself is under no memory shortage or
>any sort of distress.
>
>Move the psi annotation from the central cgroup reclaim function to
>callsites in the allocation context, and thereby no longer count any
>limit-setting reclaim as memory pressure. If the newly set limit
>causes the workload inside the cgroup into direct reclaim, that of
>course will continue to count as memory pressure.

Seems totally reasonable, and the patch looks fine too.

>Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
