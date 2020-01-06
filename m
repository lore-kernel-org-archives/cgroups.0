From: Chris Down <chris@chrisdown.name>
Subject: Re: [RFC] memcg: Add swappiness to cgroup2
Date: Mon, 6 Jan 2020 13:24:36 +0000
Message-ID: <20200106132436.GC361303@chrisdown.name>
References: <1577252208-32419-1-git-send-email-teawater@gmail.com>
 <20191225140546.GA311630@chrisdown.name>
 <20200106131020.GC9198@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wC9BOXYjk4udfBrvJm6JGmvN7DTg2mdl9SY6BiiM5CI=;
        b=P8pk1o9y6+tG5KTqZ9qfFyt85i2CdbvG8XOjpzH+VC1HkPFsLurbZEyYmkqNh4UWcL
         Eux3W369x5DtVrAYs80Bc1RAmUy6R70BJT8sQX3DdDeJZ0mV0VAsZwbqETyluYbf+uTl
         koNyRRhxh4i5PhdlCabKLdZQ3LgVHGQS9sW0c=
Content-Disposition: inline
In-Reply-To: <20200106131020.GC9198@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Hui Zhu <teawater@gmail.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

Michal Hocko writes:
>I am not really sure I agree here though. Swappiness has been
>traditionally more about workload because it has been believed that it
>is a preference of the workload whether the anonymous or disk based
>memory is more important. Whether this is a good interface is debatable
>of course but time has shown that it is extremely hard to tune.

Sure, it can theoretically be hardware- and workload-specific -- I don't think 
we disagree here. The reason I suggest it's a generally hardware-specific 
tunable rather than a workload-specific tunable is it's pretty rare to see 
anyone who's meaningfully used it for workload-specific tuning :-)
