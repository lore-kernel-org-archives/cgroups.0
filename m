From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: provide reclaim stats via 'memory.reclaim'
Date: Tue, 24 May 2022 07:45:40 -0400
Message-ID: <YozFZI2euSjWPgDb@cmpxchg.org>
References: <20220518223815.809858-1-vaibhav@linux.ibm.com>
 <YoYj4sLJfGke5IGT@dhcp22.suse.cz>
 <87zgjcg4xs.fsf@vajain21.in.ibm.com>
 <YodDaFVeU33bu7yQ@dhcp22.suse.cz>
 <CAJD7tkYwv2LDZeV2F5pxuniw7LCNjBapDCm3WuRhzwTH-jN3PA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CR09yeXsFtoUOg9OMladANfYR85/7BwnLnQK+uR1N0Y=;
        b=fvqp9+cdKj6LUnqaiDF1ifg3kW67yhA7mfjWX6ZFH2sG5F8ll4k55tNdNMuoB1M4to
         Z1AV36+WHxVDjTPLY6bzHrbo5yJXPiJYOceulRYWs7upkmVU3JGKtI50rd0LWM/Pmo91
         Z65P8xlljk+pDOkEJB58JvWaTZZdZ5QPbzT38ZFoJGHl/G+l2Jz7Limq9k4aafPrTBoO
         VQeW7Q/M2I8PndKg6WFmKst0Pc3oRyJmlwI0SCBvP/h9UWXS8S2mRljTo/QRrsFQH+/T
         7FlXtbCY5LpzOlJWW9Vrj3DkOYOFXiz3oUu1znM50xY05BDXckQpGZUkOI6gWeA7kRD+
         P8Aw==
Content-Disposition: inline
In-Reply-To: <CAJD7tkYwv2LDZeV2F5pxuniw7LCNjBapDCm3WuRhzwTH-jN3PA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@suse.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, Shakeel Butt <shakeelb@google.com>

On Mon, May 23, 2022 at 03:50:34PM -0700, Yosry Ahmed wrote:
> I think it might be useful to have a dedicated entry in memory.stat
> for proactively reclaimed memory. A case where this would be useful is
> tuning and evaluating userspace proactive reclaimers. For instance, if
> a userspace agent is asking the kernel to reclaim 100M, but it could
> only reclaim 10M, then most probably the proactive reclaimer is not
> using a good methodology to figure out how much memory do we need to
> reclaim.
> 
> IMO this is more useful, and a superset of just reading the last
> reclaim request status through memory.reclaim (read stat before and
> after).

+1
