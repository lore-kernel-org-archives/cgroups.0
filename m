From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 09/10] sched/psi: per-cgroup PSI stats
 disable/re-enable interface
Date: Wed, 10 Aug 2022 07:27:12 -1000
Message-ID: <YvPqcJh5Ffv4Yga9@slm.duckdns.org>
References: <20220808110341.15799-1-zhouchengming@bytedance.com>
 <20220808110341.15799-10-zhouchengming@bytedance.com>
 <YvKd6dezPM6UxfD/@slm.duckdns.org>
 <fcd0bd39-3049-a279-23e6-a6c02b4680a7@bytedance.com>
 <b89155d3-9315-fefc-408b-4cf538360a1c@bytedance.com>
 <YvPN07UlaPFAdlet@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=lPqOojcmdOAU79rFEpjfZKvBUO43nFGE73fllT7UubM=;
        b=eyIMIlC3NT7t/M/JASfHlCFAM/ZU0pftD5lYftV9y52nfgtwB67ojBpqf2XsOJyPSE
         myoOkkToXgt6K3WrTFoFZsHIpdtUfS60IWEMULjtaEAE+TjV+RuhH4obNjaaAnckuTC6
         BA8od9MxEGi7eaZv3+xOdXOZnJG8xOpM61nKy+o20Apn56jqN9sCRN20JqYq4Pv+iw65
         HK2ViXVajAEPsYsQna5Rtt5YlPAEu3ZDWGIAtarHArRoEI4B1VFOHV8Y8a57Fcozd92H
         RiqaFV32hD0ryvy5JOdno8MAxtJFWUmXq0AKTETBfUdepAD+T8BmAmE4OsqE3afLYwij
         OsGQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <YvPN07UlaPFAdlet@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Chengming Zhou <zhouchengming@bytedance.com>, corbet@lwn.net, surenb@google.com, mingo@redhat.com, peterz@infradead.org, vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, songmuchun@bytedance.com

Hello,

On Wed, Aug 10, 2022 at 11:25:07AM -0400, Johannes Weiner wrote:
> How about just cgroup.pressure? Too ambiguous?
> 
> cgroup.pressure.enable sounds good to me too. Or, because it's
> default-enabled and that likely won't change, cgroup.pressure.disable.

.disable sounds more logical but I like .enable better for some reason. As
for just cgroup.pressure, yeah, maybe? The conundrum is that the prettiness
order is the exact reverse of the logical order. So, I'm okay with any of
the three.

Thanks.

-- 
tejun
