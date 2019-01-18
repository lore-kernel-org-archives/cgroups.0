From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/5] sched/deadline: fix cpusets bandwidth accounting
Date: Fri, 18 Jan 2019 08:17:39 -0800
Message-ID: <20190118161739.GE50184@devbig004.ftw2.facebook.com>
References: <20190117084739.17078-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jxu0a1nkN3ZpzOxZbKmUrpD1yZ9zO9HuQcvnymZzhI0=;
        b=jz72BFxjt22s+qMlTfP1yKEqVRPB4cfDgk/N/nj7blKvYgkPWP3VEgyg0DStL144Ci
         Y6XYdYW0kyK4R2xkoyfThcbL7ufeBvSTiRZtmq1k1wowHcaQUqkt9efm3izvgfx3Si75
         MrhJwiQqrbLUZUer7Xu0a9lhkKS6OSz69ApO+zA+N8cuI8TrPIm5KHyeCKszHPq72J7x
         BGkkdmpSnHuyulZPo0PvEFMac2Ju7bvPqY15ueTozLBt/XvKiRifhygeGNv/7po6/oPL
         OX9ddJAvoxnxl96g9+XnRAu5+ttXnU7SHF+Y08Pl8CxTHupiwi+F2vQdi+g6p0WsWSEK
         h2lw==
Content-Disposition: inline
In-Reply-To: <20190117084739.17078-1-juri.lelli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Juri Lelli <juri.lelli@redhat.com>
Cc: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org

On Thu, Jan 17, 2019 at 09:47:34AM +0100, Juri Lelli wrote:
> Hi,
> 
> v6 of a series of patches, originally authored by Mathieu, with the intent
> of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
> As originally reported by Steve [1], when hotplug and/or (certain)
> cpuset reconfiguration operations take place, DEADLINE bandwidth
> accounting information is lost since root domains are destroyed and
> recreated.
> 
> Mathieu's approach is based on restoring bandwidth accounting info on
> the newly created root domains by iterating through the (DEADLINE) tasks
> belonging to the configured cpuset(s).
> 
> Apart from some minor refactoring needed to rebase the set on top of
> Waiman Long's cpuset for cgroup series (now mainline), two changes worth
> of notice:

Generally looks good to me but can you please ask Waiman to take a
look?

Thanks.

-- 
tejun
