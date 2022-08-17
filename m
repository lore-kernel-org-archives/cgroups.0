From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH cgroup/for-6.0-fixes] cgroup: Fix threadgroup_rwsem <->
 cpus_read_lock() deadlock
Date: Wed, 17 Aug 2022 07:40:32 -1000
Message-ID: <Yv0oEOXddKp+Xo1U@slm.duckdns.org>
References: <ba48eac5-8ef7-251b-11fe-8163bb7a2d54@quicinc.com>
 <224b19f3-912d-b858-7af4-185b8e55bc66@quicinc.com>
 <YthDz4BnfYHce1od@slm.duckdns.org>
 <YuGTBLkFerUboctl@slm.duckdns.org>
 <dc0cff0e-b744-9d5d-e727-70d1c31b2a74@quicinc.com>
 <20220815090556.GB27407@blackbody.suse.cz>
 <CAB8ipk90LxNNbq5OKamd-ArkqhEZjxS1fFZJXtnbQwGzyyJ3wQ@mail.gmail.com>
 <20220815093934.GA29323@blackbody.suse.cz>
 <f584fecd-6ca4-4ab0-763d-2ed219009c61@quicinc.com>
 <YvrWaml3F+x9Dk+T@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc;
        bh=T2VfnDiJkdhY/17kNIzqsKCO/jg0LojKsxYaZr+7Rkg=;
        b=KusRphF5DTFe7mhRnFmNMOI7jOlvj2TNyhLSCDAfuKCkSZkVyILc9k4eWlCXBjo/D8
         2J2lHM41jl4/+729s5SBzsqUMEvrC57GMo+IgkG1gNUzbCt9r3jDVrQTcIU+h/Ltg40v
         /WBy0rO5O4U24ET4N/ABS9JvMy0TJRmIIIOBHh0kT93W1Mw5dEnTfEkSHdViKcuks9vK
         iLbVHtjFTztE53D3sBOZqsmTce3BHEOgwhyvwKl3adB3ENzkvc4mRxl8MlYYm94htLUG
         +Ztsng8Hqv8SEzQRYgLzU9Iy35ACCmGVIWJS/G/haSnqrp2BafNL88aZARskAu+SuQJ8
         4EMQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <YvrWaml3F+x9Dk+T-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Xuewen Yan <xuewen.yan94-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Imran Khan <imran.f.khan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, steven.price-5wv7dgnIgG8@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zhao Gongyi <zhaogongyi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Zhang Qiao <zhangqiao22-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

On Mon, Aug 15, 2022 at 01:27:38PM -1000, Tejun Heo wrote:
> Bringing up a CPU may involve creating new tasks which requires read-locking
> threadgroup_rwsem, so threadgroup_rwsem nests inside cpus_read_lock().
> However, cpuset's ->attach(), which may be called with thredagroup_rwsem
> write-locked, also wants to disable CPU hotplug and acquires
> cpus_read_lock(), leading to a deadlock.
> 
> Fix it by guaranteeing that ->attach() is always called with CPU hotplug
> disabled and removing cpus_read_lock() call from cpuset_attach().
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Applied to cgroup/for-6.0-fixes w/ commit message and comment update
suggested by Xuewen and Fixes / stable tags added.

Thanks.

-- 
tejun
