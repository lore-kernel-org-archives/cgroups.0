From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Mon, 15 Aug 2022 15:23:30 +0200
Message-ID: <20220815132330.GA24237@blackbody.suse.cz>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvYoFNDMdg6mdFbU@blackbook>
 <5ce118b3-bf3b-d9a4-004c-a5a355984b0f@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1660569812; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fFv09Z66+Z9RxDrPyMXwvJHVM1uCWbRmOhnW660hzr8=;
        b=OqWPme3xuINwEeKBN52NXE/mRAnqhga05GZ3BOi4GLrd0F7tILAEBTFWeoaS5WpMm6U+b+
        99RNE/4Qgco/1FgCOblmw6w72VMGekSH328mCz2Y/HUt2vT9VlPdp0Ao+3RgrpKlVxMDnY
        gZBftxajDbblyzNmxcKMRxps1F0Fs0Y=
Content-Disposition: inline
In-Reply-To: <5ce118b3-bf3b-d9a4-004c-a5a355984b0f@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: hannes@cmpxchg.org, tj@kernel.org, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On Fri, Aug 12, 2022 at 08:36:17PM +0800, Chengming Zhou <zhouchengming@bytedance.com> wrote:
> Could you help take a look if there is anything to improve?

Thanks, just a little nit.

> +       The reason this control attribute exists is that PSI accounts stalls for
> +       each cgroup separately and aggregates it at each level of the hierarchy.
> +       This may cause non-negligible overhead for some workloads when under
> +       deep level of the hierarchy, in which case this control attribute can
> +       be used to disable PSI accounting in the cgroups.

s/in the cgroups/in the non-leaf cgroups/
or
s/in the cgroups/in the uninteresting cgroups/

(I'm concerned that it may result in lots of disabling if you want the
performance. I'll expand on it in 2nd subthread.)

Michal
