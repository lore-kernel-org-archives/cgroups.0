From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Wed, 10 Aug 2022 11:25:07 -0400
Message-ID: <YvPN07UlaPFAdlet@cmpxchg.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=XKSHwFSFM1Cfz7cdR5obhEJYaVPc+IY05aklvSLeQmw=;
        b=e25AVASdPskhVxulzpOYgaM3vGiYCxw8t0zkJEcYGUk7Fx/Mq8TE82UTUMm1fMJjVJ
         +eQqkzIQtuQ3Xt94VFmavIu2BAbiC/+oGnTH5+DCvd3jY+Tqabjep1pmpm/SXb8nex/A
         /j6SqUkQQs2pAQbRfRMOyQOcuQgo77JpaJjLIvmv7AVsaBadJL1snWWmn0oQ7Z9bDpLN
         K9GiCya8kI8O2Ly2d26O96W/pja52lx6vvKnqSoq5WH1mypXZrvJnWZ9g3p3L8ZdIPTU
         YYXBaxvP1uUq0TSvFpBrEt3YPzMVQjZZ5RhrUlBB9wTSOKi3mTgDWCYXz8j3nkwzOy+f
         g1JA==
Content-Disposition: inline
In-Reply-To: <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming@bytedance.com>
Cc: Tejun Heo <tj@kernel.org>, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

On Wed, Aug 10, 2022 at 09:30:59AM +0800, Chengming Zhou wrote:
> On 2022/8/10 08:39, Chengming Zhou wrote:
> > On 2022/8/10 01:48, Tejun Heo wrote:
> >> Hello,
> >>
> >> On Mon, Aug 08, 2022 at 07:03:40PM +0800, Chengming Zhou wrote:
> >>> So this patch introduce a per-cgroup PSI stats disable/re-enable
> >>> interface "cgroup.psi", which is a read-write single value file that
> >>> allowed values are "0" and "1", the defaults is "1" so per-cgroup
> >>> PSI stats is enabled by default.
> >>
> >> Given that the knobs are named {cpu|memory|io}.pressure, I wonder whether
> >> "cgroup.psi" is the best name. Also, it doesn't convey that it's the
> >> enable/disable knob. I think it needs a better name.
> > 
> > Yes, "cgroup.psi" is not good. What abort "pressure.enable" or "cgroup.psi_enable"?
> 
> Doesn't look good either, what do you think of "cgroup.pressure.enable"?

How about just cgroup.pressure? Too ambiguous?

cgroup.pressure.enable sounds good to me too. Or, because it's
default-enabled and that likely won't change, cgroup.pressure.disable.
